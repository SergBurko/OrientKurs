import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:second_quiz/classes/quiz/quiz_question.dart';
import 'package:second_quiz/online/common/on_participant.dart';

class OnQuizGroup extends ChangeNotifier {
  String groupId = "";
  String userId = "";
  DateTime datetime = DateTime.now();
  List<String> questions = [];
  String currentQuestion = ""; //id String
  bool lernState = true;
  int secondsOnAnswer = 120;
  DateTime endQuestionDateTime = DateTime.now();
  String land = "Berlin";
  bool answered = false;

  //local
  QuizQuestion quizQuestion = QuizQuestion.empty();
  List<String> userNames = [];
  List<String> userIds = [];
  Participant participant = Participant();

  OnQuizGroup({required this.groupId, required this.userId});

  OnQuizGroup.empty();

  addThisToDB() async {
    if (groupId.isNotEmpty) {
      final firestoreInstance = FirebaseFirestore.instance;
      try {
        await firestoreInstance.collection('group').doc(groupId).set({
          'userId': userId,
          'datetime': DateTime.now(),
          'land': land,
          'secondsOnAnswer': secondsOnAnswer,
          'lernState': lernState,
          'endQuestionDateTime': DateTime.now(),
          'questions': questions.join(","),
          'currentQuestion': currentQuestion,
          'answered': answered,
        });
      } catch (e) {
        print(e);
      }
    }
  }

  getGroupFromDBByGroupId(String groupId) async {
    final firestoreInstance = FirebaseFirestore.instance;
    try {
      var value =
          await firestoreInstance.collection('group').doc(groupId).get();

      if (value.data()!.isNotEmpty) {
        this.groupId = value.id;
        userId = value.data()!["userId"];

        var firestoreTimestamp = value.data()!["datetime"];
        datetime = DateTime.parse(firestoreTimestamp.toDate().toString());

        land = value.data()!["land"];
        secondsOnAnswer = value.data()!["secondsOnAnswer"];
        lernState = value.data()!["lernState"];
        answered = value.data()!["answered"];

        firestoreTimestamp = value.data()!["endQuestionDateTime"];
        endQuestionDateTime =
            DateTime.parse(firestoreTimestamp.toDate().toString());

        questions = value.data()!["questions"].split(",");
        currentQuestion = value.data()!["currentQuestion"];
      }
    } catch (e) {
      print(e);
    }
  }

  Future<OnQuizGroup> getMyLastGroup(String userId) async {
    final firestoreInstance = FirebaseFirestore.instance;
    try {
      var value = await firestoreInstance
          .collection('participant')
          .orderBy('datetime', descending: true)
          .where("userId", isEqualTo: userId)
          .get();

      if (value.docs.isNotEmpty) {
        groupId = value.docs[0]["groupId"];
        userId = value.docs[0]["userId"];
        answered = value.docs[0]["answered"];

        var firestoreTimestamp = value.docs[0]["datetime"];
        datetime = DateTime.parse(firestoreTimestamp.toDate().toString());

        land = value.docs[0]["land"];
        secondsOnAnswer = value.docs[0]["secondsOnAnswer"];
        lernState = value.docs[0]["lernState"];
        firestoreTimestamp = value.docs[0]["endQuestionDateTime"];
        endQuestionDateTime =
            DateTime.parse(firestoreTimestamp.toDate().toString());
        questions = value.docs[0]["questions"].split(",");
        currentQuestion = value.docs[0]["currentQuestion"];
      }
    } catch (e) {
      print(e);
    } finally {
      return this;
    }
  }

  renewQuizQuestionFromList(List<QuizQuestion> questionsList) {
    if (questionsList.isNotEmpty && currentQuestion.isNotEmpty) {
      int questionId = int.parse(currentQuestion);

      quizQuestion.renewQuestion(questionsList
          .firstWhere((element) => element.questionId == questionId));
    }

    notifyListeners();
  }

  renewQuizQuestion(QuizQuestion quizQuestion) {
    this.quizQuestion = quizQuestion;
    notifyListeners();
  }

  changeCurrentQuestionId(int id, List<QuizQuestion> questionsList) {
    currentQuestion = id.toString();
    if (questionsList.isNotEmpty &&
        questionsList.any((question) => question.questionId == id)) {
      quizQuestion =
          questionsList.firstWhere((question) => question.questionId == id);
    }
    notifyListeners();
  }

  getCurrentParticipant() async {
    participant = await Participant().getParticipantByUserIdAndGroupID(
        FirebaseAuth.instance.currentUser!.uid, groupId);
  }

