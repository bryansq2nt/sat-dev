
import 'package:sat/src/models/form/properties/default_question_properties.dart';
import 'package:sat/src/models/form/question_model.dart';

class TextQuestion {
  final QuestionModel question;
  final DefaultQuestionProperties defaultProperties;

  TextQuestion({required this.question,required this.defaultProperties});
}