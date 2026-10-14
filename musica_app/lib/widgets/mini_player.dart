import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';

import '../models/track.dart';
import '../services/player_controller.dart';

class MiniPlayer extends StatelessWidget {
  const MiniPlayer({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = PlayerController.instance;
    final player = controller.player;

    return ValueListenableBuilder<Track?>(
      valueListenable: controller.current,
      builder: (context, track, _) {
        if (track == null) return const SizedBox.shrink();
        return Container(
          color: const Color(0xFF1E1E1E),
          padding: const EdgeInsets.fromLTRB(16, 8, 8, 0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(track.title,
                            maxLines: 1, overflow: TextOverflow.ellipsis),
                        Text(track.artist,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: Theme.of(context).textTheme.bodySmall),
                      ],
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.skip_previous),
                    onPressed: player.seekToPrevious,
                  ),
                  StreamBuilder<PlayerState>(
                    stream: player.playerStateStream,
                    builder: (context, snap) {
                      final playing = snap.data?.playing ?? false;
                      return IconButton.filled(
                        icon: Icon(playing ? Icons.pause : Icons.play_arrow),
                        onPressed: playing ? player.pause : player.play,
                      );
                    },
                  ),
                  IconButton(
                    icon: const Icon(Icons.skip_next),
                    onPressed: player.seekToNext,
                  ),
                ],
              ),
              StreamBuilder<Duration>(
                stream: player.positionStream,
                builder: (context, snap) {
                  final pos = snap.data ?? Duration.zero;
                  final total =
                      player.duration ?? Duration(seconds: track.durationSeconds);
                  final max = total.inMilliseconds;
                  final value = pos.inMilliseconds.clamp(0, max > 0 ? max : 1);
                  return Slider(
                    value: value.toDouble(),
                    max: (max > 0 ? max : 1).toDouble(),
                    onChanged: (v) =>
                        player.seek(Duration(milliseconds: v.toInt())),
                  );
                },
              ),
            ],
          ),
        );
      },
    );
  }
}
