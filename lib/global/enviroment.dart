import 'dart:io';


class Enviroments {
  static String apiUrl = Platform.isAndroid ? 'http://127.0.0.1:3000/api' : 'http://localhost:3000/api';
  static String socketUrl = 'http://127.0.0.1:3000';
}