import 'package:sat/src/models/form/dependent_answer.dart';
import 'package:sat/src/models/form/properties/default_question_properties.dart';
import 'package:sat/src/models/form/properties/numeric_question_properties.dart';
import 'package:sat/src/models/form/question_model.dart';

class NumericQuestion {
    final QuestionModel question;
    final DefaultQuestionProperties defaultProperties;
    final NumericQuestionProperties numericProperties;

  NumericQuestion({required this.question,required this.defaultProperties,required this.numericProperties});
}
