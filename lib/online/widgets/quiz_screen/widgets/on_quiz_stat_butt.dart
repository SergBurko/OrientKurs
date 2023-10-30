import 'dart:async';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:second_quiz/classes/quiz/quiz_question.dart';
import 'package:second_quiz/online/common/dialogs.dart';
import 'package:second_quiz/online/common/on_participant.dart';
import 'package:second_quiz/online/common/on_quiz_group.dart';
import 'package:second_quiz/online/common/on_quiz_user_answer.dart';

class OnQuizStatisticButtons extends StatefulWidget {
  const OnQuizStatisticButtons(
      {super.key, required this.onQuizGroup, required this.questionsList});
  final OnQuizGroup onQuizGroup;
  final List<QuizQuestion> questionsList;
  @override
  State<OnQuizStatisticButtons> createState() => _OnQuizStatisticButtonsState();
}

class _OnQuizStatisticButtonsState extends State<OnQuizStatisticButtons> {
  List<OnQuizUserAnswer> answers = [];

  List<Participant> participants = [];
  List<Participant> participantsAnswered = [];
  List<Participant> participantsNOTAnswered = [];

  late Timer _timer;

  int amountOfNotAnsweredUsers = 0;

  _OnQuizStatisticButtonsState() {
    try {
      _timer = Timer.periodic(const Duration(seconds: 1), (timer) async {
        if (widget.onQuizGroup != null) {
          refreshData();
        }
      });
    } catch (e) {
      print(e);
    }
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  refreshData() async {
    try {
      answers = await OnQuizUserAnswer()
          .getAllAnwersOnQuestionByGroup(widget.onQuizGroup);

      participants = await Participant()
          .getAllParticipantsByGroupId(widget.onQuizGroup.groupId);

      if (answers.isNotEmpty) {
        participantsAnswered =
            await Participant().getAllParticipantsByAnswers(answers);
      }

      if (participants.isNotEmpty) {
        participantsNOTAnswered = (participants.where((participant) {
          return !answers.any(
              (answer) => answer.participantId == participant.participantId);
        }).toList());
      }

      amountOfNotAnsweredUsers = participantsNOTAnswered.length;
      setState(() {});
      // print("reload statButt");
    } catch (e) {
      print("Problem in StatButt: $e");
    }
  }

  // @override
  // void initState() {
  //   super.initState();
  //   // refreshData();
  // }

  @override
  Widget build(BuildContext context) {
    OnQuizGroup onQuizGroup = Provider.of<OnQuizGroup>(context);

    return Row(
      children: [
// Not Answered
        SizedBox(
          width: MediaQuery.of(context).size.width / 4,
          height: 30,
          child: Center(
              child: FilledButton.icon(
                  icon: const Icon(Icons.question_mark),
                  style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(
                          const Color.fromARGB(255, 102, 102, 102))),
                  onPressed: () async {
                    print(participantsNOTAnswered.length);
                    Dialogs.notAnsweredAlert(context, participantsNOTAnswered);
                  },
                  label: AutoSizeText(amountOfNotAnsweredUsers.toString()))),
        ),
// Statistik
        Expanded(
          child: SizedBox(
            height: 30,
            child: ElevatedButton(
              onPressed: () {
                Dialogs.showStatistiks(context, onQuizGroup);
              },
              child: const Text('Statistik'),
            ),
          ),
        ),
// Answered
        SizedBox(
          width: MediaQuery.of(context).size.width / 4,
          height: 30,
          child: Center(
              child: FilledButton.icon(
                  icon: const Icon(Icons.check),
                  style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(
                          const Color.fromARGB(255, 102, 102, 102))),
                  // onPressed: () async {
                  //   await refreshData();
                  // },
                  onPressed: () async {
                    Dialogs.answeredAlert(context, participantsAnswered,
                        answers, onQuizGroup.quizQuestion.rightAnswerIndex, int.parse(onQuizGroup.currentQuestion));
                  },
                  label: AutoSizeText(answers.length.toString()))),
        ),
      ],
    );
  }
}
