import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:sat/src/utilities/screenSize.dart';

import '../../models/form/properties/default_question_properties.dart';
import '../../models/form/properties/numeric_question_properties.dart';
import '../../models/form/question_model.dart';

class NumericFieldWidget extends StatelessWidget {
  final QuestionModel question;
  final DefaultQuestionProperties properties;
  final NumericQuestionProperties numericProperties;

  const NumericFieldWidget(
      {Key? key,
      required this.question,
      required this.properties,
      required this.numericProperties})
      : super(key: key);

  getValidators(context) {
    if (numericProperties.max != null) {
      return FormBuilderValidators.compose([
        FormBuilderValidators.required(
          context,
          errorText: 'Requerido',
        ),
        FormBuilderValidators.numeric(context, errorText: 'Este campo debe ser numerico.'),
        FormBuilderValidators.max(context, numericProperties.max!),
            (val) {
          var number = int.tryParse(val as String);
          if (number != null && number < numericProperties.min) {
            return 'No puede ser menor a ${numericProperties.min}';
          }
          return null;
        }
      ]);
    }
    return FormBuilderValidators.compose([
      FormBuilderValidators.required(
        context,
        errorText: 'Requerido',
      ),
      FormBuilderValidators.numeric(context, errorText: 'Este campo debe ser numerico.'),
      FormBuilderValidators.max(context, numericProperties.max!),
          (val) {
        var number = int.tryParse(val as String);
        if (number != null && number < numericProperties.min) {
          return 'No puede ser menor a ${numericProperties.min}';
        }
        return null;
      }
    ]);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 2 * SizeConfig.blockSizeVertical),
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
}
