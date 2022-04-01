import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:sat/src/models/form/properties/date_question_properties.dart';
import 'package:sat/src/models/form/question_model.dart';

import '../../models/form/properties/default_question_properties.dart';

class DateFieldWidget extends StatelessWidget {
  final QuestionModel question;
  final DefaultQuestionProperties properties;
  final DateQuestionProperties dateProperties;

  const DateFieldWidget({Key? key,required this.question,required this.properties,required this.dateProperties}) : super(key: key);

  DateTime? getDate(){
    if(properties.answer != null){
      if(properties.answer is String && properties.answer.toString().length > 5){
        return DateTime.parse(properties.answer.toString());
      } else if(properties.answer is DateTime){
        return properties.answer;
      }
    }
    return null;
  }

  InputType getInputDate(){
    switch(dateProperties.type){
      case DateType.date: return InputType.date;
      case DateType.time : return InputType.time;
      default: return InputType.both;
    }
  }



  @override
  Widget build(BuildContext context) {
    return FormBuilderDateTimePicker(
      enabled:properties.enabled,
      initialValue: getDate(),
      name: question.questionId,
      onChanged: (val) => properties.answer = val,
      onSaved: (val) => properties.answer = val,
      inputType: getInputDate(),
      validator: properties.required ? FormBuilderValidators.required(context,errorText:
      'Requerido',) : null,
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
      initialDate: dateProperties.current,
      format: dateProperties.format,
      lastDate: dateProperties.max,
      firstDate: dateProperties.min,
      initialEntryMode: DatePickerEntryMode.calendar,
      // initialValue: DateTime.now(),
      // enabled: true,
    );
  }
}


