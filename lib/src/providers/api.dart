import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:sat/src/models/error.dart';
import 'package:shared_preferences/shared_preferences.dart';

enum MethodType { GET, POST, PUT, DELETE, MULTIPART }

enum ApiStatus { REQUESTING, NOT_READY, READY, SERVER_ERROR }
enum Environment { LOCAL, DEV, PROD }

class ApiProvider with ChangeNotifier {
  Environment environment = Environment.LOCAL;

  String _url = "http://190.5.141.81:3000/api";
  String _bucketUrl = "http://190.5.141.81:3000";

  final Dio _dio = Dio();

  get url => _url;

  String get bucket => _bucketUrl;

  ApiProvider() {
    init();
  }

  void init() async {
    _dio.options.connectTimeout = 10000;
    _dio.options.receiveTimeout = 10000;

    if (environment == Environment.DEV) {
      _url = "http://8.6.193.79:3000/api";
      _bucketUrl = "http://8.6.193.79:3000";
    } else if (environment == Environment.LOCAL) {
      _url = "http://ba85-181-189-188-249.ngrok.io/api";
      _bucketUrl = "http://ba85-181-189-188-249.ngrok.io";
    }

    notifyListeners();
  }

  void destroyTokens() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.remove('token');
    prefs.remove('user');
    notifyListeners();
  }

  Future<Response?> makeRequest(
      { required MethodType type,
        required String endPoint,
      Map<String, dynamic>? queryParams,
      Map<String, dynamic>? body,
      FormData? formData,
      int? okCode,
        BuildContext? context,
      Function? onNetworkNonReachable}) async {
    log(_url + endPoint);
    EasyLoading.show(status: 'Cargando...');
    notifyListeners();

    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString('token');
      Response response;
      switch (type) {
        case MethodType.GET:
           response = await _dio.get(_url + endPoint,
              options: Options(
                headers: {"Authorization": token},
                contentType: "application/json",
              ), queryParameters: queryParams);
          break;
          case MethodType.POST:
           response = await _dio.post(_url + endPoint,
              data: body,
              options: Options(
                headers: {"Authorization": token},
                contentType: "application/json",
              ));
           break;
          case MethodType.PUT:
           response = await _dio.put(_url + endPoint,
              data: body,
              options: Options(
                headers: {"Authorization": token},
                contentType: "application/json",
              ));

          break;
          case MethodType.DELETE:
           response = await _dio.delete(_url + endPoint,
              options: Options(
                headers: {"Authorization": token},
                contentType: "application/json",
              ));
          break;
          case MethodType.MULTIPART:
           response = await _dio.post(_url + endPoint,
              data: formData,
              options: Options(
                  headers: {"Authorization": token},
                  contentType: "application/json"));

         break;
      }

      EasyLoading.dismiss();
      notifyListeners();
      return response;
    } on DioError catch (e) {
      EasyLoading.dismiss();
      log(e.toString());
      log("dio error" + e.type.toString());
      if (e.type == DioErrorType.connectTimeout ||
          e.type == DioErrorType.other ||
          e.type == DioErrorType.sendTimeout) {
        if (onNetworkNonReachable != null) {
          onNetworkNonReachable();
          return null;
        }
      }
      if (e.response != null) {
        log(e.response?.data.toString() ?? "");
        notifyListeners();
        handleError(json: e.response?.data , context: context);
      } else {
        notifyListeners();
        handleError(context: context);
      }

      return null;
    } catch (e,stacktrace) {
      log('Not Dio Error: $e, stacktrace: $stacktrace');
      EasyLoading.dismiss();
      return null;
    }
  }

   handleError(
      {  var json, BuildContext? context}) {
    notifyListeners();

    try {

      SnackBar snackBar;
      String? title = "Unhandled error";
      String? detail = json is String ? json : "";

      if(json != null && json is Map<String,dynamic>){
        ErrorResponseModel error =  ErrorResponseModel.fromJson(json);
        title = error.title;
        detail = error.detail;
      }

      snackBar = SnackBar(
        backgroundColor: Colors.white,
        elevation: 25.0,
        margin: const EdgeInsets.all(20),
        behavior: SnackBarBehavior.floating,
        shape:
        RoundedRectangleBorder(borderRadius: BorderRadius.circular(25.0)),
        content: ListTile(
          title: Text(title ?? ""),
          subtitle: Text(detail ?? ""),
          trailing: const Icon(
            Icons.error_outline,
            color: Colors.red,
          ),
        ),
        duration: const Duration(seconds: 3),
      );
      if(context != null){
        return ScaffoldMessenger.of(context).showSnackBar(snackBar);

      }

    } catch (e, stacktrace) {
      log('Not Dio Error: $e, stacktrace: $stacktrace');

    }
    EasyLoading.dismiss();
  }

  Color getIconColor({required int statusCode}) {
    switch (statusCode) {
      case 400:
        return Colors.red;
      case 401:
        return Colors.red;
      case 403:
        return Colors.orange;
      case 404:
        return Colors.orange;
      case 500:
        return Colors.red;
      case 502:
        return Colors.red;
      case 503:
        return Colors.blue;
      default:
        return Colors.grey;
    }
  }
}
