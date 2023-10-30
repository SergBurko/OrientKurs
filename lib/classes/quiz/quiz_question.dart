import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:second_quiz/classes/common/json_utilities.dart';
import 'package:second_quiz/classes/common/singleton.dart';
import 'package:second_quiz/classes/quiz/quiz_image.dart';
import 'package:second_quiz/online/common/on_quiz_group.dart';

// dart run build_runner build
part 'json_g/quiz_question.g.dart';

@JsonSerializable()
class QuizQuestion extends ChangeNotifier {
  @JsonKey(name: "questionId")
  late int questionId;

  @JsonKey(name: "questionText")
  late String questionText;

  @JsonKey(name: "images")
  late List<QuizImage> images;

  @JsonKey(name: "answers")
  late List<String> answers;

  @JsonKey(name: "rightAnswerIndex")
  late int rightAnswerIndex;

  int choosed = -1;
  int examinationQuestionNumer = 0;
  // int answerIdNummer = -1;

  QuizQuestion(
      {required this.questionId,
      required this.questionText,
      required this.answers,
      required this.images,
      required this.rightAnswerIndex});

  QuizQuestion.empty()
      : answers = [],
        images = [],
        questionId = -1,
        questionText = "",
        rightAnswerIndex = -1;

  factory QuizQuestion.fromJson(Map<String, dynamic> json) =>
      _$QuizQuestionFromJson(json);

  Map<String, dynamic> toJson() => _$QuizQuestionToJson(this);

  getQuestionListFromFile() async {
    String questionsStr =
        await rootBundle.loadString(Singleton.questionFileName);

    return JsonUtilities.getObjectsListFromStringWithJson(
        questionsStr, QuizQuestion.fromJson);
  }

  Future<List<QuizQuestion>> getQuestionListFromRegionFile(String region) async {
    String questionsStr = await rootBundle.loadString(
        "${Singleton.questionPathWithoutName}${region.toLowerCase()}_questions.json");

    List<QuizQuestion> regionQuestions =
        JsonUtilities.getObjectsListFromStringWithJson(
            questionsStr, QuizQuestion.fromJson);

    for (var i = 0; i < regionQuestions.length; i++) {
      regionQuestions[i].questionId = regionQuestions[i].questionId + 300;
    }

    return regionQuestions;
  }


  // Future<QuizQuestion> getQuizQuestion(List<QuizQuestion> questionList, OnQuizGroup onQuizGroup) async {
      
  //     if (questionList.isNotEmpty  && onQuizGroup.currentQuestion.isNotEmpty) {
  //       int questionId = int.parse(onQuizGroup.currentQuestion);

  //       if (questionId <= 300) {
  //         renewQuestion(questionList
  //             .firstWhere((element) => element.questionId == questionId));
  //       } else {
  //         var landQuestions = await QuizQuestion.empty()
  //             .getQuestionListFromRegionFile(onQuizGroup.land);
  //         renewQuestion(landQuestions
  //             .firstWhere((element) =>
  //                 element.questionId == questionId));
  //       }
  //     }

  //     return this;
  //   }



  void renewQuestion(QuizQuestion question) {
    questionId = question.questionId;
    answers = question.answers;
    images = question.images;
    questionText = question.questionText;
    rightAnswerIndex = question.rightAnswerIndex;
    examinationQuestionNumer = 0;
    notifyListeners();
  }

  changeQuestion(int? value, List<QuizQuestion> questions, {int increm = 1}) {
    if (value != null) {
      int indexOfValue = questions.indexOf(
          questions.where((element) => element.questionId == value).first);
      if (indexOfValue  < questions.length-1) {
        questionId = questions[indexOfValue + increm].questionId;
        answers = questions[indexOfValue  + increm ].answers;
        images = questions[indexOfValue  + increm ].images;
        questionText = questions[indexOfValue  + increm ].questionText;
        rightAnswerIndex = questions[indexOfValue  + increm ].rightAnswerIndex;
        choosed = -1;
        examinationQuestionNumer++;
        // answerIdNummer = -1;
        notifyListeners();
      } else {examinationQuestionNumer++;} 
    }
  }
}
