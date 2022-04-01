
import 'package:flutter/material.dart';
import 'package:sat/src/models/form/form_v1.dart';
import 'package:sat/src/services/case_processing.dart';
import 'package:sat/src/services/save_locally.dart';


enum CaseProcessingStatus { NotReady, Ready, Getting, Error, Uploading }

class CaseProcessingProvider with ChangeNotifier {
  CaseProcessingStatus _status = CaseProcessingStatus.NotReady;
  List<FormModel> _forms = [];
  List<FormModel> _locallyForms = [];

  CaseProcessingStatus get status => _status;
  List<FormModel> get forms => _forms;
  List<FormModel> get locallyForms => _locallyForms;



  Future<void> init() async {
    _forms = await CaseProcessingService().getForms() ?? [];
    _locallyForms = await CaseProcessingService().getLocallyForms() ?? [];
    _status = CaseProcessingStatus.Ready;
    notifyListeners();
  }

  Future<void> get() async {
    _status = CaseProcessingStatus.Getting;
    notifyListeners();
    _forms = await CaseProcessingService().getForms() ?? [];
    _status = CaseProcessingStatus.Ready;
    notifyListeners();
  }


  Future<int?> saveToLocal({required String listName,required FormModel form,required BuildContext context}) async {
    _status = CaseProcessingStatus.Getting;
    notifyListeners();
    int? newId = await SaveLocallyService().saveLocally(listName: listName,form: form,context: context);

    _status = CaseProcessingStatus.Ready;
    notifyListeners();
    return newId;
  }

  Future<void> deleteFromLocal({required String listName,required FormModel form}) async {
    _status = CaseProcessingStatus.Getting;
    notifyListeners();
    await SaveLocallyService().deleteFromLocal(listName: listName,form: form);

    await get();
    notifyListeners();
  }


}