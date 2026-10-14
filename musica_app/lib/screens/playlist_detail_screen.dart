import 'package:flutter/material.dart';

import '../models/track.dart';
import '../services/player_controller.dart';
import '../services/playlist_store.dart';
import '../widgets/mini_player.dart';
import '../widgets/track_tile.dart';

class PlaylistDetailScreen extends StatelessWidget {
  const PlaylistDetailScreen({super.key, required this.name});

  final String name;

  @override
  Widget build(BuildContext context) {
    final store = PlaylistStore.instance;
    final player = PlayerController.instance;

    return Scaffold(
      appBar: AppBar(title: Text(name)),
      body: ListenableBuilder(
        listenable: store,
        builder: (context, _) {
          final tracks = store.tracksOf(name);
          if (tracks.isEmpty) {
            return const Center(child: Text('Playlist vazia'));
          }
          return ValueListenableBuilder<Track?>(
            valueListenable: player.current,
            builder: (context, current, _) => ListView.builder(
              itemCount: tracks.length,
              itemExtent: 72,
              itemBuilder: (context, i) {
                final t = tracks[i];
                return TrackTile(
                  track: t,
                  selected: current?.id == t.id,
                  onTap: () => player.playQueue(tracks, i),
                  trailing: IconButton(
                    icon: const Icon(Icons.remove_circle_outline),
                    tooltip: 'Remover',
                    onPressed: () => store.removeTrack(name, t),
                  ),
                );
              },
            ),
          );
        },
      ),
      bottomNavigationBar: const SafeArea(child: MiniPlayer()),
    );
  }
}
