import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:second_quiz/classes/common/player.dart';
import 'package:second_quiz/classes/common/settings.dart';
import 'package:second_quiz/classes/widgets/music_floating_button.dart';
import 'package:second_quiz/classes/quiz/quiz.dart';
import 'package:second_quiz/classes/quiz/quiz_user.dart';
import 'package:second_quiz/offline/quiz_screen/off_quiz_screen.dart';
import 'package:second_quiz/offline/user_screen/widgets/off_user_screen_main_check_buttons.dart';

class OffUserScreenMain extends StatefulWidget {
  const OffUserScreenMain({super.key});

  @override
  State<OffUserScreenMain> createState() => _OffUserScreenMainState();
}

class _OffUserScreenMainState extends State<OffUserScreenMain>
    with SingleTickerProviderStateMixin {
  final TextEditingController _textEdController = TextEditingController();

  late AnimationController _controller; // ANIMATION

  loadSettings() async {
    try {
      Settings sss = Settings();
      Settings settingsFromFile = await sss.getSettingsFromFile();

      if (settingsFromFile.defaultUserName.isNotEmpty) {
        // ignore: use_build_context_synchronously
        final settingsProvider = Provider.of<Settings>(context, listen: false);

        if (settingsProvider.defaultUserName.isEmpty ||
            settingsProvider.defaultUserName.trim() == "Kursteilnehmer") {
          settingsProvider.setBySettings(settingsFromFile);
        }
      } else {
        Settings().writeSettingsToFile();
      }
    } catch (e) {
      // ignore: avoid_print
      print('Error:$e');
    }
  }

  updateData(Settings settings) async {
    await QuizUser(quizUsername: settings.defaultUserName).addQuizUserToFile();
    await settings.setUsersFromQuizUsersFile();
    await settings.writeSettingsToFile();
  }

  @override
  initState() {
    super.initState();
    loadSettings();
    _controller = AnimationController(
      // ANIMATION
      duration: const Duration(seconds: 1),
      vsync: this,
    );
    _controller.repeat(reverse: true);
  }

  @override
  void dispose() {
    _controller.dispose(); // ANIMATION
    super.dispose();
    // Player player = Provider.of<Player>(context);
    // player.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Settings settings = Provider.of<Settings>(context);
    Quiz quiz = Provider.of<Quiz>(context);
    Player player = Provider.of<Player>(context);

    _textEdController.text = settings.defaultUserName;

    return Container(
      // decoration: BoxDecoration(color: Theme.of(context).primaryColor),
      padding: const EdgeInsets.all(10),
      color: Theme.of(context).primaryColor,
      child: SafeArea(
          child: Scaffold(
        backgroundColor: Theme.of(context).primaryColor,
        body: Center(
          child: SizedBox(
            width: MediaQuery.of(context).size.width/1.5,
            height: MediaQuery.of(context).size.height,
            child: Column(
              children: [
                Flexible(
                  flex: 2,
                  child: Form(
                    child: TextFormField(
                      autofocus: false,
                      // keyboardType: TextInputType.none, //KEYBOARD!
                      textAlign: TextAlign.center,
                      style: const TextStyle(fontSize: 30),
                      maxLength: 15,
                      controller: _textEdController,
                      onChanged: (value) {
                        // print('Value: $value');
                        settings.setDefaultUserName(value);
                      },
                    ),
                  ),
                ),
                // COMBO BOX & CHECK BUTTONS
                const Flexible(flex: 1, child: OffUserScreenMainCheckButtons()),
                // LERN Button
                Flexible(
                  flex: 2,
                  child: FilledButton.icon(
                      onPressed: () {
                        if (settings.defaultUserName.isNotEmpty) {
                          settings.checkLerning = true;
                          updateData(settings);

                          Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => OffQuizScreen(
                                settings: settings, quiz: quiz, player: player),
                          ));
                        }
                      },
                      icon: const Icon(Icons.start_rounded),
                      label: const Text("Lern")),
                ),
                const SizedBox(width: 100, child: Divider()),
                Flexible(
                  flex: 2,
                  child: ScaleTransition(
                    scale: _controller.drive(
                      Tween(
                          begin: 1.0, end: 1.2), // Меняем размер от 1.0 до 1.2
                    ),
                    // PRÜFUNG BUTTON!
                    child: FilledButton.icon(
                        onPressed: () {
                          if (settings.defaultUserName.isNotEmpty) {
                            settings.checkLerning = false;
                            updateData(settings);

                            Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => OffQuizScreen(
                                  settings: settings,
                                  quiz: quiz,
                                  player: player),
                            ));
                          }
                        },
                        icon: const Icon(Icons.list_alt),
                        label: const Text("PRÜFUNG!")),
                  ),
                )
              ],
            ),
          ),
        ),
        floatingActionButton: const MusicFloatingButton(),
      )),
    );
  }
}
