import 'package:flutter/material.dart';
import 'package:sat/src/models/form/form_v1.dart';
import 'package:sat/src/services/early_warnings.dart';
import 'package:sat/src/services/save_locally.dart';

enum EarlyWarningStatus { NotReady, Ready, Getting, Error, Uploading }

class EarlyWarningProvider with ChangeNotifier {
  EarlyWarningStatus _status = EarlyWarningStatus.NotReady;
  List<FormModel> _forms = [];
  List<FormModel> _locallyForms = [];

  EarlyWarningStatus get status => _status;
  List<FormModel> get forms => _forms;
  List<FormModel> get locallyForms => _locallyForms;

  Future<void> init() async {
    _forms = await EarlyWarningsService().getForms();
    _locallyForms = await EarlyWarningsService().getLocallyForms();
    _status = EarlyWarningStatus.Ready;
    notifyListeners();
  }

  Future<void> get() async {
    _status = EarlyWarningStatus.Getting;
    notifyListeners();
    _forms = await EarlyWarningsService().getForms();
    _status = EarlyWarningStatus.Ready;
    notifyListeners();
  }

  Future<void> getLocally() async {
    _status = EarlyWarningStatus.Getting;
    notifyListeners();
    _locallyForms = await EarlyWarningsService().getLocallyForms();
    _status = EarlyWarningStatus.Ready;
    notifyListeners();
  }

  Future<int?> saveToLocal(
      {required String listName,
      required FormModel form,
      required BuildContext context}) async {
    _status = EarlyWarningStatus.Getting;
    notifyListeners();
    int? newId = await SaveLocallyService()
        .saveLocally(listName: listName, form: form, context: context);

    _status = EarlyWarningStatus.Ready;
    notifyListeners();
    return newId;
  }

  Future<void> deleteFromLocal(
      {required String listName, required FormModel form}) async {
    _status = EarlyWarningStatus.Getting;
    notifyListeners();
    await SaveLocallyService().deleteFromLocal(listName: listName, form: form);

    _locallyForms = await EarlyWarningsService().getLocallyForms();
    _status = EarlyWarningStatus.Ready;
    notifyListeners();
  }

  Future<void> getMore() async {
    List<FormModel>? _more =
        await EarlyWarningsService().getForms(offset: _forms.length);

    if (_more != null) {
      for (var newForm in _more) {
        bool contain = false;
        for (var form in _forms) {
          if (form.formId == newForm.formId) {
            contain = true;
          }
        }
        if (!contain) {
          _forms.add(newForm);
        }
      }
    }
    notifyListeners();
  }

  Future<void> update({required FormModel form}) async {
    _status = EarlyWarningStatus.Uploading;
    FormModel? updatedForm =
        await EarlyWarningsService().updateForm(form: form);
    if (updatedForm != null) {
      _forms.removeWhere((element) => element.formId == form.formId);
      _forms.add(updatedForm);
    }
    _status = EarlyWarningStatus.Ready;
    notifyListeners();
  }

  Future<void> analyze({required FormModel form}) async {
    _status = EarlyWarningStatus.Uploading;
    await EarlyWarningsService().analyzeForm(form: form);
    _status = EarlyWarningStatus.Ready;
    notifyListeners();
  }
}
