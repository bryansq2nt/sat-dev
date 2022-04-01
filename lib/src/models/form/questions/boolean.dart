

import 'package:sat/src/models/form/dependent_answer.dart';
import 'package:sat/src/models/form/properties/boolean_question_properties.dart';
import 'package:sat/src/models/form/properties/default_question_properties.dart';
import 'package:sat/src/models/form/question_model.dart';

class BooleanQuestion  {
  final QuestionModel question;
  final DefaultQuestionProperties defaultProperties;
  final BooleanQuestionProperties booleanProperties;

  BooleanQuestion({required this.question,required this.defaultProperties, required this.booleanProperties});

}