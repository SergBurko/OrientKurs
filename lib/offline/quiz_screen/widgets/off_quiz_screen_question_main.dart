import 'dart:math';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:second_quiz/classes/common/settings.dart';
import 'package:second_quiz/classes/quiz/quiz_question.dart';
import 'package:second_quiz/offline/quiz_screen/widgets/off_quiz_screen_question_answers_list.dart';
import 'package:second_quiz/offline/quiz_screen/widgets/off_quiz_screen_question_image_zone.dart';
// import 'package:second_quiz/classes/widgets/quiz_screen/widgets/quiz_screen_question_image_zone.dart';

class OffQuizScreenQuestionMain extends StatefulWidget {
  const OffQuizScreenQuestionMain({required this.settings, super.key});

  final Settings settings;

  @override
  State<OffQuizScreenQuestionMain> createState() => _OffQuizScreenQuestionMainState();
}

class _OffQuizScreenQuestionMainState extends State<OffQuizScreenQuestionMain> {
  bool loaded = false;

  Future<dynamic> dataActualisation() async {
    try {
      QuizQuestion currentQuestion =
          Provider.of<QuizQuestion>(context, listen: false);

      widget.settings.questions =
          await QuizQuestion.empty().getQuestionListFromFile();

      List<QuizQuestion> regionQuestions = await QuizQuestion.empty()
          .getQuestionListFromRegionFile(widget.settings.land);
      widget.settings.questions.addAll(regionQuestions);

      if (!widget.settings.checkLerning) {
        List<QuizQuestion> examinationQuestion = [];
        for (var i = 0; i < 33; i++) {
          int randomQuestionId = -1;
          while (randomQuestionId == -1 ||
              examinationQuestion
                  .contains(widget.settings.questions[randomQuestionId])) {
            randomQuestionId =
                Random().nextInt(widget.settings.questions.length);
          }
          examinationQuestion.add(widget.settings.questions[randomQuestionId]);
        }
        widget.settings.questions = examinationQuestion;
      }

      currentQuestion.renewQuestion(widget.settings.questions[0]);
    } catch (e) {
      print(e);
    }
  }

  Future<void> delay() async {
    await Future.delayed(const Duration(seconds: 1));
    setState(() {
      loaded = true;
    });
  }

  @override
  void initState() {
    super.initState();
    dataActualisation();
    delay();
  }

  @override
  Widget build(BuildContext context) {

    QuizQuestion currentQuestion = Provider.of<QuizQuestion>(context);
    return !loaded 
        ? const Center(child: CircularProgressIndicator())
        : SafeArea(
          child: Scaffold(
            // appBar: AppBar(actions: [Text("yohoho")] ),
            // appBar: AppBar(actions: [Text("${examTimer.minutes}:${examTimer.seconds}")]),
            body: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Flexible(
                    flex: 2,
                  // Question #
                    child: FittedBox(
                      alignment: Alignment.center,
                      child: Text(
                          textAlign: TextAlign.center,
                          'Aufgabe №${currentQuestion.questionId} \n${!widget.settings.checkLerning ? "${currentQuestion.examinationQuestionNumer+1}/33" : ""}',
                          style: const TextStyle(fontSize: 30)),
                    ),
                  ),
                  // question TEXT
                  Flexible(
                      flex: 5,
                      child: InkWell(
                        onTap: () {
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                backgroundColor: Colors.white,
                                surfaceTintColor: Colors.white,
                                title: const Text(''),
                                content: SizedBox(
                                  height: 500,
                                  width: 300,
                                  child: AutoSizeText(
                                    currentQuestion.questionText,
                                    textAlign: TextAlign.center,
                                    style: const TextStyle(
                                        fontSize: 40, fontStyle: FontStyle.italic),
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
                            },
                          );
                        },
                        child: AutoSizeText(
                          currentQuestion.questionText,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                              fontSize: 50, fontStyle: FontStyle.italic),
                          maxLines: 5,
                        ),
                      )),
                  // IMAGES
                  Flexible(
                      flex: currentQuestion.images.isNotEmpty ? 6 : 0,
                      child: Builder(builder: (context) {
                        if (currentQuestion.images.isNotEmpty) {
                          return const OffQuizScreenQuestionImageZone();
                        } else {
                          return Container();
                        }
                      })),
                  // ANSWERS
                  const Flexible(
                      flex: 12,
                      child: OffQuizScreenQuestionAnswersList(
                          /* settings : widget.settings */))
                ],
              ),
          ),
        );
  }
}
