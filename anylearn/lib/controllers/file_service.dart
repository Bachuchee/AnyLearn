import 'package:flutter/foundation.dart';
import 'package:image_picker/image_picker.dart';

class FileService {
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
}
