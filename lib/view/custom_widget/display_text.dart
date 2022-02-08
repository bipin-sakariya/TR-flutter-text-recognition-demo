import 'package:flutter/material.dart';
import 'package:image_to_text/provider/text_provider.dart';

class DisplayResult extends StatelessWidget {
  final TextViewModel? textProvider;
  const DisplayResult(this.textProvider, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          color: Colors.white,

          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: Container(
            margin: const EdgeInsets.only(left: 25,right: 25),
            child: Text(
              'Found ${textProvider!.processedTexts!.length} items from picture',style: const TextStyle(color: Colors.black),
            ),
          ),
        ),
        const SizedBox(
          height: 5.0,
        ),
        ListView.builder(
          physics: const NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          itemCount: textProvider!.processedTexts!.length,
          padding: const EdgeInsets.all(12.0),
          itemBuilder: (_, index) {
            return SelectableText(
                    '${textProvider!.processedTexts![index].block}');
          },
        ),
      ],
    );
  }
}