# Musica

Player de música em Flutter com código original. Usa o catálogo livre do Jamendo.

## Rodar

1. Crie um `client_id` gratuito em https://developer.jamendo.com
2. Na pasta do projeto, gere as pastas de plataforma (uma vez):
   `flutter create --org app.musica .`
3. Aplique os ajustes de segundo plano abaixo.
4. `flutter pub get`
5. `flutter run --release --dart-define=JAMENDO_CLIENT_ID=seu_id`

## Ajustes para tocar em segundo plano

### Android — `android/app/src/main/AndroidManifest.xml`

Antes de `<application ...>`, adicione:

```xml
<uses-permission android:name="android.permission.INTERNET"/>
<uses-permission android:name="android.permission.WAKE_LOCK"/>
<uses-permission android:name="android.permission.FOREGROUND_SERVICE"/>
<uses-permission android:name="android.permission.FOREGROUND_SERVICE_MEDIA_PLAYBACK"/>
```

Na tag `<activity>`, troque `android:name=".MainActivity"` por:

```xml
android:name="com.ryanheise.audioservice.AudioServiceActivity"
```

Dentro de `<application>`, adicione:

```xml
<service
    android:name="com.ryanheise.audioservice.AudioService"
    android:foregroundServiceType="mediaPlayback"
    android:exported="true">
    <intent-filter>
        <action android:name="android.media.browse.MediaBrowserService"/>
    </intent-filter>
</service>

<receiver
    android:name="com.ryanheise.audioservice.MediaButtonReceiver"
    android:exported="true">
    <intent-filter>
        <action android:name="android.intent.action.MEDIA_BUTTON"/>
    </intent-filter>
</receiver>
```

Em `android/app/build.gradle`, use `minSdkVersion 21` (ou superior).

### iOS — `ios/Runner/Info.plist`

```xml
<key>UIBackgroundModes</key>
<array>
    <string>audio</string>
</array>
```

## Estrutura

- `lib/services/player_controller.dart`: player único, fila e notificação de mídia
- `lib/services/playlist_store.dart`: playlists salvas no aparelho
- `lib/services/jamendo_service.dart`: busca no Jamendo
- `lib/screens/`: início, playlists e detalhe da playlist
- `lib/widgets/`: mini player, item de música e seletor de playlist
