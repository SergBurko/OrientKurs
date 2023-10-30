import 'package:auto_size_text/auto_size_text.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:second_quiz/classes/common/singleton.dart';
import 'package:second_quiz/online/common/on_participant.dart';
import 'package:second_quiz/online/common/on_quiz_group.dart';
import 'package:second_quiz/online/common/on_quiz_user.dart';
import 'package:second_quiz/online/widgets/quiz_screen/on_quiz_screen.dart';
import 'package:uuid/uuid.dart';

class OnGroupScreen extends StatefulWidget {
  const OnGroupScreen({super.key});

  @override
  State<OnGroupScreen> createState() => _OnGroupScreenState();
}

class _OnGroupScreenState extends State<OnGroupScreen> {
  String? _radioButtonValue = "Studie";

  OnQuizUser onQuizUser = OnQuizUser.empty("");
  OnQuizGroup onQuizGroup = OnQuizGroup.empty();
  final TextEditingController _textEdCName = TextEditingController();
  final TextEditingController _textEdCSeconds = TextEditingController();
  final TextEditingController _textEdCVerbinden = TextEditingController();
  // OnQuiz onQuiz = OnQuiz();

  @override
  initState() {
    super.initState();
    initializeOnQuiz();
  }

  initializeOnQuiz() async {
    await fetchOnQuiz();
    setState(() {
      _textEdCName.text = onQuizUser.name;
      _textEdCSeconds.text = onQuizGroup.secondsOnAnswer.toString();
    });
  }

  fetchOnQuiz() async {
    OnQuizUser authU = OnQuizUser.empty(FirebaseAuth.instance.currentUser!.uid)
        .byFirebaseAuthUser(FirebaseAuth.instance.currentUser);
    onQuizUser = await OnQuizUser.empty(authU.id).readLastFromDB();

    if ((onQuizUser.name.isEmpty)) {
      onQuizUser.email = authU.email;
      onQuizUser.name = authU.name;
      onQuizUser.addThisToDB();
    }

    onQuizGroup.userId = onQuizUser.id;

    // onQuiz.userId = onQuizUser.id;
    // onQuiz = await onQuiz.readLastFromDBByUserId();

    // if (onQuiz.userName.isEmpty && onQuizUser.name.isNotEmpty ||
    //     onQuiz.userName != onQuizUser.name) {
    //   onQuiz.userName = onQuizUser.name;
    //   onQuiz.addThisInDB();
    // }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(actions:  const [
        // FilledButton.icon(
        //   onPressed: () {
        //     FirebaseAuth.instance.signOut();
        //     // Navigator.of(context).pop();
        //   },
        //   icon: const Icon(
        //     Icons.exit_to_app,
        //   ),
        //   label: const Text("Aus"),
        //   style: ButtonStyle(
        //       backgroundColor: MaterialStateProperty.all(Colors.redAccent)),
        // )
      ]),
