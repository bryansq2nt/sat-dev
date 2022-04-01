import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:sat/src/models/form/properties/boolean_question_properties.dart';
import 'package:sat/src/utilities/screenSize.dart';

import '../../models/form/properties/default_question_properties.dart';
import '../../models/form/question_model.dart';

class SwitchFieldWidget extends StatelessWidget {
  final QuestionModel question;
  final DefaultQuestionProperties properties;
  final BooleanQuestionProperties booleanProperties;

  const SwitchFieldWidget({Key? key, required this.question, required this.properties,required this.booleanProperties}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    return Padding(
        padding: EdgeInsets.symmetric(vertical: 2 * SizeConfig.blockSizeVertical),
        child: FormBuilderSwitch(
          enabled: properties.enabled,
          initialValue: properties.answer != null && properties.answer is String && properties.answer == "true" || properties.answer != null && properties.answer is bool && properties.answer == true,
          name: question.questionId,
          title: Row(
            children: [
              Expanded(child: Text(question.questionTitle, style: const TextStyle(color: Color(0xff8480ae), fontSize: 14, fontWeight: FontWeight.w400),)),
              Text(
                properties.required ? "(*)" : "",
                style: const TextStyle(color: Colors.red),
              )
            ],
          ),
          onChanged:(val) => properties.answer = val,
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
        )
    );
  }
}


