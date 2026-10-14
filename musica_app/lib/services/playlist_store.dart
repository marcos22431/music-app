import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/track.dart';

/// Playlists do usuário, salvas localmente no aparelho.
class PlaylistStore extends ChangeNotifier {
  PlaylistStore._();
  static final PlaylistStore instance = PlaylistStore._();

  static const _key = 'playlists_v1';
  final Map<String, List<Track>> _data = {};

  List<String> get names => _data.keys.toList(growable: false);
  List<Track> tracksOf(String name) => List.unmodifiable(_data[name] ?? const []);

  Future<void> load() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_key);
    if (raw == null) return;
    final decoded = jsonDecode(raw) as Map<String, dynamic>;
    _data
      ..clear()
      ..addAll(decoded.map((name, list) => MapEntry(
            name,
            (list as List)
                .map((e) => Track.fromJson(e as Map<String, dynamic>))
                .toList(),
          )));
    notifyListeners();
  }

  Future<void> _save() async {
    final prefs = await SharedPreferences.getInstance();
    final encoded = _data.map(
      (name, tracks) => MapEntry(name, tracks.map((t) => t.toJson()).toList()),
    );
    await prefs.setString(_key, jsonEncode(encoded));
    notifyListeners();
  }

  Future<void> create(String name) async {
    final clean = name.trim();
    if (clean.isEmpty || _data.containsKey(clean)) return;
    _data[clean] = [];
    await _save();
  }

  Future<void> delete(String name) async {
    _data.remove(name);
    await _save();
  }

  Future<void> add(String name, Track track) async {
    final list = _data[name];
    if (list == null || list.any((t) => t.id == track.id)) return;
    list.add(track);
    await _save();
  }

  Future<void> removeTrack(String name, Track track) async {
    _data[name]?.removeWhere((t) => t.id == track.id);
    await _save();
  }
}
