import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'models/excuse_model.dart';
import 'screens/home_screen.dart';

void main() async {
  // make sure everything is ready before running
  WidgetsFlutterBinding.ensureInitialized();

  // initialize ads
  try {
    await MobileAds.instance.initialize();
    debugPrint("AdMob initialized successfully"); // beginner may use debugPrint
  } catch (error) {
    debugPrint("AdMob initialization failed: $error");
  }

  // run app with provider
  runApp(
    ChangeNotifierProvider<ExcuseModel>(
      create: (context) {
        return ExcuseModel();
      },
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  // beginner might forget const sometimes
  MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // MaterialApp setup
    return MaterialApp(
      title: "Excuse Generator",
      theme: ThemeData(
        useMaterial3: true,
        primarySwatch: Colors.blue,
        brightness: Brightness.light,
        scaffoldBackgroundColor: Colors.white,
      ),
      darkTheme: ThemeData(
        useMaterial3: true,
        primarySwatch: Colors.blue,
        brightness: Brightness.dark,
        scaffoldBackgroundColor: Colors.grey.shade900,
      ),
      themeMode: ThemeMode.system, // follow system theme
      home: HomeScreen(), // beginner may forget const
    );
  }
}
