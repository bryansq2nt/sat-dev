
import 'package:sat/src/models/form/dependent_answer.dart';
import 'package:sat/src/models/form/properties/date_question_properties.dart';
import 'package:sat/src/models/form/properties/default_question_properties.dart';
import 'package:sat/src/models/form/question_model.dart';

class DateQuestion {
  final QuestionModel question;
  final DefaultQuestionProperties defaultProperties;
  final DateQuestionProperties dateProperties;

  DateQuestion({required this.question,required this.defaultProperties,required this.dateProperties});

}