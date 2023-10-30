// import 'dart:js_interop_unsafe';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:second_quiz/classes/common/player.dart';
import 'package:second_quiz/classes/common/settings.dart';
import 'package:second_quiz/classes/quiz/quiz.dart';
import 'package:second_quiz/offline/user_screen/widgets/off_user_screen_main.dart';

class OffUserScreen extends StatefulWidget {
  const OffUserScreen({super.key});

  @override
  State<OffUserScreen> createState() => _OffUserScreenState();
}

class _OffUserScreenState extends State<OffUserScreen> {
  @override
  Widget build(BuildContext context) {
    // Settings settingsProvider = Provider.of<Settings>(context);

    // if (settingsProvider.defaultUserName.isNotEmpty) {
    //   settingsProvider.setSettingsToFile();
    // }
    var providers = [
      ChangeNotifierProvider<Settings>(
        create: (context) => Settings(),
      ),
      ChangeNotifierProvider<Player>(create: (context) => Player()),
      ChangeNotifierProvider<Quiz>(create: (context) => Quiz.empty()),
    ];

    return SafeArea(
        child: Scaffold(
          backgroundColor: Theme.of(context).primaryColor,
      appBar: AppBar(backgroundColor: Colors.lightBlue[200]),
      body: Padding(
          padding: const EdgeInsets.all(10),
          child: MultiProvider(
            providers: providers,
            child: const Row(
              children: [
                // Flexible(flex: 2, child: UserScreenUsersList()),
                Flexible(flex: 5, child: OffUserScreenMain())
              ],
            ),
          )),
    ));
  }
}
