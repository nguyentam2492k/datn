library my_prj.globals;

import 'package:datn/model/student/student_profile.dart';
import 'package:datn/services/secure_storage/secure_storage_servies.dart';
import 'package:flutter/material.dart';

final GlobalKey<ScaffoldMessengerState> rootScaffoldMessengerKey = GlobalKey<ScaffoldMessengerState>();
final GlobalKey<NavigatorState> globalNavigatorKey = GlobalKey<NavigatorState>();
SecureStorageServices secureStorageServices = SecureStorageServices();

var globalStudentProfile = StudentProfile();
ValueNotifier<String?> globalProfileImage = ValueNotifier(null);

setGlobalLoginResponse(StudentProfile studentProfile) {
  globalStudentProfile = studentProfile;
  globalProfileImage.value = studentProfile.image;
}

StudentProfile getGlobalLoginResponse() {
  return globalStudentProfile;
}