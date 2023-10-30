import 'dart:math';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:second_quiz/online/common/auth_services.dart';

class OnLoginScreen extends StatelessWidget {
  const OnLoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
            backgroundColor: Theme.of(context).primaryColor,
            appBar: AppBar(backgroundColor: Colors.lightBlue[200]),
            body: SizedBox(
              height: double.infinity,
              width: double.infinity,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  const SizedBox(
                    height: 20,
                  ),
                  const AutoSizeText(
                      maxFontSize: 40,
                      minFontSize: 30,
                      textAlign: TextAlign.center,
                      "Autorisierung:"),
                  const SizedBox(
                    height: 20,
                  ),
// GOOGLE BUTTON
                  // Container(
                  //   height: 100,
                  //   width: 300,
                  //   child: Row(
                  //     mainAxisAlignment: MainAxisAlignment.center,
                  //     children: [
                  //       FilledButton(
                  //           style: ButtonStyle(
                  //               backgroundColor:
                  //                   MaterialStateProperty.all(Colors.white),
                  //               elevation: MaterialStateProperty.all(5)),
                  //           onPressed: () {
                  //             AuthServices().signInWithGoogle();
                  //           },
                  //           child: Image.asset("assets/images/google.png", width: 70, height: 60,)),
                  //       AutoSizeText("  Mit Google")
                  //     ],
                  //   ),
                  // ),
                  // const SizedBox(height: 30, width: 200, child: Divider()),
// ANNONYM
                  SizedBox(
                    height: 100,
                    width: 300,
                    child: Tooltip(
                      message: "Anonymous",
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          FilledButton(
                            style: ButtonStyle(
                                backgroundColor:
                                    MaterialStateProperty.all(Colors.white),
                                elevation: MaterialStateProperty.all(5)),
                            onPressed: () {
                              AuthServices().signInAsAnonymous();
                            },
                            child: Builder(builder: (context) {
                              int indx = Random().nextInt(2);
                              return Image.asset(
                                  "assets/images/incognito${indx + 1}.png", width: 70, height: 60,);
                            }),
                          ),
                          AutoSizeText("  Anonym")
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            )));
  }
}