  bool changeQuestion(List<QuizQuestion> questionsList, int i) {
    int currentQuestionIndex = questionsList.indexWhere(
        (question) => question.questionId == int.parse(currentQuestion));
    int movedQuestionIndex = currentQuestionIndex + i;
    if (movedQuestionIndex >= questionsList.length || movedQuestionIndex < 0) {
      return false;
    } else {
      changeCurrentQuestionId(
          questionsList[movedQuestionIndex].questionId, questionsList);
      addThisToDB();
      return true;
    }
  }

  bool nextExamQuestion(List<QuizQuestion> questionsList) {
    if (questions.isNotEmpty) {
      int currentQuestionIndex = questions.indexOf(currentQuestion) + 1;
      if (currentQuestionIndex < 33) {
        changeCurrentQuestionId(
            int.parse(questions[currentQuestionIndex]), questionsList);
        addThisToDB();
        return true;
      } 
    }
    return false;
  }

  changeAnsweredStatus(bool value) {
    answered = value;
    changeAnsweredStatusInDb(answered);
    notifyListeners();
  }

  changeAnsweredStatusInDb(bool answeredStatus) async {
    if (groupId.isNotEmpty) {
      final firestoreInstance = FirebaseFirestore.instance;
      try {
        // Если нет документов, создайте новый
        await firestoreInstance.collection('group').doc(groupId).set({
          'userId': userId,
          'datetime': DateTime.now(),
          'land': land,
          'secondsOnAnswer': secondsOnAnswer,
          'lernState': lernState,
          'endQuestionDateTime': DateTime.now(),
          'questions': questions.join(","),
          'currentQuestion': currentQuestion,
          'answered': answeredStatus,
        });
      } catch (e) {
        print(e);
      }
    }
  }

  refreshThisGroupByAnotherGroup(OnQuizGroup onQuizGroup) {
    groupId = onQuizGroup.groupId;
    userId = onQuizGroup.userId;
    datetime = onQuizGroup.datetime;
    questions = onQuizGroup.questions;
    currentQuestion = onQuizGroup.currentQuestion; //id String
    lernState = onQuizGroup.lernState;
    secondsOnAnswer = onQuizGroup.secondsOnAnswer;
    endQuestionDateTime = onQuizGroup.endQuestionDateTime;
    land = onQuizGroup.land;
    answered = onQuizGroup.answered;
    quizQuestion = onQuizGroup.quizQuestion;
    userNames = onQuizGroup.userNames;
    userIds = onQuizGroup.userIds;
    participant = onQuizGroup.participant;
  }

  void listenToChanges(List<QuizQuestion> questionsList) {
    try {
      // const duration = const Duration(milliseconds: 500);
      // Timer.periodic(duration, (Timer t) {
        OnQuizGroup onQuizGroupBefore = OnQuizGroup.empty();
        onQuizGroupBefore.refreshThisGroupByAnotherGroup(this);

        FirebaseFirestore.instance
            .collection('group')
            .doc(groupId)
            .snapshots()
            .listen((DocumentSnapshot snapshot) async {
          if (snapshot.exists) {
            var data = await snapshot.data();
            if (data != null && questionsList.isNotEmpty) {
              var dataMap = data as Map<String, dynamic>;
              land = dataMap["land"];
              secondsOnAnswer = dataMap["secondsOnAnswer"];
              lernState = dataMap["lernState"];
              questions = (dataMap["questions"] as String).split(",");
              currentQuestion = dataMap["currentQuestion"];
              answered = dataMap["answered"];

              if (compareOnQuizGroupsChanges(onQuizGroupBefore)) {
                changeCurrentQuestionId(
                    int.parse(currentQuestion), questionsList);
              }
            } else {
              // const duration = const Duration(milliseconds: 1000);
              // Timer.periodic(duration, (Timer t) {});
              // Handle the case where the document does not exist
            }
          }
        });
      // });
    } catch (e) {
      print(e);
    }
  }

  bool compareOnQuizGroupsChanges(OnQuizGroup onQuizGroupBefore) {
    bool changed = false;
    if (onQuizGroupBefore.questions.isEmpty && questions.isNotEmpty ||
        onQuizGroupBefore.questions[0] != questions[0] ||
        onQuizGroupBefore.currentQuestion != currentQuestion ||
        onQuizGroupBefore.answered != answered) {
      // if (onQuizGroupBefore.questions[0] != questions[0])
      // print ("quest");
      // if (onQuizGroupBefore.currentQuestion != currentQuestion)
      // print ("curr");
      // if (onQuizGroupBefore.answered != answered)
      // print ("quest");

      changed = true;
    }

    return changed;
  }
}
