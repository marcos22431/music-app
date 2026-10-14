import 'package:flutter/foundation.dart';
import 'package:just_audio/just_audio.dart';
import 'package:just_audio_background/just_audio_background.dart';

import '../models/track.dart';

/// Player único do app, compartilhado por todas as telas.
class PlayerController {
  PlayerController._();
  static final PlayerController instance = PlayerController._();

  final AudioPlayer player = AudioPlayer();
  final ValueNotifier<Track?> current = ValueNotifier<Track?>(null);
  List<Track> _queue = const [];

  void init() {
    player.currentIndexStream.listen((i) {
      if (i != null && i >= 0 && i < _queue.length) {
        current.value = _queue[i];
      }
    });
  }

  Future<void> playQueue(List<Track> tracks, int index) async {
    if (tracks.isEmpty) return;
    _queue = tracks;
    current.value = tracks[index];

    final source = ConcatenatingAudioSource(children: [
      for (final t in tracks)
        AudioSource.uri(
          Uri.parse(t.audioUrl),
          tag: MediaItem(
            id: t.id,
            title: t.title,
            artist: t.artist,
            artUri: t.coverUrl.isEmpty ? null : Uri.parse(t.coverUrl),
            duration: Duration(seconds: t.durationSeconds),
          ),
        ),
    ]);

    await player.setAudioSource(source, initialIndex: index);
    await player.play();
  }
}
