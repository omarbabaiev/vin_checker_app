import 'package:flutter/material.dart';
import 'package:vin_checker_app/screens/home_screen.dart';
import 'package:get/get.dart';
import 'package:vin_checker_app/screens/intro_screen.dart';
import 'package:vin_checker_app/screens/splash_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'VINCheck',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.pinkAccent),
        useMaterial3: true,
      ),
      home: MyCustomSplashScreen(),
    );
  }
}

