library my_prj.globals;

import 'package:datn/services/secure_storage/secure_storage_servies.dart';
import 'package:flutter/material.dart';

final GlobalKey<ScaffoldMessengerState> rootScaffoldMessengerKey = GlobalKey<ScaffoldMessengerState>();
final GlobalKey<NavigatorState> globalNavigatorKey = GlobalKey<NavigatorState>();
SecureStorageServices secureStorageServices = SecureStorageServices();