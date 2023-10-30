import 'package:flutter/material.dart';
import 'package:second_quiz/classes/quiz/quiz_answer.dart';
import 'package:second_quiz/classes/quiz/quiz_user.dart';
import 'package:json_annotation/json_annotation.dart';

//dart run build_runner build
part 'json_g/quiz.g.dart';

@JsonSerializable()
class Quiz extends ChangeNotifier {
  @JsonKey(name: 'quizId')
  late int quizId;

  @JsonKey(name: 'quizUser')
  late QuizUser quizUser;

  @JsonKey(name: 'quizAnswers')
  late List<QuizAnswer> quizAnswers;

  @JsonKey(name: 'quizContinue')
  bool quizContinue = false;

  Quiz(
      {required this.quizId,
      required this.quizUser,
      required this.quizAnswers});
  Quiz.empty() {
    quizId = 0;
    quizUser = QuizUser.empty();
    quizAnswers = [];
  }

  factory Quiz.fromJson(Map<String, dynamic> json) => _$QuizFromJson(json);
  Map<String, dynamic> toJson() => _$QuizToJson(this);
}
