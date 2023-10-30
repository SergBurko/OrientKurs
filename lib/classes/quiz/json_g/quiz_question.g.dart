// GENERATED CODE - DO NOT MODIFY BY HAND

part of '../quiz_question.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

QuizQuestion _$QuizQuestionFromJson(Map<String, dynamic> json) => QuizQuestion(
      questionId: json['questionId'] as int,
      questionText: json['questionText'] as String,
      answers:
          (json['answers'] as List<dynamic>).map((e) => e as String).toList(),
      images: (json['images'] as List<dynamic>)
          .map((e) => QuizImage.fromJson(e as Map<String, dynamic>))
          .toList(),
      rightAnswerIndex: json['rightAnswerIndex'] as int,
    );

Map<String, dynamic> _$QuizQuestionToJson(QuizQuestion instance) =>
    <String, dynamic>{
      'questionId': instance.questionId,
      'questionText': instance.questionText,
      'images': instance.images,
      'answers': instance.answers,
      'rightAnswerIndex': instance.rightAnswerIndex,
    };
