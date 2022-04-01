import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

class PreferenciasUsuario {
  static final PreferenciasUsuario _instancia =
   PreferenciasUsuario._internal();

  factory PreferenciasUsuario() {
    return _instancia;
  }

  PreferenciasUsuario._internal();

  late SharedPreferences _prefs;

  initPrefs() async {
    _prefs = await SharedPreferences.getInstance();
  }
  // GET y SET del user
  set user( user ) {
    _prefs.setString('user', json.encode(user));
  }

  get user {
    return _prefs.getString('user') ?? '';
  }

  // GET y SET del password
  set password( password ) {
    _prefs.setString('password', password);
  }

  get password {
    return _prefs.getString('password') ?? '';
  }

  // GET y SET key
  set key( key ) {
    _prefs.setString('key', key);
  }

  get key {
    return _prefs.getString('key') ?? '';
  }

  // GET y SET key
  set email( key ) {
    _prefs.setString('email', key);
  }

  get email {
    return _prefs.getString('email') ?? '';
  }

  // GET y SET formAlert
  set formAlert( key ) {
    _prefs.setString('formAlert', key);
  }

  get formAlert {
    return _prefs.getString('formAlert') ?? '';
  }
}
