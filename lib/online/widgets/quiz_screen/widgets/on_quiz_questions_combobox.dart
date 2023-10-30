import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:second_quiz/classes/quiz/quiz_question.dart';
import 'package:second_quiz/online/common/on_quiz_group.dart';

class OnQuizQuestionsCombobox extends StatefulWidget {
  const OnQuizQuestionsCombobox(
      {super.key, required this.onQuizGroup, required this.questionsList});
  final OnQuizGroup onQuizGroup;
  final List<QuizQuestion> questionsList;
  @override
  State<OnQuizQuestionsCombobox> createState() =>
      _OnQuizQuestionsComboboxState();
}

class _OnQuizQuestionsComboboxState extends State<OnQuizQuestionsCombobox> {
  @override
  Widget build(BuildContext context) {
    OnQuizGroup onQuizGroup = Provider.of<OnQuizGroup>(context);

    return FractionallySizedBox(
      widthFactor: 0.5,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Flexible(
              flex: 1,
              child: Text("Wählen Aufgabe", textAlign: TextAlign.center)),
          Flexible(
            flex: 1,
            child: widget.questionsList.isEmpty
                ? Container()
                : DropdownButton(
                  alignment: Alignment.center,
                  dropdownColor: Color.fromARGB(232, 245, 255, 235),
                  borderRadius: BorderRadius.circular(15),
                    value: onQuizGroup.quizQuestion.questionId,
                    // onQuizGroup.quizQuestion.questionId >= 1
                    //     ? onQuizGroup.quizQuestion.questionId
                    //     : widget.questionsList.first.questionId,
                    onChanged: (value) {
                      // onQuizGroup.quizQuestion.changeQuestion(
                      //     value, widget.questionsList,
                      //     increm: 0);
                      onQuizGroup.changeCurrentQuestionId(value ?? 1, widget.questionsList);
                      onQuizGroup.addThisToDB();
                    },
                    items: widget.questionsList.map((value) {
                      return DropdownMenuItem<int>(
                        value: value.questionId,
                        child: Text(value.questionId.toString(),textAlign: TextAlign.center,
                            style: const TextStyle(fontSize: 25)),
                      );
                    }).toList(),
                  ),
          )
        ],
      ),
    );
  }
}
