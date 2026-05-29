import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'settings_channel.dart';

class OpenSettingsButton extends StatelessWidget {
  const OpenSettingsButton({super.key});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () async {
        try {
          await SettingsChannel.openWifiSettings();
        } on PlatformException catch (e) {
          if (context.mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(e.message ?? 'Unknown error')),
            );
          }
        }
      },
      child: const Text('Open WiFi Settings'),
    );
  }
}
