import 'package:datn/global_variable/globals.dart';
import 'package:datn/screens/log_in/log_in.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform
  );
  runApp(const MyApp());
  configLoading();
}

void configLoading() {
  EasyLoading.instance
    ..indicatorType = EasyLoadingIndicatorType.fadingCircle
    ..loadingStyle = EasyLoadingStyle.light
    ..maskType = EasyLoadingMaskType.black
    ..userInteractions = false
    ..dismissOnTap = false
    ..animationDuration = const Duration(milliseconds: 80)
    ..contentPadding = const EdgeInsets.all(15)
    ..indicatorSize = 40.0
    ..radius = 15.0
    ..textStyle = const TextStyle(
        fontSize: 13,
        fontWeight: FontWeight.w600,
      )
    ..progressWidth = 3;
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});
  
  @override
  State<StatefulWidget> createState() {
    return MyAppState();
  }
}

class MyAppState extends State<MyApp> {

  @override
  void initState() {
    print("INIT APP");
    super.initState();
  }

  @override
  void dispose() {
    print("APP DISPOSED");
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return buildMyApp();
  }

  Widget buildMyApp() {
    return MaterialApp(
      scaffoldMessengerKey: rootScaffoldMessengerKey,
      navigatorKey: globalNavigatorKey,
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
      builder: EasyLoading.init(),
    );
  }
}
