import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:second_quiz/online/common/on_quiz_group.dart';

class OnQuizAufgabeNum extends StatelessWidget {
  const OnQuizAufgabeNum({super.key/* , required this.onQuizGroup */});
  // final OnQuizGroup onQuizGroup;

  @override
  Widget build(BuildContext context) {
    OnQuizGroup onQuizGroup = Provider.of<OnQuizGroup>(context);
    return AutoSizeText("Aufgabe №${onQuizGroup.currentQuestion}", textAlign: TextAlign.center,
        minFontSize: 20, maxFontSize: 40);
  }
}
