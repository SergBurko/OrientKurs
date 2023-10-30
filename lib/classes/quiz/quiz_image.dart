
import 'package:json_annotation/json_annotation.dart';

// dart run build_runner build
part 'json_g/quiz_image.g.dart';

@JsonSerializable()
class QuizImage {
  
  @JsonKey(name: "quizImage")
  String quizImage;

  @JsonKey(name: "quizImageDescription")
  String quizImageDescription;

  QuizImage ({required this.quizImage, required this.quizImageDescription});

 factory QuizImage.fromJson(Map<String, dynamic> json) =>
      _$QuizImageFromJson(json);

  Map<String, dynamic> toJson() => _$QuizImageToJson(this);
}