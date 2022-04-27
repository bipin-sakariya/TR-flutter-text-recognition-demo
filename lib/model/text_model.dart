import 'package:google_ml_kit/google_ml_kit.dart';

class RecognizedText {
  String? block;
  List<TextBlock>? lines;

  RecognizedText({required this.lines, this.block});
}
