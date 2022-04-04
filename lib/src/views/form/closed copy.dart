import 'dart:developer';

import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:sat/src/models/form/form_v1.dart';
import 'package:sat/src/models/form/properties/default_question_properties.dart';
import 'package:sat/src/models/form/question_model.dart';
import 'package:sat/src/models/form/section_model.dart';

import '../../models/form/properties/drop_down_properties.dart';

class ClosedFieldWidget extends StatelessWidget {
  ClosedFieldWidget(
      {Key? key,
      required this.form,
      required this.question,
      required this.properties,
      required this.dropdownProperties})
      : super(key: key);

  final FormModel form;
  final QuestionModel question;
  final DefaultQuestionProperties properties;
  final DropDownQuestionProperties dropdownProperties;

  late List<DropDownAnswer> answers;
  DropDownAnswer? answer;
  bool loading = true;

  getAnswer() {
    if (properties.answer != null) {
      if (properties.answer is int) {
        answer = answers
            .firstWhere((element) => element.answerId == properties.answer);
      }
    }
    loading = false;
  }

  getAnswers() {
    answers = dropdownProperties.answers;
    getAnswer();
  }

  onChangeValue(val) {
    if (dropdownProperties.multiSelect) {
      properties.answer = val != null ? val.toString().split("|")[0] : null;
    } else {
      properties.answer = val;
    }

    if (dropdownProperties.hasChild == true) {
      if (dropdownProperties.children != null &&
          dropdownProperties.children!.isNotEmpty) {
        dropdownProperties.children?.forEach((element) {
          //search this question on form to change answers
        });
      }
      if (dropdownProperties.principalChild != null) {
        //search this question on form to change answers

        for (int i = 0; i < form.sections.length; i++) {
          if (form.sections[i].sectionId ==
              dropdownProperties.principalChild?.section) {
            for (int j = 0; j < form.sections[i].questions.length; j++) {
              if (form.sections[i].questions[j].question.questionId ==
                  dropdownProperties.principalChild!.question) {
                form.sections[i].questions[j].dropdownProperties.answers
                    .clear();
                List<DropDownAnswer> newChildAnswers = [];

                for (DropDownAnswer answer in form
                    .sections[i].questions[j].dropdownProperties.allAnswers) {
                  if (answer.toCompare != null &&
                      properties.answer != null &&
                      answer.toCompare?.toLowerCase() ==
                          properties.answer.answerId.toString().toLowerCase()) {
                    newChildAnswers.add(answer);
                  }
                }

                form.sections[i].questions[j].dropdownProperties.answers =
                    newChildAnswers;
              }
            }
          }
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    getAnswers();

    if (loading && answer == null) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    if (dropdownProperties.multiSelect == true) {
      return FormBuilderCheckboxGroup(
        enabled: properties.enabled,
        initialValue: properties.answer,
        name: question.questionId,
        decoration: InputDecoration(
            enabledBorder: OutlineInputBorder(
                borderSide: const BorderSide(color: Color(0xffcfe2ff)),
                borderRadius: BorderRadius.circular(15.0)),
            focusedBorder: OutlineInputBorder(
                borderSide: const BorderSide(color: Color(0xffcfe2ff)),
                borderRadius: BorderRadius.circular(15.0)),
            border: OutlineInputBorder(
                borderSide: const BorderSide(color: Color(0xffcfe2ff)),
                borderRadius: BorderRadius.circular(15.0))),
        onChanged: onChangeValue,
        onSaved: (val) => properties.answer = val,
        options: answers
            .map((value) => FormBuilderFieldOption(
                value: value.answerId, child: Text(value.answer)))
            .toList(growable: false),
      );
    } else if (dropdownProperties.searchable == true) {
      return DropdownSearch<DropDownAnswer>(
        mode: Mode.BOTTOM_SHEET,
        enabled: properties.enabled,
        items: answers.map((e) => e).toList(),
        selectedItem: properties.answer,
        validator: properties.required
            ? FormBuilderValidators.required(
                context,
                errorText: 'Requerido',
              )
            : null,
        onChanged: onChangeValue,
      );
    }

    return FormBuilderDropdown(
      enabled: properties.enabled,
      name: question.questionId,
      hint: const Text("Seleccionar..."),
      initialValue: answer,
      decoration: InputDecoration(
          enabledBorder: OutlineInputBorder(
              borderSide: const BorderSide(color: Color(0xffcfe2ff)),
              borderRadius: BorderRadius.circular(15.0)),
          focusedBorder: OutlineInputBorder(
              borderSide: const BorderSide(color: Color(0xffcfe2ff)),
              borderRadius: BorderRadius.circular(15.0)),
          border: OutlineInputBorder(
              borderSide: const BorderSide(color: Color(0xffcfe2ff)),
              borderRadius: BorderRadius.circular(15.0))),
      allowClear: true,
      validator: properties.required
          ? FormBuilderValidators.required(
              context,
              errorText: 'Requerido',
            )
          : null,
      onChanged: onChangeValue,
      onSaved: (val) => properties.answer = val,
      items: answers
          .map((value) => DropdownMenuItem<DropDownAnswer>(
              value: value, child: Text(value.answer)))
          .toList(),
    );
  }
}
