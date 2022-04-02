import 'dart:developer';

import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:sat/src/models/form/properties/default_question_properties.dart';
import 'package:sat/src/models/form/question_model.dart';

import '../../models/form/properties/drop_down_properties.dart';

class ClosedFieldWidget extends StatelessWidget {
  final QuestionModel question;
  final DefaultQuestionProperties properties;
  final DropDownQuestionProperties dropdownProperties;

  const ClosedFieldWidget(
      {Key? key,
      required this.question,
      required this.properties,
      required this.dropdownProperties})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    final List<DropDownAnswer> answers =
        dropdownProperties.answers.whereType<DropDownAnswer>().toList();

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
        onChanged: (val) => properties.answer = val,
        onSaved: (val) => properties.answer = val,
        options: dropdownProperties.answers
            .map((value) => FormBuilderFieldOption(
                value: value.answerId, child: Text(value.answer))
                )
            .toList(growable: false),
      );
    }


    if (dropdownProperties.searchable == true) {
      return DropdownSearch<DropDownAnswer>(
        mode: Mode.BOTTOM_SHEET,
        enabled: properties.enabled,
        items: dropdownProperties.answers.map((e) => e).toList(),
        selectedItem: properties.answer,
        validator: properties.required
            ? FormBuilderValidators.required(
                context,
                errorText: 'Requerido',
              )
            : null,
        onChanged: (value) {
          properties.answer =
              value != null ? value.toString().split("|")[0] : null;
        },
      );
    }

    return FormBuilderDropdown(
      enabled: properties.enabled,
      name: question.questionId,
      hint: const Text("Seleccionar..."),
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
      onChanged: (val) => properties.answer = val,
      onSaved: (val) => properties.answer = val,
      items: answers
          .map((value) => DropdownMenuItem(
              value: value.answerId, child: Text(value.answer)))
          .toList(),
    );
  }
}
