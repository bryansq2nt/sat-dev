import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:sat/src/models/form/form_v1.dart';
import 'package:sat/src/utilities/screenSize.dart';
import 'package:sat/src/views/form/section.dart';

class FormWidget extends StatefulWidget {
  final GlobalKey<FormBuilderState> formKey;
  final FormModel form;
  final bool enabled;

  const FormWidget(
      {Key? key,
      required this.formKey,
      required this.form,
      this.enabled = true})
      : super(key: key);

  @override
  _FormWidgetState createState() => _FormWidgetState();
}

class _FormWidgetState extends State<FormWidget> {
  @override
  Widget build(BuildContext context) {
    return FormBuilder(
      key: widget.formKey,
      autovalidateMode: AutovalidateMode.disabled,
      enabled: widget.enabled,
      onChanged: () {
        setState(() {});
      },
      child: Column(
        children: [
          SizedBox(
            height: 2 * SizeConfig.blockSizeVertical,
          ),
          SizedBox(
            width: SizeConfig.screenWidth * 0.9,
            child: Card(
              margin: EdgeInsets.only(bottom: !widget.enabled ? 25 : 0),
              child: Padding(
                padding: EdgeInsets.symmetric(
                    horizontal: 5 * SizeConfig.blockSizeHorizontal,
                    vertical: 3 * SizeConfig.blockSizeVertical),
                child: ListView.builder(
                  physics: const ScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: widget.form.sections.length,
                  itemBuilder: (BuildContext context, int section) {
                    return SectionWidget(
                        formKey: widget.formKey,
                        form: widget.form, sectionId: section);
                  },
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
