import 'package:flutter/material.dart';
import 'package:open_settings/open_settings.dart';

void showNetworkError(context) {
  final snackBar = SnackBar(
    content: Text('Netzwerkfehler'),
    action: SnackBarAction(
      label: 'Einstellungen',
      onPressed: () => {
        OpenSettings.openWIFISetting(),
      },
    ),
  );

  ScaffoldMessenger.of(context).showSnackBar(snackBar);
}