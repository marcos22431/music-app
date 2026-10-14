import 'package:flutter/material.dart';

import '../models/track.dart';
import '../services/playlist_store.dart';

Future<String?> askPlaylistName(BuildContext context) {
  final controller = TextEditingController();
  return showDialog<String>(
    context: context,
    builder: (ctx) => AlertDialog(
      title: const Text('Nova playlist'),
      content: TextField(
        controller: controller,
        autofocus: true,
        decoration: const InputDecoration(hintText: 'Nome da playlist'),
        onSubmitted: (v) => Navigator.pop(ctx, v),
      ),
      actions: [
        TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancelar')),
        FilledButton(
          onPressed: () => Navigator.pop(ctx, controller.text),
          child: const Text('Criar'),
        ),
      ],
    ),
  );
}

Future<void> showAddToPlaylistSheet(BuildContext context, Track track) {
  final store = PlaylistStore.instance;
  return showModalBottomSheet<void>(
    context: context,
    builder: (ctx) => SafeArea(
      child: ListenableBuilder(
        listenable: store,
        builder: (context, _) => ListView(
          shrinkWrap: true,
          children: [
            ListTile(
              leading: const Icon(Icons.add),
              title: const Text('Nova playlist'),
              onTap: () async {
                final name = await askPlaylistName(ctx);
                if (name == null || name.trim().isEmpty) return;
                await store.create(name);
                await store.add(name.trim(), track);
                if (ctx.mounted) Navigator.pop(ctx);
              },
            ),
            for (final name in store.names)
              ListTile(
                leading: const Icon(Icons.queue_music),
                title: Text(name),
                onTap: () async {
                  await store.add(name, track);
                  if (ctx.mounted) Navigator.pop(ctx);
                },
              ),
          ],
        ),
      ),
    ),
  );
}
