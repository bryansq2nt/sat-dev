// import 'dart:developer';

// import 'package:flutter/material.dart';
// import 'package:flutter_form_builder/flutter_form_builder.dart';
// import 'package:sat/src/models/form/form_v1.dart';
// import 'package:sat/src/models/form/question_model.dart';
// import 'package:sat/src/utilities/screenSize.dart';
// import 'package:sat/src/views/form/area.dart';
// import 'package:sat/src/views/form/bold_title.dart';
// import 'package:sat/src/views/form/closed.dart';
// import 'package:sat/src/views/form/closed_multiple.dart';
// import 'package:sat/src/views/form/closed_with_child.dart';
// import 'package:sat/src/views/form/date.dart';
// import 'package:sat/src/views/form/image.dart';
// import 'package:sat/src/views/form/not_bold_title.dart';
// import 'package:sat/src/views/form/numeric.dart';
// import 'package:sat/src/views/form/numeric_mask.dart';
// import 'package:sat/src/views/form/open.dart';
// import 'package:sat/src/views/form/searchable_dropdown.dart';
// import 'package:sat/src/views/form/searchable_dropdown_case_processing.dart';
// import 'package:sat/src/views/form/switch.dart';

// import '../../models/form/section_model.dart';

// class FormWidget extends StatefulWidget {
//   final GlobalKey<FormBuilderState> formKey;
//   final FormModel form;
//   final bool enabled;

//   const FormWidget({Key? key,required this.formKey,required this.form, this.enabled = true})
//       : super(key: key);

//   @override
//   _FormWidgetState createState() => _FormWidgetState();
// }

// class _FormWidgetState extends State<FormWidget> {

//   @override
//   Widget build(BuildContext context) {
//     return FormBuilder(
//       key: widget.formKey,
//       autovalidateMode: AutovalidateMode.disabled,
//       enabled: widget.enabled,
//       onChanged: () {
//         setState(() {});

//       },
//       child: Column(
//         children: [
//           SizedBox(
//             height: 2 * SizeConfig.blockSizeVertical,
//           ),
//           SizedBox(
//             width: SizeConfig.screenWidth * 0.9,
//             child: Card(
//               margin: EdgeInsets.only(bottom: !widget.enabled ? 25 : 0),
//               child: Padding(
//                 padding: EdgeInsets.symmetric(
//                     horizontal: 5 * SizeConfig.blockSizeHorizontal,
//                     vertical: 3 * SizeConfig.blockSizeVertical),
//                 child: ListView.builder(
//                   physics: const ScrollPhysics(),
//                   shrinkWrap: true,
//                   itemCount: widget.form.sections.length,
//                   itemBuilder: (BuildContext context, int section) {
//                     if ((widget.form.sections[section].dependent) == false
//                         && (widget.form.sections[section].dependentMultiple) == false) {
//                       return _questions(section);
//                     } else {
//                       bool show = false;

//                       for (var sectionToCheck in widget.form.sections) {

//                         if ((widget.form.sections[section].dependent) == true) {
//                           if (widget
//                                   .form.sections[section].dependentSectionId ==
//                               sectionToCheck.sectionId) {

//                             for (var questionToCheck in sectionToCheck.questions) {

//                               if ( questionToCheck.questionId == widget
//                                   .form.sections[section].dependentQuestionId && questionToCheck.answer ==
//                                   widget
//                                       .form.sections[section].dependentAnswer) {

//                                 show = true;
//                               }
//                             }
//                           }
//                         } else {
//                           if (widget
//                               .form.sections[section].dependentSectionId ==
//                               sectionToCheck.sectionId) {
//                             for (var questionToCheck in sectionToCheck.questions) {
//                               if ( widget
//                                   .form.sections[section].dependentQuestions.contains(questionToCheck.answer)) {
//                                 show = true;
//                               }
//                             }
//                           }
//                         }
//                       }

//                       /*for ( SectionModel sectionToCheck in widget.form.sections){
//                         if(sectionToCheck.sectionId == widget.form.sections[section].dependentSectionId){
//                           for( QuestionModel questionToCheck in sectionToCheck.questions){
//                             if(questionToCheck.questionId == widget.form.sections[section].dependentQuestionId){
//                               log("check: ${questionToCheck.questionId} dependent: ${widget.form.sections[section].dependentQuestionId}");
//                               if(widget.form.sections[section].dependent){
//                                 if(questionToCheck.answer == widget.form.sections[section].dependentAnswer){
//                                   show = true;
//                                 }
//                               } else {
//                                 if(widget.form.sections[section].dependentAnswer.contains(questionToCheck.answer)){
//                                   show = true;
//                                 }
//                               }

//                             }


//                           }
//                         }
//                       }*/

//                       if (show) {
//                         return _questions(section);
//                       } else {
//                         return Container();
//                       }
//                     }
//                   },
//                 ),
//               ),
//             ),
//           )
//         ],
//       ),
//     );
//   }

//   Widget _questions(int section) {
//     return Column(
//       children: [
//         widget.form.sections[section].boldTitle == true
//                 ? BoldTitleWidget(
//                     title: widget.form.sections[section].sectionTitle,
//                   )
//                 : NotBoldTitleWidget(
//                     title: widget.form.sections[section].sectionTitle
//                   ),
//         ListView.builder(
//           physics: const ScrollPhysics(),
//           shrinkWrap: true,
//           itemCount: widget.form.sections[section].questions.length,
//           itemBuilder: (BuildContext context, int question) {
//             bool show = false;

