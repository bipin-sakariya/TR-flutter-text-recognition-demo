import 'dart:math';

import 'package:flutter/material.dart';
import 'package:image_to_text/camera_screen/camera_screen.dart';
import 'package:image_to_text/provider/base_model.dart';
import 'package:image_to_text/provider/image_provider.dart';
import 'package:image_to_text/provider/text_provider.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import 'custom_widget/display_image.dart';
import 'custom_widget/display_text.dart';
import 'custom_widget/upload_image_button.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
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
    List<DateTime> convertedList = [];
    List<double> totalList = [];
    DateTime? dueDate;
    String? invoiceNumber;
    double? total;
    String? companyName;
    List<String> companyNameList = ["Landscaping Brisbane", "FLOORS and TILING", "Niges Frameworking", "Roofing Extras Pty Ltd"];
    if (Provider.of<ImageViewModel>(context).image != null && Provider.of<TextViewModel>(context).state == CurrentState.loaded) {
      /* Provider.of<TextViewModel>(context).processedTexts?.forEach((element) {
      });
*/
      Provider.of<TextViewModel>(context).processedTexts?.asMap().forEach((index, element) {
        //for due date regex
        try {
          if (element.block!.contains(":")) {
            var name = element.block!.split(":");
            if (RegExp(
                    r'^(?:(?:31(\/|-|\.)(?:0?[13578]|1[02]|(?:Jan|Mar|May|Jul|Aug|Oct|Dec)))\1|(?:(?:29|30)(\/|-|\.)(?:0?[1,3-9]|1[0-2]|(?:Jan|Mar|Apr|May|Jun|Jul|Aug|Sep|Oct|Nov|Dec))\2))(?:(?:1[6-9]|[2-9]\d)?\d{2})$|^(?:29(\/|-|\.)(?:0?2|(?:Feb))\3(?:(?:(?:1[6-9]|[2-9]\d)?(?:0[48]|[2468][048]|[13579][26])|(?:(?:16|[2468][048]|[3579][26])00))))$|^(?:0?[1-9]|1\d|2[0-8])(\/|-|\.|\s)(?:(?:0?[1-9]|(?:Jan|Feb|Mar|Apr|May|Jun|Jul|Aug|Sep))|(?:1[0-2]|(?:Oct|Nov|Dec)))\4(?:(?:1[6-9]|[2-9]\d)?\d{2})$')
                .hasMatch(name[1].trim())) {
              filterDate.add(name[1].trim());
            }
          } else {
            if (RegExp(
                    r'^(?:(?:31(\/|-|\.)(?:0?[13578]|1[02]|(?:Jan|Mar|May|Jul|Aug|Oct|Dec)))\1|(?:(?:29|30)(\/|-|\.)(?:0?[1,3-9]|1[0-2]|(?:Jan|Mar|Apr|May|Jun|Jul|Aug|Sep|Oct|Nov|Dec))\2))(?:(?:1[6-9]|[2-9]\d)?\d{2})$|^(?:29(\/|-|\.)(?:0?2|(?:Feb))\3(?:(?:(?:1[6-9]|[2-9]\d)?(?:0[48]|[2468][048]|[13579][26])|(?:(?:16|[2468][048]|[3579][26])00))))$|^(?:0?[1-9]|1\d|2[0-8])(\/|-|\.|\s)(?:(?:0?[1-9]|(?:Jan|Feb|Mar|Apr|May|Jun|Jul|Aug|Sep))|(?:1[0-2]|(?:Oct|Nov|Dec)))\4(?:(?:1[6-9]|[2-9]\d)?\d{2})$')
                .hasMatch(element.block!)) {
              filterDate.add(element.block!);
            } else {
              print("===>Not Found");
            }
          }
        } catch (e) {
          print("===>CATCH--${e}");
        }

        //for invoice number regex
        if (RegExp(r'^(\bInv|INV\b)(.*?)$').hasMatch(element.block!)) {
          try {
            String? name = Provider.of<TextViewModel>(context).processedTexts?.elementAt(index + 1).block!;
            if (RegExp(r'^\d{4}$').hasMatch(name!)) {
              // ^(.*)\d{4}(.*?)$
              invoiceNumber = name;
            } else {
              invoiceNumber = Provider.of<TextViewModel>(context).processedTexts?.elementAt(index - 1).block;
            }
          } catch (e) {
            print("===>CATCH--${e}");
          }
        } else if (element.block!.contains("Tax Invoice #")) {
          try {
            var nameInvoice = element.block!.split("#");
            if (RegExp(r'^\d{4}$').hasMatch(nameInvoice[1].trim())) {
              print("===>Tax Invoice Is ---${nameInvoice[1]}");
              invoiceNumber = nameInvoice[1];
            } else {
              print("===>Tax Invoice Is Not Found");
              invoiceNumber = "Tax Invoice Is Not Found Please ReTake!";
            }
            print("===>Inv Not Found");
          } catch (e) {
            print("===>CATCH--${e}");
          }
        } else if (element.block!.contains("INVOICE #")) {
          try {
            String? name = Provider.of<TextViewModel>(context).processedTexts?.elementAt(index + 4).block!;
            if (RegExp(r'^\d{4}$').hasMatch(name!)) {
              // ^(.*)\d{4}(.*?)$
              invoiceNumber = name;
            } else {
              print("===>Tax Invoice Is Not Found");
              invoiceNumber = "Tax Invoice Is Not Found Please ReTake!";
            }
          } catch (e) {
            print("===>CATCH--${e}");
          }
        } else if (RegExp(r'^(.*)[\.][0-9]{2}?$').hasMatch(element.block!)) {
          try {
            if (element.block!.startsWith("\$")) {
              totalList.add(double.parse(element.block!.replaceAll("\$", "").replaceAll("%", "")));
            } else {
              totalList.add(double.parse(element.block!.replaceAll("%", "")));
            }
            total = totalList.reduce(max);
            totalList.reduce(max);
            totalList.remove(total);
            print("====>MAX ---- ${total}");
          } catch (e) {
            print("===>CATCH--${e}");
          }
        }
        //For company name
        else if (companyNameList.contains(element.block!)) {
          companyName = element.block!;
        }
      });
    } else {
      filter.clear();
    }
    try {
      filterDate.forEach((element) {
        if (element.contains("Jan") ||
            element.contains("Feb") ||
            element.contains("Mar") ||
            element.contains("Apr") ||
            element.contains("May") ||
            element.contains("Jun") ||
            element.contains("Jul") ||
            element.contains("Aug") ||
            element.contains("Sep") ||
            element.contains("Oct") ||
            element.contains("Nov") ||
            element.contains("Dec")) {
          DateTime pdate1 = DateFormat("d MMM y").parse(element);
          convertedList.add(pdate1);
        } else {
          DateTime pdate = DateFormat("d/M/y").parse(element);
          convertedList.add(pdate);
        }
      });
      if (convertedList.length == 2) {
        if (convertedList[0].isBefore(convertedList[1])) {
          dueDate = convertedList[1];
        } else {
          dueDate = convertedList[0];
        }
      } else {
        print("====>Converted List is empty");
      }
    } catch (e) {
      print("===>${e.toString()}");
    }
    return filterDate.isNotEmpty
        ? Column(
            children: [
              filterDate.isNotEmpty
                  ? const Text(
                      "Detected Dates from image",
                      style: TextStyle(decoration: TextDecoration.underline, fontSize: 16),
                    )
                  : Container(
                      child: const Text("Detected Dates Not Found"),
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
                      child: const Text("Detected Dates Not Found"),
                    ),
              const SizedBox(height: 20),
              companyName != null ? Text("Company Name is :- $companyName") : const Text("Company Name is Not Found"),
              dueDate != null ? Text("Due Date is:- ${DateFormat("d/M/y").format(dueDate)}") : const Text("Due Date is Not Found"),
              invoiceNumber != null ? Text("Invoice Number is :- $invoiceNumber") : const Text("Invoice Number is Not Found"),
              total != null ? Text("Total is  :- ${total!.toStringAsFixed(2)}") : const Text("Total is Not Found")
            ],
          )
        : Container();
  }
}
