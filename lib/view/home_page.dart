import 'package:flutter/material.dart';
import 'package:image_to_text/provider/base_model.dart';
import 'package:image_to_text/provider/image_provider.dart';
import 'package:image_to_text/provider/text_provider.dart';
import 'package:provider/provider.dart';

import 'custom_widget/display_image.dart';
import 'custom_widget/display_text.dart';
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
      body: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        child: Column(
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
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      CustomButton(
                          text: 'Click another picture',
                          onTap: imageProvider.getImage),
                      Consumer2<TextViewModel, ImageViewModel>(
                        builder: (_, textProvider, imageProvider, __) => ElevatedButton(
                          onPressed: (imageProvider.image == null)
                              ? null
                              : () {
                            textProvider.getText();
                          },
                          child: const Text('Convert'),
                        ),
                      ),
                      Consumer<TextViewModel>( builder: (_, textProvider, __) {
                        return  CustomButton(
                            text: 'Clear',
                            onTap: (){
                              textProvider.setState(CurrentState.idle);
                              imageProvider.clearImage();
                            });
                      }

                      ),
                    ],
                  ),
                ],
              )
                  : CustomButton(
                  text: 'Click picture',
                  onTap: imageProvider.getImage),
            ),
            const SizedBox(
              height: 5.0,
            ),
            const SizedBox(height: 15,),
            Consumer<TextViewModel>(
              builder: (_, textProvider, __) =>
              (textProvider.state == CurrentState.idle)
                  ? const Center(
                child: Text(''),
              )
                  : (textProvider.state == CurrentState.error)
                  ? const Center(
                child: Text('Something went wrong!!!!'),
              )
                  : (textProvider.state == CurrentState.loading)
                  ? const Center(child: CircularProgressIndicator())
                  : Center(child: DisplayResult(textProvider)),
            ),

          ],
        ),
      ),
    );
  }
}