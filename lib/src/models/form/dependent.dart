

import 'package:sat/src/models/form/dependent_answer.dart';

class Dependent {
  Dependent(this.sectionId,this.questionId, this.isMultiple,this.currentDependentAnswer,this.currentDependentQuestions);
  String? sectionId;
  String? questionId;
  bool isMultiple = false;
  DependentAnswerModel? currentDependentAnswer;
  List<String> currentDependentQuestions = [];

  String? get sid => sectionId;
  set sid(String? value) => sectionId = value;

  String? get qid => questionId;
  set qid(String? value) => questionId = value;

  bool get multiple => isMultiple;
  set multiple(bool value) => isMultiple = value;

  set dependentAnswer(DependentAnswerModel? value) => currentDependentAnswer = value;

  DependentAnswerModel? get dependentAnswer => currentDependentAnswer;

  set dependentQuestions(List<String> value) => currentDependentQuestions = value;

  List<String> get dependentQuestions => currentDependentQuestions;

}