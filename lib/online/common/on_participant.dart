import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:second_quiz/online/common/on_quiz_user.dart';
import 'package:second_quiz/online/common/on_quiz_user_answer.dart';

class Participant {
  String participantId = "";
  String groupId = "";
  String userId = "";
  String name = "";
  DateTime dateTime = DateTime.now();

  Participant();

  Participant.fill(
      this.participantId, this.groupId, this.userId, this.name, this.dateTime);

  addInDBAsParticipant(String groupId, OnQuizUser onQuizUser) async {
    final firestoreInstance = FirebaseFirestore.instance;
    try {
      // Если нет документов, создайте новый
      await firestoreInstance.collection('participant').doc().set({
        'groupId': groupId,
        'userId': onQuizUser.id,
        'name': onQuizUser.name,
        'datetime': DateTime.now()
      });
      // print('OnQuiz успешно записан.');
    } catch (e) {
      print(e);
    }
  }

  getParticipantByUserIdAndGroupID(String userId, String groupId) async {
    final firestoreInstance = FirebaseFirestore.instance;
    try {
      // Если нет документов, создайте новый
      var value = await firestoreInstance
          .collection('participant')
          .orderBy('datetime', descending: true)
          .where("groupId", isEqualTo: groupId)
          .where("userId", isEqualTo: userId)
          .get();

      participantId = value.docs[0].id;
      groupId = value.docs[0]["groupId"];
      userId = value.docs[0]["userId"];
      name = value.docs[0]["name"];

      var firestoreTimestamp = value.docs[0]["datetime"];
      dateTime = DateTime.parse(firestoreTimestamp.toDate().toString());
    }
    // print('OnQuiz успешно записан.');
    catch (e) {
      print(e);
    }
    return this;
  }

  Future<List<Participant>> getAllParticipantsByGroupId(String groupId) async {
    final firestoreInstance = FirebaseFirestore.instance;
    List<Participant> participants = [];
    try {
      var value = await firestoreInstance
          .collection('participant')
          .orderBy('datetime', descending: true)
          .where("groupId", isEqualTo: groupId)
          .get();

      if (value.docs.isNotEmpty) {
        for (var doc in value.docs) {
          var firestoreTimestamp = doc["datetime"];

          participants.add(Participant.fill(
              doc.id,
              groupId,
              doc["userId"],
              doc["name"],
              DateTime.parse(firestoreTimestamp.toDate().toString())));
        }
      }
    } catch (e) {
      print(e);
    } finally {
      // ignore: control_flow_in_finally
      return participants;
    }
  }

  getAllParticipantsByAnswers(List<OnQuizUserAnswer> answers) async {
    final firestoreInstance = FirebaseFirestore.instance;
    List<String> participantIds = [];
    List<Participant> participants = [];

    try {
      if (answers.isNotEmpty) {
        for (var answer in answers) {
          participantIds.add(answer.participantId);
        }
        if (participantIds.isNotEmpty) {
          var value = await firestoreInstance
              .collection('participant')
              .where(FieldPath.documentId, whereIn: participantIds)
              .get();

          if (value.docs.isNotEmpty) {
            for (var doc in value.docs) {
              var firestoreTimestamp = doc["datetime"];

              participants.add(Participant.fill(
                  doc.id,
                  groupId,
                  doc["userId"],
                  doc["name"],
                  DateTime.parse(firestoreTimestamp.toDate().toString())));
            }
          }
        }
      }
    } catch (e) {
      print(e);
    } finally {
      // ignore: control_flow_in_finally
      return participants;
    }
  }
}
