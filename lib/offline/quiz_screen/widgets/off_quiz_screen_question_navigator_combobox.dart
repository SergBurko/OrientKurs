import 'package:flutter/material.dart';
import 'package:second_quiz/classes/common/settings.dart';
import 'package:second_quiz/classes/quiz/quiz_question.dart';

class OffQuizScreenQuestionNavigatorCombobox extends StatefulWidget {
  const OffQuizScreenQuestionNavigatorCombobox(
      {super.key, required this.settings, required this.currentQuestion});

  final Settings settings;
  final QuizQuestion currentQuestion;

  @override
  State<OffQuizScreenQuestionNavigatorCombobox> createState() =>
      _OffQuizScreenQuestionNavigatorComboboxState();
}

class _OffQuizScreenQuestionNavigatorComboboxState
    extends State<OffQuizScreenQuestionNavigatorCombobox> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Flexible(
            flex: 1,
            child: Text("Wählen Aufgabe", textAlign: TextAlign.center)),
        Flexible(
          flex: 3,
          child: widget.settings.questions.isEmpty
              ? const Center(child: CircularProgressIndicator())
              : DropdownButton(
                  value: widget.currentQuestion.questionId >= 1
                      ? widget.currentQuestion.questionId
                      : widget.settings.questions.first.questionId,
                  onChanged: (value) => widget.currentQuestion.changeQuestion(
                      value, widget.settings.questions,
                      increm: 0),
                  items: widget.settings.questions.map((value) {
                    return DropdownMenuItem<int>(
                      value: value.questionId,
                      child: Text(value.questionId.toString(),
                          style: const TextStyle(fontSize: 25)),
                    );
                  }).toList(),
                ),
        )
      ],
    );
  }
}
