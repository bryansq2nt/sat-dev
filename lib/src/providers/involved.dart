


import 'package:flutter/material.dart';
import 'package:sat/src/models/involved.dart';

class InvolvedProvider with ChangeNotifier {

  late int _caseId;
  int get caseId => _caseId;

  final List<Involved> _involved = [];
  List<Involved> get involved => _involved;

  InvolvedProvider({required int caseId}){
    _caseId = caseId;
    notifyListeners();
  }


  addInvolved({required Involved involved}){
    _involved.add(involved);
    notifyListeners();
  }




}