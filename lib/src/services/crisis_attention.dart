import 'dart:developer';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:sat/src/models/form/form_v1.dart';
import 'package:sat/src/providers/api.dart';
import 'package:sat/src/services/save_locally.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../providers/crisis_attention.dart';

class CrisisAttentionService {

  Future<List<FormModel>?> getForms({int offset = 0}) async {
    try {
      Response? response = await ApiProvider().makeRequest(
          type: MethodType.GET,
          endPoint: '/crisis',
          queryParams: {"offset": offset},
          okCode: 200);

      return List<FormModel>.from(
          response?.data['crisisAlerts'].map((e) => FormModel.fromJson(e)));
    } catch (e) {
      log(e.toString());
      return null;
    }
  }

  Future<List<FormModel>?> getLocallyForms() async {
    try {
      List<FormModel>? list =
          await SaveLocallyService().getLocallyList('crisis_attention');
      return list;
    } catch (e) {
      log(e.toString());
      return null;
    }
  }

  Future<FormModel?> getForm({required int formId}) async {
    try {

      Response? response = await ApiProvider().makeRequest(
          type: MethodType.GET, endPoint: '/crisis/$formId', okCode: 200);

      FormModel formModel = FormModel.fromJson(response?.data['form']);
      int sections = 0;
      sections = formModel.sections.length;

      for(int i = 0; i < sections; i++){
        int questions = 0;
        questions = formModel.sections[i].questions.length;
        

        for(int j = 0; j < questions; j++){
          formModel.sections[i].questions[j]!.answers = formModel.sections[i].questions[j]!.answers;
        }
      }
      return formModel;
    } catch (e) {
      log(e.toString());
      return null;
    }
  }

  Future<FormModel?> getLocallyForm({required int formId}) async {
    try {
      Map<String, dynamic> json =
          await SaveLocallyService().readFromLocal(fileName: "form-$formId");

      FormModel formModel = FormModel.fromJson(json);

      int sections = 0;
      sections = formModel.sections.length;

      for(int i = 0; i < sections; i++){
        int questions = 0;
        questions = formModel.sections[i].questions.length;
        

        for(int j = 0; j < questions; j++){
          formModel.sections[i].questions[j]!.answers = formModel.sections[i].questions[j]!.answers;
        }
      }

      return formModel;
    } catch (e) {
      log(e.toString());
      return null;
    }
  }

  Future<FormModel?> getFormToFill() async {
    try {

      bool currentFormUpdated = await checkFormVersion();
      if(!currentFormUpdated){
        return await getNewForm();
      }

      FormModel? currentForm = await getCurrentForm();

      if(currentForm != null){
        return currentForm;
      }

      return await getNewForm();

    } catch (e) {
      log(e.toString());
      return null;
    }
  }

  Future<FormModel?> getNewForm() async {
    try {



      Response? response = await ApiProvider().makeRequest(
          type: MethodType.GET,
          endPoint: '/crisis/form/empty',
          okCode: 200);
      FormModel formModel = FormModel.fromJson(response?.data['form']);

      int sections = 0;
      sections = formModel.sections.length;

      for(int i = 0; i < sections; i++){
        int questions = 0;
        questions = formModel.sections[i].questions.length;
        

        for(int j = 0; j < questions; j++){
          formModel.sections[i].questions[j]!.answers = formModel.sections[i].questions[j]!.answers;
        }
      }

      await SaveLocallyService().writeToLocal(fileName: "crisisAttentionForm", content: response?.data['form']);
      return formModel;

    } catch (e) {
      log(e.toString());
      return null;
    }
  }

  Future<FormModel?> getFormToAnalyze({required int formId, BuildContext? context}) async {
    try {

      Response? response = await ApiProvider().makeRequest(
          type: MethodType.GET,
          endPoint: '/crisis/form/analyze/$formId',
          okCode: 200,
          context: context);

      FormModel formModel = FormModel.fromJson(response?.data['form']);
      int sections = 0;
      sections = formModel.sections.length;

      for(int i = 0; i < sections; i++){
        int questions = 0;
        questions = formModel.sections[i].questions.length;
        

        for(int j = 0; j < questions; j++){
          formModel.sections[i].questions[j]!.answers = formModel.sections[i].questions[j]!.answers;
        }
      }
      return formModel;
    } catch (e) {
      log(e.toString());
      return null;
    }
  }

