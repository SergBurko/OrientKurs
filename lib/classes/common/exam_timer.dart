import 'dart:async';

import 'package:flutter/widgets.dart';

class ExamTimer extends ChangeNotifier {
  int seconds = 59;
  int minutes = 59;
  bool finished = false;



  start() {
    Timer.periodic(const Duration(seconds: 1), (Timer t) {
      if (minutes == 0 && seconds == 0) {
        t.cancel(); // Остановка таймера
        finished = true;
      } else {
        if (seconds == 0) {
          minutes--;
          seconds = 59;
        } else {
          seconds--;
        }
        // notifyListeners();
      }
    });
  }
}
