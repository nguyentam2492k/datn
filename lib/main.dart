import 'package:datn/global_variable/globals.dart';
import 'package:datn/model/login/login_model.dart';
import 'package:datn/screens/home/home_screen.dart';
import 'package:datn/screens/log_in/log_in.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  var userInfo = await secureStorageServices.getSaveUserInfo();
  runApp(MyApp(saveUserInfo: userInfo,));
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
  final LoginResponseModel? saveUserInfo;
  const MyApp({super.key, this.saveUserInfo});
  
  @override
  State<StatefulWidget> createState() {
    return MyAppState();
  }
}

class MyAppState extends State<MyApp> {

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
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
      title: 'UET Single Window System',
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
      home: SafeArea(
        child: widget.saveUserInfo == null ? const LogIn() : HomeScreen(loginResponse: widget.saveUserInfo!),
      ),
      debugShowCheckedModeBanner: false,
      builder: EasyLoading.init(),
    );
  }
}
