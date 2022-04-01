import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sat/src/models/form/form_v1.dart';
import 'package:sat/src/providers/api.dart';

class SaveLocallyService {

  Future<List<FormModel>?> getLocallyList(String listName) async {
    try {
      final file = await _localFile(listName);
      Map<String,dynamic> content = await jsonDecode(file.readAsStringSync());

      if(content.isNotEmpty){
        return List<FormModel>.from(
            content["forms"].map((e) => FormModel.fromJson(e)));
      } else {
        return [];
      }

    } catch (e) {
      log(e.toString());
      return null;
    }
  }

  Future<int?> saveLocally(
      {required String listName, required FormModel form, BuildContext? context}) async {
    try {
      EasyLoading.show(status: 'Cargando...');
      Map<String, dynamic> currentList =
          await readFromLocal(fileName: listName);

      bool exists = false;

      if (form.formId == 0) {
        form.formId = DateTime.now().millisecondsSinceEpoch;
        form.isUpdate = false;
      } else {
        form.isUpdate = true;
      }

      Map<String, dynamic> currentForm = {
        "form_id": form.formId,
        "locally": true,
        "isUpdate": form.isUpdate
      };

      if (currentList.isEmpty) {
        currentList = {"forms": []};
        currentList["forms"] = [currentForm];
      } else {
        currentList["forms"].forEach((f) {
          if (f["form_id"] == form.formId) {
            exists = true;
          }
        });

        if (!exists) {
          currentList["forms"].add(currentForm);
        }
      }


      writeToLocal(fileName: listName, content: currentList);
      writeToLocal(fileName: "form-${form.formId}", content: form.toJson());
      EasyLoading.dismiss();
      return form.formId;
    } catch (e) {
      EasyLoading.dismiss();
      log("here: $e");
      return null;
    }
  }

  Future<bool> deleteFromLocal(
      {required String listName, required FormModel form, BuildContext? context}) async {
    try {
      Map<String, dynamic> currentList =
          await readFromLocal(fileName: listName);

      if (currentList.isNotEmpty) {
        currentList["forms"].removeWhere((x) => x["form_id"] == form.formId);
      }

      writeToLocal(fileName: listName, content: currentList);

      deleteLocalFile("form-${form.formId}");

      return true;
    } catch (e) {
      log(e.toString());
      return false;
    }
  }

  Future<Map<String, dynamic>?> getFormattedJson(FormModel form) async {
    try {
      Map<String, dynamic> _form = {};

      for (int i = 0; i < form.sections.length; i++) {
        for (int j = 0; j < form.sections[i].questions.length; j++) {
          if (form.sections[i].questions[j].questionType == "image") {
            if (form.sections[i].questions[j].answer is! String) {
              form.sections[i].questions[j].answer =
                  await uploadFile(form.sections[i].questions[j].answer);
            }
          }
          if (form.sections[i].questions[j].questionType == 'date' ||
              form.sections[i].questions[j].questionType ==
                  'date_time_before' ||
              form.sections[i].questions[j].questionType == 'date_after' ||
              form.sections[i].questions[j].questionType == 'date_time') {
            form.sections[i].questions[j].answer =
                form.sections[i].questions[j].answer != null &&
                        form.sections[i].questions[j].answer != "null"
                    ? form.sections[i].questions[j].answer.toString()
                    : null;
          }
          if (form.sections[i].questions[j].questionType == "numeric") {
            if (form.sections[i].questions[j].answer != null) {
              if (form.sections[i].questions[j].answer is String) {
                form.sections[i].questions[j].answer =
                    int.tryParse(form.sections[i].questions[j].answer);
              }
            } else {
              form.sections[i].questions[j].answer = 0;
            }
          }
          Map<String, dynamic> _question = {
            form.sections[i].questions[j].questionId:
                form.sections[i].questions[j].answer
          };
          _form.addAll(_question);
        }
      }

      return _form;
    } catch (e) {
      log(e.toString());
      return null;
    }
  }

  Future<String?> uploadFile(image) async {
    if (image != null) {
      File file = image[0] as File;
      String fileName = file.path.split('/').last;
      FormData formData = FormData.fromMap({
        "file": await MultipartFile.fromFile(file.path, filename: fileName),
      });

      try {
        Response? response = await ApiProvider().makeRequest(
            type: MethodType.MULTIPART,
            endPoint: '/uploads',
            formData: formData,
            okCode: 201);
        if (response != null && response.statusCode == 201) {
          return response.data['path'];
        }
        return null;
      } catch (e) {
        log(e.toString());
        return null;
      }
    } else {
      return null;
    }
  }

  Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();
    return directory.path;
  }

  Future<File> _localFile(String fileName) async {
    File jsonFile;
    bool exists = false;

    try {
      final path = await _localPath;

      jsonFile =  File(path + "/" + fileName + ".json");
      exists = jsonFile.existsSync();

      if (exists) {
        return jsonFile;
      } else {
        File newJson =
            await File(path + "/" + fileName + ".json").create(recursive: true);

        newJson.writeAsStringSync("{}");
        return newJson;
      }
    } catch (e) {
      log(e.toString());
      return throw Error();
    }
  }

  Future<File> writeToLocal(

      {required String fileName, required Map<String, dynamic> content}) async {
    try {
      final file = await _localFile(fileName);

      return file.writeAsString(jsonEncode(content));
    } catch (e){
      log(e.toString());
      return throw Error();
    }

  }

  Future<Map<String, dynamic>> readFromLocal({required String fileName}) async {
    try {
      final file = await _localFile(fileName);


      Map<String, dynamic> content = await jsonDecode(file.readAsStringSync());

      return content;
    } catch (e) {
      log(e.toString());
      return throw Error();
    }
  }

  Future<bool> deleteLocalFile(String fileName) async {
    File jsonFile;
    bool exists = false;

    try {
      final path = await _localPath;

      jsonFile =  File(path + "/" + fileName + ".json");
      exists = jsonFile.existsSync();

      if (exists) {
        jsonFile.deleteSync();
        return true;
      } else {
        return false;
      }
    } catch (e) {
      log(e.toString());
      return false;
    }
  }
}
