import 'package:flutter/material.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:sat/src/models/form/properties/default_question_properties.dart';
import 'package:sat/src/models/form/properties/drop_down_properties.dart';
import 'package:sat/src/models/form/questions/dropdown.dart';
import 'package:dropdown_search/dropdown_search.dart';

class SearchableDropdownField extends StatefulWidget {
  final DropDownQuestion question;
  final DefaultQuestionProperties properties;
  final DropDownQuestionProperties dropdownProperties;
  const SearchableDropdownField(
      {Key? key,
      required this.question,
      required this.properties,
      required this.dropdownProperties})
      : super(key: key);

  @override
  _SearchableDropdownFieldState createState() =>
      _SearchableDropdownFieldState();
}

class _SearchableDropdownFieldState extends State<SearchableDropdownField> {
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
    return DropdownSearch<String>(
      mode: Mode.MENU,
      enabled: widget.properties.enabled,
      items: widget.dropdownProperties.answers.map((e) => e.answer).toList(),
      selectedItem: widget.properties.answer,
      validator: widget.properties.required
          ? FormBuilderValidators.required(
              context,
              errorText: 'Requerido',
            )
          : null,
      onChanged: (value) {
        setState(() {
          widget.properties.answer =
              value != null ? value.toString().split("|")[0] : null;
        });
      },
      popupItemDisabled: (String s) => s.startsWith('I'),
    );
  }
}
