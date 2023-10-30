
import 'package:json_annotation/json_annotation.dart';

part 'json_g/quiz_answer.g.dart';

@JsonSerializable()
class QuizAnswer {
  @JsonKey(name: "questionId")
  final int questionId;

  @JsonKey(name: "answerIndex")
  final int answerIndex;

  @JsonKey(name: "date")
  final DateTime date;

  int rightIndex;

  QuizAnswer ({required this.questionId, required  this.answerIndex, required  this.date, this.rightIndex = -1});

  factory QuizAnswer.fromJson(Map<String, dynamic> json) => _$QuizAnswerFromJson(json);

  Map<String, dynamic> toJson() => _$QuizAnswerToJson(this);
}