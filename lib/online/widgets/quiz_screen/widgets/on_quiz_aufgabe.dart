import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:second_quiz/online/common/on_quiz_group.dart';

class OnQuizAufgabe extends StatelessWidget {
  const OnQuizAufgabe(
      {super.key/* , required this.onQuizGroup */});
  /* final OnQuizGroup onQuizGroup; */
  // final QuizQuestion quizQuestion;

  @override
  Widget build(BuildContext context) {
  OnQuizGroup onQuizGroup = Provider.of<OnQuizGroup>(context);

    return InkWell(
      onTap: () {
        showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                backgroundColor: Colors.white,
                surfaceTintColor: Colors.white,
                title: const Text(''),
                content: SizedBox(
                  height: 500,
                  width: 300,
                  child: AutoSizeText(
                    onQuizGroup.quizQuestion.questionText,
                    minFontSize: 25,
                    maxFontSize: 50,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                         fontStyle: FontStyle.italic),
                    maxLines: 15,
                  ),
                ),
                actions: <Widget>[
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: const Text('Ok'),
                  ),
                ],
              );
            });
      },
      child: Padding(
        padding: const EdgeInsets.all(3.0),
        child: AutoSizeText(
          onQuizGroup.quizQuestion.questionText,
          minFontSize: 16,
          maxFontSize: 50,
          maxLines: 6,
          textAlign: TextAlign.center,
          style: const TextStyle(
                           fontStyle: FontStyle.italic)
        ),
      ),
    );
  }
}
