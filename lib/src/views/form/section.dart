import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:sat/src/models/form/dependent_answer.dart';
import 'package:sat/src/models/form/form_v1.dart';
import 'package:sat/src/models/form/properties/default_question_properties.dart';
import 'package:sat/src/models/form/section_model.dart';

import 'bold_title.dart';
import 'not_bold_title.dart';
import 'question/body.dart';

class SectionWidget extends StatelessWidget {
  SectionWidget(
      {Key? key,
      required this.form,
      required this.section,
      required this.formKey})
      : super(key: key);

  final GlobalKey<FormBuilderState> formKey;
  final FormModel form;
  final SectionModel section;

  bool visible = false;

  bool getVisibility() {
    if (!section.dependent && !section.dependentMultiple) {
      return true;
    }
    return checkValidation();
  }

  bool checkValidation() {
    if (section.sectionDependentAnswer != null) {
      DefaultQuestionProperties? questionToCheck;

      if (questionToCheck != null) {
        log(questionToCheck.answer.toString());
      }
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    if (getVisibility() == true) {
      return section.sectionTitle.length > 0
          ? Column(
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
                      formKey: formKey,
                      form: form,
                      section: section,
                      question: section.questions[question],
                    );
                  },
                )
              ],
            )
          : ListView.builder(
              physics: const ScrollPhysics(),
              shrinkWrap: true,
              itemCount: section.questions.length,
              itemBuilder: (BuildContext context, int question) {
                return QuestionBody(
                  formKey: formKey,
                  form: form,
                  section: section,
                  question: section.questions[question],
                );
              },
            );
    }
    return Container();
  }
}
