import 'package:flutter/material.dart';
import 'package:flutter_api_sample/ui/screen/splash_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter api Sample',
      theme: ThemeData(
        primarySwatch: Colors.orange,
      ),
      home: SplashScreen(key: UniqueKey()),
    );
  }

}
