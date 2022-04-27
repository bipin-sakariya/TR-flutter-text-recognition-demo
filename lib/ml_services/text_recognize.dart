import 'package:google_ml_kit/google_ml_kit.dart';
import 'package:image_to_text/model/text_model.dart';

class MlService {
  Future<List<RecognizedText>> getText(String path) async {
    final inputImage = InputImage.fromFilePath(path);
    final textDetector = GoogleMlKit.vision.textDetector();
    final RecognisedText recognisedText = await textDetector.processImage(inputImage);
    List<RecognizedText> recognizedList = [];
    print("======>${recognisedText.blocks}");
    // recognizedList.add(RecognizedText(lines: recognisedText.blocks));
    int i = 0, j = 0;
    for (TextBlock block in recognisedText.blocks) {
      i++;
      for (var textLine in block.lines) {
        j++;
        // for (var words in textLine.elements) {
        recognizedList.add(RecognizedText(lines: recognisedText.blocks, block: textLine.text));

        // }
      }
    }
    return recognizedList;
  }
}
