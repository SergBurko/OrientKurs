import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:second_quiz/classes/common/settings.dart';
import 'package:second_quiz/classes/common/singleton.dart';

class OffUserScreenMainCheckButtons extends StatelessWidget {
  const OffUserScreenMainCheckButtons({super.key});

  @override
  Widget build(BuildContext context) {
    Settings settings = Provider.of<Settings>(context);

    return Column(
      children: [
        DropdownButton(
          alignment: Alignment.center,
          isDense: false,
          iconSize: 30,
          value: settings.land,
          onChanged: (value) => settings.changeLand(value),
          items: Singleton.lands.map((value) {
            return DropdownMenuItem<String>(
                value: value, child: Text(value.trim()));
          }).toList(),
        ),
        Visibility(
          visible: false,
          child: Column(
            children: [
              Tooltip(
                  message:
                      "Randomisierung der Antworten. Nicht in einer bestimmten Reihenfolge.",
                  preferBelow: false,
                  child: Row(children: [
                    Checkbox(
                      value: settings.checkRandomAnswers,
                      onChanged: (value) {
                        settings.changeRandomAnswergValue();
                      },
                    ),
                    const Text("Zufällige Antwortposition")
                  ])),
              Tooltip(
                  message:
                      "Das wären höchstens die Antworten, bei denen Sie vorher Fehler gemacht haben",
                  preferBelow: false,
                  child: Row(children: [
                    Checkbox(
                      value: settings.checkStressTesting,
                      onChanged: (value) {
                        settings.changeStressTestingValue();
                      },
                    ),
                    const Text("Schwierige Antworten")
                  ])),
            ],
          ),
        ),
      ],
    );
  }
}
