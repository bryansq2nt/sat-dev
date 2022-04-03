import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:sat/src/models/form/question_model.dart';
import 'package:sat/src/utilities/screenSize.dart';

import '../../models/form/properties/default_question_properties.dart';
import '../../models/form/properties/drop_down_properties.dart';

class SearchableDropdownFieldCaseProcessing extends StatefulWidget {
  final QuestionModel question;
  final DefaultQuestionProperties properties;
  final DropDownQuestionProperties dropdownProperties;
  const SearchableDropdownFieldCaseProcessing(
      {Key? key,
      required this.question,
      required this.properties,
      required this.dropdownProperties})
      : super(key: key);

  @override
  _SearchableDropdownFieldCaseProcessingState createState() =>
      _SearchableDropdownFieldCaseProcessingState();
}

class _SearchableDropdownFieldCaseProcessingState
    extends State<SearchableDropdownFieldCaseProcessing> {
  late String selectedValue;

  void formatAnswer() {
    if (widget.properties.answer != null) {
      widget.properties.answer =
          widget.properties.answer.toString().split("|")[0];
    }
  }

  @override
  void initState() {
    formatAnswer();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
                widget.question.questionTitle,
                style: const TextStyle(
                    color: Color(0xff8480ae),
                    fontSize: 14,
                    fontWeight: FontWeight.w400),
              )),
              Text(
                widget.properties.required ? "(*)" : "",
                style: const TextStyle(color: Colors.red),
              )
            ],
          ),
          const SizedBox(
            height: 5.0,
          ),
          DropdownSearch<String>(
            mode: Mode.MENU,
            enabled: widget.properties.enabled,
            items:
                widget.dropdownProperties.answers.map((e) => e.answer).toList(),
            selectedItem: widget.properties.answer,
            validator: widget.properties.required
                ? FormBuilderValidators.required(
                    context,
                    errorText: 'Requerido',
                  )
                : null,
            onChanged: (value) {
              setState(() {
                widget.properties.answer = value;
              });
            },
            popupItemDisabled: (String s) => s.startsWith('I'),
          ),
        ],
      ),
    );
  }
}
