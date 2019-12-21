import 'dart:io';

class IoUtils {
  const IoUtils._();

  /// 计算文件(夹)大小，返回单位为 bytes
  static Future<int> sizeOf(FileSystemEntity file) async {
    if(file == null) return 0;
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
