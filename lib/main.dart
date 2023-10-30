import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:second_quiz/classes/common/player.dart';
import 'package:second_quiz/classes/common/settings.dart';
import 'package:second_quiz/classes/common/singleton.dart';
import 'package:second_quiz/classes/quiz/quiz.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:second_quiz/start_screen.dart';
import 'package:firebase_core/firebase_core.dart';

// creating changes and generate new JSonFiles
// dart run build_runner build

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  FlutterNativeSplash.preserve(widgetsBinding: WidgetsBinding.instance);

  SystemChannels.textInput.invokeMethod('TextInput.hide'); //hide Keyboard

  try {
    await Firebase.initializeApp();
    FirebaseDatabase.instance.setPersistenceEnabled(true);
    FirebaseDatabase.instance.databaseURL = Singleton.dbPath;
  } catch (e) {
    print("Start error: $e");
  }

  // FirebaseDatabase.instance.databaseURL = "gs://orientkurs.appspot.com";

  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp, // restrict landshaft side
    DeviceOrientation.portraitDown,
  ]);

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    // initialization();
    FlutterNativeSplash.remove();

    return MaterialApp(
      title: 'Orientkurs',
      supportedLocales: const [Locale('en')],
      theme: Singleton.themes,
      home: MultiProvider(
        providers: [
          ChangeNotifierProvider<Settings>(
            create: (context) => Settings(),
          ),
          ChangeNotifierProvider<Player>(create: (context) => Player()),
          ChangeNotifierProvider<Quiz>(create: (context) => Quiz.empty()),
        ],
        child: const StartScreen(),
      ),
    );
  }
}
