import 'package:flutter/material.dart';
import 'package:image_to_text/provider/text_provider.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';


import 'image_provider.dart';

List<SingleChildWidget> providers = [
  ///List of all providers
  ChangeNotifierProvider<ImageViewModel>(
    create: (context) => ImageViewModel(),
  ),
  ChangeNotifierProxyProvider<ImageViewModel, TextViewModel>(
    create: (_) => TextViewModel(),
    update: (BuildContext context, ImageViewModel? imageProvider,
        TextViewModel? textProvider) {
      textProvider!.imageProvider = imageProvider!;
      return textProvider;
    },
    lazy: true,
  ),
];