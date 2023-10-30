import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
// import 'package:second_quiz/classes/common/settings.dart';
import 'package:second_quiz/classes/quiz/quiz_question.dart';

class OffQuizScreenQuestionAnswersList extends StatefulWidget {
  const OffQuizScreenQuestionAnswersList(
      {/* required this.settings, */ super.key});

  // final Settings settings;

  @override
  State<OffQuizScreenQuestionAnswersList> createState() =>
      _OffQuizScreenQuestionAnswersListState();
}

class _OffQuizScreenQuestionAnswersListState
    extends State<OffQuizScreenQuestionAnswersList> {
  @override
  Widget build(BuildContext context) {
    QuizQuestion currentQuestion = Provider.of<QuizQuestion>(context);
    return Builder(builder: (context) {
      if (currentQuestion.answers.isNotEmpty) {
        return ListView.builder(
          itemCount:
              currentQuestion.answers.length * 2 - 1, // Учитываем разделители
          itemBuilder: (context, index) {
            if (index.isOdd) {
              // Вставляем разделительную черту
              return const Divider(height: 5);
            }

            final answerIndex = index ~/ 2; // Получаем индекс ответа

            // Определяем цвет кнопки на основе выбора пользователя
            Color buttonColor = Colors.lightBlue;
            if (answerIndex == currentQuestion.choosed) {
              if (answerIndex == currentQuestion.rightAnswerIndex) {
                buttonColor = Colors.green; // Правильный ответ
              } else {
                buttonColor = Colors.red; // Неправильный ответ
              }
            } else if (answerIndex == currentQuestion.rightAnswerIndex &&
                currentQuestion.choosed > -1) {
              //  if (answerIndex == currentQuestion.rightAnswerIndex && currentQuestion.choosed>-1) {
              buttonColor = Colors.lightGreen; // Правильный ответ без выбора
            }

            return SizedBox(
              height: 60,
              child: FilledButton(
                onPressed: currentQuestion.choosed == -1
                    ? () {
                        setState(() {
                          currentQuestion.choosed = answerIndex;
                        });
                      }
                    : null,
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(buttonColor),
                ),
                child: AutoSizeText(
                  currentQuestion.answers[answerIndex],
                  maxLines: 3,
                  maxFontSize: 30,
                  textAlign: TextAlign.center,
                ),
              ),
            );
          },
        );
      } else {
        return Container();
      }
    });
  }
}