  Future<FormModel?> uploadForm(
      { required FormModel form,
      BuildContext? context,
      Function? onNetworkNotReachable}) async {
    try {
      Map<String, dynamic>? _form = await _getFormattedJson(form);

      Response? response = await ApiProvider().makeRequest(
          type: MethodType.POST,
          endPoint: '/crisis',
          okCode: 201,
          context: context,
          body: _form,
          onNetworkNonReachable: onNetworkNotReachable);
      if (response is int) {
        form.timeOutError = true;
        return form;
      }
      if ((response as Response).statusCode == 201) {
        return form;
      }
      return null;
    } catch (e) {
      log(e.toString());
      return null;
    }
  }

  syncLocalData(CrisisAttentionProvider provider, BuildContext context) async {
    await provider.getLocally();
    List<FormModel> localForms = provider.locallyForms;
    log(localForms.length.toString());
    if (localForms.isNotEmpty) {
      bool success = true;
      for (FormModel currentForm in localForms) {
        FormModel? form = await getLocallyForm(formId: currentForm.formId);
        FormModel? temp;
        if (currentForm.isUpdate && form != null) {
          temp = await updateForm(form: form, context: context);
        } else {
          if(form != null){
            temp = await uploadForm(form: form, context: context);
          }
        }

        if (temp == null) {
          success = false;
        } else {
          await provider.deleteFromLocal(listName: "crisis_attention", form: currentForm);
        }
      }
      if (success) {
        return "Registros sincronizados con exito";
      } else {
        return "Uno o mas elementos no se pudieron sincronizar";
      }
    } else {
      return "No hay elementos que sincronizar";
    }
  }

