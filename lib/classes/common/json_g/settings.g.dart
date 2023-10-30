// GENERATED CODE - DO NOT MODIFY BY HAND

part of '../settings.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Settings _$SettingsFromJson(Map<String, dynamic> json) => Settings()
  ..defaultUserName = json['defaultUserName'] as String
  ..users = (json['users'] as List<dynamic>)
      .map((e) => QuizUser.fromJson(e as Map<String, dynamic>))
      .toList()
  ..land = json['land'] as String
  ..checkRandomAnswers = json['checkRandomAnswers'] as bool
  ..checkLerning = json['checkLerning'] as bool
  ..checkStressTesting = json['checkStressTesting'] as bool;

Map<String, dynamic> _$SettingsToJson(Settings instance) => <String, dynamic>{
      'defaultUserName': instance.defaultUserName,
      'users': instance.users,
      'land': instance.land,
      'checkRandomAnswers': instance.checkRandomAnswers,
      'checkLerning': instance.checkLerning,
      'checkStressTesting': instance.checkStressTesting
    };
