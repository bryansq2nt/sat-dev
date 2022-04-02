import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';

import '../../models/form/properties/default_question_properties.dart';
import '../../models/form/question_model.dart';


class OpenFieldWidget extends StatelessWidget {
  final QuestionModel question;
  final DefaultQuestionProperties properties;
  const OpenFieldWidget({Key? key, required this.question,required this.properties}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FormBuilderTextField(
      enabled: properties.enabled,
      initialValue: properties.answer.toString() != "null" ? properties.answer.toString() : "",
      name: question.questionId,
      maxLines: properties.maxLines,
      maxLength: properties.limit,
      onChanged: (val) => properties.answer = val,
      onSaved: (val) => properties.answer = val,
      validator: properties.required ? FormBuilderValidators.required(context,errorText:
      'Requerido',) : null,
      decoration: InputDecoration(
        hintText: properties.hint,
        enabledBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: Color(0xffcfe2ff)),
            borderRadius: BorderRadius.circular(15.0)
        ),
        focusedBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: Color(0xffcfe2ff)),
            borderRadius: BorderRadius.circular(15.0)
        ),
        border: OutlineInputBorder(
            borderSide: const BorderSide(color: Color(0xffcfe2ff)),
            borderRadius: BorderRadius.circular(15.0)
        ),

      ),

    );
  }
}
