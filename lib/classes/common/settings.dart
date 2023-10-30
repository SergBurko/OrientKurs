import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:second_quiz/classes/common/file_utilies.dart';
import 'package:second_quiz/classes/common/json_utilities.dart';
import 'package:second_quiz/classes/common/singleton.dart';
// import 'package:second_quiz/classes/quiz/quiz.dart';
import 'package:second_quiz/classes/quiz/quiz_question.dart';
import 'package:second_quiz/classes/quiz/quiz_user.dart';

//  dart run build_runner build to renew
part 'json_g/settings.g.dart';

@JsonSerializable()
class Settings extends ChangeNotifier {
  final _fileUtilities = FileUtilities(
        Singleton.quizSettingsFileName, Singleton.quizDirectoryName);

  @JsonKey(name: "defaultUserName")
  String defaultUserName = "Kursteilnehmer";

  @JsonKey(name: "users")
  List<QuizUser> users = [];

  // @JsonKey(name: "quizes")
  // List<Quiz> quizes = [];

  @JsonKey(name: "land")
  String land = "Berlin";

  @JsonKey(name: "checkRandomAnswers")
  bool checkRandomAnswers = false;

  @JsonKey(name: "checkLerning")
  bool checkLerning = false;

  @JsonKey(name: "checkStressTesting")
  bool checkStressTesting = false;

  List<QuizQuestion> questions = [];

  Settings();

  factory Settings.fromJson(Map<String, dynamic> json) =>
      _$SettingsFromJson(json);
  Map<String, dynamic> toJson() => _$SettingsToJson(this);

//////// FILE OPERATIONS

  Future<Settings> getSettingsFromFile() async {

    String settingsJsonStr = await _fileUtilities.readFromFile();
    setBySettings(JsonUtilities.getObjectFromStringWithJson(
          settingsJsonStr, Settings.fromJson));

    return this;
  }

////

  writeSettingsToFile() {
    var json = toJson();
    _fileUtilities.writeToFile(JsonUtilities.getStringFromJson(json));
  }


//////// FILE OPERATIONS   END

  void setDefaultUserName(String value) {
    defaultUserName = value;
    notifyListeners();
  }

////

  void setBySettings(Settings settings) {
    defaultUserName = settings.defaultUserName;
    // quizes = settings.quizes;
    land = settings.land;
    checkLerning = settings.checkLerning;
    checkRandomAnswers = settings.checkRandomAnswers;
    checkStressTesting = settings.checkStressTesting;
    users = settings.users;
    notifyListeners();
  }

  setUsersFromQuizUsersFile() async {
    List<QuizUser> quizUsers = await QuizUser (quizUsername: defaultUserName).getQuizUsersFromFile();
    if (quizUsers.length != users.length)
    {
      users = quizUsers;
      notifyListeners();
    }
  }

  void changeStressTestingValue() {
    checkStressTesting = !checkStressTesting;
    notifyListeners();
  }

  void changeRandomAnswergValue() {
    checkRandomAnswers = !checkRandomAnswers;
    notifyListeners();
  }

  changeLand(String? value) {
    land = value ?? "";
    notifyListeners();
  }

  notify() {
    notifyListeners();
  }

}
