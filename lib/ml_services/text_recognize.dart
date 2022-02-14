import 'package:google_ml_kit/google_ml_kit.dart';
import 'package:image_to_text/model/text_model.dart';

class MlService {
  Future<List<RecognizedText>> getText(String path) async {
    final inputImage = InputImage.fromFilePath(path);
    final textDetector = GoogleMlKit.vision.textDetector();
    final RecognisedText recognisedText =
    await textDetector.processImage(inputImage);


    List<RecognizedText> recognizedList = [];

    for (TextBlock block in recognisedText.blocks) {
      for (var textLine in block.lines) {
        for (var words in textLine.elements) {
          recognizedList.add(
              RecognizedText(/*lines: block.lines,*/
                  block: words.text.toLowerCase()));
        }
      }
    }
    return recognizedList;
}}