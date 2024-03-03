import 'package:flutter/material.dart';
import 'package:flutter_api_sample/ui/widget_keys.dart';
import 'package:flutter_api_sample/viewModel/splash_screen_view_model.dart';
import 'package:provider/provider.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({required Key key}) : super(key: key);

  @override
  SplashScreenState createState() => SplashScreenState();
}

class SplashScreenState extends State<SplashScreen> {

  late final SplashScreenViewModel viewModel;

  @override
  Widget build(BuildContext context) {
    viewModel = SplashScreenViewModel();
    viewModel.moveNextScreen(context);
    return ChangeNotifierProvider(
        create: (context) => viewModel,
        child: const SplashScreenPage()
    );
  }

}

class SplashScreenPage extends StatelessWidget {
  const SplashScreenPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
          child: Image(
              key: Key(WidgetKey.KEY_SPLASH_SPLASH_IMAGE),
              image: AssetImage('assets/splash.png')
          ),
      ),
    );
  }

}