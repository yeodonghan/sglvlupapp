import 'package:SGLvlUp/shared/UserPreferences.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:flame/flame.dart';


class SoundsHandler {

  bool sound = UserPreferences().sound;
  bool tapSound = UserPreferences().tapSound;
  AudioPlayer _audioPlayer;

  static final SoundsHandler _instance = SoundsHandler._ctor();

  factory SoundsHandler() {
    return _instance;
  }

  SoundsHandler._ctor();

  void playTap() async{
    try {
      if (this.tapSound == true) {
        await Flame.audio.play('tap.ogg');
      }
    }
    catch(Exception){}
  }

  void playBGM() async{
    try {
      if (this.sound == true) {
        _audioPlayer = await Flame.audio.loopLongAudio('bgm.mp3');
      }

    }
    catch(Exception){
    }
  }

  Future<void> update() async {
    try {
      Flame.audio.disableLog();
      if (sound) {
        _audioPlayer = await Flame.audio.loopLongAudio('bgm.mp3');

      } else {
        if (_audioPlayer != null) {
          _audioPlayer.stop();
        }
      }
    }
    catch (Exception) {

    }
  }

  void resume(){
    try {
      if(_audioPlayer != null && sound) {
        _audioPlayer.resume();
      }
    }
    catch(Exception) {}
  }

  void pause(){
    try {
      if(_audioPlayer != null && sound) {
        _audioPlayer.pause();
      }
    }
    catch(Exception) {}
  }
}