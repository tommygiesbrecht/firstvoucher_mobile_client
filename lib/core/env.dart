import 'package:flutter_config/flutter_config.dart';

class Environment {
  static String BASE_URL = '';
  static String APP_NAME = '';
  static String AUTH_TOKEN = '';

  static Future<void> setup() async {
    await FlutterConfig.loadEnvVariables();

    BASE_URL = FlutterConfig.get('BASE_URL');
    APP_NAME = FlutterConfig.get('APP_NAME');
    AUTH_TOKEN = FlutterConfig.get('AUTH_TOKEN');
  }
}