import 'package:flutter/material.dart';
import 'package:image_to_text/camera_screen/camera_screen.dart';
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
              builder: (_, imageProvider, __) => (imageProvider.state == CurrentState.loading)
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
                                CustomButton(text: 'Click another picture', onTap: imageProvider.getImage),
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
                                Consumer<TextViewModel>(builder: (_, textProvider, __) {
                                  return CustomButton(
                                      text: 'Clear',
                                      onTap: () {
                                        textProvider.setState(CurrentState.idle);
                                        imageProvider.clearImage();
                                      });
                                }),
                              ],
                            ),
                          ],
                        )
                      : CustomButton(text: 'Click picture', onTap: imageProvider.getImage),
            ),
            const SizedBox(
              height: 5.0,
            ),
            const SizedBox(
              height: 15,
            ),
            Consumer<TextViewModel>(
              builder: (_, textProvider, __) => (textProvider.state == CurrentState.idle)
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
            filterData(context),
            // CustomButton(
            //     text: 'Scan',
            //     onTap: () {
            //       Navigator.push(
            //           context,
            //           MaterialPageRoute(
            //               builder: (context) => const CameraPreviewScanner()));
            //     }),
            CustomButton(
                text: 'Camera',
                onTap: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => CameraScreen()));
                }),
          ],
        ),
      ),
    );
  }

  Widget filterData(BuildContext context) {
    List<String> filter = [];
    List<String> filterDate = [];
    // filterDate.clear();
    if (Provider.of<ImageViewModel>(context).image != null && Provider.of<TextViewModel>(context).state == CurrentState.loaded) {
      Provider.of<TextViewModel>(context).processedTexts?.forEach((element) {
        RegExp exp = RegExp('\\d{2}/\\d{2}/\\d{4}');
        // String str = "test string 01/06/1986 with a date inside";
        String? match = exp.firstMatch(element.block!)?.group(0);
        print("===MATCHED>${match}");
        if (RegExp(
                r'^(?:(?:31(\/|-|\.)(?:0?[13578]|1[02]|(?:Jan|Mar|May|Jul|Aug|Oct|Dec)))\1|(?:(?:29|30)(\/|-|\.)(?:0?[1,3-9]|1[0-2]|(?:Jan|Mar|Apr|May|Jun|Jul|Aug|Sep|Oct|Nov|Dec))\2))(?:(?:1[6-9]|[2-9]\d)?\d{2})$|^(?:29(\/|-|\.)(?:0?2|(?:Feb))\3(?:(?:(?:1[6-9]|[2-9]\d)?(?:0[48]|[2468][048]|[13579][26])|(?:(?:16|[2468][048]|[3579][26])00))))$|^(?:0?[1-9]|1\d|2[0-8])(\/|-|\.|\s)(?:(?:0?[1-9]|(?:Jan|Feb|Mar|Apr|May|Jun|Jul|Aug|Sep))|(?:1[0-2]|(?:Oct|Nov|Dec)))\4(?:(?:1[6-9]|[2-9]\d)?\d{2})$')
            .hasMatch(element.block!)) {
          print("===>${element.block!}");
          filterDate.add(element.block!);
          print("===>Found");
        } else {
          print("===>Not Found");
        }

        /*  if (RegExp(r'^[0-9]').hasMatch(element.block!)) {
          print(element.block);
          filter.add(element.block!);
          */ /*if (DateTime.parse("dd/MM/YYYY").toString() != DateTime.parse(element.block!).toString()) {
            print("===>${element.block!}");
          }*/ /*
        }*/
      });
    } else {
      filter.clear();
    }

    //fliter with month name
    /*filter.forEach((element) {
      if (RegExp(
      r'^(?:(?:31(\/|-|\.)(?:0?[13578]|1[02]|(?:Jan|Mar|May|Jul|Aug|Oct|Dec)))\1|(?:(?:29|30)(\/|-|\.)(?:0?[1,3-9]|1[0-2]|(?:Jan|Mar|Apr|May|Jun|Jul|Aug|Sep|Oct|Nov|Dec))\2))(?:(?:1[6-9]|[2-9]\d)?\d{2})$|^(?:29(\/|-|\.)(?:0?2|(?:Feb))\3(?:(?:(?:1[6-9]|[2-9]\d)?(?:0[48]|[2468][048]|[13579][26])|(?:(?:16|[2468][048]|[3579][26])00))))$|^(?:0?[1-9]|1\d|2[0-8])(\/|-|\.|\s)(?:(?:0?[1-9]|(?:Jan|Feb|Mar|Apr|May|Jun|Jul|Aug|Sep))|(?:1[0-2]|(?:Oct|Nov|Dec)))\4(?:(?:1[6-9]|[2-9]\d)?\d{2})$')
          .hasMatch(element)) {
        print("===>${element}");
        filterDate.add(element);
        print("===>Found");
      } else {
        print("===>Not Found");
      }
    });*/
    return filterDate.isNotEmpty
        ? Column(
            children: [
              /*const Text(
                "Detected numbers from image",
                style: TextStyle(decoration: TextDecoration.underline, fontSize: 16),
              ),
              ListView.builder(
                itemCount: filter.length,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemBuilder: (_, index) {
                  return SelectableText(filter[index]);
                },
              ),*/
              filterDate.isNotEmpty
                  ? const Text(
                      "Detected Dates from image",
                      style: TextStyle(decoration: TextDecoration.underline, fontSize: 16),
                    )
                  : Container(
                      child: Text("Detected Dates Not Found"),
                    ),
              filterDate.isNotEmpty
                  ? ListView.builder(
                      itemCount: filterDate.length,
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemBuilder: (_, index) {
                        return SelectableText(filterDate[index]);
                      },
                    )
                  : Container(
                      child: Text("Detected Dates Not Found"),
                    )
            ],
          )
        : Container();
  }
}
