// GENERATED CODE - DO NOT MODIFY BY HAND

part of '../quiz_answer.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

QuizAnswer _$QuizAnswerFromJson(Map<String, dynamic> json) => QuizAnswer(
      questionId: json['questionId'] as int,
      answerIndex: json['answerIndex'] as int,
      date: DateTime.parse(json['date'] as String),
    );

Map<String, dynamic> _$QuizAnswerToJson(QuizAnswer instance) =>
    <String, dynamic>{
      'questionId': instance.questionId,
      'answerIndex': instance.answerIndex,
      'date': instance.date.toIso8601String(),
    };
