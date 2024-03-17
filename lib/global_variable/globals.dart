library my_prj.globals;

import 'package:datn/model/login/login_model.dart';
import 'package:flutter/material.dart';

LoginResponseModel? globalLoginResponse;
final GlobalKey<ScaffoldMessengerState> rootScaffoldMessengerKey = GlobalKey<ScaffoldMessengerState>();
final GlobalKey<NavigatorState> globalNavigatorKey = GlobalKey<NavigatorState>();