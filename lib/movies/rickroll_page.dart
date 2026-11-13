import 'package:audioplayers/audioplayers.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart' show debugPrint;
import 'package:material_ui/material_ui.dart';
import 'package:final_project_debojyoti_64_g_306/constants.dart';

// The harmless "Watch now" surprise screen. The sound can't be muted. That's the prank.
class RickrollPage extends StatefulWidget {
  final String movieTitle;
  const RickrollPage({super.key, required this.movieTitle});

  @override
  State<RickrollPage> createState() => _RickrollPageState();
}

class _RickrollPageState extends State<RickrollPage> {
  final AudioPlayer _player = AudioPlayer();
  bool _playing = false;

  @override
  void initState() {
    super.initState();
    _play(); // start the sound as soon as the page opens
  }

  Future<void> _play() async {
    try {
      await _player.setReleaseMode(ReleaseMode.loop);
      // The path is relative to the assets folder: assets/audio/rickroll.mp3
      await _player.play(AssetSource('rickroll.mp3'));
      _playing = true;
    } catch (e) {
      // Look for this line in your Debug Console / terminal if there is no sound.
      debugPrint('Rickroll audio error: $e');
    }
  }

  @override
  void dispose() {
    _player.dispose(); // stops the sound when you leave the page
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final uid = FirebaseAuth.instance.currentUser!.uid;

    return Scaffold(
      backgroundColor: kMaroon,
      appBar: AppBar(
        title: Text("Now playing: ${widget.movieTitle}"),
        backgroundColor: kMaroon,
        foregroundColor: Colors.white,
      ),
      // If a browser blocked the autoplay, the first tap anywhere starts the sound.
      body: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () {
          if (!_playing) _play();
        },
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                const Text(
                  "🎵 SURPRISE! 🎵",
                  style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 20),
                Image.network(
                  kRickrollGif,
                  height: 260,
                  errorBuilder: (context, error, stackTrace) {
                    return const Text("🕺", style: TextStyle(fontSize: 120));
                  },
                ),
                const SizedBox(height: 20),
                const Text(
                  "You just got Rickrolled!",
                  style: TextStyle(fontSize: 24, color: Colors.white),
                ),
                const SizedBox(height: 10),
                StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
                  stream:
                      FirebaseFirestore.instance
                          .collection('users')
                          .doc(uid)
                          .snapshots(),
                  builder: (context, snapshot) {
                    final count = snapshot.data?.data()?['rickrollCount'] ?? 0;
                    return Text(
                      "Your Rickroll meter: $count",
                      style: const TextStyle(fontSize: 18, color: kPink),
                    );
                  },
                ),
                const SizedBox(height: 25),
                ElevatedButton(
                  onPressed: () => Navigator.pop(context),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: kPink,
                    foregroundColor: kMaroon,
                    fixedSize: const Size(200, 45),
                  ),
                  child: const Text("Back to movies"),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}