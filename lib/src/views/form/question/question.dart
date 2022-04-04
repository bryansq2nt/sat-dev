import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:sat/src/models/form/dependent_answer.dart';
import 'package:sat/src/models/form/properties/date_question_properties.dart';
import 'package:sat/src/models/form/properties/default_question_properties.dart';
import 'package:sat/src/models/form/properties/numeric_question_properties.dart';
import 'package:sat/src/models/form/question_model.dart';
import 'package:sat/src/models/form/section_model.dart';

import '../../../utilities/screenSize.dart';

class QuestionWidgetV1 extends StatelessWidget {
  final SectionModel currentSection;
  final QuestionModel question;
  final DefaultQuestionProperties properties;
  DateQuestionProperties? dateProperties;
  NumericQuestionProperties? numericProperties;
  final Widget body;

  QuestionWidgetV1(
      {Key? key,
      required this.question,
      required this.properties,
      this.dateProperties,
      this.numericProperties,
      required this.body,
      required this.currentSection})
      : super(key: key);

  bool visible = false;

  bool getVisibility() {
    if (!question.dependent && !question.dependentMultiple) {
      return true;
    }
    return checkValidation();
  }

  bool checkValidation() {

    if (question.questionDependentAnswer != null) {
      DefaultQuestionProperties questionToCheck =
          DefaultQuestionProperties(answer: "");

      for (var i = 0; i < currentSection.questions.length; i++) {
        if (currentSection.questions[i].question.questionId ==
            question.dependentQuestionId) {
          questionToCheck = currentSection.questions[i].defaultProperties;
        }
      }

      switch (question.questionDependentAnswer!.type) {
        case DependentAnswerType.text:
          if (questionToCheck.answer ==
              question.questionDependentAnswer!.answer) {
            return true;
          }
          break;
        case DependentAnswerType.numeric:
          if (questionToCheck.answer ==
              question.questionDependentAnswer!.answer) {
            return true;
          }
          break;
        case DependentAnswerType.boolean:
          if (questionToCheck.answer ==
              question.questionDependentAnswer!.answer) {
            return true;
          }
          break;
        case DependentAnswerType.clear:
          if (questionToCheck.answer == null ||
              questionToCheck.answer.toString().isEmpty) {
            return true;
          }
          break;
        case DependentAnswerType.containInt:
          if (questionToCheck.answer != null) {
            int? value = int.tryParse(questionToCheck.answer);
            if (value != null) {
              if (question.questionDependentAnswer!.answer.contains(value)) {
                return true;
              }
            }
          }
          break;
        case DependentAnswerType.containString:
          if (questionToCheck.answer != null &&
              question.questionDependentAnswer!.answer is String &&
              question.questionDependentAnswer!.answer
                  .contains(questionToCheck.answer)) {
            return true;
          }
          break;
        case DependentAnswerType.date:
          DateTime? firstDate = DateTime.tryParse(questionToCheck.answer);
          DateTime? secondtDate =
              DateTime.tryParse(question.questionDependentAnswer?.answer);

          if (firstDate != null &&
              secondtDate != null &&
              firstDate == secondtDate) {
            return true;
          }

          break;
        case DependentAnswerType.dateRange:
          DateTime? minDate = dateProperties?.min;
          DateTime? maxDate = dateProperties?.max;
          if (properties.answer != null && minDate != null && maxDate != null) {
            if (properties.answer is DateTime) {
              if ((properties.answer as DateTime).isAfter(minDate) &&
                  (properties.answer as DateTime).isBefore(maxDate)) {
                return true;
              }
            }
          }

          break;
        case DependentAnswerType.numericRange:
          int? firstNum = numericProperties?.min;
          int? secondNum = numericProperties?.max;
          if (firstNum != null &&
              secondNum != null &&
              properties.answer != null) {
            int? currentValue = int.tryParse(properties.answer);
            if (currentValue != null &&
                currentValue >= firstNum &&
                currentValue <= secondNum) {
              return true;
            }
          }
          break;
        default:
          return false;
      }
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    if (getVisibility() == true) {
      return _body(context);
    }
    return Container();
  }

  Widget _body(context) {
    if (question.questionType == QuestionTypes.boolean) {
      return Padding(
          padding:
              EdgeInsets.symmetric(vertical: 2 * SizeConfig.blockSizeVertical),
          child: FormBuilderSwitch(
            enabled: properties.enabled,
            initialValue: properties.answer != null &&
                    properties.answer is String &&
                    properties.answer == "true" ||
                properties.answer != null &&
                    properties.answer is bool &&
                    properties.answer == true,
            name: question.questionId,
            title: Row(
              children: [
                Expanded(
                    child: Text(
                  question.questionTitle,
                  style: const TextStyle(
                      color: Color(0xff8480ae),
                      fontSize: 14,
                      fontWeight: FontWeight.w400),
                )),
                Text(
                  properties.required ? "(*)" : "",
                  style: const TextStyle(color: Colors.red),
                )
              ],
            ),
            onChanged: (val) => properties.answer = val,
            onSaved: (val) => properties.answer = val,
            validator: properties.required
                ? FormBuilderValidators.required(
                    context,
                    errorText: 'Requerido',
                  )
                : null,
            decoration: InputDecoration(
              hintText: properties.hint,
              enabledBorder: OutlineInputBorder(
                  borderSide: const BorderSide(color: Color(0xffcfe2ff)),
                  borderRadius: BorderRadius.circular(15.0)),
              focusedBorder: OutlineInputBorder(
                  borderSide: const BorderSide(color: Color(0xffcfe2ff)),
                  borderRadius: BorderRadius.circular(15.0)),
              border: OutlineInputBorder(
                  borderSide: const BorderSide(color: Color(0xffcfe2ff)),
                  borderRadius: BorderRadius.circular(15.0)),
            ),
          ));
    } else if (question.questionType == QuestionTypes.numeric) {
      return Padding(
        padding:
            EdgeInsets.symmetric(vertical: 2 * SizeConfig.blockSizeVertical),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              width: 0.4 * SizeConfig.screenWidth,
              child: Row(
                children: [
                  Expanded(
                      child: Text(
                    question.questionTitle,
                    style: const TextStyle(
                        color: Color(0xff8480ae),
                        fontSize: 14,
                        fontWeight: FontWeight.w400),
                  )),
                  Text(
                    properties.required ? "(*)" : "",
                    style: const TextStyle(color: Colors.red),
                  )
                ],
              ),
            ),
            const SizedBox(
              height: 5.0,
            ),
            SizedBox(
              width: 0.3 * SizeConfig.screenWidth,
              child: FormBuilderTextField(
                enabled: properties.enabled,
                initialValue: properties.answer != null
                    ? properties.answer.toString()
                    : "0",
                keyboardType: TextInputType.number,
                name: question.questionId,
                maxLength: properties.limit,
                onChanged: (val) => properties.answer = val,
                onSaved: (val) => properties.answer = val,
                validator: properties.required
                    ? FormBuilderValidators.required(
                        context,
                        errorText: 'Requerido',
                      )
                    : null,
                decoration: InputDecoration(
                    hintText: properties.hint,
                    enabledBorder: OutlineInputBorder(
                        borderSide: const BorderSide(color: Color(0xffcfe2ff)),
                        borderRadius: BorderRadius.circular(15.0)),
                    focusedBorder: OutlineInputBorder(
                        borderSide: const BorderSide(color: Color(0xffcfe2ff)),
                        borderRadius: BorderRadius.circular(15.0)),
                    border: OutlineInputBorder(
                        borderSide: const BorderSide(color: Color(0xffcfe2ff)),
                        borderRadius: BorderRadius.circular(15.0))),
              ),
            ),
          ],
        ),
      );
    }

    return Padding(
      padding: EdgeInsets.symmetric(vertical: 2 * SizeConfig.blockSizeVertical),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                  child: Text(
                question.questionTitle,
                style: const TextStyle(
                    color: Color(0xff8480ae),
                    fontSize: 14,
                    fontWeight: FontWeight.w400),
              )),
              Text(
                properties.required ? "(*)" : "",
                style: const TextStyle(color: Colors.red),
              )
            ],
          ),
          const SizedBox(
            height: 5.0,
          ),
          body
        ],
      ),
    );
  }
}
