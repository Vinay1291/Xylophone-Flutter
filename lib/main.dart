import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';

void main() {
  runApp(const XylophoneApp());
}

class XylophoneApp extends StatelessWidget {
  const XylophoneApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '7 Note Xylophone',
      home: Scaffold(
        backgroundColor: Colors.black, // Background color of the whole screen
        body: SafeArea(
          // SafeArea prevents keys from going into the status bar area
          child: XylophoneKeysManager(),
        ),
      ),
    );
  }
}

// Stateful Widget to manage the AudioPlayer lifecycle
class XylophoneKeysManager extends StatefulWidget {
  const XylophoneKeysManager({super.key});

  @override
  State<XylophoneKeysManager> createState() => _XylophoneKeysManagerState();
}

class _XylophoneKeysManagerState extends State<XylophoneKeysManager> {
  // Single instance of the audio player for efficiency
  final AudioPlayer audioPlayer = AudioPlayer();

  // Function to play sound from an asset path
  void playSound(int soundNumber) async {
    // Note: This does not await completion, allowing quick successive presses
    audioPlayer.play(AssetSource('note$soundNumber.wav'));
  }

  @override
  void dispose() {
    // Important: release native resources
    audioPlayer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // List of colors corresponding to the 7 keys/notes
    final List<Color> keyColors = [
      Colors.red,
      Colors.orange,
      Colors.yellow,
      Colors.green,
      Colors.teal,
      Colors.blue,
      Colors.purple,
    ];

    return Column(
      // Stretch keys horizontally to fill the width
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: List.generate(7, (index) {
        final soundNumber = index + 1;
        return ExpandedNoteKey(
          color: keyColors[index],
          onPress: () => playSound(soundNumber),
        );
      }),
    );
  }
}

// Reusable Stateless Widget for a single xylophone key
class ExpandedNoteKey extends StatelessWidget {
  final Color color;
  final VoidCallback onPress;

  const ExpandedNoteKey({
    super.key,
    required this.color,
    required this.onPress,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      // Expanded makes each key take up equal vertical space
      child: TextButton(
        style: TextButton.styleFrom(
          backgroundColor: color,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(0), // Sharp rectangle edges
          ),
        ),
        onPressed: onPress, // The function passed from the parent
        child: const SizedBox.shrink(), // Empty child widget
      ),
    );
  }
}