import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kptkfrontendluring/pages/login_screen.dart';
import 'package:kptkfrontendluring/pages/splash_screen.dart';
void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: Future.delayed(const Duration(seconds: 3),), 
      builder:(context, snapshot) {
        if(snapshot.connectionState == ConnectionState.waiting){
          return SplashScreen();
        }else{
          return GetMaterialApp(
            title: 'Login Aplikasi',
            debugShowCheckedModeBanner: false,
            home: LoginScreen(),
          );
        }
      },
      );
  }
}