  Future<FormModel?> updateForm(
      {required FormModel form,
      BuildContext? context,
      Function? onNetworkNotReachable}) async {
    try {
      Map<String, dynamic> _form = {};

      for (int i = 0; i < form.sections.length; i++) {
        for (int j = 0; j < form.sections[i].questions.length; j++) {
          if (form.sections[i].questions[j].questionType == "image") {
            if (form.sections[i].questions[j].answer != null) {
              if (form.sections[i].questions[j].answer is! String) {
                if (form.sections[i].questions[j].answer[0] is File) {
                  form.sections[i].questions[j].answer =
                      await uploadFile(form.sections[i].questions[j].answer);
                } else {
                  String image = form.sections[i].questions[j].answer[0]
                      .split('uploads')[1];
                  image = image.replaceAll('/', r'\');
                  image = r'\uploads' + image;
                  form.sections[i].questions[j].answer = image;
                }
              } else {
                String image =
                    form.sections[i].questions[j].answer.split('uploads')[1];
                image = image.replaceAll('/', r'\');
                image = r'\uploads' + image;
                form.sections[i].questions[j].answer = image;
              }
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

          if (form.sections[i].questions[j].questionType ==
              "closed_searchable") {
            if (form.sections[i].questions[j].answer != null &&
                form.sections[i].questions[j].answer is String) {
              form.sections[i].questions[j].answer = int.tryParse(form
                  .sections[i].questions[j].answer
                  .toString()
                  .split("|")[0]);
            }
          }

          Map<String, dynamic> _question = {
            form.sections[i].questions[j].questionId:
                form.sections[i].questions[j].answer
          };
          _form.addAll(_question);
        }
      }
      Response? response = await ApiProvider().makeRequest(
          type: MethodType.PUT,
          endPoint: '/crisis/${form.formId}',
          okCode: 200,
          context: context,
          body: _form,
          onNetworkNonReachable: onNetworkNotReachable);
      if (response is int) {
        form.timeOutError = true;
        return form;
      }
      if ((response as Response).statusCode == 200) {
        return form;
      }
      return null;
    } catch (e) {
      log(e.toString());
      return null;
    }
  }

  Future<bool> analyzeForm({required FormModel form, BuildContext? context}) async {
    try {
      Map<String, dynamic> _form = {};

      for (int i = 0; i < form.sections.length; i++) {
        for (int j = 0; j < form.sections[i].questions.length; j++) {
          Map<String, dynamic> _question = {
            form.sections[i].questions[j].questionId:
                form.sections[i].questions[j].answer
          };
          _form.addAll(_question);
        }
      }
      Response? response = await ApiProvider().makeRequest(
          type: MethodType.PUT,
          endPoint: '/crisis/form/analyze/${form.formId}',
          okCode: 200,
          context: context,
          body: _form);

      if (response?.statusCode == 200) {
        return true;
      }
      return false;
    } catch (e) {
      log(e.toString());
      return false;
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

  Future<List<FormModel>?> searchForms({String? delegate}) async {
    try {
      Response? response = await ApiProvider().makeRequest(
        type: MethodType.GET,
        endPoint: "/crisis/search",
        queryParams: {"delegate": delegate},
        okCode: 200,
      );
      List<FormModel> _forms = List<FormModel>.from(
          response?.data['crisisAlerts'].map((x) => FormModel.fromJson(x)));
      return _forms;
    } catch (e) {
      log(e.toString());
      return null;
    }
  }

  Future<Map<String, dynamic>?> _getFormattedJson(FormModel form) async {
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
              form.sections[i].questions[j].questionType == 'date_time' || form.sections[i].questions[j].questionType == 'date_before') {
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

          if (form.sections[i].questions[j].questionType ==
              "closed_searchable") {
            if (form.sections[i].questions[j].answer != null &&
                form.sections[i].questions[j].answer is String) {
              form.sections[i].questions[j].answer = int.tryParse(form
                  .sections[i].questions[j].answer
                  .toString()
                  .split("|")[0]);
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

  Future<List<FormModel>?> getRelatedForms({required int formId}) async {
    try {
      Response? response = await ApiProvider().makeRequest(
          type: MethodType.GET,
          endPoint: '/crisis/$formId/related',
          okCode: 200);
      return List<FormModel>.from(
          response?.data['related_cases'].map((e) => FormModel.fromJson(e)));
    } catch (e) {
      log(e.toString());
      return null;
    }
  }

  Future<bool> removeRelatedForm({required int fatherId,required int childId}) async {
    try {
      Response? response = await ApiProvider().makeRequest(
          type: MethodType.DELETE,
          endPoint: '/crisis/related/$fatherId/$childId',
          okCode: 200);

      if (response != null && response.statusCode == 200) {
        return true;
      } else {
        return false;
      }
    } catch (e) {
      log(e.toString());
      return false;
    }
  }

  Future<bool> addToRelatedForms({required int fatherId, required int childId}) async {
    try {
      Response? response = await ApiProvider().makeRequest(
          type: MethodType.PUT,
          endPoint: '/crisis/related/$fatherId/$childId',
          okCode: 200);

      if (response != null && response.statusCode == 200) {
        return true;
      } else {
        return false;
      }
    } catch (e) {
      log(e.toString());
      return false;
    }
  }

  Future<List<FormModel>?> searchRelatedForm(
      {required int fatherId,required String delegate}) async {
    try {
      Response? response = await ApiProvider().makeRequest(
        type: MethodType.GET,
        endPoint: "/crisis/$fatherId/related/search",
        queryParams: {"delegate": delegate},
        okCode: 200,
      );
      List<FormModel> _forms = List<FormModel>.from(
          response?.data['crisisAlerts'].map((x) => FormModel.fromJson(x)));
      return _forms;
    } catch (e) {
      log(e.toString());
      return null;
    }
  }

  Future<bool> sendToAnalyze({required int formId, BuildContext? context}) async {
    try {
      Response? response = await ApiProvider().makeRequest(
          type: MethodType.PUT,
          endPoint: '/crisis/$formId/sendToAnalyze',
          okCode: 200,
          context: context);

      if (response?.statusCode == 200) {
        return true;
      }
      return false;
    } catch (e) {
      log(e.toString());
      return false;
    }
  }

  Future<bool> sendToSigi({required int formId, BuildContext? context}) async {
    try {
      Response? response = await ApiProvider().makeRequest(
          type: MethodType.PUT,
          endPoint: '/crisis/$formId/send-to-sigi',
          okCode: 200,
          context: context);

      if (response?.statusCode == 200) {
        log(response?.data.toString() ?? "");
        return true;
      }
      return false;
    } catch (e) {
      log(e.toString());
      return false;
    }
  }


  Future<FormModel?> getCurrentForm() async {
    try {
      Map<String, dynamic> json =
      await SaveLocallyService().readFromLocal(fileName: "crisisAttentionForm");
      FormModel formModel = FormModel.fromJson(json);
      for(int i = 0; i < formModel.sections.length; i++){
        for(int j = 0; j < formModel.sections[i].questions.length; j++){
          formModel.sections[i].questions[j].answers = formModel.sections[i].questions[j].answers;
        }
      }

      return formModel;
    } catch (e) {
      log(e.toString());
      return null;
    }
  }

  Future<bool> checkFormVersion() async {

    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      double currentVersion = prefs.getDouble("crisisAttentionFormVersion") ?? 0.0;
      Response? response = await ApiProvider().makeRequest(
          type: MethodType.GET, endPoint: '/forms/crisis/version', okCode: 200);

      if(response == null){
        return true;
      }

      double serverVersion = double.parse(response.data['version'].toString());

      if( serverVersion == currentVersion){
        return true;
      }

      prefs.setDouble("crisisAttentionFormVersion", serverVersion);
      return false;

    } catch (e){
      log(e.toString());
      return false;
    }
  }

}
