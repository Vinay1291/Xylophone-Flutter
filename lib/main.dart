import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(XylophoneApp());
}

class XylophoneApp extends StatelessWidget {
  const XylophoneApp({super.key});


  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Xylophone',
      home: Scaffold(
        backgroundColor: Colors.black,
        body: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              NoteButton(
                soundNumber: 1,
                buttonColor: Colors.red,
              ),
              NoteButton(
                soundNumber: 2,
                buttonColor: Colors.orange,
              ),
              NoteButton(
                soundNumber: 3,
                buttonColor: Colors.yellow,
              ),
              NoteButton(
                soundNumber: 4,
                buttonColor: Colors.green,
              ),
              NoteButton(
                soundNumber: 5,
                buttonColor: Colors.teal,
              ),
              NoteButton(
                soundNumber: 6,
                buttonColor: Colors.blue,
              ),
              NoteButton(
                soundNumber: 7,
                buttonColor: Colors.purple,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class NoteButton extends StatelessWidget {
  final int soundNumber;
  final Color buttonColor;
  const NoteButton({super.key, required this.soundNumber, required this.buttonColor});


  void playSound(int soundNumber) async {
    final player = AudioPlayer();
    await player.play(AssetSource('note$soundNumber.wav'));
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: TextButton(
        style: TextButton.styleFrom(
          backgroundColor: buttonColor,
          shape: RoundedRectangleBorder(),

        ),
        onPressed: () {
          playSound(soundNumber);
        },
        child: Text(''),
      ),
    );
  }
}
