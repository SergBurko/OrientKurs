import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:second_quiz/classes/common/player.dart';
import 'package:second_quiz/classes/common/settings.dart';
import 'package:second_quiz/classes/quiz/quiz.dart';
// import 'package:second_quiz/classes/quiz/quiz_question.dart';
// import 'package:second_quiz/start_screen.dart';
// import 'package:second_quiz/classes/widgets/user_screen/user_screen.dart';

class RouterScreen extends StatefulWidget {
  const RouterScreen({super.key});

  @override
  State<RouterScreen> createState() => _RouterScreenState();
}

class _RouterScreenState extends State<RouterScreen> {
  Widget currentScreen = Container();

  @override
  void initState() {
    // currentScreen = StartScreen(startQuiz);
    super.initState();
  }

  // void startQuiz() {
  //   setState(() {
  //     currentScreen = const UserScreen();
  //   });
  // }

  @override
  build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<Settings>(
          create: (context) => Settings(),
        ),
        ChangeNotifierProvider<Player>(create: (context) => Player()),
        ChangeNotifierProvider<Quiz>(create: (context) => Quiz.empty()),
      ],
      child: currentScreen,
    );
  }
}
