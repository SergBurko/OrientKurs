import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:second_quiz/classes/common/player.dart';

class MusicFloatingButton extends StatelessWidget {
  const MusicFloatingButton({super.key});

  @override
  Widget build(BuildContext context) {
    Player player = Provider.of<Player>(context);

    return FloatingActionButton(
          onPressed: () {
            player.togglePlay();
          },
          backgroundColor: player.isPlaying ? Colors.green : Colors.blue,
          child: Icon(player.isPlaying
              ? Icons.pause
              : Icons.play_arrow_outlined), // Цвет кнопки
        );
  }
} 