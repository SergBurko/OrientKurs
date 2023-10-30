import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:second_quiz/classes/common/singleton.dart';

class Player extends ChangeNotifier {
  
  Player (){
    for (var i = 0; i < Singleton.amountOfTracks; i++) {
      musicTracks.add("${Singleton.assetsMusicFolder}mus${i+1}.mp3");
    }
  }
  final player = AudioPlayer();
  List<String> musicTracks = [];
  int currentIndex = 0;

  bool _isPlaying = false;

  bool get isPlaying => _isPlaying;

  togglePlay() async {
    if (_isPlaying) {
      await player.pause();
    } else {
      playMelody();
    }
    _isPlaying = !_isPlaying;
    notifyListeners();
  }

  playMelody () async {
    try {
        await player.play(AssetSource(musicTracks[currentIndex]));
        player.onPlayerComplete.listen((event) {
        try {
        currentIndex = (currentIndex + 1) % musicTracks.length;
        playMelody();
        } catch (e) {
          print(e); 
        }
      });
      } catch (e) {
      print(e); 
    }
  }

  nextMelody() async {
    try {
        await player.stop();
        currentIndex = (currentIndex + 1) % musicTracks.length;
        await player.play(AssetSource(musicTracks[currentIndex]));
      } catch (e) {
      print(e); 
    }
  }

  disposePlayer(){
    player.dispose();
  }
  // beep () async {
  //   await player.play(AssetSource("${Singleton.assetsMusicFolder}beep.mp3"));
  // }

}
