import 'package:flutter/material.dart';
import 'package:just_audio_background/just_audio_background.dart';

import 'screens/home_screen.dart';
import 'screens/playlists_screen.dart';
import 'services/player_controller.dart';
import 'services/playlist_store.dart';
import 'widgets/mini_player.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Habilita reprodução em segundo plano e controles na tela de bloqueio.
  await JustAudioBackground.init(
    androidNotificationChannelId: 'app.musica.audio',
    androidNotificationChannelName: 'Reprodução de música',
    androidNotificationOngoing: true,
  );

  PlayerController.instance.init();
  await PlaylistStore.instance.load();

  runApp(const MusicaApp());
}

class MusicaApp extends StatelessWidget {
  const MusicaApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Musica',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        brightness: Brightness.dark,
        colorSchemeSeed: const Color(0xFF1ED760),
        scaffoldBackgroundColor: const Color(0xFF121212),
      ),
      home: const AppShell(),
    );
  }
}

class AppShell extends StatefulWidget {
  const AppShell({super.key});

  @override
  State<AppShell> createState() => _AppShellState();
}

class _AppShellState extends State<AppShell> {
  int _index = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: IndexedStack(
          index: _index,
          children: const [HomeScreen(), PlaylistsScreen()],
        ),
      ),
      bottomNavigationBar: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const MiniPlayer(),
          NavigationBar(
            selectedIndex: _index,
            onDestinationSelected: (i) => setState(() => _index = i),
            destinations: const [
              NavigationDestination(icon: Icon(Icons.home_outlined), label: 'Início'),
              NavigationDestination(icon: Icon(Icons.queue_music), label: 'Playlists'),
            ],
          ),
        ],
      ),
    );
  }
}