///// BODY
      body: Center(
        child: SingleChildScrollView(
          child: ConstrainedBox(
              constraints: BoxConstraints(
                maxHeight: MediaQuery.of(context).size.height-100,
                maxWidth: MediaQuery.of(context).size.width,
              ),
              child: Center(
                  child: Column(
                children: [
                  const SizedBox(
                    height: 10,
                  ),
////// COLUMN /////////////////////////////////////////////////////////////////

//// NAME TextField
                  SizedBox(
                    width: MediaQuery.of(context).size.width / 1.3,
                    // height: 1,
                    child: TextField(
                        autofocus: false,
                        textAlignVertical: TextAlignVertical.top,
                        textAlign: TextAlign.center,
                        onChanged: (value) {
                          onQuizUser.name = value;
                        },
                        onEditingComplete: () {
                          OnQuizUser(onQuizUser.id, onQuizUser.name,
                                  email: onQuizUser.email)
                              .addThisToDB();
                          FocusScope.of(context).unfocus();
                        },
                        maxLength: 15,
                        controller: _textEdCName,
                        decoration: InputDecoration(
                          prefixIcon: const Icon(
                            Icons.person,
                            size: 40,
                          ),
                          filled: true,
                          fillColor: _textEdCName.text.isEmpty
                              ? Colors.red[50]
                              : Colors.lightGreen[50],
                          border: const OutlineInputBorder(
                              borderSide: BorderSide.none,
                              borderRadius:
                                  BorderRadius.all(Radius.circular(50))),
                          hintText: "Ihren Namen",
                          focusedBorder: const OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.lightBlue)),
                          contentPadding:
                              const EdgeInsets.symmetric(vertical: 5),
                          // border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide(width: 1, color: const Color.fromARGB(255, 242, 245, 247))),
                        )),
                  ),
                  const SizedBox(
                      height: 50,
                      width: 50,
                      child: Center(
                          child: Divider(
                        thickness: 3,
                      ))),
// GRUPPE ERSTELLEN
                  Container(
                    decoration: BoxDecoration(
                        color: Colors.lightBlue[50],
                        border: const Border.symmetric(
                            horizontal: BorderSide(width: 1))),
                    child: Column(
                      children: [
                        const SizedBox(
                            height: 30,
                            width: 300,
                            child: Center(
                                child: Text(
                                    "↓ ↓ ↓ ↓  GRUPPE ERSTELLEN  ↓ ↓ ↓ ↓"))),
//// RADIO BUTTONS
                        Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: SizedBox(
                            width: MediaQuery.of(context).size.width,
                            height: 50,
                            child: Row(
                              // crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Flexible(
                                  flex: 2,
                                  child: RadioListTile<String>(
                                    contentPadding: EdgeInsets.zero,
                                    title: AutoSizeText(
                                      'Studie',
                                      style: TextStyle(
                                          fontStyle: FontStyle.italic,
                                          decoration:
                                              _radioButtonValue == "Studie"
                                                  ? TextDecoration.underline
                                                  : TextDecoration.none),
                                    ),
                                    value: 'Studie',
                                    groupValue: _radioButtonValue,
                                    onChanged: (value) {
                                      setState(() {
                                        onQuizGroup.lernState = true;
                                        _radioButtonValue = value;
                                      });
                                    },
                                  ),
                                ),
                                Flexible(
                                  flex: 2,
                                  child: RadioListTile<String>(
                                    contentPadding: EdgeInsets.zero,
                                    title: AutoSizeText('Prüfung',
                                        style: TextStyle(
                                            fontStyle: FontStyle.italic,
                                            decoration:
                                                _radioButtonValue == "Prüfung"
                                                    ? TextDecoration.underline
                                                    : TextDecoration.none)),
                                    value: 'Prüfung',
                                    groupValue: _radioButtonValue,
                                    onChanged: (value) {
                                      setState(() {
                                        onQuizGroup.lernState = false;
                                        _radioButtonValue = value;
                                      });
                                    },
                                  ),
                                ),

                                // Text(
                                //   'Selected value: ${_radioButtonValue ?? "Nothing selected"}',
                                //   style: TextStyle(fontSize: 18),
                                // ),
                              ],
                            ),
                          ),
                        ),
//// LAND choosing
                        DropdownButton(
                          alignment: Alignment.center,
                          isDense: false,
                          iconSize: 30,
                          value: onQuizGroup.land,
                          onChanged: (value) => setState(() {
                            onQuizGroup.land = value ?? "Berlin";
                          }),
                          // onChanged: (value) {},
                          items: Singleton.lands.map((value) {
                            return DropdownMenuItem<String>(
                                value: value, child: Text(value.trim()));
                          }).toList(),
                        ),
//// SECONDS Choose

                        const SizedBox(height: 10),
                        !Singleton.OnGroupScreenBlockSeconds
                            ? Container(
                                height: 0,
                              )
                            : SizedBox(
                                height: 50,
                                width: MediaQuery.of(context).size.width,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    const Flexible(
                                        flex: 3,
                                        child: AutoSizeText(
                                            "Sekunden zur Antwort:")),
                                    Flexible(
                                      flex: 1,
                                      child: TextFormField(
                                        textAlign: TextAlign.center,
                                        controller: _textEdCSeconds,
                                        onChanged: (value) {
                                          if (value.isNotEmpty) {
                                            if (int.parse(value) >= 0 &&
                                                int.parse(value) < 300) {
                                              onQuizGroup.secondsOnAnswer =
                                                  int.parse(value);
                                            }
                                            // if (int.parse(value) >= 0 &&
                                            //     int.parse(value) <= 5) {
                                            //   _textEdCSeconds.text = "6";
                                            // }
                                          } else {
                                            _textEdCSeconds.text = onQuizGroup
                                                .secondsOnAnswer
                                                .toString();
                                          }
                                        },
                                        keyboardType: TextInputType.number,
                                        inputFormatters: <TextInputFormatter>[
                                          FilteringTextInputFormatter.allow(
                                              RegExp(r'^[0-9]*$')),
                                          FilteringTextInputFormatter
                                              .digitsOnly,
                                          FilteringTextInputFormatter
                                              .singleLineFormatter,
                                          LengthLimitingTextInputFormatter(3)
                                        ],
                                        validator: (value) {
                                          if (value == null || value.isEmpty) {
                                            return 'Geben Sie eine Zahl zwischen 5 und 300 ein';
                                          }
                                          int intValue = int.parse(value);
                                          if (intValue == null ||
                                              intValue < 5 ||
                                              intValue > 300) {
                                            return 'Geben Sie eine Zahl zwischen 5 und 300 ein!!';
                                          }
                                          return null;
                                        },
                                      ),
                                    )
                                  ],
                                ),
                              ),
                        const SizedBox(height: 10),

//// ERSTELLEN Button
                        FilledButton.icon(
                          onPressed: () {
                            onQuizGroup.groupId = const Uuid().v4();
                            onQuizGroup.currentQuestion = "";
                            onQuizGroup.questions = [];
                            onQuizGroup.addThisToDB();
                            Participant().addInDBAsParticipant(
                                onQuizGroup.groupId, onQuizUser);

                            if (onQuizUser.name.isEmpty) {
                              showDialogChooseAnswer(context);
                            } else {
                              Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) {
                                  return ChangeNotifierProvider.value(
                                    value:
                                        onQuizGroup, // Передача существующего объекта
                                    child: OnQuizScreen(
                                      onQuizGroup: onQuizGroup,
                                    ),
                                  );
                                },
                              ));

                              // Navigator.of(context).push(MaterialPageRoute(
                              //   builder: (context) {
                              //     return OnQuizScreen(onQuizGroup: onQuizGroup);
                              //   },
                              // ));
                            }
                          },
                          icon: const Icon(Icons.new_label),
                          label: const AutoSizeText("Neue Erstellen"),
                        ),
                      ],
                    ),
                  ),
