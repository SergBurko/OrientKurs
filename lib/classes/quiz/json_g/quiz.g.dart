// GENERATED CODE - DO NOT MODIFY BY HAND

part of '../quiz.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Quiz _$QuizFromJson(Map<String, dynamic> json) => Quiz(
      quizId: json['quizId'] as int,
      quizUser: QuizUser.fromJson(json['quizUser'] as Map<String, dynamic>),
      quizAnswers: (json['quizAnswers'] as List<dynamic>)
          .map((e) => QuizAnswer.fromJson(e as Map<String, dynamic>))
          .toList(),
    )..quizContinue = json['quizContinue'] as bool;

Map<String, dynamic> _$QuizToJson(Quiz instance) => <String, dynamic>{
      'quizId': instance.quizId,
      'quizUser': instance.quizUser,
      'quizAnswers': instance.quizAnswers,
      'quizContinue': instance.quizContinue,
    };
