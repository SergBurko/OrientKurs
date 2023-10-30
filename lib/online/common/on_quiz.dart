import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

class OnQuiz extends ChangeNotifier {
  Uuid uuid = const Uuid();
  String userName = "";
  String userId = "";
  String id = "";
  // int currentQuestion = 0;
  // bool finished = false;
  // bool lernState = true;
  // bool megaboss = false;
  // int secondsOnAnswer = 120;
  // bool autoFinishWhenAnswered = true;
  // List<QuizQuestion> questions = [];
  // List<OnQuizUserAnswer> answers = [];
  // String groupId = "";
  DateTime datetime = DateTime.now();

  readLastFromDBByUserId() async {
    final firestoreInstance = FirebaseFirestore.instance;
    try {
      DocumentSnapshot<Map<String, dynamic>>? documentSnapshot;
      var value = await firestoreInstance
          .collection('quiz')
          .orderBy('datetime', descending: true)
          .where("userId", isEqualTo: userId)
          .limit(1)
          .get();
          
      if (value.docs.isNotEmpty) {
        documentSnapshot = value.docs[0];
      }

      if (documentSnapshot != null) {
        _fillByDBValue(documentSnapshot.data()!, documentSnapshot.id);
      }
    } catch (e) {
      print(e);
    } finally {
      if (id.isEmpty) {
        id = uuid.v4();
      }
      // ignore: control_flow_in_finally
      return this;
    }
  }

  //   readLastFromDB () async {
  //   final firestoreInstance = FirebaseFirestore.instance;
  //   try {
  //     QuerySnapshot querySnapshot = await firestoreInstance
  //         .collection('quiz')
  //         .orderBy('datetime', descending: true)
  //         .limit(1)
  //         .get()
  //         .then((value) =>
  //             _fillByDBValue(value.docs[0].data() as Map<String, dynamic>, value.docs[0].id));
  //   } catch (e) {
  //     print(e);
  //   } finally {
  //     if (id.isEmpty) {
  //       id = uuid.v4();
  //     }
  //     // ignore: control_flow_in_finally
  //     return this;
  //   }
  // }

  // Future<OnQuiz> addOnQuizInDB(OnQuiz onQuiz) async {
  //   if (id.isEmpty) {
  //     id = uuid.v4();
  //   }
  //   final firestoreInstance = FirebaseFirestore.instance;

  //   try {
  //     // Если нет документов, создайте новый
  //     await firestoreInstance.collection('quiz').doc(onQuiz.id).set({
  //       'currentQuestion': onQuiz.currentQuestion,
  //       'userName': onQuiz.userName,
  //       'userId': onQuiz.userId,
  //       'finished': onQuiz.finished,
  //       'lernState': onQuiz.lernState,
  //       'megaboss': onQuiz.megaboss,
  //       'secondsOnAnswer': onQuiz.secondsOnAnswer,
  //       'autoFinishWhenAnswered': onQuiz.autoFinishWhenAnswered,
  //       'groupId': onQuiz.groupId,
  //       'datetime': onQuiz.datetime.toIso8601String(),
  //     });
  //     print('OnQuiz успешно записан.');
  //   } catch (e) {
  //     print(e);
  //   }

  //   return onQuiz;
  // }

 addThisInDB() async {
    if (id.isEmpty) {
      id = uuid.v4();
    }
    final firestoreInstance = FirebaseFirestore.instance;

    try {
      // Если нет документов, создайте новый
      await firestoreInstance.collection('quiz').doc(id).set({
        // 'currentQuestion': currentQuestion,
        'userName': userName,
        'userId': userId,
        // 'finished': finished,
        // 'lernState': lernState,
        // 'megaboss': megaboss,
        // 'secondsOnAnswer': secondsOnAnswer,
        // 'autoFinishWhenAnswered': autoFinishWhenAnswered,
        // 'groupId': groupId,
        'datetime': datetime.toIso8601String(),
      });
      print('OnQuiz успешно записан.');
    } catch (e) {
      print(e);
    }


  }

  _fillByDBValue(Map<String, dynamic> value, String id) {
    if (value != null) {
      this.id = id;
      // currentQuestion = value["currentQuestion"];
      userId = value["userId"];
      userName = value["userName"];
      // finished = value["finished"];
      // lernState = value["lernState"];
      // megaboss = value["megaboss"];
      // secondsOnAnswer = value["secondsOnAnswer"];
      // autoFinishWhenAnswered = value["autoFinishWhenAnswered"];
      // groupId = value["groupId"];
      datetime = DateTime.parse(value["datetime"]);
    }
    return this;
  }
}