// Divider
                  const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: SizedBox(
                        height: 50,
                        width: 50,
                        child: Center(
                            child: Divider(
                          thickness: 3,
                        ))),
                  ),
//// GRUPPE VERBINDEN
                  Container(
                    decoration: BoxDecoration(
                        color: Colors.lightGreen[50],
                        border: const Border.symmetric(
                            horizontal: BorderSide(width: 1))),
                    child: Column(
                      children: [
                        const SizedBox(
                            height: 30,
                            width: 300,
                            child: Center(
                                child: Text(
                                    "- ↓ ↓ ↓  GRUPPE VERBINDEN  ↓ ↓ ↓ -"))),

//// Letzte Button
                        Align(
                          alignment: Alignment.centerRight,
                          child: FilledButton.icon(
                            onPressed: () async {
                              OnQuizGroup grp = await OnQuizGroup.empty()
                                  .getMyLastGroup(onQuizUser.id);
                              _textEdCVerbinden.text = grp.groupId;
                            },
                            icon: const Icon(Icons.paste, color: Colors.black),
                            label: const AutoSizeText(
                              "letzte",
                              style: TextStyle(color: Colors.black),
                            ),
                            style: ButtonStyle(
                                backgroundColor:
                                    MaterialStateProperty.all(Colors.grey)),
                          ),
                        ),

//// VERBINDEN Link
                        SizedBox(
                          width: 300,
                          height: 50,
                          child: TextFormField(
                            textAlign: TextAlign.center,
                            style: const TextStyle(fontSize: 16),
                            controller: _textEdCVerbinden,
                            onChanged: (value) {
                              _textEdCVerbinden.text = value;
                            },
                            keyboardType: TextInputType.text,
                            decoration: InputDecoration(
                                filled: true,
                                fillColor: Colors.grey[50],
                                hintText: "Gruppenlink",
                                hintStyle: const TextStyle(
                                    fontSize: 16, color: Colors.grey)),
                          ),
                        ),
                        const SizedBox(height: 10),
//// VERBINDEN Button
                        FilledButton.icon(
                          onPressed: () async {
                            try {
                              if (_textEdCVerbinden.text.isNotEmpty) {
                                OnQuizGroup grp = OnQuizGroup.empty();
                                await grp.getGroupFromDBByGroupId(
                                    _textEdCVerbinden.text);

                                if (onQuizUser.name.isEmpty) {
                                  // ignore: use_build_context_synchronously
                                  showDialogChooseAnswer(context);
                                } else {
                                  if (grp.groupId.isNotEmpty &&
                                      onQuizUser.name.isNotEmpty) {
                                    var participant = await Participant()
                                        .getParticipantByUserIdAndGroupID(
                                            onQuizUser.id, grp.groupId);
                                    if (participant.participantId.isEmpty) {
                                      Participant().addInDBAsParticipant(
                                          grp.groupId, onQuizUser);
                                    }

                                    // ignore: use_build_context_synchronously
                                    Navigator.of(context)
                                        .push(MaterialPageRoute(
                                      builder: (context) {
                                        return ChangeNotifierProvider.value(
                                          value:
                                              grp, // Передача существующего объекта
                                          child: OnQuizScreen(
                                            onQuizGroup: grp,
                                          ),
                                        );
                                      },
                                    ));
                                    // ignore: use_build_context_synchronously
                                    // Navigator.of(context).push(MaterialPageRoute(
                                    //   builder: (context) {
                                    //     return OnQuizScreen(onQuizGroup: grp);
                                    //   },
                                    // ));
                                  }
                                }
                              }
                            } catch (e) {
                              print("Verbinden fehler: $e");
                            }
                            
                          },
                          icon: const Icon(Icons.connect_without_contact),
                          label: const AutoSizeText("Verbinden"),
                        ),
                      ],
                    ),
                  ),
                ],
              ))),
        ),
      ),
    );
  }

  void showDialogChooseAnswer(BuildContext context) {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Center(
                child: Text(
                    textAlign: TextAlign.center, "Wählen Sie einen Namen")),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text('OK'),
              ),
            ],
          );
        });
  }
}
