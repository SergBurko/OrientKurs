import 'package:auto_size_text/auto_size_text.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:second_quiz/online/common/on_participant.dart';
import 'package:second_quiz/online/common/on_quiz_group.dart';
import 'package:second_quiz/online/common/on_quiz_user_answer.dart';

class Dialogs {
  static notAnsweredAlert(BuildContext context, List<Participant> paticipants) {
    if (paticipants.isNotEmpty) {
      String headText = "Nicht geantwortet:";
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
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      AutoSizeText(
                        headText,
                        minFontSize: 30,
                      ),
                      const SizedBox(
                        width: 90,
                        child: Divider(),
                      ),
                      Column(
                        children: paticipants.map(
                          (participant) {
                            return AutoSizeText(
                              participant.name,
                              minFontSize: 25,
                              maxFontSize: 50,
                              textAlign: TextAlign.center,
                              style:
                                  const TextStyle(fontStyle: FontStyle.italic),
                              maxLines: 15,
                            );
                          },
                        ).toList(),
                      ),
                    ],
                  ),
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
    }
  }

  static answeredAlert(
      BuildContext context,
      List<Participant> participants,
      List<OnQuizUserAnswer> answers,
      int rightAnswerIndex,
      int currentQuestion) {
    if (participants.isNotEmpty && answers.isNotEmpty) {
      bool currentParticipantAnswered = false;

      Participant? participant;
      if (participants.any((element) =>
          element.userId == FirebaseAuth.instance.currentUser!.uid)) {
        participant = participants.firstWhere((element) =>
            element.userId == FirebaseAuth.instance.currentUser!.uid);
      }

      if (participant != null &&
          answers.any((answer) =>
              answer.participantId == participant!.participantId &&
              answer.questionId == currentQuestion)) {
        currentParticipantAnswered = !currentParticipantAnswered;
      }

      String headText = "Geantwortet:";
      String rightAnswer = "Richtige Antwort:";
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
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      !currentParticipantAnswered
                          ? Container(height: 0)
                          : Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                AutoSizeText(
                                  rightAnswer,
                                  minFontSize: 30,
                                ),
                                SizedBox(
                                  width: 50,
                                  // decoration: BoxDecoration(
                                  //     border: Border.all(width: 5)),
                                  child: Center(
                                    child: AutoSizeText(
                                      "${rightAnswerIndex + 1}",
                                      minFontSize: 50,
                                      style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: Colors.lightGreen),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                      AutoSizeText(
                        headText,
                        minFontSize: 30,
                      ),
                      const SizedBox(
                        width: 90,
                        child: Divider(),
                      ),
                      Column(
                        children: participants.map(
                          (participant) {
                            return Builder(builder: (context) {
                              OnQuizUserAnswer answer = answers.firstWhere(
                                  (element) =>
                                      element.participantId ==
                                      participant.participantId);
                              final bool correctAnswer =
                                  answer.answerIndex == answer.rightAnswerIndex;
                              return AutoSizeText(
                                // () {
                                // OnQuizUserAnswer answer = answers.firstWhere((element) => element.participantId == participant.participantId);
                                // return "";
                                // },

                                "${participant.name} (Antw: ${answer.answerIndex + 1})",
                                minFontSize: 25,
                                maxFontSize: 50,
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontStyle: FontStyle.italic,
                                  // color:  Colors.black,
                                  color: !currentParticipantAnswered
                                      ? Colors.black
                                      : correctAnswer
                                          ? Colors.lightGreen
                                          : Colors.redAccent,
                                ),
                                maxLines: 15,
                              );
                            });
                          },
                        ).toList(),
                      ),
                    ],
                  ),
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
    }
  }

  static noInternetConnection(BuildContext context) {
    String headText = "Keine Internetverbindung!";
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            backgroundColor: Colors.white,
            surfaceTintColor: Colors.white,
            title: const Text(''),
            content: SizedBox(
              height: 200,
              width: 300,
              child: SingleChildScrollView(
                child: Center(
                  child: AutoSizeText(
                    headText,
                    minFontSize: 30,
                  ),
                ),
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
  }

  static Future<void> showStatistiks(
      BuildContext context, OnQuizGroup onQuizGroup) async {
    List<OnQuizUserAnswer> answers =
        await OnQuizUserAnswer().getAllAnwersOnAllQuestionsByGroup(onQuizGroup);
    List<Participant> participants =
        await Participant().getAllParticipantsByGroupId(onQuizGroup.groupId);

    // ignore: use_build_context_synchronously
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
              child: SingleChildScrollView(
                child: participants.isEmpty || answers.isEmpty
                    ? const Center(
                        child: Text("Keine Antworten. Machen die Prüfung! "))
//answer
                    : Builder(builder: (context) {
                        List<Widget> statistikWidgetsList = [];
                        participants.sort((a, b) => a.name.compareTo(b.name));

                        for (var participant in participants) {
                          int correct = 0;
                          int wrong = 0;
                          for (var answer in answers) {
                            if (answer.participantId ==
                                participant.participantId) {
                              if (answer.answerIndex ==
                                  answer.rightAnswerIndex) {
                                correct++;
                              } else {
                                wrong++;
                              }
                            }
                          }
                          int correctPercent = 0;
                          try {
                            correctPercent =
                                ((correct / (correct + wrong)) * 100).round();
                          } catch (e) {
                            print(e);
                          }

                          int wrongPercent = 100 - correctPercent;

// STATISTIC WIDGETS
                          statistikWidgetsList.add(Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                IconButton(
                                    onPressed: () {
                                      Dialogs.ShowParticipansAllAnswers(
                                          context, onQuizGroup, participant);
                                    },
                                    icon: Icon(Icons.question_mark)),
                                RichText(
                                    text: TextSpan(children: <TextSpan>[
                                  TextSpan(
                                    text: "${participant.name}: ",
                                    style: TextStyle(
                                        color: correct > wrong
                                            ? Colors.green
                                            : const Color.fromARGB(
                                                255, 252, 111, 111)),
                                  ),
                                  TextSpan(
                                    text:
                                        ('${(correct + wrong).toString()} / '),
                                    style: const TextStyle(color: Colors.black),
                                  ),
                                  TextSpan(
                                    text: '$correct ($correctPercent%) / ',
                                    style: const TextStyle(
                                        color: Colors.lightGreen),
                                  ),
                                  TextSpan(
                                    text: '$wrong ($wrongPercent%)',
                                    style: const TextStyle(color: Colors.red),
                                  ),
                                ]))
                              ]));
                        }

                        return Column(
                          children: [
                            RichText(
                                text: const TextSpan(children: <TextSpan>[
                              TextSpan(
                                text: ('ingesamt / '),
                                style: TextStyle(color: Colors.black),
                              ),
                              TextSpan(
                                text: 'richtige / ',
                                style: TextStyle(color: Colors.lightGreen),
                              ),
                              TextSpan(
                                text: 'falsche',
                                style: TextStyle(color: Colors.red),
                              ),
                            ])),
                            SizedBox(width: 100, child: Divider()),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: statistikWidgetsList,
                            )
                          ],
                        );
                      }),
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
  }

  static showConfirmationDialog(BuildContext context) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Center(child: Text('! Vorsicht !')),
          content: const SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text('Eine neue Prüfung zu beginnen?'),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Ja'),
              onPressed: () {
                Navigator.of(context).pop(true);
              },
            ),
            TextButton(
              child: Text('Nein'),
              onPressed: () {
                Navigator.of(context).pop(false);
              },
            ),
          ],
        );
      },
    );
  }

  static ShowParticipansAllAnswers(BuildContext context,
      OnQuizGroup onQuizGroup, Participant participant) async {
    List<OnQuizUserAnswer> answers =
        await OnQuizUserAnswer().getAllAnswersByParticipant(participant);

    List<Widget> widgets = [];

    if (answers.isNotEmpty) {
      for (var answer in answers) {
        if (answer.answerIndex != answer.rightAnswerIndex) {
          widgets.add(AutoSizeText(
              "Frage: ${answer.questionId}\nAntwort: ${answer.answerIndex}\nRightige Antwort: ${answer.rightAnswerIndex}\n\n"));
        }
      }
    }

    if (widgets.isNotEmpty) {
      // ignore: use_build_context_synchronously
      return showDialog<void>(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return AlertDialog(
            title:
                Center(child: Text("Falsche Antworten\n${participant.name}")),
            content: SingleChildScrollView(
              child: SizedBox(
                width: 300,
                height: 500,
                child: ListView(
                    // mainAxisAlignment: MainAxisAlignment.start,
                    children: widgets),
              ),
            ),
            actions: <Widget>[
              TextButton(
                child: const Text('Ok'),
                onPressed: () {
                  Navigator.of(context).pop(false);
                },
              ),
            ],
          );
        },
      );
    }
  }
}
