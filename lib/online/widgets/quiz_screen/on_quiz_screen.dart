import 'dart:math';

import 'package:audioplayers/audioplayers.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:provider/provider.dart';
import 'package:second_quiz/classes/quiz/quiz_question.dart';
import 'package:second_quiz/online/common/dialogs.dart';
import 'package:second_quiz/online/common/on_quiz_group.dart';
import 'package:second_quiz/online/common/on_quiz_user_answer.dart';
import 'package:second_quiz/online/widgets/quiz_screen/widgets/on_quiz_answers.dart';
import 'package:second_quiz/online/widgets/quiz_screen/widgets/on_quiz_aufgabe.dart';
import 'package:second_quiz/online/widgets/quiz_screen/widgets/on_quiz_aufgabe_num.dart';
import 'package:second_quiz/online/widgets/quiz_screen/widgets/on_quiz_images.dart';
import 'package:second_quiz/online/widgets/quiz_screen/widgets/on_quiz_navigator.dart';
import 'package:second_quiz/online/widgets/quiz_screen/widgets/on_quiz_questions_combobox.dart';
import 'package:second_quiz/online/widgets/quiz_screen/widgets/on_quiz_stat_butt.dart';

// ignore: must_be_immutable
class OnQuizScreen extends StatefulWidget {
  OnQuizScreen({super.key, required this.onQuizGroup});

  OnQuizGroup onQuizGroup;

  @override
  State<OnQuizScreen> createState() => _OnQuizScreenState();
}

