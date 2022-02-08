import 'package:image_to_text/ml_services/text_recognize.dart';
import 'package:image_to_text/model/image_model.dart';
import 'package:image_to_text/model/text_model.dart';
import 'base_model.dart';
import 'image_provider.dart';

class TextViewModel extends BaseModel {

  late ImageViewModel _imageProvider;

  List<RecognizedText>? _processedTexts;

  List<RecognizedText>? get processedTexts => _processedTexts;
  ImageViewModel get imageProvider => _imageProvider;

  set imageProvider(ImageViewModel imageProvider) {
    _imageProvider = imageProvider;
  }
  void getText() async {
    setState(CurrentState.loading);
    try {
      final _mlServices = MlService();
      final ImageModel _image = _imageProvider.image;
      final String _imagePath = _image.imagePath!;
      _processedTexts = await _mlServices.getText(_imagePath);
      setState(CurrentState.loaded);
    } catch (e) {
      setState(CurrentState.error);
    }

  }
}