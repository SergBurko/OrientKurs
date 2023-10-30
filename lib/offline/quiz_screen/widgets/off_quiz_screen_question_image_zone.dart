import 'dart:convert';
import 'dart:typed_data';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:second_quiz/classes/quiz/quiz_question.dart';

class OffQuizScreenQuestionImageZone extends StatelessWidget {
  const OffQuizScreenQuestionImageZone({super.key});

  @override
  Widget build(BuildContext context) {
    QuizQuestion currentQuestion = Provider.of<QuizQuestion>(context);

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: List.generate(currentQuestion.images.length, (index) {
          final image = currentQuestion.images[index];
          Uint8List imageBytes = base64Decode(image.quizImage);
          return Padding(
            padding: const EdgeInsets.all(3.0),
            child: Column(
              children: [
                InkWell(
                  focusColor: Colors.lightBlue,
                  onTap: () {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          backgroundColor: Colors.white,
                          surfaceTintColor: Colors.white,
                          title: const Text(''),
                          content: Image.memory(
                              imageBytes,
                              width: MediaQuery.of(context).size.width / 1.5,
                              height: MediaQuery.of(context).size.width / 1.5,
                            ),
                          actions: <Widget>[
                            
                            TextButton(
                              onPressed: () {
                                Navigator.of(context)
                                    .pop(); // Закрыть AlertDialog
                              },
                              child: const Text('Ok'),
                            ),
                          ],
                        );
                      },
                    );
                  },
                  child: Image.memory(
                    imageBytes,
                    width: MediaQuery.of(context).size.width /
                        (currentQuestion.images.length > 1 ? 4.5 : 2),
                    height: MediaQuery.of(context).size.width /
                        (currentQuestion.images.length > 1 ? 4.5 : 4),
                  ),
                ),
                const SizedBox(height: 3),
                AutoSizeText(
                  image.quizImageDescription,
                  maxLines: 2,
                  maxFontSize: 20,
                ),
              ],
            ),
          );
        }),
      ),
    );

    // return Container(
    //   width: MediaQuery.of(context).size.width,
    //   child: ListView.builder(
    //       scrollDirection: Axis.horizontal,
    //       shrinkWrap: true,
    //       // shrinkWrap: true,
    //       itemCount: currentQuestion.images.length,
    //       itemBuilder: (context, index) {
    //         final image = currentQuestion.images[index];
    //         Uint8List imageBytes = base64Decode(image.quizImage);
    //         return Padding(
    //           padding: const EdgeInsets.all(3.0),
    //           child: Column(
    //             children: [
    //               Image.memory(
    //                 imageBytes,
    //                 // width: 50,
    //                 // height: 50,
    //                 fit: BoxFit.contain,
    //               ),
    //               const SizedBox(height: 8),
    //               AutoSizeText(image.quizImageDescription, maxLines: 2, maxFontSize: 20),
    //             ],
    //           ),
    //         );
    //       },
    //     ),
    // );
  }
}
