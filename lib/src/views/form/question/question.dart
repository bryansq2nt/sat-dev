import 'package:flutter/material.dart';
import 'package:sat/src/models/form/properties/default_question_properties.dart';
import 'package:sat/src/models/form/question_model.dart';

import '../../../utilities/screenSize.dart';


class QuestionWidgetV1 extends StatelessWidget {
  final QuestionModel question;
  final DefaultQuestionProperties properties;
  final Widget body;

  QuestionWidgetV1({Key? key,required this.question,required this.properties,required this.body}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 2 * SizeConfig.blockSizeVertical),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(child: Text(question.questionTitle, style: const TextStyle(color: Color(0xff8480ae), fontSize: 14, fontWeight: FontWeight.w400),)),
              Text(
                properties.required ? "(*)" : "",
                style: const TextStyle(color: Colors.red),
              )
            ],
          ),
          const SizedBox(height: 5.0,),
          body
        ],
      ),
    );
  }
}
