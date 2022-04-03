import 'dart:developer';

import 'package:sat/src/models/form/dependent_answer.dart';
import 'package:sat/src/models/form/properties/boolean_question_properties.dart';
import 'package:sat/src/models/form/properties/date_question_properties.dart';
import 'package:sat/src/models/form/properties/default_question_properties.dart';
import 'package:sat/src/models/form/properties/drop_down_properties.dart';
import 'package:sat/src/models/form/properties/numeric_question_properties.dart';
import 'package:sat/src/models/form/question_model.dart';
import 'package:sat/src/models/form/questions/boolean.dart';
import 'package:sat/src/models/form/questions/date.dart';
import 'package:sat/src/models/form/questions/dropdown.dart';
import 'package:sat/src/models/form/questions/image.dart';
import 'package:sat/src/models/form/questions/numeric.dart';
import 'package:sat/src/models/form/questions/text.dart';

import 'package:intl/intl.dart' show DateFormat;

class QuestionsUtilities {
  QuestionTypes getType(var type) {
    switch (type) {
      case "numeric":
        return QuestionTypes.numeric;
      case "closed":
        return QuestionTypes.closed;
      case "date":
        return QuestionTypes.date;
      case "boolean":
        return QuestionTypes.boolean;
      case "switch":
        return QuestionTypes.boolean;
      case "image":
        return QuestionTypes.image;
      default:
        return QuestionTypes.open;
    }
  }

  bool getSwitchValue(var value) {
    if (value != null) {
      if (value is String) {
        if (value == "true") {
          return true;
        }
      } else if (value is bool) {
        return value;
      }
    }

    return false;
  }

  List<dynamic> getQuestions(json) {
    List<dynamic> questions = [];
    for (var e in json['questions']) {
      QuestionModel defaultQuestion = QuestionModel(
          sectionId: e['section_id'] ?? "",
          questionId: e['question_id'],
          questionTitle: e['question'],
          dependent: e['dependent'] ?? false,
          dependentSectionId: e['dependent_section_id'],
          dependentQuestionId: e['dependent_question_id'],
          questionDependentAnswer: e['dependent_answer'] != null
              ? DependentAnswerModel.fromJson(e['dependent_answer'])
              : null,
          dependentMultiple: e['dependent_multiple'] ?? false,
          questionDependentQuestions: e['dependent_questions'] ?? [],
          downloadedJson: e);

      defaultQuestion.questionType = QuestionTypes.open;
      DefaultQuestionProperties defaultProperties = DefaultQuestionProperties(
          hint: e['hint'] ?? "",
          limit: e['limit'],
          maxLines: e["max_lines"] ?? 1,
          mask: e['mask'] ?? "",
          answer: e['answer']);
      TextQuestion dfq = TextQuestion(
          question: defaultQuestion, defaultProperties: defaultProperties);
      switch (e['question_type']) {
        case 'numeric':
          defaultQuestion.questionType = QuestionTypes.numeric;
          NumericQuestion newQuestion = NumericQuestion(
              question: defaultQuestion,
              defaultProperties: defaultProperties,
              numericProperties:
                  NumericQuestionProperties(min: e['min'] ?? 0, max: e['max']));
          questions.add(newQuestion);
          break;
        case 'date':
          defaultQuestion.questionType = QuestionTypes.date;
          DateQuestion newQuestion = DateQuestion(
              question: defaultQuestion,
              defaultProperties: defaultProperties,
              dateProperties: DateQuestionProperties(
                type: e['type'] != null
                    ? DateType.values
                        .firstWhere((element) => element.name == e['type'])
                    : DateType.datetime,
                min: e['min'] != null ? DateTime.parse(e['min']) : null,
                max: e['max'] != null ? DateTime.parse(e['max']) : null,
                format: e['format'] ?? DateFormat("dd/MM/yyyy"),
              ));
          questions.add(newQuestion);
          break;
        case 'closed':
          defaultQuestion.questionType = QuestionTypes.closed;

          DropDownQuestion newQuestion = DropDownQuestion(
              question: defaultQuestion,
              defaultProperties: defaultProperties,
              dropdownProperties: DropDownQuestionProperties(
                  isChild: e['is_child'] ?? false,
                  searchable: e['searchable'] ?? false,
                  multiSelect: e['multi_select'] ?? false,
                  answers: e['answers'] != null
                      ? List<DropDownAnswer>.from(
                          e['answers'].map((x) => DropDownAnswer.fromJson(x)))
                      : [],
                  allAnswers: e['all_answers'] != null
                      ? List<DropDownAnswer>.from(e['all_answers']
                          .map((x) => DropDownAnswer.fromJson(x)))
                      : [],
                  hasChild: e['has_child'] ?? false,
                  principalChild: e['principal_child'] != null
                      ? DropDownChildren.fromJson(e['principal_child'])
                      : null,
                  children: e['children'] != null
                      ? List<DropDownChildren>.from(e['children']
                          .map((e) => DropDownChildren.fromJson(e)))
                      : null));

          questions.add(newQuestion);
          break;
        case "switch":
          defaultQuestion.questionType = QuestionTypes.boolean;
          BooleanQuestion newQuestion = BooleanQuestion(
              question: defaultQuestion,
              defaultProperties: defaultProperties,
              booleanProperties: BooleanQuestionProperties(
                  active: getSwitchValue(e['answer'])));
          questions.add(newQuestion);
          break;
        case "image":
          defaultQuestion.questionType = QuestionTypes.image;
          ImageQuestion newQuestion = ImageQuestion(
              question: defaultQuestion, defaultProperties: defaultProperties);
          questions.add(newQuestion);
          break;
        case "bool":
          break;
        default:
          questions.add(dfq);
          break;
      }
    }
    return questions;
  }
}
