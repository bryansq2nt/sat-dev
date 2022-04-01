
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:sat/src/models/form/questions/dropdown.dart';
import 'package:sat/src/utilities/screenSize.dart';

import '../../models/form/properties/default_question_properties.dart';
import '../../models/form/properties/drop_down_properties.dart';
import '../../models/form/question_model.dart';



class ClosedMultipleFieldWidget extends StatelessWidget {
  final QuestionModel question;
  final DefaultQuestionProperties properties;
  final DropDownQuestionProperties dropdownProperties;

  const ClosedMultipleFieldWidget({Key? key,required this.question,required this.properties,required this.dropdownProperties}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    return FormBuilderCheckboxGroup(
      enabled:properties.enabled,
      initialValue: properties.answer,
      name: question.questionId,

      decoration: InputDecoration(

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
          )
      ),


      onChanged: (val) => properties.answer = val,
      onSaved: (val) => properties.answer = val,

      options: dropdownProperties.answersToShow
          .map((value) => FormBuilderFieldOption(
          value: value.answerId,
          child: Text(value.answer)
      )).toList( growable: false),

    );

  }
}

