class Track {
  final String id;
  final String title;
  final String artist;
  final String audioUrl;
  final String coverUrl;
  final int durationSeconds;

  const Track({
    required this.id,
    required this.title,
    required this.artist,
    required this.audioUrl,
    required this.coverUrl,
    required this.durationSeconds,
  });

  factory Track.fromJamendo(Map<String, dynamic> json) {
    return Track(
      id: json['id'].toString(),
      title: json['name'] as String? ?? 'Sem título',
      artist: json['artist_name'] as String? ?? 'Artista desconhecido',
      audioUrl: json['audio'] as String? ?? '',
      coverUrl: json['image'] as String? ?? '',
      durationSeconds: (json['duration'] as num?)?.toInt() ?? 0,
    );
  }

  factory Track.fromJson(Map<String, dynamic> json) => Track(
        id: json['id'] as String,
        title: json['title'] as String,
        artist: json['artist'] as String,
        audioUrl: json['audioUrl'] as String,
        coverUrl: json['coverUrl'] as String,
        durationSeconds: json['durationSeconds'] as int,
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'artist': artist,
        'audioUrl': audioUrl,
        'coverUrl': coverUrl,
        'durationSeconds': durationSeconds,
      };
}
