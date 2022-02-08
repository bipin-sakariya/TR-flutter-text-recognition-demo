import 'package:image_to_text/ml_services/media_services.dart';
import 'package:image_to_text/model/image_model.dart';



import 'base_model.dart';

class ImageViewModel extends BaseModel {
  ImageModel? _image;
  get image => _image;

  void clearImage() {
    print("clear");
    _image ==null;
    setState(CurrentState.idle);
    _image =null;
    notifyListeners();
  }

  void getImage() async {
    //Clears previous picture from memory
    if (_image != null) {
      _image = null;
    }
    setState(CurrentState.loading);
    try {
      final _mediaService = MediaService();
      _image = await _mediaService.clickImageFromCamera();
      if (_image!.imagePath !=null){
        setState(CurrentState.loaded);
      }

    } catch (e) {
      setState(CurrentState.error);
    }
  }
}