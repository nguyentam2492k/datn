library my_prj.globals;

import 'package:datn/model/login/login_model.dart';
import 'package:datn/services/secure_storage/secure_storage_servies.dart';
import 'package:flutter/material.dart';

LoginResponseModel? globalLoginResponse;
final GlobalKey<ScaffoldMessengerState> rootScaffoldMessengerKey = GlobalKey<ScaffoldMessengerState>();
final GlobalKey<NavigatorState> globalNavigatorKey = GlobalKey<NavigatorState>();
SecureStorageServices secureStorageServices = SecureStorageServices();