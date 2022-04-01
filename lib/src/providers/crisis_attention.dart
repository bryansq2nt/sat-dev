import 'package:flutter/material.dart';
import 'package:sat/src/models/form/form_v1.dart';
import 'package:sat/src/services/crisis_attention.dart';
import 'package:sat/src/services/save_locally.dart';


enum CrisisAttentionStatus { NotReady, Ready, Getting, Error, Uploading }
class CrisisAttentionProvider with ChangeNotifier {
  CrisisAttentionStatus _status = CrisisAttentionStatus.NotReady;
  List<FormModel> _forms = [];
  List<FormModel> _locallyForms = [];

  CrisisAttentionStatus get status => _status;
  List<FormModel> get forms => _forms;
  List<FormModel> get locallyForms => _locallyForms;




  Future<void> init() async {
    _forms = await CrisisAttentionService().getForms() ?? [];
    _locallyForms = await CrisisAttentionService().getLocallyForms() ?? [];
    _status = CrisisAttentionStatus.Ready;
    notifyListeners();
  }

  Future<void> get() async {
    _status = CrisisAttentionStatus.Getting;
    notifyListeners();
    _forms = await CrisisAttentionService().getForms() ?? [];
    _status = CrisisAttentionStatus.Ready;
    notifyListeners();
  }

  Future<void> getLocally() async {
    _status = CrisisAttentionStatus.Getting;
    notifyListeners();
    _locallyForms = await CrisisAttentionService().getLocallyForms() ?? [];
    _status = CrisisAttentionStatus.Ready;
    notifyListeners();
  }

  Future<int?> saveToLocal({required String listName,required FormModel form,required BuildContext context}) async {
    _status = CrisisAttentionStatus.Getting;
    notifyListeners();
    int? newId = await SaveLocallyService().saveLocally(listName: listName,form: form,context: context);

    _status = CrisisAttentionStatus.Ready;
    notifyListeners();
    return newId;
  }

  Future<void> deleteFromLocal({required String listName, required FormModel form}) async {
    _status = CrisisAttentionStatus.Getting;
    notifyListeners();
    await SaveLocallyService().deleteFromLocal(listName: listName,form: form);

    _locallyForms = await CrisisAttentionService().getLocallyForms() ?? [];
    _status = CrisisAttentionStatus.Ready;
    notifyListeners();
  }

  Future<void> getMore() async {
    List<FormModel>? _more = await CrisisAttentionService().getForms(offset: _forms.length);
    if(_more != null){
      for (var element in _more) {
        _forms.add(element);
      }
    }
    notifyListeners();
  }


  Future<void> update({required FormModel form}) async {
    _status = CrisisAttentionStatus.Uploading;
    FormModel? updatedForm = await CrisisAttentionService().updateForm(form: form);
    if(updatedForm != null){
      _forms.removeWhere((element) => element.formId == form.formId);
      _forms.add(updatedForm);
    }
    _status = CrisisAttentionStatus.Ready;
    notifyListeners();
  }

  Future<void> analyze({required FormModel form}) async {
    _status = CrisisAttentionStatus.Uploading;
     await CrisisAttentionService().analyzeForm(form: form);
    _status = CrisisAttentionStatus.Ready;
    notifyListeners();
  }
}