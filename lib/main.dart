// import 'package:datn/screens/home/home_screen.dart';
import 'package:datn/screens/log_in/log_in.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

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
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [Locale('vi')],
      home: Container(
        color: Colors.white,
        child: const SafeArea(
          child: LogIn(),
        ),
      ),
      debugShowCheckedModeBanner: false,
    );
  }
}
