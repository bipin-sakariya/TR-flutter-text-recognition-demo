import 'package:flutter/material.dart';
import 'package:image_to_text/provider/image_provider.dart';
import 'package:image_to_text/provider/text_provider.dart';
import 'package:image_to_text/view/home_page.dart';
import 'package:provider/provider.dart';


void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
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
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
          title: 'Flutter Demo',
          // theme: ThemeData(
          //   primarySwatch: Colors.blue,
          // ),
          theme: ThemeData.dark(),
          darkTheme: ThemeData.dark(),
          home: const HomePage()),
    );
  }
}