class _OnQuizScreenState extends State<OnQuizScreen>
    with WidgetsBindingObserver {
  int seconds = 0;
  int minutes = 0;
  bool isActive = true;
  bool timeAlmostFinished = false;
  bool timeFinished = false;
  // late Timer timer;
  AudioPlayer audioPlayer = AudioPlayer();
  List<QuizQuestion> questionsList = [];

  // void startTimer() {
  //   timer = Timer.periodic(const Duration(seconds: 1), (Timer t) {
  //     if (!isActive) {
  //       return; // Если приложение неактивно, просто выходите из функции
  //     }
  //     if (minutes == 0 && seconds == 0) {
  //       timeFinished = true;
  //       t.cancel(); // Остановка таймера
  //       audioPlayer
  //           .play(AssetSource("${Singleton.assetsMusicFolder}timerout.mp3"));
  //     } else {
  //       setState(() {
  //         if (seconds == 0) {
  //           minutes--;
  //           seconds = 59;
  //         } else {
  //           seconds--;
  //         }
  //         if (minutes < 1 && seconds > 1 && seconds < 20) {
  //           timeAlmostFinished = true;
  //           // if (seconds % 10 == 0) {
  //           audioPlayer
  //               .play(AssetSource("${Singleton.assetsMusicFolder}clock.mp3"));
  //           // }
  //         }
  //       });
  //     }
  //   });
  // }

  @override
  void initState() {
    super.initState();
    // widget.quiz = Quiz(
    //     quizId: 0,
    //     quizAnswers: [],
    //     quizUser: QuizUser(quizUsername: widget.settings.defaultUserName));

    fillData(null);
    WidgetsBinding.instance.addObserver(this);

    // startTimer();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    // timer.cancel(); // Остановка таймера при закрытии экрана
    audioPlayer.dispose();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    setState(() {
      if (state == AppLifecycleState.resumed) {
        isActive = true;
        // startTimer();
        audioPlayer.resume();
      } else {
        isActive = false;
        // timer.cancel(); // Приостановка таймера, когда приложение сворачивается
        audioPlayer.pause();
      }
    });
  }

  fillData(OnQuizGroup? onQuizGroupNotified) async {
    OnQuizGroup onQuizGroup = onQuizGroupNotified ?? widget.onQuizGroup;

    questionsList = await QuizQuestion.empty().getQuestionListFromFile();
    questionsList.addAll(await QuizQuestion.empty()
        .getQuestionListFromRegionFile(onQuizGroup.land));

    try {
      if (onQuizGroup.currentQuestion.isEmpty) {
        if (onQuizGroup.lernState == true) {
          onQuizGroup.currentQuestion = "1";
        } else {
          List<String> oldQuestions = onQuizGroup.questions;
          onQuizGroup.questions = [];

          int regularQuestionAmount = 31;
          while (onQuizGroup.questions.length < regularQuestionAmount) {

            addQuestion(String value) {
              if (!onQuizGroup.questions.contains(value) && !oldQuestions.contains(value) &&
                  onQuizGroup.questions.length < regularQuestionAmount) {
                onQuizGroup.questions.add(value);
              }
            }

            String randomQuestionIndex = "";
            randomQuestionIndex = (Random().nextInt(50) + 51).toString();
            addQuestion(randomQuestionIndex);
            randomQuestionIndex = (Random().nextInt(50) + 101).toString();
            addQuestion(randomQuestionIndex);
            randomQuestionIndex = (Random().nextInt(50) + 151).toString();
            addQuestion(randomQuestionIndex);
            randomQuestionIndex = (Random().nextInt(50) + 201).toString();
            addQuestion(randomQuestionIndex);
            randomQuestionIndex = (Random().nextInt(50) + 251).toString();
            addQuestion(randomQuestionIndex);
          }

          while (onQuizGroup.questions.length < 33) {
            String randomQuestionIndex =
                (Random().nextInt(10) + 301).toString();
            if (!onQuizGroup.questions.contains(randomQuestionIndex)) {
              onQuizGroup.questions.add(randomQuestionIndex);
            }
            
          }
          onQuizGroup.questions.shuffle();
          onQuizGroup.currentQuestion = onQuizGroup.questions[0];
        }
      }

      onQuizGroup.addThisToDB();

      await onQuizGroup.renewQuizQuestionFromList(questionsList);

      await onQuizGroup.getCurrentParticipant();
    } catch (e) {
      print("FillData error #1: $e");
    }
    setState(() {});

    return onQuizGroup;
  }

  // fillData() async {

  //   questionsList = await QuizQuestion.empty().getQuestionListFromFile();
  //   questionsList.addAll(await QuizQuestion.empty()
  //       .getQuestionListFromRegionFile(widget.onQuizGroup.land));

  //   OnQuizUserAnswer().deleteAllAnswers(widget.onQuizGroup);

  //   try {
  //     if (widget.onQuizGroup.currentQuestion.isEmpty) {
  //       if (widget.onQuizGroup.lernState == true) {
  //         widget.onQuizGroup.currentQuestion = "1";
  //       } else {
  //         while (widget.onQuizGroup.questions.length < 33) {
  //           String randomQuestionIndex = (Random().nextInt(310) + 1).toString();
  //           if (!widget.onQuizGroup.questions.contains(randomQuestionIndex)) {
  //             widget.onQuizGroup.questions.add(randomQuestionIndex);
  //           }
  //         }
  //         widget.onQuizGroup.currentQuestion = widget.onQuizGroup.questions[0];
  //       }
  //     }

  //     widget.onQuizGroup.addThisToDB();

  //     await widget.onQuizGroup.renewQuizQuestionFromList(questionsList);

  //     await widget.onQuizGroup.getCurrentParticipant();
  //   } catch (e) {
  //     print("FillData error #1: $e");
  //   }

  //   setState(() {});
  // }

  @override
  Widget build(BuildContext context) {
    // OnQuizGroup onQuizGroup = Provider.of<OnQuizGroup>(context, listen: false);
    // OnQuizGroup onQuizGroup = Provider.of<OnQuizGroup>(context);
    // minutes = widget.onQuizGroup.secondsOnAnswer ~/ 60;
    // seconds = widget.onQuizGroup.secondsOnAnswer % 60;

    return Consumer<OnQuizGroup>(
      builder: (context, onQuizGroup, child) {
//LISTENING DB ON CHANGES
        onQuizGroup.listenToChanges(questionsList);

        return Scaffold(
// APPBAR
            appBar: AppBar(
              title: onQuizGroup.userId !=
                      FirebaseAuth.instance.currentUser!.uid
                  ? const Text("")
                  : Center(
                      child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Material(
                            elevation: 5,
                            borderRadius: BorderRadius.circular(30),
                            child: SizedBox(
                              height: 35,
                              width: 35,
                              child: IconButton(
                                  padding: EdgeInsets.all(0),
                                  onPressed: () async {
                                    bool refreshAskResult =
                                        await Dialogs.showConfirmationDialog(
                                            context);
                                    if (refreshAskResult) {
                                      OnQuizUserAnswer()
                                          .deleteAllAnswers(onQuizGroup);
                                      OnQuizGroup aaa = onQuizGroup;
                                      aaa.currentQuestion = ""; //trash....
                                      onQuizGroup
                                          .refreshThisGroupByAnotherGroup(
                                              await fillData(aaa));
                                      setState(() {});
                                    }
                                  },
                                  icon: Icon(
                                    Icons.refresh,
                                    size: 35,
                                  )),
                            )),
                        SizedBox(width: 10),
                        AutoSizeText(
                            "${amountPassedQuestions(onQuizGroup)}/33"),
                      ],
                    )),
              toolbarHeight: 40,
              actions: <Widget>[
                SizedBox(
                  height: 30,
                  child: FilledButton.icon(
                    label: const AutoSizeText(
                      "GrID",
                      style: TextStyle(color: Colors.black),
                    ),
                    style: ButtonStyle(
                        backgroundColor:
                            MaterialStateProperty.all(Colors.grey[300])),
                    icon: const Icon(
                      Icons.copy_all,
                      size: 20,
                      color: Colors.black,
                    ),
                    onPressed: () {
                      Clipboard.setData(
                          ClipboardData(text: widget.onQuizGroup.groupId));
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                          content: Text(
                              "Die ID dieser Gruppe wird in den Puffer kopiert.\nSie können an andere Teilnehmer senden."),
                          duration: Duration(seconds: 4)));
                    },
                  ),
                ),
              ],
              //   actions: [
              //   Builder(
              //     builder: (context) {
              //       return SizedBox(
              //         height: 35,
              //         child: FilledButton.icon(
              //           style: ButtonStyle(
              //               backgroundColor: timeAlmostFinished
              //                   ? MaterialStateProperty.all<Color>(Colors.red)
              //                   : MaterialStateProperty.all(Colors.lightBlue)),
              //           icon: const Icon(Icons.timer),
              //           label: AutoSizeText(
              //               "$minutes : ${seconds < 10 ? "0$seconds" : seconds}"),
              //           onPressed: () {},
              //         ),
              //       );
              //     },
              //   ),
              // ],
            ),
            backgroundColor: Colors.white,
// BODY
            body: SingleChildScrollView(
              child: ConstrainedBox(
                  constraints: BoxConstraints(
                    maxHeight: MediaQuery.of(context).size.height - 50,
                    maxWidth: MediaQuery.of(context).size.width,
                  ),
                  child: Center(
                      child: Column(
                    children: [
                      const SizedBox(height: 10),
// NUMBER
                      const SizedBox(
                        height: 30,
//
                        child: OnQuizAufgabeNum(/* onQuizGroup: onQuizGroup */),
                      ),
                      const SizedBox(height: 10),
                      // TEXT
                      Container(
                        constraints: const BoxConstraints(
                          minHeight: 50,
                          maxHeight: 150,
                        ),
                        child: Container(
                          decoration: const BoxDecoration(
                              color: Color.fromARGB(255, 228, 243, 210),
                              border: Border.symmetric(
                                  horizontal: BorderSide(width: 1))),
                          child: Center(
                            heightFactor: BorderSide.strokeAlignOutside,
                            child: onQuizGroup.quizQuestion.questionText.isEmpty
                                ? const SpinKitSpinningLines(
                                    color: Colors.lightBlue,
                                  )
// AUFGABE
//
                                : const OnQuizAufgabe(),
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),
// Images
                      onQuizGroup.quizQuestion.images.isNotEmpty
                          ? SizedBox(
                              height: 140,
//
                              child: OnQuizImages(onQuizGroup: onQuizGroup),
                            )
                          : Container(
                              height: 0,
                            ),
// ANSWERS!
                      SizedBox(
                        height: 270,
//
                        child: OnQuizAnswers(onQuizGroup: onQuizGroup),
                      ),
// Select Combobox!
                      FirebaseAuth.instance.currentUser != null &&
                              FirebaseAuth.instance.currentUser!.uid !=
                                  onQuizGroup.userId
                          ? Center(
                              child: Container(
                              height: 0,
                            ))
                          : SizedBox(
                              height: onQuizGroup.lernState ? 60 : 0,
                              child: onQuizGroup.lernState
//
                                  ? OnQuizQuestionsCombobox(
                                      onQuizGroup: onQuizGroup,
                                      questionsList: questionsList)
                                  : Container(height: 0),
                            ),
// Select Navigator!
                      SizedBox(
                        height: 50,
//
                        child: OnQuizNavigator(
                            onQuizGroup: onQuizGroup,
                            questionsList: questionsList),
                      ),
// StatisticsButtons
                      SizedBox(
                          height: 60,
                          child: OnQuizStatisticButtons(
                              onQuizGroup: onQuizGroup,
                              questionsList: questionsList)),
                    ],
                  ))),
            ));
      },
    );
  }

  String amountPassedQuestions(OnQuizGroup onQuizGroup) {
    if (onQuizGroup.questions.isNotEmpty) {
      int currentQuestionIndex =
          onQuizGroup.questions.indexOf(onQuizGroup.currentQuestion) + 1;
      return currentQuestionIndex.toString();
    } else {
      return "";
    }
  }
}
