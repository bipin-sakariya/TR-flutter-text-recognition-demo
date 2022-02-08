import 'package:flutter/material.dart';
import 'package:image_to_text/provider/text_provider.dart';

class DisplayResult extends StatelessWidget {
  final TextViewModel? textProvider;
  const DisplayResult(this.textProvider, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(
          height: 5.0,
        ),
        Container(
          decoration: BoxDecoration(
            border: Border.all(color: Colors.white)
          ),
          child: Column(
            children: [
              const Text("Selected Text From Picture",style: TextStyle(decoration: TextDecoration.underline,fontSize: 16),),
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
          ),
        ),
      ],
    );
  }
}