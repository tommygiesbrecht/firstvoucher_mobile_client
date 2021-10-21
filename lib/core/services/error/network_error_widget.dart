import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:open_settings/open_settings.dart';

class NetworkErrorWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text('Gutscheine konnten nicht geladen werden.'),
        ),
        ElevatedButton.icon(
          onPressed: () => {
            OpenSettings.openWIFISetting(),
          },
          icon: Icon(Icons.wifi),
          label: Text('Netwerkeinstellungen öffnen'),
        ),
      ],
    );
  }
}
