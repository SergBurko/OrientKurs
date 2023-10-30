import 'dart:convert';
import 'dart:typed_data';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:second_quiz/online/common/on_quiz_group.dart';

class OnQuizImages extends StatefulWidget {  
  const OnQuizImages({super.key, required this.onQuizGroup});  

  final OnQuizGroup onQuizGroup;

  @override
  State<OnQuizImages> createState() => _OnQuizImagesState();  
}

class _OnQuizImagesState extends State<OnQuizImages> {  
  @override
  Widget build(BuildContext context) {
    
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: List.generate(widget.onQuizGroup.quizQuestion.images.length, (index) {
          final image = widget.onQuizGroup.quizQuestion.images[index];
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
                        (widget.onQuizGroup.quizQuestion.images.length > 1 ? 4.5 : 2),
                    height: MediaQuery.of(context).size.width /
                        (widget.onQuizGroup.quizQuestion.images.length > 1 ? 4.5 : 4),
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
  }
}