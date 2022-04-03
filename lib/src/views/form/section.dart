import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:sat/src/models/form/form_v1.dart';
import 'package:sat/src/models/form/section_model.dart';

import 'bold_title.dart';
import 'not_bold_title.dart';
import 'question/body.dart';

class SectionWidget extends StatelessWidget {
  SectionWidget({Key? key, required this.form, required this.sectionId})
      : super(key: key);

  final FormModel form;
  late SectionModel section;
  final int sectionId;

  bool visible = false;

  bool getVisibility() {
    if (!section.dependent && !section.dependentMultiple) {
      return true;
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    section = form.sections[sectionId];

    if (getVisibility() == true) {
      return Column(
        children: [
          section.boldTitle == true
              ? BoldTitleWidget(
                  title: section.sectionTitle,
                )
              : NotBoldTitleWidget(title: section.sectionTitle),
          ListView.builder(
            physics: const ScrollPhysics(),
            shrinkWrap: true,
            itemCount: section.questions.length,
            itemBuilder: (BuildContext context, int question) {
              return QuestionBody(
                form: form,
                section: section,
                question: section.questions[question],
              );
            },
          )
        ],
      );
    }
    return Container();
  }
}
