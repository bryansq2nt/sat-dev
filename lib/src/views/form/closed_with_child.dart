import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:sat/src/models/form/form_v1.dart';
import 'package:sat/src/models/form/properties/drop_down_properties.dart';

import '../../models/form/properties/default_question_properties.dart';
import '../../models/form/question_model.dart';



class ClosedWithChildField extends StatefulWidget {
  final QuestionModel question;
  final DefaultQuestionProperties properties;
  final DropDownQuestionProperties dropdownProperties;
  final FormModel form;
  final GlobalKey<FormBuilderState> formKey;


  const ClosedWithChildField({Key? key,required this.question,required this.form,required this.formKey,required this.properties,required this.dropdownProperties}) : super(key: key);

  @override
  _ClosedWithChildFieldState createState() => _ClosedWithChildFieldState();
}

class _ClosedWithChildFieldState extends State<ClosedWithChildField> {
  final List<DropDownAnswer> _answersToShow = [];
  List<DropDownAnswer> _answers = [];
  late int principalSection;
  late int principalQuestion;

  void clearAnswers() async {
    if(widget.dropdownProperties.hasChild){

      for(int i = 0; i < widget.form.sections.length; i++){
        for (int j = 0; j < widget.form.sections[i].questions.length; j++){
          if(widget.dropdownProperties == widget.form.sections[i].questions[j].questionId){

            setState(() {
              principalSection = i;
              principalQuestion = j;


              _answers = widget.form.sections[i].questions[j].answers!;

              if(widget.form.formId == 0){
                widget.form.sections[i].questions[j].answers = [];

              } else {
                filter();
              }

            });

          }
        }
      }
    }
  }

  void filter() async {
    _answersToShow.clear();
    for (var element in _answers) {

    if(element.toCompare.toString() == widget.properties.answer.toString()){
      _answersToShow.add(element);
    }
  }

    widget.form.sections[principalSection].questions[principalQuestion].answers = _answersToShow;


  }

  void change(compare) async {


    _answersToShow.clear();
    for (var element in _answers) {
    if(element.toCompare.toString() == compare.toString()){
      _answersToShow.add(element);
    }
  }

    if(widget.dropdownProperties.hasChild){
      for(int i = 0; i < widget.form.sections.length; i++){
        for (int j = 0; j < widget.form.sections[i].questions.length; j++){
          if(widget.dropdownProperties.principalChild == widget.form.sections[i].questions[j].questionId){
            setState(() {
              widget.formKey.currentState?.fields[widget.dropdownProperties.principalChild]?.setValue(null);
              widget.form.sections[i].questions[j].answer = null;
              widget.form.sections[i].questions[j].answers = _answersToShow;
            });
          }
          if(widget.dropdownProperties.children != null && widget.dropdownProperties.children!.contains(widget.form.sections[i].questions[j].questionId)){
            setState(() {
              widget.formKey.currentState?.fields['${widget.form.sections[i].questions[j].questionId}']?.setValue(null);
              widget.form.sections[i].questions[j].answers = [];
            });
          }

        }
      }

    }

  }

  @override
  void initState() {
    clearAnswers();
    super.initState();

  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    return  FormBuilderDropdown(
      enabled: widget.properties.enabled,
      initialValue: widget.properties.answer,
      name: widget.question.questionId,
      hint: const Text("Seleccionar..."),
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
      allowClear: true,
      validator: widget.properties.required ? FormBuilderValidators.required(context,errorText:
      'Requerido',) : null,
      onChanged: (val) {
        setState(() {
          /*final opt = Provider.of<CaseProcessingProvider>(context, listen: false);
                opt.updateOpt(val);*/
          widget.properties.answer = val;
          change(val);
        });
      },
      onSaved: (val) => widget.properties.answer = val,
      items: widget.dropdownProperties.answersToShow
          .map((value) => DropdownMenuItem(
          value: value.answerId,
          child: Text(value.answer)
      )).toList(),
    );

  }
}