//             dynamic currentQuestion = widget.form.sections[section].questions[question];
//                 if(currentQuestion != null){
//                   if (currentQuestion.question.dependent ||
//                       currentQuestion.question.dependentMultiple) {
//                     for (SectionModel sectionToCheck in widget.form.sections) {
//                       if (sectionToCheck.sectionId ==
//                           currentQuestion.question.dependentSectionId) {
//                         for (dynamic questionToCheck
//                         in sectionToCheck.questions) {
//                           if (questionToCheck.questionId ==
//                               currentQuestion.question.dependentQuestionId) {

//                             if (widget.form.sections[section].questions[question]
//                                  .question.dependentMultiple) {

//                               if(currentQuestion.question.dependentAnswer is int){
//                                 if(questionToCheck.answer != null && questionToCheck.answer.contains(currentQuestion.question.dependentAnswer)){
//                                   show = true;
//                                 }
//                               }
//                               else if (currentQuestion.question.dependentAnswer != null && questionToCheck.answer != null && questionToCheck.question.answer is! DateTime && currentQuestion.question.dependentAnswer
//                                   .contains(questionToCheck.answer)) {
//                                 show = true;
//                               }

//                             } else {
//                               if(currentQuestion.question.questionType == "numeric_date_before_null"){
//                                 log("=============================================");
//                                 log("Answe: ${questionToCheck.answer}");
//                                 log("=============================================");
//                                 if (questionToCheck.answer != null && questionToCheck.answer.toString().length > 1) {
//                                   show = false;
//                                 } else {
//                                   show = true;
//                                 }
//                               } else {
//                                 if (questionToCheck.answer ==
//                                     currentQuestion.question.dependentAnswer) {
//                                   show = true;
//                                 }
//                               }

//                             }
//                           }
//                         }
//                       }
//                     }
//                   } else {
//                     show = true;
//                   }

//                   if (show ) {
//                     switch (widget
//                         .form.sections[section].questions[question].question.questionType) {
//                       case QuestionTypes.open:
//                         log("aqui 1");
//                         return OpenFieldWidget(
//                           question: currentQuestion.question,
//                           properties: currentQuestion.defaultProperties,

//                         );
//                       case QuestionTypes.numeric:
//                         log("aqui 2");
//                         return NumericFieldWidget(
//                           question: currentQuestion.question,
//                           properties: currentQuestion.defaultProperties,
//                           numericProperties: currentQuestion.numericProperties
//                         );
//                       case "numeric_mask":
//                         log("aqui 3");
//                         return NumericMaskFieldWidget(
//                           question: currentQuestion.question,
//                           properties: currentQuestion.defaultProperties
//                         );
//                       case "area":
//                         log("aqui 4");
//                         return AreaFieldWidget(
//                           question: currentQuestion.question,
//                           properties: currentQuestion.defaultProperties,

//                         );
//                       case QuestionTypes.closed:
//                         log("aqui 5");
//                         return ClosedFieldWidget(
//                           question: currentQuestion.question,
//                           properties: currentQuestion.defaultProperties,
//                           dropdownProperties: currentQuestion.dropdownProperties,
//                         );
//                       case "closed_multiple":
//                         log("aqui 6");
//                         return ClosedMultipleFieldWidget(
//                           question: currentQuestion.question,
//                           properties: currentQuestion.defaultProperties,
//                           dropdownProperties: currentQuestion.dropdownProperties,
//                         );
//                       case "closed_searchable":
//                         log("aqui 7");
//                         return SearchableDropdownField(
//                           question: currentQuestion.question,
//                           properties: currentQuestion.defaultProperties,
//                           dropdownProperties: currentQuestion.dropdownProperties,
//                         );
//                       case "closed_searchable_case_processing":
//                         log("aqui 8");
//                         return SearchableDropdownFieldCaseProcessing(
//                           question: currentQuestion.question,
//                           properties: currentQuestion.defaultProperties,
//                           dropdownProperties: currentQuestion.dropdownProperties,
//                         );
//                       case "closed_with_child":
//                         log("aqui 9");
//                         return ClosedWithChildField(
//                           question: currentQuestion.question,
//                           properties: currentQuestion.defaultProperties,
//                           dropdownProperties: currentQuestion.dropdownProperties,
//                           form: widget.form,
//                           formKey: widget.formKey,
//                         );
//                       case "switch":
//                         log("aqui 10");
//                         return SwitchFieldWidget(
//                           question: currentQuestion.question,
//                           properties: currentQuestion.defaultProperties,
//                           booleanProperties: currentQuestion.booleanProperties,
//                         );
//                       case "date":
//                         log("aqui 11");
//                         return DateFieldWidget(
//                           question: currentQuestion.question,
//                           properties: currentQuestion.defaultProperties,
//                           dateProperties: currentQuestion.dateProperties,
//                         );

//                       case "image":
//                         log("aqui 12");
//                         return ImageFieldWidget(
//                           question: currentQuestion.question,
//                           properties: currentQuestion.defaultProperties,
//                         );
//                       default:
//                         log("aqui 13");
//                         return OpenFieldWidget(
//                           question: currentQuestion.question,
//                           properties: currentQuestion.defaultProperties,
//                         );
//                     }
//                   } else {
//                     return Container();
//                   }
//                 }
//                 return Container();

//           },
//         )
//       ],
//     );
//   }


// }
