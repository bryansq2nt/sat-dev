import 'dart:convert';

import 'package:sat/src/models/form/questions.dart';

import 'dependent.dart';
import 'dependent_answer.dart';

SectionModel dependentSectionModelFromJson(String str) =>
    SectionModel.fromJson(json.decode(str));

class SectionModel extends Dependent {
  SectionModel({
    required String sectionId,
    this.sectionTitle = "",
    this.boldTitle = false,
    this.dependent = false,
    this.dependentQuestionId,
    this.dependentSectionId,
    this.dependentMultiple = false,
    required this.questions,
    this.sectionDependentAnswer,
    required this.sectionDependentQuestions,
  }) : super(
          sectionId,
          dependentSectionId,
          dependentMultiple,
          sectionDependentAnswer,
          sectionDependentQuestions,
        );

  String sectionTitle = "";
  bool boldTitle = false;

  bool dependent = false;
  String? dependentSectionId;
  String? dependentQuestionId;
  bool dependentMultiple = false;

  DependentAnswerModel? sectionDependentAnswer;
  List<String> sectionDependentQuestions;

  List<dynamic> questions = [];

  factory SectionModel.fromJson(Map<String, dynamic> json) {
    List<dynamic> questions = QuestionsUtilities().getQuestions(json: json);

    bool getBool(var val) {
      if (val is int) {
        if (val == 1) {
          return true;
        }
      } else if (val is bool) {
        return val;
      } else if (val is String) {
        if (val == "bool") {
          return true;
        }
      }
      return false;
    }

    return SectionModel(
      sectionId: json['section_id'].toString(),
      boldTitle: getBool(json['bold_title']),
      sectionTitle: json['section_title'] ?? "",
      dependent: getBool(json['dependent']),
      dependentQuestionId: json['dependent_question_id'],
      dependentSectionId: json['dependent_section_id'],
      sectionDependentAnswer: json['dependent_answer'] != null
          ? DependentAnswerModel.fromJson(json['dependent_answer'])
          : null,
      dependentMultiple: getBool(json['dependent_multiple']),
      sectionDependentQuestions: json['section_dependent_questions'] ?? [],
      questions: questions,
    );
  }

  Map<String, dynamic> toJson() => {
        "section_id": sectionId,
        "section_title": sectionTitle,
        "dependent_section_id": dependentSectionId,
        "dependent_question_id": dependentQuestionId,
        "dependent_answer": dependentAnswer,
        "dependent_multiple": dependentMultiple,
        "section_dependent_questions": sectionDependentQuestions,
        "questions": questions.map((e) => e.toJson())
      };
}
