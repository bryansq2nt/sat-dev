import 'package:sat/src/models/form/properties/default_question_properties.dart';
import 'package:sat/src/models/form/properties/drop_down_properties.dart';
import 'package:sat/src/models/form/question_model.dart';


class DropDownQuestion {
  final QuestionModel question;
  final DefaultQuestionProperties defaultProperties;
  final DropDownQuestionProperties dropdownProperties;

  DropDownQuestion({required this.question,required this.defaultProperties,required this.dropdownProperties});
}