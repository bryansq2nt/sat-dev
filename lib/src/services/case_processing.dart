

import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sat/src/models/form/form_v1.dart';
import 'package:sat/src/providers/api.dart';
import 'package:sat/src/providers/case_processing.dart';
import 'package:sat/src/services/save_locally.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CaseProcessingService {

  Future<List<FormModel>?> getForms() async {
    try {
      List<FormModel>? list = await SaveLocallyService().getLocallyList('case_processing');
      return list;
    } catch (e) {
      log(e.toString());
      return throw Error();
    }
  }

  // Future<Map<String, dynamic>> _getFormattedJson(FormModel form) async {
  //   try {
  //     Map<String, dynamic> _form = {};
  //
  //     for (int i = 0; i < form.sections.length; i++) {
  //       for (int j = 0; j < form.sections[i].questions.length; j++) {
  //         // if (form.sections[i].questions[j].questionType == "image") {
  //         //   if (form.sections[i].questions[j].answer is! String)
  //         //     form.sections[i].questions[j].answer =
  //         //     await uploadFile(form.sections[i].questions[j].answer);
  //         // }
  //         if (form.sections[i].questions[j].questionType == 'date' ||
  //             form.sections[i].questions[j].questionType ==
  //                 'date_time_before' ||
  //             form.sections[i].questions[j].questionType == 'date_after' ||
  //             form.sections[i].questions[j].questionType == 'date_time') {
  //           form.sections[i].questions[j].answer =
  //           form.sections[i].questions[j].answer != null &&
  //               form.sections[i].questions[j].answer != "null"
  //               ? form.sections[i].questions[j].answer.toString()
  //               : null;
  //         }
  //         if (form.sections[i].questions[j].questionType == "numeric") {
  //           if (form.sections[i].questions[j].answer != null) {
  //             if (form.sections[i].questions[j].answer is String) {
  //               form.sections[i].questions[j].answer =
  //                   int.tryParse(form.sections[i].questions[j].answer);
  //             }
  //           } else {
  //             form.sections[i].questions[j].answer = 0;
  //           }
  //         }
  //
  //         if (form.sections[i].questions[j].questionType ==
  //             "closed_searchable") {
  //           if (form.sections[i].questions[j].answer != null &&
  //               form.sections[i].questions[j].answer is String) {
  //             form.sections[i].questions[j].answer = int.tryParse(form
  //                 .sections[i].questions[j].answer
  //                 .toString()
  //                 .split("|")[0]);
  //           }
  //         }
  //         Map<String, dynamic> _question = {
  //           form.sections[i].questions[j].questionId:
  //           form.sections[i].questions[j].answer
  //         };
  //         _form.addAll(_question);
  //       }
  //     }
  //
  //     return _form;
  //   } catch (e) {
  //     print(e);
  //     return null;
  //   }
  // }

  // Future<FormModel> uploadForm(
  //     {FormModel form,
  //       BuildContext context,
  //       Function onNetworkNotReachable}) async {
  //   try {
  //     Map<String, dynamic> _form = await _getFormattedJson(form);
  //
  //     Response response = await ApiProvider().makeRequest(
  //         type: MethodType.POST,
  //         endPoint: '/case-processing',
  //         okCode: 201,
  //         context: context,
  //         body: _form,
  //         onNetworkNonReachable: onNetworkNotReachable);
  //
  //     log(response.data.toString());
  //     return form;
  //   } catch (e) {
  //     print(e);
  //     return null;
  //   }
  // }

  Future<List<FormModel>?> getLocallyForms() async {
    try {
      List<FormModel>? list =
          await SaveLocallyService().getLocallyList('case_processing');
      return list;
    } catch (e) {
      log(e.toString());
      return null;
    }
  }

  Future<List<FormModel>?> getLocallyInvolvedForms(int formId) async {
    try {
      String listName = 'case_involved_' + formId.toString();

      List<FormModel> involvedList = [];


      List<FormModel>? list =
          await SaveLocallyService().getLocallyList(listName);


      if(list != null){
        for(int i = 0; i < list.length; i++){

          Map<String,dynamic> json = await SaveLocallyService().readFromLocal(fileName: "form-${list[i].formId.toString()}");

          if(json.isNotEmpty){
            FormModel involved = FormModel.fromJson(json);
            involvedList.add(involved);
          }

        }

        return involvedList;
      }

      return involvedList;

    } catch (e) {
      log("error: $e");
      return null;
    }
  }

  // Future<FormModel> getForm({int formId}) async {
  //   try {
  //     Response response = await ApiProvider().makeRequest(
  //         type: MethodType.GET,
  //         endPoint: '/case-processing/$formId',
  //         okCode: 200);
  //
  //     FormModel formModel = FormModel.fromJson(response.data['form']);
  //     return formModel;
  //   } catch (e) {
  //     print(e);
  //     return null;
  //   }
  // }

  Future<FormModel?> getLocallyForm({required int formId}) async {
    try {
      Map<String, dynamic> json =
          await SaveLocallyService().readFromLocal(fileName: "form-$formId");

      FormModel formModel = FormModel.fromJson(json);
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
          endPoint: '/case-processing',
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


      await SaveLocallyService().writeToLocal(fileName: "caseProcessingForm", content: response?.data['form']);
      return formModel;

    } catch (e) {
      log(e.toString());
      return null;
    }
  }

  Future<FormModel?> getInvolvedFormToFill() async {
    try {

      bool currentFormUpdated = await checkInvolvedFormVersion();
      if(!currentFormUpdated){
        return await getNewInvolvedForm();
      }

      FormModel? currentForm = await getInvolvedCurrentForm();

      if(currentForm != null){
        return currentForm;
      }

      return await getNewInvolvedForm();

    } catch (e) {
      log(e.toString());
      return null;
    }
  }

  Future<FormModel?> getNewInvolvedForm() async {
    try {
      Response? response = await ApiProvider().makeRequest(
          type: MethodType.GET,
          endPoint: '/case-processing/involved/form/empty',
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


      await SaveLocallyService().writeToLocal(fileName: "involvedForm", content: response?.data['form']);
      return formModel;

    } catch (e) {
      log(e.toString());
      return null;
    }
  }

  // Future<FormModel> getInvolvedForm({int caseId, BuildContext context}) async {
  //   try {
  //     Response response = await ApiProvider().makeRequest(
  //         type: MethodType.GET,
  //         endPoint: '/case-processing/$caseId/involved/form',
  //         okCode: 200,
  //         context: context);
  //     FormModel formModel = FormModel.fromJson(response.data['form']);
  //
  //     return formModel;
  //   } catch (e) {
  //     print(e);
  //     return null;
  //   }
  // }
  //
  // Future<List<ProvidedListItem>> getInvolvedList({int caseId, BuildContext context}) async {
  //   try {
  //     List<ProvidedListItem> items = List<ProvidedListItem>.empty(growable: true);
  //     List<dynamic> data;
  //     Response response = await ApiProvider().makeRequest(
  //         type: MethodType.GET,
  //         endPoint: '/case-processing/$caseId/involved/list',
  //         okCode: 200,
  //         context: context);
  //     if(response.statusCode == 200){
  //       data = response.data["involved"];
  //       for (var item in data) {
  //         items.add(ProvidedListItem.fromJson(item));
  //       }
  //     }
  //
  //     return items;
  //   } catch (e) {
  //     print(e);
  //     return null;
  //   }
  // }


  Future<FormModel?> sendToSigi({required FormModel form ,required BuildContext context}) async {
    try {
      Map<String, dynamic>? _form = await getFormattedJson(form);
      Response? response = await ApiProvider().makeRequest(
          type: MethodType.POST,
          endPoint: '/case-processing',
          okCode: 201,
          context: context,
          body: _form);

      if (response?.statusCode == 201) {
        int tempCaseId = int.parse(response?.data["case_id"]);
        List<FormModel> involved = await getLocallyInvolvedForms(form.formId) ?? [];

        for(int i =0; i < involved.length; i ++){
          await createInvolved(caseId: tempCaseId, form: involved[i]);
          await SaveLocallyService().deleteFromLocal(listName: "case_involved_${form.formId}",form: involved[i]);
        }


        Response? sigiReponse = await ApiProvider().makeRequest(
            type: MethodType.POST,
            endPoint: '/case-processing/$tempCaseId/send-to-sigi',
            okCode: 200);

        if(sigiReponse != null){
          final provider = Provider.of<CaseProcessingProvider>(context,listen: false);
          await provider.deleteFromLocal(listName: "case_processing", form: form);
          await provider.get();
          return form;
        } else {
          return null;
        }

      }
      return null;
    } catch (e) {

      log(e.toString());
      return null;
    }
  }

  // Future<String> uploadFile(image) async {
  //   if (image != null) {
  //     File file = image[0] as File;
  //     String fileName = file.path.split('/').last;
  //     FormData formData = FormData.fromMap({
  //       "file": await MultipartFile.fromFile(file.path, filename: fileName),
  //     });
  //
  //     try {
  //       Response response = await ApiProvider().makeRequest(
  //           type: MethodType.MULTIPART,
  //           endPoint: '/uploads',
  //           formData: formData,
  //           okCode: 201);
  //       if (response != null && response.statusCode == 201) {
  //         return response.data['path'];
  //       }
  //       return null;
  //     } catch (e) {
  //       print(e);
  //       return null;
  //     }
  //   } else {
  //     return null;
  //   }
  // }

  Future<Map<String, dynamic>?> getFormattedJson(FormModel form) async {
    try {
      Map<String, dynamic> _form = {};

      for (int i = 0; i < form.sections.length; i++) {
        for (int j = 0; j < form.sections[i].questions.length; j++) {
          // if (form.sections[i].questions[j].questionType == "image") {
          //   if (form.sections[i].questions[j].answer is! String)
          //     form.sections[i].questions[j].answer =
          //         await uploadFile(form.sections[i].questions[j].answer);
          // }
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

  Future<FormModel?> createInvolved({required int caseId,required FormModel form}) async {
    try {
      Map<String, dynamic>? _form = await getFormattedJson(form);

      Response? response = await ApiProvider().makeRequest(
          type: MethodType.POST,
          endPoint: '/case-processing/$caseId/involved/form',
          okCode: 201,
          body: _form);

      if (response == null) {
        return null;
      }
      if (response.statusCode == 201) {
        return form;
      }
      return null;
    } catch (e) {
      log("$e");
      return null;
    }
  }

  // syncLocallyInvolved(FormModel currentForm, CaseProcessingProvider provider, int previous, int current) async{
  //   List<FormModel> tempInvolved =
  //       await getLocallyInvolvedForms(previous);
  //   if (tempInvolved != null) {
  //     log("previous "+previous.toString());
  //     log("current "+current.toString());
  //     for (FormModel data in tempInvolved) {
  //       log("involved " + data.formId.toString());
  //       FormModel thisForm = await getLocallyForm(formId: data.formId);
  //       Map<String, dynamic> _form = await getFormattedJson(thisForm);
  //       log("form to involved " + _form.toString());
  //       FormModel f = await createInvolved(
  //           caseId: current, form: thisForm);
  //       if (f == null) {
  //         print("Not uploaded");
  //       } else {
  //         await provider.deleteFromLocal(
  //             listName: 'case_involved_' + previous.toString(),
  //             form: thisForm);
  //       }
  //     }
  //   }
  // }

  Future<FormModel?> getCurrentForm() async {
    try {
      Map<String, dynamic> json =
      await SaveLocallyService().readFromLocal(fileName: "caseProcessingForm");
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

  Future<bool> checkFormVersion() async {

    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      double currentVersion = prefs.getDouble("caseProcessingFormVersion") ?? 0.0;
      Response? response = await ApiProvider().makeRequest(
          type: MethodType.GET, endPoint: '/forms/caseProcessing/version', okCode: 200);


      if(response == null){
        return true;
      }

      double serverVersion = double.parse(response.data['version'].toString());

      if( serverVersion == currentVersion){
        return true;
      }

      prefs.setDouble("caseProcessingFormVersion", serverVersion);
      return false;

    } catch (e){
      log(e.toString());
      return false;
    }
  }

  Future<FormModel?> getInvolvedCurrentForm() async {
    try {
      Map<String, dynamic> json =
      await SaveLocallyService().readFromLocal(fileName: "involvedForm");
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

  Future<bool> checkInvolvedFormVersion() async {

    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      double currentVersion = prefs.getDouble("involvedFormVersion") ?? 0.0;
      Response? response = await ApiProvider().makeRequest(
          type: MethodType.GET, endPoint: '/forms/involved/version', okCode: 200);


      if(response == null){
        return true;
      }

      double serverVersion = double.parse(response.data['version'].toString());

      if( serverVersion == currentVersion){
        return true;
      }

      prefs.setDouble("involvedFormVersion", serverVersion);
      return false;

    } catch (e){
      log(e.toString());
      return false;
    }
  }

}
