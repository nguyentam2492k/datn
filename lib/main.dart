import 'package:datn/screens/home/home_screen.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  
  @override
  Widget build(BuildContext context) {
    return buildMyApp();
  }

  MaterialApp buildMyApp() {
    return MaterialApp(
      title: 'Student UET System',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.white),
        useMaterial3: true,
      ),
      home: SafeArea(
          child: HomeScreen()
        ),
      debugShowCheckedModeBanner: false,
  );
  }

}
