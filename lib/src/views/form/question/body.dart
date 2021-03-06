import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:sat/src/models/form/form_v1.dart';
import 'package:sat/src/models/form/question_model.dart';
import 'package:sat/src/models/form/questions/boolean.dart';
import 'package:sat/src/models/form/questions/date.dart';
import 'package:sat/src/models/form/questions/dropdown.dart';
import 'package:sat/src/models/form/questions/image.dart';
import 'package:sat/src/models/form/questions/numeric.dart';
import 'package:sat/src/models/form/section_model.dart';
import 'package:sat/src/views/form/closed.dart';
import 'package:sat/src/views/form/date.dart';
import 'package:sat/src/views/form/image.dart';
import 'package:sat/src/views/form/numeric.dart';
import 'package:sat/src/views/form/question/question.dart';

import '../../../models/form/questions/text.dart';
import '../open.dart';
import '../switch.dart';

class QuestionBody extends StatelessWidget {
  final GlobalKey<FormBuilderState> formKey;
  final FormModel form;
  final dynamic question;
  final SectionModel section;
  const QuestionBody(
      {Key? key, this.question, required this.section, required this.form, required this.formKey})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    switch (questionType(question)) {
      case QuestionTypes.boolean:
        BooleanQuestion currentQuestion = question;
        return SwitchFieldWidget(
          curentSection: section,
          question: currentQuestion.question,
          properties: currentQuestion.defaultProperties,
          booleanProperties: currentQuestion.booleanProperties,
        );
      case QuestionTypes.date:
        DateQuestion currentQuestion = question;
        return QuestionWidgetV1(
            currentSection: section,
            question: currentQuestion.question,
            properties: currentQuestion.defaultProperties,
            body: DateFieldWidget(
                question: currentQuestion.question,
                properties: currentQuestion.defaultProperties,
                dateProperties: currentQuestion.dateProperties));
      case QuestionTypes.closed:
        DropDownQuestion currentQuestion = question;
        return QuestionWidgetV1(
            currentSection: section,
            question: currentQuestion.question,
            properties: currentQuestion.defaultProperties,
            body: ClosedFieldWidget(
              formKey: formKey,
              form: form,
              question: currentQuestion.question,
              properties: currentQuestion.defaultProperties,
              dropdownProperties: currentQuestion.dropdownProperties,
            ));
      case QuestionTypes.image:
        ImageQuestion currentQuestion = question;
        return QuestionWidgetV1(
            currentSection: section,
            question: currentQuestion.question,
            properties: currentQuestion.defaultProperties,
            body: ImageFieldWidget(
              question: currentQuestion.question,
              properties: currentQuestion.defaultProperties,
            ));
      case QuestionTypes.numeric:
        NumericQuestion currentQuestion = question;
        return NumericFieldWidget(
          curentSection: section,
          question: currentQuestion.question,
          properties: currentQuestion.defaultProperties,
          numericProperties: currentQuestion.numericProperties,
        );
      default:
        TextQuestion currentQuestion = question;
        return QuestionWidgetV1(
            currentSection: section,
            question: currentQuestion.question,
            properties: currentQuestion.defaultProperties,
            body: OpenFieldWidget(
                question: currentQuestion.question,
                properties: currentQuestion.defaultProperties));
    }
  }

  QuestionTypes questionType(dynamic question) {
    if (question is BooleanQuestion) {
      return QuestionTypes.boolean;
    } else if (question is DateQuestion) {
      return QuestionTypes.date;
    } else if (question is DropDownQuestion) {
      return QuestionTypes.closed;
    } else if (question is ImageQuestion) {
      return QuestionTypes.image;
    } else if (question is NumericQuestion) {
      return QuestionTypes.numeric;
    }
    return QuestionTypes.open;
  }
}
