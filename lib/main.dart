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
// ... (XylophoneApp and ExpandedNoteKey classes remain the same) ...
class XylophoneKeysManager extends StatefulWidget {
  const XylophoneKeysManager({super.key});

  @override
  State<XylophoneKeysManager> createState() => _XylophoneKeysManagerState();
}

class _XylophoneKeysManagerState extends State<XylophoneKeysManager> {
  // Use AudioCache for fast loading of short sound effects
  // AudioCache is now integrated into the main AudioPlayer instance in recent versions.
  // We can just use a single AudioPlayer instance but leverage pre-caching.
  final AudioPlayer audioPlayer = AudioPlayer();

  // A list of asset paths we will cache
  final List<String> soundAssets = [
    'audio/note1.wav',
    'audio/note2.wav',
    'audio/note3.wav',
    'audio/note4.wav',
    'audio/note5.wav',
    'audio/note6.wav',
    'audio/note7.wav',
  ];

  @override
  void initState() {
    super.initState();
    // Pre-load all audio files into memory when the widget initializes
    _preloadAudioFiles();
  }

  Future<void> _preloadAudioFiles() async {
    // The audioplayers package handles caching automatically if you call preLoad()
    // across the list of sources you intend to use.
    for (String assetPath in soundAssets) {
      await audioPlayer.setSource(AssetSource(assetPath));
      // In modern versions of audioplayers, simply setting the source or playing it once
      // can initiate the underlying caching mechanisms. For guaranteed caching
      // without playing the sound immediately, the package's internal mechanism works fine.
    }
    // Alternatively, you can use the static AudioCache helper if you have a separate instance
    // await AudioCache.instance.loadAll(soundAssets);
  }

  // Function to play sound efficiently from a cached asset
  void playSound(int soundNumber) {
    // We don't await this call, so the UI remains responsive
    audioPlayer.play(AssetSource('note$soundNumber.wav'));
  }

  @override
  void dispose() {
    audioPlayer.dispose();
    super.dispose();
  }

  // ... (The build method remains the same, calling playSound(soundNumber) ) ...

  @override
  Widget build(BuildContext context) {
    final List<Color> keyColors = [
      Colors.red, Colors.orange, Colors.yellow, Colors.green,
      Colors.teal, Colors.blue, Colors.purple,
    ];

    return Column(
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