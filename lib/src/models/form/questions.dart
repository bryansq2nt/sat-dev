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
import 'package:sat/src/models/form/questions/numeric.dart';
import 'package:sat/src/models/form/questions/text.dart';

import 'package:intl/intl.dart' show DateFormat;

class QuestionsUtilities {


  QuestionTypes getType(var type){
    switch(type){
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
    default: return QuestionTypes.open;
    }

  }
  
  bool getSwitchValue(var value){
    if(value != null){
      if(value is String){
        if(value == "true"){
          return true;
        }
      } else if(value is bool){
        return value;
      }
    }
    
    return false;
  }


  dynamic getAnswer(QuestionTypes type,dynamic value){


    if(value == null){
      if(type == QuestionTypes.open){
        return "";
      }
    }


    return value;
  }

  List<dynamic> getQuestions(json){
    List<dynamic> questions = [];
    for(var e in json['questions']){
      QuestionModel defaultQuestion = QuestionModel(
          sectionId: e['section_id'] ?? "",
          questionId: e['question_id'],
          questionTitle: e['question'],
          questionType: getType(json['question_type']),
          dependent: e['dependent'] ?? false,
          dependentSectionId: e['dependent_section_id'],
          dependentQuestionId: e['dependent_question_id'],
          questionDependentAnswer: e['dependent_answer'] != null ? DependentAnswerModel.fromJson(e['dependent_answer']) : null,
          dependentMultiple: e['dependent_multiple'] ?? false,
          questionDependentQuestions: e['dependent_questions'] ?? [],
          downloadedJson: e);
      DefaultQuestionProperties defaultProperties = DefaultQuestionProperties(
          hint: e['hint'] ?? "",
          limit: e['limit'],
          maxLines: e["max_lines"] ?? 1,
          mask: e['mask'] ?? "",
          answer: getAnswer(getType(json['question_type']), e['answer'])
      );
      TextQuestion newQuestion = TextQuestion(question: defaultQuestion, defaultProperties: defaultProperties);
      switch(e['question_type']){
        case 'numeric':
          NumericQuestion newQuestion = NumericQuestion(
              question: defaultQuestion,
              defaultProperties: defaultProperties,
              numericProperties: NumericQuestionProperties(
                  min: e['min'] ?? 0,
                  max: e['max']
              ));
          questions.add(newQuestion);
          break;
        case 'date':
          DateQuestion newQuestion = DateQuestion(
              question: defaultQuestion,
              defaultProperties: defaultProperties,
              dateProperties: DateQuestionProperties(
                type: e['type'] != null ? DateType.values.firstWhere((element) => element.name == e['type']) : DateType.datetime,
                min: e['min'],
                max: e['max'],
                format: e['format'] ?? DateFormat("dd/MM/yyyy"),
              ));
          questions.add(newQuestion);
          break;
        case 'closed':
          DropDownQuestion newQuestion = DropDownQuestion(
              question: defaultQuestion,
              defaultProperties: defaultProperties,
              dropdownProperties: DropDownQuestionProperties(
                multiSelect: e['multi_select'] ?? false,
                  answers: List<DropDownAnswer>.from( e['answers'].map((x) => DropDownAnswer.fromJson(x)))  ,
                  answersToShow: [],
                  hasChild: e['has_child'] ?? false,
                  principalChild: e['principal_child'],
                  children: e['children'] != null ? List<String>.from(e['children'].map((e) => e)) : null
              ));
          questions.add(newQuestion);
          break;
        case "switch":
          BooleanQuestion newQuestion = BooleanQuestion(
              question: defaultQuestion,
              defaultProperties: defaultProperties,
            booleanProperties: BooleanQuestionProperties(
              active:  getSwitchValue(e['answer'])
            )
          );
          questions.add(newQuestion);
          break;
        case "bool":
          break;
        default: questions.add(newQuestion); break;
      }
    }
    return questions;
  }



}