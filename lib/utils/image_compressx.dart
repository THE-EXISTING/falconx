import 'dart:io';
import 'package:falconx/falconx.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:path_provider/path_provider.dart' as path_provider;

class ImageCompressX {
  static Future<XFile?> compressImageFile({required File file}) async {
    final saveTargetPath = await _getSaveTempTargetPath();
    return _compressAndGetFile(file, saveTargetPath);
  }

  static Future<String> _getSaveTempTargetPath() async {
    // directory
    final dir = await path_provider.getTemporaryDirectory();
    final timeStamp = DateTime.now().millisecondsSinceEpoch.toString();
    // image path
    return dir.absolute.path + '/' + timeStamp + '.jpg';
  }

  static Future<XFile?> _compressAndGetFile(File file, String targetPath) async {
    return FlutterImageCompress.compressAndGetFile(
      file.absolute.path,
      targetPath,
      minWidth: 1000,
      minHeight: 1000,
      quality: 70,
    );
  }
}
