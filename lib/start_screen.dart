import 'dart:math';

// import 'package:audioplayers/audioplayers.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:connectivity/connectivity.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:second_quiz/online/common/auth_services.dart';
import 'package:second_quiz/online/common/dialogs.dart';
import 'package:second_quiz/classes/common/saying.dart';
import 'package:second_quiz/classes/common/singleton.dart';
import 'package:second_quiz/classes/widgets/music_floating_button.dart';
import 'package:second_quiz/offline/user_screen/off_user_screen.dart';
import 'package:second_quiz/online/widgets/group_screen/on_group_screen.dart';
import 'package:second_quiz/online/widgets/login_screen/on_login_screen.dart';
// import 'package:second_quiz/quiz_screen.dart';

class StartScreen extends StatefulWidget {
  const StartScreen(/* this.startQuiz ,*/ {super.key});

  // final void Function() startQuiz;

  @override
  State<StartScreen> createState() => _StartScreenState();
}

class _StartScreenState extends State<StartScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller; // ANIMATION

  // @override
  // void initState() {
  //   super.initState();
  //   _controller = AnimationController(
  //     // ANIMATION
  //     duration: const Duration(seconds: 2),
  //     vsync: this,
  //   );
  //   _controller.repeat(reverse: true);
  //   // play();
  // }

  // play () async {

  // }

  Future<bool> checkConnectivity() async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.mobile ||
        connectivityResult == ConnectivityResult.wifi) {
      return true;
    } else {
      // Нет подключения к Интернету
      return false;
    }
  }

  @override
  void dispose() {
    // _controller.dispose(); // ANIMATION

    // Player player = Provider.of<Player>(context);
    // player.disposePlayer();
    // player.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // AuthServices authServices = Provider.of<AuthServices>(context);

    return SafeArea(
      child: Scaffold(
        body: Container(
          color: Theme.of(context).primaryColor,
          child: Padding(
            padding: const EdgeInsets.all(10),
            child: Column(mainAxisSize: MainAxisSize.max, children: [
              Container(
                height: 40,
              ),
              Flexible(
                flex: 3,
                child: Image.asset(
                  // "assets/images/quiz-logo.png",
                  "assets/images/logo.png",
                  // width: 300,
                  // color: const Color.fromARGB(125, 255, 255, 255),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              SizedBox(
                height: 100,
                child: Builder(builder: (context) {
                  int randomInt = Random().nextInt(Singleton.sayings.length);
                  Saying saying = Singleton.sayings[randomInt];
                  return AutoSizeText(
                    textAlign: TextAlign.center,
                    "${saying.value}${saying.autor.trim().isEmpty ? "" : "\n\n(ℂ)${saying.autor}"}",
                    style: Theme.of(context).textTheme.labelLarge,
                  );
                }),
              ),
              Container(
                height: 40,
              ),
              Flexible(
                flex: 2,
                child: Column(
                  children: [
//////// SELBST
                    FilledButton.icon(
                      icon: const Icon(Icons.man),
                      onPressed: () {
                        Navigator.push(context, MaterialPageRoute(
                          builder: (context) {
                            return const OffUserScreen();
                          },
                        ));
                      },
                      label: Text("Selbststudium",
                          style: Theme.of(context).textTheme.labelLarge),
                    ),
                    const SizedBox(
                        height: 20,
                        width: 50,
                        child: Divider(thickness: 1, height: 1)),
//////// GRUPPEN
                    FilledButton.icon(
                      icon: const Icon(Icons.people),
                      onPressed: () async {
                        bool internetCheck = await checkConnectivity();
                        if (internetCheck) {
                          // ignore: use_build_context_synchronously
                          Navigator.push(context,
                              MaterialPageRoute(builder: (context) {
                            return StreamBuilder<User?>(
                              stream: FirebaseAuth.instance.authStateChanges(),
                              builder: (context, snapshot) {
                                if (snapshot.hasError) {
                                  print(snapshot.error);
                                  return Container();
                                }
                                if (snapshot.connectionState ==
                                    ConnectionState.waiting) {
                                  // Показать загрузочный индикатор, пока идет проверка состояния аутентификации
                                  return SpinKitSpinningLines(color: Colors.lightBlue,);
                                }
                                if (snapshot.data != null) {
                                  return const OnGroupScreen();
                                } else {
                                  return FutureBuilder(
                                    future: AuthServices().signInAsAnonymous(),
                                    builder: (context, snapshot) {
                                      if (snapshot.connectionState ==
                                          ConnectionState.waiting) {
                                        // Показать загрузочный индикатор, пока выполняется вход анонимного пользователя
                                        return  SpinKitSpinningLines(color: Colors.lightBlue,);
                                      }
                                      if (snapshot.hasError) {
                                        print(snapshot.error);
                                        // Обработать ошибку входа анонимного пользователя
                                        return Text('Error occurred');
                                      }
                                      // Возвратить OnGroupScreen после успешного входа анонимного пользователя
                                      return const OnGroupScreen();
                                    },
                                  );
                                }
                              },
                            );

                            // StreamBuilder<User?>(
                            //   stream: FirebaseAuth.instance.authStateChanges(),
                            //   builder: (context, snapshot) {
                            //     if (snapshot.hasError) {
                            //       print(snapshot.error);
                            //       return Container();
                            //     }
                            //     if (snapshot.data != null) {
                            //       return const OnGroupScreen();
                            //     } else {
                            //       AuthServices().signInAsAnonymous();
                            //       return const OnGroupScreen();
                            //       // return const OnLoginScreen();
                            //     }
                            //   },
                            // );
                          }));
                        } else {
                          Dialogs.noInternetConnection(context);
                        }
                      },
                      label: Text("Gruppenübung",
                          style: Theme.of(context).textTheme.labelLarge),
                    ),
                  ],
                ),
              )
            ]),
          ),
        ),
        floatingActionButton: const MusicFloatingButton(),
      ),
    );
  }

  loginAsAnonym() async {
    await AuthServices().signInAsAnonymous();
  }
}
