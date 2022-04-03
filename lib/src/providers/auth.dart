import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:sat/src/models/user.dart';
import 'package:sat/src/providers/api.dart';
import 'package:sat/src/providers/case_processing.dart';
import 'package:sat/src/providers/crisis_attention.dart';
import 'package:sat/src/providers/early_warning.dart';
import 'package:sat/src/services/auth.dart';
import 'package:sat/src/services/crisis_attention.dart';
import 'package:sat/src/services/early_warnings.dart';
import 'package:sat/src/shared_preferences/shared_preferences.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../flutter_string_encryption.dart';

enum Status {
  Initialized,
  Uninitialized,
  Authenticated,
  Authenticating,
  Unauthenticated,
  Updating
}

class AuthProvider with ChangeNotifier {
  Status _status = Status.Uninitialized;
  late UserModel? _user;

  UserModel? get user => _user;
  Status get status => _status;

  final prefs = PreferenciasUsuario();

  AuthProvider() {
    checkSession();
  }

  void checkSession() async {
    _status = Status.Authenticating;
    notifyListeners();
    // if (ApiProvider().environment == Environment.DEV ||
    //     ApiProvider().environment == Environment.LOCAL) {
    //   _user = await AuthService().refreshToken();

    //   if (_user != null) {
    //     _status = Status.Authenticated;
    //   } else {
    //     _status = Status.Unauthenticated;
    //   }
    // }

    _status = Status.Unauthenticated;
    notifyListeners();
  }

  void saveLocalPasswordAndUser(String password, String email) async {
    prefs.password = password;
    prefs.email = email;
  }

  void decrypt() async {
    try {
      // final decrypted = encrypter.decrypt(encrypted, iv: iv);
      // print(decrypted);
    } on MacMismatchException {}
  }

  Future<void> getUser() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    String? json = prefs.getString('user');

    if (json != null) {
      UserModel user = UserModel.fromJson(jsonDecode(json));
      _user = user;
      _status = Status.Authenticated;
      notifyListeners();
    } else {
      _status = Status.Unauthenticated;
      notifyListeners();
    }
  }

  Future<void> getUpdateUser({required BuildContext context}) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    _status = Status.Updating;
    notifyListeners();

    UserModel? updatedUser = await AuthService().getUser(context);

    if (updatedUser != null) {
      _user = updatedUser;
      prefs.setString('user', jsonEncode(user!.toJson()));
    }

    _status = Status.Authenticated;
    notifyListeners();
  }

  Future<void> login(
      {required String email,
      required String password,
      required BuildContext context,
      required EarlyWarningProvider warnProv,
      required CrisisAttentionProvider crisisProv,
      required CaseProcessingProvider caseProv}) async {
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        EasyLoading.show(status: 'Cargando...');
        SharedPreferences prefs = await SharedPreferences.getInstance();

        _status = Status.Authenticating;
        notifyListeners();

        _user = await AuthService()
            .login(email: email, password: password, context: context);

        if (_user != null) {
          saveLocalPasswordAndUser(password, email);
          await prefs.setString('user', jsonEncode(_user!.toJson()));
          await CrisisAttentionService().syncLocalData(crisisProv, context);
          await EarlyWarningsService().syncLocalData(warnProv, context);
          _status = Status.Authenticated;
          notifyListeners();
        } else {
          _status = Status.Unauthenticated;
          notifyListeners();
        }
        EasyLoading.dismiss();
      }
    } on SocketException catch (e, stacktrace) {
      EasyLoading.dismiss();
      log('Socket Error: $e, stacktrace: $stacktrace');

      final passwordLocal = prefs.password;
      final emailLocal = prefs.email;
      final userLocal = prefs.user;
      jsonDecode(userLocal);

      List<Module> modulos = [];
      List<Role> roles = [];

      final newUser = Map<String, dynamic>.from(jsonDecode(userLocal));

      _status = Status.Authenticating;
      notifyListeners();

      if (email == emailLocal && password == passwordLocal) {
        if (userLocal != null) {
          for (var i = 0; i < newUser["modules"].length; i++) {
            modulos.add(Module(
                moduleId: newUser["modules"][i]["module_id"],
                name: newUser["modules"][i]["name"]));
          }
          for (var i = 0; i < newUser["roles"].length; i++) {
            roles.add(Role(
                roleId: newUser["roles"][i]["role_id"],
                name: newUser["roles"][i]["name"]));
          }

          _user = UserModel(
              userId: newUser["user_id"],
              name: newUser["name"],
              userName: newUser["user_name"],
              position: newUser["position"],
              email: newUser["email"],
              gender: newUser["gender"],
              modules: modulos,
              phone: newUser["phone"],
              roles: roles);

          await CrisisAttentionService().syncLocalData(crisisProv, context);
          await EarlyWarningsService().syncLocalData(warnProv, context);
          _status = Status.Authenticated;
          notifyListeners();
        } else {
          _status = Status.Unauthenticated;
          notifyListeners();
        }
      } else {
        dialog(
            'Usuario no encontrado, para acceder sin acceso a internet debes ingresar con el ultimo usuario autenticado.',
            context);
        _status = Status.Unauthenticated;
        notifyListeners();
      }
    } catch (e, stacktrace) {
      EasyLoading.dismiss();
      log('Not Dio Error: $e, stacktrace: $stacktrace');
    }
  }

  dialog(String value, BuildContext context) {
    AwesomeDialog(
            isDense: true,
            context: context,
            dialogType: DialogType.ERROR,
            padding: const EdgeInsets.all(20.0),
            animType: AnimType.BOTTOMSLIDE,
            title: "SAT PDDH",
            desc: value,
            btnOkOnPress: () {},
            btnOkColor: const Color(0xFFF2B10F))
        .show();
  }

  void logOut(BuildContext context) async {
    ApiProvider().destroyTokens();
    _status = Status.Unauthenticated;
    _user = null;
    Navigator.pushNamedAndRemoveUntil(context, '/root', (route) => false);
    notifyListeners();
  }
}
