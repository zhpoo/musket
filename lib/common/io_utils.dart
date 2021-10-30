import 'dart:io';
import 'dart:math';

import 'package:flutter_native_image/flutter_native_image.dart';
import 'package:image_picker/image_picker.dart';

/// 计算文件(夹)大小，返回单位为 bytes
Future<int> sizeOfFile(FileSystemEntity file) async {
  if (file == null) return 0;
  bool exists = await file.exists();
  if (!exists) return 0;
  if (file is File) {
    int length = await file.length();
    return length;
  }
  if (file is Directory) {
    final List<FileSystemEntity> children = file.listSync();
    if (children?.isEmpty ?? true) return 0;
    int total = 0;
    for (FileSystemEntity child in children) {
      var size = await sizeOfFile(child);
      total += size;
    }
    return total;
  }
  return 0;
}

String renderFileSize(double bytes) {
  bytes ??= 0;
  List<String> unitArr = const ['B', 'K', 'M', 'G'];
  int index = 0;
  while (bytes >= 1024 && index < unitArr.length - 1) {
    index++;
    bytes /= 1024;
  }
  return '${bytes.toStringAsFixed(2)}${unitArr[index]}';
}

Future<File> pickImage({
  ImageSource source: ImageSource.gallery,
  int maxFileLength = 2 * 1024 * 1024,
}) async {
  var pickedFile = await ImagePicker().getImage(source: source);
  if (pickedFile?.path?.isEmpty ?? true) return null;
  var origin = File(pickedFile.path);
  var result = origin;
  int breaker = 0; // iOS 上 FlutterNativeImage 可能存在 bug，避免死循环
  while (maxFileLength != null && result.lengthSync() > maxFileLength) {
    final temp = result;
    var lengthPercentage = maxFileLength / result.lengthSync();
    result = await FlutterNativeImage.compressImage(
      temp.path,
      percentage: (sqrt(lengthPercentage) * 100).floor(),
      quality: (lengthPercentage * 100).floor(),
    );
    if (temp.path != result.path) {
      await temp.delete();
    }
    result = await renameFileToMillis(result);
    if (breaker++ > 9) break;
  }
  return result;
}

Future<XFile> retrieveLostImage(ImagePicker imagePicker) async {
  if (!Platform.isAndroid) {
    return null;
  }
  var lostDataResponse = await imagePicker.retrieveLostData();
  if (lostDataResponse?.file != null && lostDataResponse.type == RetrieveType.image) {
    return lostDataResponse.file;
  }
  return null;
}

Future<File> renameFileToMillis(File origin) {
  var newPath = origin.path.replaceRange(
    origin.path.lastIndexOf('/') + 1,
    origin.path.lastIndexOf('.'),
    '${DateTime.now().millisecondsSinceEpoch}',
  );
  return origin.rename(newPath);
}

Future<File> pickVideo({
  ImageSource source: ImageSource.gallery,
  Duration maxDuration,
}) async {
  var pickedFile = await ImagePicker().getVideo(source: source, maxDuration: maxDuration);
  if (pickedFile?.path?.isEmpty ?? true) return null;
  var origin = File(pickedFile.path);
  if (pickedFile.path.endsWith('.jpg')) {
    /// https://github.com/flutter/flutter/issues/52419
    /// 从相册选择视频返回文件扩展名为.jpg，修改扩展名为.mp4
    var jpgIndex = pickedFile.path.lastIndexOf('.jpg');
    origin = await origin.rename(pickedFile.path.replaceRange(jpgIndex, pickedFile.path.length, '.mp4'));
  }
  var result = origin;
  return result;
}
