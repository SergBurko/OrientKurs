import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:second_quiz/online/common/on_participant.dart';
import 'package:second_quiz/online/common/on_quiz_group.dart';

class OnQuizUserAnswer {
  String participantId = "";
  int questionId = 0;
  int rightAnswerIndex = 0;
  int answerIndex = 0;
  // DateTime start_date = DateTime.now();
  // DateTime stop_date = DateTime.now();

  OnQuizUserAnswer();

  OnQuizUserAnswer.fill(this.participantId, this.questionId,
      this.rightAnswerIndex, this.answerIndex);

  addAnswerInDB(
      // String participantId, QuizQuestion quizQuestion, int answerIndex
      ) async {
    final firestoreInstance = FirebaseFirestore.instance;
    try {
      var value = await firestoreInstance
          .collection('answer')
          // .orderBy('datetime', descending: true)
          .where("participantId", isEqualTo: participantId)
          .where("questionId", isEqualTo: questionId)
          .get();

      String? answerId = value.docs.isEmpty ? null : value.docs[0].id;

      await firestoreInstance
          .collection('answer')
          .doc(answerId != null && answerId.isNotEmpty ? answerId : null)
          .set({
        'participantId': participantId,
        'questionId': questionId,
        'rightAnswerIndex': rightAnswerIndex,
        'answerIndex': answerIndex
      });
      // print('OnQuiz успешно записан.');
    } catch (e) {
      print(e);
    }
  }

  Future<List<OnQuizUserAnswer>> getAllAnwersOnQuestionByGroup(
      OnQuizGroup onQuizGroup) async {
    final firestoreInstance = FirebaseFirestore.instance;
    List<OnQuizUserAnswer> answers = [];
    List<Participant> participants = [];
    List<String> participantsIds = [];
    try {
      participants =
          await Participant().getAllParticipantsByGroupId(onQuizGroup.groupId);

      for (var participant in participants) {
        participantsIds.add(participant.participantId);
      }

      if (participantsIds.isNotEmpty) {
        var value = await firestoreInstance
            .collection('answer')
            // .where("participantId", isEqualTo: onQuizGroup.participant.participantId.trim())
            .where("participantId", whereIn: participantsIds)
            .where("questionId", isEqualTo: onQuizGroup.quizQuestion.questionId)
            .get();

        if (value.docs.isNotEmpty) {
          for (var doc in value.docs) {
            // var firestoreTimestamp = doc["datetime"];

            answers.add(OnQuizUserAnswer.fill(
              doc["participantId"],
              doc["questionId"],
              doc["rightAnswerIndex"],
              doc["answerIndex"],
            ));
          }
        }
      }
    } catch (e) {
      print(e);
    } finally {
      // ignore: control_flow_in_finally
      return answers;
    }
  }

  Future<List<OnQuizUserAnswer>> getAllAnwersOnAllQuestionsByGroup(
      OnQuizGroup onQuizGroup) async {
    final firestoreInstance = FirebaseFirestore.instance;
    List<OnQuizUserAnswer> answers = [];
    List<Participant> participants = [];
    List<String> participantsIds = [];
    try {
      participants =
          await Participant().getAllParticipantsByGroupId(onQuizGroup.groupId);

      for (var participant in participants) {
        participantsIds.add(participant.participantId);
      }

      if (participantsIds.isNotEmpty) {
        var value = await firestoreInstance
            .collection('answer')
            // .where("participantId", isEqualTo: onQuizGroup.participant.participantId.trim())
            .where("participantId", whereIn: participantsIds)
            // .where("questionId", isEqualTo: onQuizGroup.quizQuestion.questionId)
            .get();

        if (value.docs.isNotEmpty) {
          for (var doc in value.docs) {
            // var firestoreTimestamp = doc["datetime"];

            answers.add(OnQuizUserAnswer.fill(
              doc["participantId"],
              doc["questionId"],
              doc["rightAnswerIndex"],
              doc["answerIndex"],
            ));
          }
        }
      }
    } catch (e) {
      print(e);
    } finally {
      // ignore: control_flow_in_finally
      return answers;
    }
  }

  getAnswerByParticipantAndQuestionId(
      String participantId, int questionId) async {
    final firestoreInstance = FirebaseFirestore.instance;
    try {
      var value = await firestoreInstance
          .collection('answer')
          .orderBy('datetime', descending: true)
          .where("participantId", isEqualTo: participantId)
          .where("questionId", isEqualTo: questionId)
          .get();

      if (value.docs.isNotEmpty) {
        this.participantId = value.docs[0]["participantId"];
        this.questionId = value.docs[0]["questionId"];
        rightAnswerIndex = value.docs[0]["rightAnswerIndex"];
        answerIndex = value.docs[0]["answerIndex"];
      }
    } catch (e) {
      print(e);
    }
  }

  Future<void> deleteAllAnswers(OnQuizGroup onQuizGroup) async {

    final firestoreInstance = FirebaseFirestore.instance;
    List<Participant> participants = [];
    List<String> participantsIds = [];
    try {
      participants =
          await Participant().getAllParticipantsByGroupId(onQuizGroup.groupId);

      for (var participant in participants) {
        participantsIds.add(participant.participantId);
      }

      if (participantsIds.isNotEmpty) {
        var value = await firestoreInstance
            .collection('answer')
            // .where("participantId", isEqualTo: onQuizGroup.participant.participantId.trim())
            .where("participantId", whereIn: participantsIds)
            // .where("questionId", isEqualTo: onQuizGroup.quizQuestion.questionId)
            .get();

        if (value.docs.isNotEmpty) {
          for (var doc in value.docs) {
            doc.reference.delete();
          }
        }
      }
    } catch (e) {
      print(e);
    } 
  }

  Future<List<OnQuizUserAnswer>> getAllAnswersByParticipant( Participant participant) async {
    final firestoreInstance = FirebaseFirestore.instance;
    List<OnQuizUserAnswer> answers = [];
    try {
        var value = await firestoreInstance
            .collection('answer')
            // .where("participantId", isEqualTo: onQuizGroup.participant.participantId.trim())
            .where("participantId", isEqualTo: participant.participantId)
            // .where("questionId", isEqualTo: onQuizGroup.quizQuestion.questionId)
            .get();

        if (value.docs.isNotEmpty) {
          for (var doc in value.docs) {
            // var firestoreTimestamp = doc["datetime"];

            answers.add(OnQuizUserAnswer.fill(
              doc["participantId"],
              doc["questionId"],
              doc["rightAnswerIndex"],
              doc["answerIndex"],
            ));
          }
        }
    } catch (e) {
      print(e);
    } finally {
      // ignore: control_flow_in_finally
      return answers;
    }
  }
}
