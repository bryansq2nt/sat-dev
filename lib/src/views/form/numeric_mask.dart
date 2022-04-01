import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:sat/src/utilities/screenSize.dart';
import '../../models/form/properties/default_question_properties.dart';
import '../../models/form/question_model.dart';

class NumericMaskFieldWidget extends StatelessWidget {
  final QuestionModel question;
  final DefaultQuestionProperties properties;
  const NumericMaskFieldWidget({Key? key,required this.question,required this.properties}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    return Padding(
      padding: EdgeInsets.symmetric(vertical: 2 * SizeConfig.blockSizeVertical),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 0.4 * SizeConfig.screenWidth,
            child: Row(
              children: [
                Expanded(child: Text(question.questionTitle, style: const TextStyle(color: Color(0xff8480ae), fontSize: 14, fontWeight: FontWeight.w400),)),
                Text(
                  properties.required  ? "(*)" : "",
                  style: const TextStyle(color: Colors.red),
                )
              ],
            ),     ),
          const SizedBox(height: 5.0,),
          FormBuilderTextField(
            enabled: properties.enabled,
            initialValue: properties.answer,
            keyboardType: TextInputType.number,
            name:question.questionId,
            maxLength: properties.limit,
            inputFormatters: [MaskTextInputFormatter(properties.mask ?? "")],
            onChanged: (val) => properties.answer = val,
            onSaved: (val) => properties.answer = val,
            validator: properties.required ? FormBuilderValidators.required(context,errorText:
            'Requerido',) : null,
            decoration: InputDecoration(
                hintText: properties.mask ?? "",
                enabledBorder: OutlineInputBorder(
                    borderSide: const BorderSide(color: Color(0xffcfe2ff)),
                    borderRadius: BorderRadius.circular(15.0)
                ),
                focusedBorder: OutlineInputBorder(
                    borderSide:const BorderSide(color: Color(0xffcfe2ff)),
                    borderRadius: BorderRadius.circular(15.0)
                ),
                border: OutlineInputBorder(
                    borderSide:const BorderSide(color: Color(0xffcfe2ff)),
                    borderRadius: BorderRadius.circular(15.0)
                )
            ),
          )
        ],
      ),
    );
  }
}

class MaskTextInputFormatter extends TextInputFormatter {
  final String mask;
  final int maskLength;
  final Map<String, List<int>> separatorBounds;

  MaskTextInputFormatter(this.mask, {
    List<String> separators = const ["-"],
  })  : separatorBounds = {
    for (var v in separators)
      v: mask.split("").asMap().entries.where((entry) => entry.value == v).map((e) => e.key).toList()
  },
        maskLength = mask.length;

  @override
  TextEditingValue formatEditUpdate(TextEditingValue oldValue, TextEditingValue newValue) {
    final int newTextLength = newValue.text.length;
    final int oldTextLength = oldValue.text.length;
    // removed char
    if (newTextLength < oldTextLength) return newValue;
    // maximum amount of chars
    if (oldTextLength == maskLength) return oldValue;

    // masking
    final StringBuffer newText = StringBuffer();
    int selectionIndex = newValue.selection.end;

    // extra boundaries check
    final separatorEntry1 = separatorBounds.entries.firstWhere((entry) => entry.value.contains(oldTextLength));
    if (separatorEntry1 != null) {
      newText.write(oldValue.text + separatorEntry1.key);
      selectionIndex++;
    } else {
      newText.write(oldValue.text);
    }
    // write the char
    newText.write(newValue.text[newValue.text.length - 1]);

    return TextEditingValue(
      text: newText.toString(),
      selection: TextSelection.collapsed(offset: selectionIndex),
    );
  }
}