import 'dart:io';
import 'dart:math';

import 'package:flutter_native_image/flutter_native_image.dart';
import 'package:image_picker/image_picker.dart';

class IoUtils {
  const IoUtils._();

  /// 计算文件(夹)大小，返回单位为 bytes
  static Future<int> sizeOf(FileSystemEntity file) async {
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
        var size = await sizeOf(child);
        total += size;
      }
      return total;
    }
    return 0;
  }

  static String renderFileSize(double value) {
    value ??= 0;
    List<String> unitArr = ['B', 'K', 'M', 'G'];
    int index = 0;
    while (value > 1024 && index < 3) {
      index++;
      value /= 1024;
    }
    return '${value.toStringAsFixed(2)}${unitArr[index]}';
  }
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
    result = await renameFileToMillis(result);
    if (temp.path != origin.path) {
      await temp.delete();
    }
    if (breaker++ > 9) break;
  }
  return result;
}

Future<File> retrieveLostImage() async {
  var lostDataResponse = await ImagePicker.retrieveLostData();
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
