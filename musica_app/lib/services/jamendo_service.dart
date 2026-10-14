import 'dart:convert';

import 'package:http/http.dart' as http;

import '../models/track.dart';

/// Busca músicas livres na API pública do Jamendo.
/// Crie um client_id gratuito em https://developer.jamendo.com
/// e rode com: flutter run --dart-define=JAMENDO_CLIENT_ID=seu_id
class JamendoService {
  static const String _clientId =
      String.fromEnvironment('JAMENDO_CLIENT_ID', defaultValue: '');
  static const String _base = 'https://api.jamendo.com/v3.0/tracks/';

  Future<List<Track>> fetch({String query = '', int limit = 30}) async {
    if (_clientId.isEmpty) {
      throw StateError(
          'Defina JAMENDO_CLIENT_ID com --dart-define para carregar músicas.');
    }

    final uri = Uri.parse(_base).replace(queryParameters: {
      'client_id': _clientId,
      'format': 'json',
      'limit': '$limit',
      'audioformat': 'mp32',
      'imagesize': '300',
      if (query.isEmpty) 'order': 'popularity_week' else 'search': query,
    });

    final response = await http.get(uri).timeout(const Duration(seconds: 15));
    if (response.statusCode != 200) {
      throw http.ClientException('Erro ${response.statusCode} ao buscar músicas');
    }

    final body = jsonDecode(response.body) as Map<String, dynamic>;
    final results = (body['results'] as List).cast<Map<String, dynamic>>();
    return results
        .map(Track.fromJamendo)
        .where((t) => t.audioUrl.isNotEmpty)
        .toList(growable: false);
  }
}
