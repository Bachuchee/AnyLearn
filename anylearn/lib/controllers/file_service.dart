import 'package:flutter/foundation.dart';
import 'package:image_picker/image_picker.dart';

class AnyFileService {
  static Future<Uint8List> getImage() async {
    try {
      final imagePicker = ImagePicker();

      final imageFile =
          await imagePicker.pickImage(source: ImageSource.gallery);

      final imageData = await imageFile!.readAsBytes();

      return imageData;
    } catch (e) {
      return Uint8List(0);
    }
  }

  static Future<Uint8List> getVideo() async {
    try {
      final imagePicker = ImagePicker();

      final videoFile =
          await imagePicker.pickVideo(source: ImageSource.gallery);

      final videoData = await videoFile!.readAsBytes();

      return videoData;
    } catch (e) {
      return Uint8List(0);
    }
  }
}
