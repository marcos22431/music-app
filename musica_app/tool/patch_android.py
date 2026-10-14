"""Ajusta o AndroidManifest gerado pelo `flutter create` para tocar em segundo plano."""
import pathlib
import sys

path = pathlib.Path("android/app/src/main/AndroidManifest.xml")
text = path.read_text(encoding="utf-8")

if "AudioServiceActivity" in text:
    print("Manifest já ajustado.")
    sys.exit(0)

permissions = """    <uses-permission android:name="android.permission.INTERNET"/>
    <uses-permission android:name="android.permission.WAKE_LOCK"/>
    <uses-permission android:name="android.permission.FOREGROUND_SERVICE"/>
    <uses-permission android:name="android.permission.FOREGROUND_SERVICE_MEDIA_PLAYBACK"/>
"""

service = """        <service
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
"""

if '<application' not in text or '</application>' not in text:
    sys.exit("Manifest em formato inesperado.")
if 'android:name=".MainActivity"' not in text:
    sys.exit("Activity principal não encontrada.")

text = text.replace("<application", permissions + "    <application", 1)
text = text.replace(
    'android:name=".MainActivity"',
    'android:name="com.ryanheise.audioservice.AudioServiceActivity"',
    1,
)
text = text.replace("</application>", service + "    </application>", 1)

path.write_text(text, encoding="utf-8")
print("Manifest ajustado.")
