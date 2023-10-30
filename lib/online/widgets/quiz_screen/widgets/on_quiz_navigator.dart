import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:second_quiz/classes/quiz/quiz_question.dart';
import 'package:second_quiz/online/common/dialogs.dart';
import 'package:second_quiz/online/common/on_quiz_group.dart';
import 'package:firebase_auth/firebase_auth.dart';

// ignore: must_be_immutable
class OnQuizNavigator extends StatefulWidget {
  OnQuizNavigator(
      {super.key, required this.onQuizGroup, required this.questionsList});

  OnQuizGroup onQuizGroup;
  List<QuizQuestion> questionsList;

  @override
  State<OnQuizNavigator> createState() => _OnQuizNavigatorState();
}

class _OnQuizNavigatorState extends State<OnQuizNavigator> {
  bool showLeftButton = true;
  bool showRightButton = true;

  // @override
  // void initState() {
  //   super.initState();
  //   refreshData();
  // }

  // refreshData() {
  //   // showLeftButton  = widget.questionsList.first.questionId == int.parse(widget.onQuizGroup.currentQuestion);
  //   // showRightButton = widget.questionsList.last.questionId  == int.parse(widget.onQuizGroup.currentQuestion);
  //   setState(() {});
  // }

  @override
  Widget build(BuildContext context) {
    OnQuizGroup onQuizGroup = Provider.of<OnQuizGroup>(context);

    return FirebaseAuth.instance.currentUser != null &&
            FirebaseAuth.instance.currentUser!.uid != onQuizGroup.userId
        ? Center(
            child: Text(
            "Viel Erfolg!",
            style: Theme.of(context).textTheme.bodyLarge,
          ))
        : Row(
            children: [
// LEFT button
              SizedBox(
                  width: MediaQuery.of(context).size.width / 4,
                  child: Material(
                    elevation: 4,
                    shape: const CircleBorder(),
                    color: Colors.white,
                    child: IconButton(
                        onPressed: showLeftButton && onQuizGroup.lernState
                            ? () {
                                setState(() {
                                  showLeftButton = onQuizGroup.changeQuestion(
                                      widget.questionsList, -1);
                                  showRightButton = true;
                                  onQuizGroup.changeAnsweredStatus(false);
                                });
                              } // DISABLED if this is first element in list
                            : () {},
                        icon: const Icon(
                          Icons.chevron_left,
                          size: 35,
                          color: Colors.black,
                        )),
                  )),
// SHOW button
              Expanded(
                  child: FilledButton(
                      onPressed: () {
                        onQuizGroup.changeAnsweredStatus(true);
                      },
                      child: const AutoSizeText(
                        "Shau Antwort",
                        maxLines: 1,
                      ))),
// RIGHT button
              SizedBox(
                  width: MediaQuery.of(context).size.width / 4,
                  child: Material(
                    elevation: 4,
                    shape: const CircleBorder(),
                    child: IconButton(
                        onPressed: showRightButton
                            ? () {
                                setState(() {
                                  if (onQuizGroup.lernState) {
                                    // LERNEN
                                    showRightButton =
                                        onQuizGroup.changeQuestion(
                                            widget.questionsList, 1);
                                    showLeftButton = true;
                                    onQuizGroup.changeAnsweredStatus(false);
                                  } else {
                                    // EXAMINATIONS
                                    showRightButton = onQuizGroup
                                        .nextExamQuestion(widget.questionsList);
                                    if (showRightButton == false) {
                                      Dialogs.showStatistiks(
                                          context, onQuizGroup);
                                    }
                                    onQuizGroup.changeAnsweredStatus(false);
                                  }
                                });
                              } // DISABLED if this is first element in list
                            : () {
                                if (onQuizGroup.questions.last !=
                                    onQuizGroup.currentQuestion) {
                                  showRightButton = true;
                                  setState(() {});
                                }
                                if (onQuizGroup.questions.first !=
                                    onQuizGroup.currentQuestion) {
                                  showLeftButton = true;
                                  setState(() {});
                                }
                              }, // DISABLED if this is last element in list
                        icon: const Icon(
                          Icons.chevron_right,
                          size: 35,
                          color: Colors.black,
                        )),
                  )),
            ],
          );
  }
}
