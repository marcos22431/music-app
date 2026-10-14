import 'package:flutter/material.dart';

import '../services/playlist_store.dart';
import '../widgets/add_to_playlist_sheet.dart';
import 'playlist_detail_screen.dart';

class PlaylistsScreen extends StatelessWidget {
  const PlaylistsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final store = PlaylistStore.instance;
    return ListenableBuilder(
      listenable: store,
      builder: (context, _) {
        final names = store.names;
        return Column(
          children: [
            ListTile(
              leading: const Icon(Icons.add_circle_outline),
              title: const Text('Nova playlist'),
              onTap: () async {
                final name = await askPlaylistName(context);
                if (name != null) await store.create(name);
              },
            ),
            const Divider(height: 1),
            Expanded(
              child: names.isEmpty
                  ? const Center(child: Text('Você ainda não tem playlists'))
                  : ListView.builder(
                      itemCount: names.length,
                      itemBuilder: (context, i) {
                        final name = names[i];
                        final count = store.tracksOf(name).length;
                        return ListTile(
                          leading: const Icon(Icons.queue_music),
                          title: Text(name),
                          subtitle: Text('$count música(s)'),
                          trailing: IconButton(
                            icon: const Icon(Icons.delete_outline),
                            onPressed: () => store.delete(name),
                          ),
                          onTap: () => Navigator.push(
                            context,
                            MaterialPageRoute<void>(
                              builder: (_) => PlaylistDetailScreen(name: name),
                            ),
                          ),
                        );
                      },
                    ),
            ),
          ],
        );
      },
    );
  }
}
