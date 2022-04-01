import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:sat/src/models/form/form_v1.dart';
import 'package:sat/src/models/form/question_model.dart';
import 'package:sat/src/models/form/questions/boolean.dart';
import 'package:sat/src/models/form/questions/date.dart';
import 'package:sat/src/models/form/questions/dropdown.dart';
import 'package:sat/src/models/form/questions/numeric.dart';
import 'package:sat/src/models/form/questions/text.dart';
import 'package:sat/src/utilities/screenSize.dart';
import 'package:sat/src/views/form/area.dart';
import 'package:sat/src/views/form/bold_title.dart';
import 'package:sat/src/views/form/closed.dart';
import 'package:sat/src/views/form/closed_multiple.dart';
import 'package:sat/src/views/form/closed_with_child.dart';
import 'package:sat/src/views/form/date.dart';
import 'package:sat/src/views/form/image.dart';
import 'package:sat/src/views/form/not_bold_title.dart';
import 'package:sat/src/views/form/numeric.dart';
import 'package:sat/src/views/form/numeric_mask.dart';
import 'package:sat/src/views/form/open.dart';
import 'package:sat/src/views/form/question/body.dart';
import 'package:sat/src/views/form/searchable_dropdown.dart';
import 'package:sat/src/views/form/searchable_dropdown_case_processing.dart';
import 'package:sat/src/views/form/switch.dart';

import '../../models/form/section_model.dart';

class FormWidget extends StatefulWidget {
  final GlobalKey<FormBuilderState> formKey;
  final FormModel form;
  final bool enabled;

  const FormWidget({Key? key,required this.formKey,required this.form, this.enabled = true})
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
                    if ((widget.form.sections[section].dependent) == false
                        && (widget.form.sections[section].dependentMultiple) == false) {
                      return _section(section);
                    } else {
                      bool show = false;

                      for (var sectionToCheck in widget.form.sections) {

                        if ((widget.form.sections[section].dependent) == true) {
                          if (widget
                              .form.sections[section].dependentSectionId ==
                              sectionToCheck.sectionId) {

                            for (var questionToCheck in sectionToCheck.questions) {

                              if ( questionToCheck.questionId == widget
                                  .form.sections[section].dependentQuestionId && questionToCheck.answer ==
                                  widget
                                      .form.sections[section].dependentAnswer) {

                                show = true;
                              }
                            }
                          }
                        } else {
                          if (widget
                              .form.sections[section].dependentSectionId ==
                              sectionToCheck.sectionId) {
                            for (var questionToCheck in sectionToCheck.questions) {
                              if ( widget
                                  .form.sections[section].dependentQuestions.contains(questionToCheck.answer)) {
                                show = true;
                              }
                            }
                          }
                        }
                      }

                      /*for ( SectionModel sectionToCheck in widget.form.sections){
                        if(sectionToCheck.sectionId == widget.form.sections[section].dependentSectionId){
                          for( QuestionModel questionToCheck in sectionToCheck.questions){
                            if(questionToCheck.questionId == widget.form.sections[section].dependentQuestionId){
                              log("check: ${questionToCheck.questionId} dependent: ${widget.form.sections[section].dependentQuestionId}");
                              if(widget.form.sections[section].dependent){
                                if(questionToCheck.answer == widget.form.sections[section].dependentAnswer){
                                  show = true;
                                }
                              } else {
                                if(widget.form.sections[section].dependentAnswer.contains(questionToCheck.answer)){
                                  show = true;
                                }
                              }

                            }


                          }
                        }
                      }*/

                      if (show) {
                        return _section(section);
                      } else {
                        return Container();
                      }
                    }
                  },
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget _section(int section) {
    return Column(
      children: [
        widget.form.sections[section].boldTitle == true
            ? BoldTitleWidget(
          title: widget.form.sections[section].sectionTitle,
        )
            : NotBoldTitleWidget(
            title: widget.form.sections[section].sectionTitle
        ),
        ListView.builder(
          physics: const ScrollPhysics(),
          shrinkWrap: true,
          itemCount: widget.form.sections[section].questions.length,
          itemBuilder: (BuildContext context, int question) {
            return QuestionBody(
              question: widget.form.sections[section].questions[question],
            );

          },
        )
      ],
    );
  }


}
