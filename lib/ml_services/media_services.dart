import 'package:image_picker/image_picker.dart';
import 'package:image_to_text/model/image_model.dart';

class MediaService {
  final ImagePicker _imagePicker = ImagePicker();
  ImageModel? image;

  Future<ImageModel?> clickImageFromCamera() async {
    try {
      final _image = await _imagePicker.pickImage(source: ImageSource.gallery);
      final image = ImageModel(imagePath: _image!.path);
      return image;
    } catch (e) {
      print(e);
    }
  }
}
