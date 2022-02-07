import 'package:flutter/material.dart';
import 'package:image_to_text/provider/text_provider.dart';

class DisplayText extends StatelessWidget {
  final TextViewModel? textProvider;
  const DisplayText(this.textProvider, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      // mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          color: Colors.white,

          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: Container(
            margin: const EdgeInsets.only(left: 25,right: 25),
            child: Text(
              'Found ${textProvider!.processedTexts!.length} items from image',style: TextStyle(color: Colors.black),
            ),
          ),
        ),
        const SizedBox(
          height: 5.0,
        ),
        Expanded(
          child: ListView.builder(

            itemCount: textProvider!.processedTexts!.length,
            padding: const EdgeInsets.all(12.0),
            itemBuilder: (_, index) {
              return SelectableText(
                      '${textProvider!.processedTexts![index].block}');
            },
          ),
        ),
      ],
    );
  }
}