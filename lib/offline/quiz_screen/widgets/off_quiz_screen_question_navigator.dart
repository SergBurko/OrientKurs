import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:second_quiz/classes/common/settings.dart';
import 'package:second_quiz/classes/quiz/quiz.dart';
import 'package:second_quiz/classes/quiz/quiz_answer.dart';
import 'package:second_quiz/classes/quiz/quiz_question.dart';
import 'package:second_quiz/offline/quiz_screen/widgets/off_quiz_screen_question_navigator_combobox.dart';

// ignore: must_be_immutable
class OffQuizScreenQuestionNavigator extends StatelessWidget {
  OffQuizScreenQuestionNavigator(
      {super.key, required this.settings, required this.quiz});

  final Settings settings;
  Quiz quiz;

  @override
  Widget build(BuildContext context) {
    QuizQuestion currentQuestion = Provider.of<QuizQuestion>(context);

    return Center(
      child: Column(
          // mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Flexible(
                flex: 2,
                child: OffQuizScreenQuestionNavigatorCombobox(
                    settings: settings, currentQuestion: currentQuestion)),
            Flexible(
              flex: 1,
              child: Row(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Flexible(
                      flex: 3,
                      child: // when making examination, then you can not return
                          currentQuestion.questionId > 1 &&
                                  settings.checkLerning
// Button Left
                              ? FilledButton.icon(
                                  onPressed: () {
                                    currentQuestion.changeQuestion(
                                        currentQuestion.questionId,
                                        settings.questions,
                                        increm: -1);
                                  },
                                  label: const Text(""),
                                  icon: const Icon(Icons.arrow_left, size: 40),
                                )
                              : Container(),
                    ),
                    const Flexible(flex: 4, child: SizedBox(width: 10)),
                    Flexible(
                      flex: 3,
                      child: currentQuestion.questionId < 310 &&
                                  settings.checkLerning ||
                              !settings.checkLerning
// Button Right
                          ? FilledButton.icon(
                              onPressed: () {
                                if (!settings.checkLerning) {
                                  if (currentQuestion.examinationQuestionNumer <
                                      33) {
                                    if (currentQuestion.choosed > -1) {
                                      quiz.quizAnswers.add(QuizAnswer(
                                          questionId:
                                              currentQuestion.questionId,
                                          answerIndex: currentQuestion.choosed,
                                          rightIndex:
                                              currentQuestion.rightAnswerIndex,
                                          date: DateTime.now()));

                                      currentQuestion.changeQuestion(
                                          currentQuestion.questionId,
                                          settings.questions);

                                      if (currentQuestion
                                              .examinationQuestionNumer ==
                                          33) {
                                        showDialogAfterTest(quiz, context);
                                      }
                                    } else {
                                      showDialogChooseAnswer(context);
                                    }
                                  }
                                } else {
                                  currentQuestion.changeQuestion(
                                      currentQuestion.questionId,
                                      settings.questions);
                                }
                              },
                              label: const Text(""),
                              icon: const Icon(Icons.arrow_right, size: 40),
                            )
                          : Container(),
                    ),
                  ]),
            )
          ]),
    );
  }

  void showDialogAfterTest(Quiz quiz, BuildContext context) {
    showDialog(
        context: context,
        builder: (context) {
          int rightAnswersCount = 0;
          for (var quizAnswer in quiz.quizAnswers) {
            if (quizAnswer.answerIndex == quizAnswer.rightIndex) {
              rightAnswersCount++;
            }
          }
          var str = ["", "", "", ""];
          if (rightAnswersCount >= 15) {
            str[0] = "SUPER!\n\n";
            str[1] = "Prüfung bestanden!!\n\n";
            str[2] = "$rightAnswersCount / ${quiz.quizAnswers.length}\n\n";
            str[3] = "sind ";
          } else {
            str[0] = "Schade! :(\n\n";
            str[1] = "Nicht Passiert...\n\n";
            str[2] = "$rightAnswersCount / ${quiz.quizAnswers.length}\n\n";
            str[3] = "waren ";
          }
          return AlertDialog(
            content: SizedBox(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.width / 1.3,
              child: Center(
                  child: RichText(
                textAlign: TextAlign.center,
                text: TextSpan(children: [
                  TextSpan(
                      text: str[0],
                      style: Theme.of(context).textTheme.bodyLarge),
                  TextSpan(
                      text: str[1],
                      style: Theme.of(context).textTheme.titleMedium),
                  TextSpan(
                      text: str[2],
                      style: Theme.of(context).textTheme.bodyLarge),
                  TextSpan(
                      text: str[3],
                      style: Theme.of(context).textTheme.titleMedium),
                  TextSpan(
                      text: "richtig!",
                      style: Theme.of(context).textTheme.bodyLarge),
                ]),
              )

                  //     AutoSizeText(
                  //   str,
                  //   maxFontSize: 40,
                  //   textAlign: TextAlign.center,
                  //   maxLines: 10,
                  // )
                  ),
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  Navigator.of(context).pop();
                },
                child: const Text('OK'),
              ),
            ],
          );
        });
  }

  void showDialogChooseAnswer(BuildContext context) {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Center(
                child: Text(
                    textAlign: TextAlign.center, "Wählen Sie eine Antwort!")),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text('OK'),
              ),
            ],
          );
        });
  }
}
