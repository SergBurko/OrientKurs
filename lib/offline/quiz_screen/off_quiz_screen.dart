import 'dart:async';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:second_quiz/classes/common/player.dart';
import 'package:second_quiz/classes/common/settings.dart';
import 'package:second_quiz/classes/common/singleton.dart';
import 'package:second_quiz/classes/quiz/quiz.dart';
import 'package:second_quiz/classes/quiz/quiz_question.dart';
import 'package:second_quiz/classes/quiz/quiz_user.dart';
import 'package:second_quiz/offline/quiz_screen/widgets/off_quiz_screen_question_main.dart';
import 'package:second_quiz/offline/quiz_screen/widgets/off_quiz_screen_question_navigator.dart';

// ignore: must_be_immutable
class OffQuizScreen extends StatefulWidget {
  OffQuizScreen(
      {required this.settings,
      required this.quiz,
      required this.player,
      super.key});

  final Settings settings; // Поле для получения провайдера
  Quiz quiz;
  Player player;

  @override
  State<OffQuizScreen> createState() => _OffQuizScreenState();
}

class _OffQuizScreenState extends State<OffQuizScreen>
    with WidgetsBindingObserver {
  int minutes = 60;
  int seconds = 00;
  bool isActive = true;
  bool timeAlmostFinished = false;
  late Timer timer;
  AudioPlayer audioPlayer = AudioPlayer();

  void startTimer() {
    timer = Timer.periodic(const Duration(seconds: 1), (Timer t) {
      if (!isActive) {
        return; // Если приложение неактивно, просто выходите из функции
      }
      if (minutes == 0 && seconds == 0) {
        t.cancel(); // Остановка таймера
        audioPlayer
            .play(AssetSource("${Singleton.assetsMusicFolder}timerout.mp3"));
      } else {
        setState(() {
          if (seconds == 0) {
            minutes--;
            seconds = 59;
          } else {
            seconds--;
          }
          if (minutes < 1 && seconds > 1) {
            timeAlmostFinished = true;
            // if (seconds % 10 == 0) {
            audioPlayer
                .play(AssetSource("${Singleton.assetsMusicFolder}clock.mp3"));
            // }
          }
        });
      }
    });
  }

  @override
  void initState() {
    super.initState();
    widget.quiz = Quiz(
        quizId: 0,
        quizAnswers: [],
        quizUser: QuizUser(quizUsername: widget.settings.defaultUserName));

    WidgetsBinding.instance.addObserver(this);
    startTimer();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    timer.cancel(); // Остановка таймера при закрытии экрана
    audioPlayer.dispose();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    setState(() {
      if (state == AppLifecycleState.resumed) {
        isActive = true;
        startTimer();
        audioPlayer.resume();
      } else {
        isActive = false;
        timer.cancel(); // Приостановка таймера, когда приложение сворачивается
        audioPlayer.pause();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<QuizQuestion>(
            create: (context) => QuizQuestion.empty()),
        // ChangeNotifierProvider<ExamTimer>(create: (context) => ExamTimer()),
      ],
      child: Scaffold(
        appBar: AppBar(actions: [
          widget.settings.checkLerning
              ? Container()
              : Builder(
                  builder: (context) {
                    // final examTimer = Provider.of<ExamTimer>(context, listen: false);
                    // examTimer.start();
                    return FilledButton.icon(
                      style: ButtonStyle(
                          backgroundColor: timeAlmostFinished
                              ? MaterialStateProperty.all<Color>(Colors.red)
                              : MaterialStateProperty.all(Colors.lightBlue)),
                      icon: const Icon(Icons.timer),
                      label: Text(
                          "$minutes : ${seconds < 10 ? "0$seconds" : seconds}"),
                      onPressed: () {
                        // Используйте examTimer здесь
                      },
                    );
                  },
                ),
        ]),
        backgroundColor: Colors.white,
        body: SafeArea(
          child: Column(
            children: [
              //QUESTIONS
              Flexible(
                  flex: 8,
                  child: Padding(
                    padding: const EdgeInsets.all(5.0),
                    child: OffQuizScreenQuestionMain(settings: widget.settings),
                  )),

              //NAVIGATOR
              Flexible(
                  flex: 2,
                  child: Container(
                    // alignment: Alignment.bottomRight,
                    padding: const EdgeInsets.all(5),
                    child: OffQuizScreenQuestionNavigator(
                        settings: widget.settings, quiz: widget.quiz),
                  )),

              //BACK
              // Flexible(
              //   flex: 1,
              //   child: Container(
              //     padding: const EdgeInsets.all(3),
              //     decoration: const BoxDecoration(
              //         border: Border(top: BorderSide(color: Colors.grey))),
              //     child: OutlinedButton.icon(
              //       icon: const Icon(Icons.backspace_outlined),
              //       label: const Text("Zurück"),
              //       onPressed: () {
              //         Navigator.pop(context);
              //       },
              //     ),
              //   ),
              // )
            ],
          ),
        ),
      ),
    );
  }
}
