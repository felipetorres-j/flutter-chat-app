
import 'dart:convert';


import 'package:chatapp/global/enviroment.dart';
import 'package:chatapp/models/login_response.dart';
import 'package:chatapp/models/usuario.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';



import 'package:http/http.dart' as http;

class AuthService with ChangeNotifier {

  Usuario usuario;
  bool _autenticando = false;

  final _storage = new FlutterSecureStorage();

  bool get authenticando => this._autenticando;
  set autenticando( bool valor){
    this._autenticando = valor;
    notifyListeners();
  }

  //getters del token de forma estatica
  static Future<String> getToken() async{
    final _storage = new FlutterSecureStorage();
    final token = await _storage.read(key: 'token');
    return token;
  }

  static Future<String> deleteToken() async{
    final _storage = new FlutterSecureStorage();
    await _storage.delete(key: 'token');
  }

  Future<bool> login( String email, String password) async{

    this.autenticando = true;

    final data = {
      'email': email,
      'password': password
    };

    final resp = await http.post('${Enviroments.apiUrl}/login',
      body: jsonEncode(data),
      headers: {
        'Content-Type': 'application/json'
      }
    );
    print( resp.body );
    this.autenticando = false;
    if( resp.statusCode == 200 ){
      final loginResponse = loginResponseFromJson(resp.body);
      this.usuario = loginResponse.usuario;
      await this._logOut();
      await this._guardarToken(loginResponse.token);
      return true;
    }else{
      return false;
    }

  }

  Future<dynamic> register(String nombre, String email, String password)async{

     this.autenticando = true;

    final data = {
      'nombre': nombre,
      'email': email,
      'password': password
    };

    final resp = await http.post('${Enviroments.apiUrl}/login/new',
      body: jsonEncode(data),
      headers: {
        'Content-Type': 'application/json'
      }
    );
    print( resp.body );
    this.autenticando = false;
    if( resp.statusCode == 200 ){
      final loginResponse = loginResponseFromJson(resp.body);
      this.usuario = loginResponse.usuario;
      await this._logOut();
      await this._guardarToken(loginResponse.token);
      return true;
    }else{
      final respBody = jsonDecode(resp.body);
      return respBody['msg'];
    }
  }

  Future _guardarToken( String token)async{
    return await _storage.write(key: 'token', value: token);
  }

  Future _logOut()async{
    await _storage.delete(key: 'token');
  }

  Future<bool> isLoggedIn() async{
    final token = await this._storage.read(key: 'token');

    print(token);

    final resp = await http.get('${Enviroments.apiUrl}/login/renew',
      headers: {
        'Content-Type': 'application/json',
        'x-token': token
      }
    );
    print( resp.body );
    if( resp.statusCode == 200 ){
      final loginResponse = loginResponseFromJson(resp.body);
      this.usuario = loginResponse.usuario;
      await this._logOut();
      await this._guardarToken(loginResponse.token);
      return true;
    }else{
      this._logOut();
      return false;
    }
  }

}