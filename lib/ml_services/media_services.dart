import 'package:edge_detection/edge_detection.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image_to_text/model/image_model.dart';

class MediaService {
  final ImagePicker _imagePicker = ImagePicker();
  ImageModel? image;

  Future<ImageModel?> clickImageFromCamera() async {
    try {
      final imagePath = await EdgeDetection.detectEdge;
      final image = ImageModel(imagePath: imagePath);
      return image;
    } catch (e) {
      print(e);
    }
  }
}
