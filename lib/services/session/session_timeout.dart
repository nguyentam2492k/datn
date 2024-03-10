// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:async';

import 'package:flutter/material.dart';

class SessionTimeoutLitener extends StatefulWidget {
  final Widget child;
  final Duration duration;
  final VoidCallback onTimeOut;
  
  const SessionTimeoutLitener({
    super.key,
    required this.child,
    required this.duration,
    required this.onTimeOut,
  });

  @override
  State<StatefulWidget> createState() {
    return SessionTimeoutLitenerState();
  }
}

class SessionTimeoutLitenerState extends State<SessionTimeoutLitener> {

  Timer? _timer;

  _startTimer() {
    print("Session start");
    if (_timer != null) {
      _timer?.cancel();
      _timer = null;
    }

    _timer = Timer(widget.duration, () {
      print("Session end");
      widget.onTimeOut();
    });
  }

  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  @override
  void dispose() {
    super.dispose();
    if (_timer != null) {
      _timer?.cancel();
      _timer = null;
    }
  }
  
  @override
  Widget build(BuildContext context) {
    return widget.child;
  }
  
}