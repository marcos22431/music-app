import 'dart:async';

import 'package:flutter/material.dart';

import '../models/track.dart';
import '../services/jamendo_service.dart';
import '../services/player_controller.dart';
import '../widgets/add_to_playlist_sheet.dart';
import '../widgets/track_tile.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with AutomaticKeepAliveClientMixin {
  final _service = JamendoService();
  final _controller = TextEditingController();
  Timer? _debounce;

  List<Track> _tracks = const [];
  bool _loading = true;
  String? _error;

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load([String query = '']) async {
    setState(() {
      _loading = true;
      _error = null;
    });
    try {
      final result = await _service.fetch(query: query);
      if (!mounted) return;
      setState(() {
        _tracks = result;
        _loading = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _error = e.toString();
        _loading = false;
      });
    }
  }

  void _onChanged(String text) {
    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 500), () => _load(text.trim()));
  }

  @override
  void dispose() {
    _debounce?.cancel();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
          child: SearchBar(
            controller: _controller,
            hintText: 'Buscar músicas ou artistas',
            leading: const Icon(Icons.search),
            onChanged: _onChanged,
          ),
        ),
        Expanded(child: _body()),
      ],
    );
  }

  Widget _body() {
    if (_loading) return const Center(child: CircularProgressIndicator());
    if (_error != null) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Text(_error!, textAlign: TextAlign.center),
        ),
      );
    }
    if (_tracks.isEmpty) return const Center(child: Text('Nada encontrado'));

    final player = PlayerController.instance;
    return ValueListenableBuilder<Track?>(
      valueListenable: player.current,
      builder: (context, current, _) => ListView.builder(
        itemCount: _tracks.length,
        itemExtent: 72,
        itemBuilder: (context, i) {
          final t = _tracks[i];
          return TrackTile(
            track: t,
            selected: current?.id == t.id,
            onTap: () => player.playQueue(_tracks, i),
            trailing: IconButton(
              icon: const Icon(Icons.playlist_add),
              tooltip: 'Adicionar à playlist',
              onPressed: () => showAddToPlaylistSheet(context, t),
            ),
          );
        },
      ),
    );
  }
}
