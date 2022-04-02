

import 'dependent_answer.dart';



enum QuestionTypes {open,numeric,closed,date, boolean, image}

class QuestionModel {
  QuestionModel({
    required this.sectionId,
    required this.questionId,
    required this.questionTitle,
    this.questionType,
    required this.dependent,
    required this.dependentMultiple,
    this.dependentSectionId,
    this.dependentQuestionId,
    this.questionDependentAnswer,
    this.questionDependentQuestions = const [],
    required this.downloadedJson
  });

  final String sectionId;
  final String questionId;
  final String questionTitle;
  QuestionTypes? questionType;

  bool dependent;
  String? dependentSectionId;
  String? dependentQuestionId;
  bool dependentMultiple;

  DependentAnswerModel? questionDependentAnswer;

  List<String> questionDependentQuestions = [];

  final Map<String, dynamic>   downloadedJson;





  Map<String, dynamic> toJson() => {
    "section_id": sectionId,
    "question_id": questionId,
    "question_title": questionTitle,
    "question_type": questionType!.name,
    "dependent": dependent,
    "dependent_section_id": dependentSectionId,
    "dependent_question_id": dependentQuestionId,
    "dependent_multiple": dependentMultiple,
    "dependent_question_ids": questionDependentQuestions,
  };
}
