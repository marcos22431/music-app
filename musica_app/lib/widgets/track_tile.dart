import 'package:flutter/material.dart';

import '../models/track.dart';

class TrackTile extends StatelessWidget {
  const TrackTile({
    super.key,
    required this.track,
    required this.selected,
    required this.onTap,
    this.trailing,
  });

  final Track track;
  final bool selected;
  final VoidCallback onTap;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: ClipRRect(
        borderRadius: BorderRadius.circular(6),
        child: Image.network(
          track.coverUrl,
          width: 48,
          height: 48,
          fit: BoxFit.cover,
          cacheWidth: 96,
          errorBuilder: (_, __, ___) => const SizedBox(
            width: 48,
            height: 48,
            child: Icon(Icons.music_note),
          ),
        ),
      ),
      title: Text(track.title, maxLines: 1, overflow: TextOverflow.ellipsis),
      subtitle: Text(track.artist, maxLines: 1, overflow: TextOverflow.ellipsis),
      selected: selected,
      onTap: onTap,
      trailing: trailing,
    );
  }
}
