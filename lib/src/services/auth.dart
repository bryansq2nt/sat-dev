import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:sat/src/models/user.dart';
import 'package:sat/src/providers/api.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  Future<UserModel?> login(
      {required String email,
      required String password,
      required BuildContext context}) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    String? fcmToken;
    FirebaseMessaging messaging = FirebaseMessaging.instance;

    NotificationSettings settings = await messaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );

    log('User granted permission: ${settings.authorizationStatus}');
    String? token = await messaging.getToken(vapidKey: "");
    fcmToken = token;
    log("token: $token");
    prefs.setString('fcm_token', fcmToken ?? "null");

    Map<String, dynamic> authInfo = {
      "user": email,
      "password": password,
      "fcm_token": fcmToken
    };

    Response? response = await ApiProvider().makeRequest(
        type: MethodType.POST,
        endPoint: "/login",
        body: authInfo,
        okCode: 200,
        context: context);

    UserModel user = UserModel.fromJson(response?.data['user']);
    prefs.setString('token', response?.data['token']);
    return user;
  }

  Future<UserModel?> getUser(BuildContext? context) async {
    try {
      Response? response = await ApiProvider().makeRequest(
          type: MethodType.GET,
          endPoint: "/profile",
          okCode: 200,
          context: context);

      UserModel user = UserModel.fromJson(response?.data['user']);

      return user;
    } catch (e) {
      log(e.toString());
      ApiProvider().handleError(context: context);
      return throw Error();
    }
  }

  Future<UserModel?> refreshToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    FirebaseMessaging messaging = FirebaseMessaging.instance;
    NotificationSettings settings = await messaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );

    log('User granted permission: ${settings.authorizationStatus}');

    String? fcmToken = await messaging.getToken();
    fcmToken = fcmToken;
    log("fcm_token: $fcmToken");
    prefs.setString('fcm_token', fcmToken ?? "");

    String? token = prefs.getString('token');

    if (token == null) {
      return null;
    } else {
      Map<String, dynamic> tokenInfo = {"token": token, "fcm_token": fcmToken};

      Response? response = await ApiProvider().makeRequest(
          type: MethodType.POST,
          body: tokenInfo,
          endPoint: "/refreshToken",
          okCode: 200);
      if (response != null) {
        prefs.setString('token', response.data['token']);
        return await getUser(null);
      } else {
        return null;
      }
    }
  }
}
