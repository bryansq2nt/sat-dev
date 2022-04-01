import 'package:flutter/material.dart';

import '../../utilities/screenSize.dart';

class QuestionWidget extends StatelessWidget {
  const QuestionWidget({Key? key, required this.title, required this.required, required this.body}) : super(key: key);
  final String title;
  final bool required;
  final Widget body;


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
              Expanded(child: Text(title, style: const TextStyle(color: Color(0xff8480ae), fontSize: 14, fontWeight: FontWeight.w400),)),
              Text(
                required ? "(*)" : "",
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
