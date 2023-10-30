import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:second_quiz/classes/common/file_utilies.dart';
import 'package:second_quiz/classes/common/json_utilities.dart';
import 'package:second_quiz/classes/common/singleton.dart';

part 'json_g/quiz_user.g.dart';

@JsonSerializable()
class QuizUser extends ChangeNotifier {

  final _fileUtilities = FileUtilities(Singleton.quizUsersFileName, Singleton.quizDirectoryName);
  
  @JsonKey(name: "quizUserName")
  late final String quizUsername;

  QuizUser({required this.quizUsername});

  QuizUser.empty() {
    quizUsername = "";
  }

  factory QuizUser.fromJson(Map<String, dynamic> json) =>
      _$QuizUserFromJson(json);

  Map<String, dynamic> toJson() => _$QuizUserToJson(this);

//////// FILE OPERATIONS

  Future<List<QuizUser>> getQuizUsersFromFile() async {

    String quizUserJsonStr = await _fileUtilities.readFromFile();
    List<QuizUser> quizUsers = [];

    if (quizUserJsonStr.isNotEmpty) {
      quizUsers = JsonUtilities.getObjectsListFromStringWithJson(
          quizUserJsonStr, QuizUser.fromJson);
    } 

    return quizUsers;
  }

  addQuizUserToFile() async {
    List<QuizUser> quizUsersInFile = [];
    quizUsersInFile.addAll(await getQuizUsersFromFile());

    if (!quizUsersInFile
        .any((element) => element.quizUsername == quizUsername)) {
      quizUsersInFile.add(this);
    }

    var jsonList = quizUsersInFile.map((user) => user.toJson()).toList();

    _fileUtilities.writeToFile(JsonUtilities.getStringFromJson(jsonList));
  }

//////// FILE OPERATIONS   END  
}
