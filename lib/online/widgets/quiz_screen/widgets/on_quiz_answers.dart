import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:second_quiz/online/common/on_quiz_group.dart';
import 'package:second_quiz/online/common/on_quiz_user_answer.dart';

class OnQuizAnswers extends StatefulWidget {
  const OnQuizAnswers({super.key, required this.onQuizGroup});

  final OnQuizGroup onQuizGroup;

  @override
  State<OnQuizAnswers> createState() => _OnQuizAnswersState();
}

class _OnQuizAnswersState extends State<OnQuizAnswers> {
  // @override
  // void initState() {
  //   super.initState();
  //   refreshAnswer();
  // }

  // refreshAnswer() async {
  //   OnQuizUserAnswer onQuizUserAnswer = await OnQuizUserAnswer().getAnswerByParticipantAndQuestionId(
  //           widget.onQuizGroup.participant.participantId,
  //           widget.onQuizGroup.quizQuestion.questionId);

  //   QuizQuestion quizQuestion = widget.onQuizGroup.quizQuestion;
  //   quizQuestion.choosed = onQuizUserAnswer.answerIndex;
  //   widget.onQuizGroup.renewQuizQuestion(quizQuestion);
  // }

  @override
  Widget build(BuildContext context) {
    OnQuizGroup onQuizGroup = Provider.of<OnQuizGroup>(context);
    
    return Builder(builder: (context) {
      if (onQuizGroup.quizQuestion.answers.isNotEmpty) {
        return ListView.builder(
          itemCount: onQuizGroup.quizQuestion.answers.length * 2 -
              1, // Учитываем разделители
          itemBuilder: (context, index) {
            if (index.isOdd) {
              // Вставляем разделительную черту
              return const FractionallySizedBox(
                widthFactor:
                    0.05, // Установите желаемый процент от ширины экрана
                child: Divider(height: 5, color: Colors.black),
              );
            }

            final answerIndex = index ~/ 2; // Получаем индекс ответа

            // Определяем цвет кнопки на основе выбора пользователя
            Color buttonColor = Colors.lightBlue;
            if (answerIndex == onQuizGroup.quizQuestion.choosed) {
              if (answerIndex ==
                  onQuizGroup.quizQuestion.rightAnswerIndex ) {
                buttonColor = Colors.green; // Правильный ответ
              } else {
                buttonColor = Colors.red; // Неправильный ответ
              }
            } else if (answerIndex ==
                    onQuizGroup.quizQuestion.rightAnswerIndex &&
                (onQuizGroup.quizQuestion.choosed > -1 || onQuizGroup.answered)) {
              //  if (answerIndex == widget.quizQuestion.rightAnswerIndex && widget.quizQuestion.choosed>-1) {
              buttonColor = Colors.lightGreen; // Правильный ответ без выбора
            } 
            

            return SizedBox(
              height: 60,
              child: FilledButton(
                onPressed: onQuizGroup.quizQuestion.choosed == -1 && !onQuizGroup.answered
                    ? () {
                        setState(() {
                          onQuizGroup.quizQuestion.choosed = answerIndex;
                        });
                        
                        OnQuizUserAnswer.fill(
                                onQuizGroup.participant.participantId,
                                onQuizGroup.quizQuestion.questionId,
                                widget
                                    .onQuizGroup.quizQuestion.rightAnswerIndex,
                                answerIndex)
                            .addAnswerInDB();
                      }
                    : null,
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(buttonColor),
                ),
                child: AutoSizeText(
                  onQuizGroup.quizQuestion.answers[answerIndex],
                  maxLines: 4,
                  minFontSize: 10,
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
