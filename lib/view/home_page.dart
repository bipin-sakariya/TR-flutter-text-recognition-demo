import 'package:flutter/material.dart';
import 'package:image_to_text/provider/base_model.dart';
import 'package:image_to_text/provider/image_provider.dart';
import 'package:image_to_text/provider/text_provider.dart';
import 'package:image_to_text/view/result_page.dart';
import 'package:provider/provider.dart';

import 'custom_widget/display_image.dart';
import 'custom_widget/upload_image_button.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Text Detection'),
        centerTitle: true,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const SizedBox(
            height: 25.0,
          ),
          Consumer<ImageViewModel>(
            builder: (_, imageProvider, __) =>
            (imageProvider.state == CurrentState.loading)
                ? const Center(child: CircularProgressIndicator())
                : (imageProvider.state == CurrentState.loaded)
                ? Column(
              children: [
                DisplayImage(imageProvider.image.imagePath),
                const SizedBox(
                  height: 15.0,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CustomButton(
                        text: 'Click another picture',
                        onTap: imageProvider.getImage),
                    const SizedBox(width: 10,),
                    CustomButton(
                        text: 'Clear',
                        onTap: imageProvider.clearImage)
                  ],
                ),
              ],
            )
                : CustomButton(
                text: 'Click picture',
                onTap: imageProvider.getImage),
          ),
          const SizedBox(
            height: 15.0,
          ),
          Consumer2<TextViewModel, ImageViewModel>(
            builder: (_, textProvider, imageProvider, __) => ElevatedButton(
              onPressed: (imageProvider.image == null)
                  ? null
                  : () {
                textProvider.getText();
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (_) => const ResultPage()));
              },
              child: const Text('Convert'),
            ),
          ),
        ],
      ),
    );
  }
}