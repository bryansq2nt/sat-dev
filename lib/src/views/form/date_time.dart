// import 'package:flutter/material.dart';
// import 'package:flutter_form_builder/flutter_form_builder.dart';
// import 'package:form_builder_validators/form_builder_validators.dart';
// import 'package:sat/src/models/form/questions/date.dart';
// import 'package:sat/src/utilities/screenSize.dart';
//
// class DateTimeFieldWidget extends StatelessWidget {
//   final DateQuestion question;
//
//   const DateTimeFieldWidget({Key? key,required this.question}) : super(key: key);
//
//
//   DateTime? getDate(){
//     if(question.answer != null){
//       if(question.answer is String){
//         return DateTime.tryParse(question.answer.toString());
//       } else if(question.answer is DateTime){
//         return question.answer;
//       }
//     }
//     return null;
//   }
//
//
//
//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: EdgeInsets.symmetric(vertical: 2 * SizeConfig.blockSizeVertical),
//       child: Column(
//         mainAxisAlignment: MainAxisAlignment.start,
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Row(
//             children: [
//               Expanded(child: Text(question.questionTitle, style: const TextStyle(color: Color(0xff8480ae), fontSize: 14, fontWeight: FontWeight.w400),)),
//               Text(
//                 question.required ? "(*)" : "",
//                 style: const TextStyle(color: Colors.red),
//               )
//             ],
//           ),
//           const SizedBox(height: 5.0,),
//           FormBuilderDateTimePicker(
//             enabled: question.enabled,
//             initialValue: getDate(),
//             name: '${question.questionId}',
//             onChanged: (val) => question.answer = val,
//             onSaved: (val) => question.answer = val,
//             inputType: InputType.both,
//             validator: question.required ? FormBuilderValidators.required(context,errorText:
//             'Requerido',) : null,
//             decoration: InputDecoration(
//
//                 enabledBorder: OutlineInputBorder(
//                     borderSide: const BorderSide(color: Color(0xffcfe2ff)),
//                     borderRadius: BorderRadius.circular(15.0)
//                 ),
//                 focusedBorder: OutlineInputBorder(
//                     borderSide: const BorderSide(color: Color(0xffcfe2ff)),
//                     borderRadius: BorderRadius.circular(15.0)
//                 ),
//                 border: OutlineInputBorder(
//                     borderSide: const BorderSide(color: Color(0xffcfe2ff)),
//                     borderRadius: BorderRadius.circular(15.0)
//                 )
//             ),
//             initialDate: DateTime.now(),
//             // initialValue: DateTime.now(),
//             // enabled: true,
//           ),
//         ],
//       ),
//     );
//   }
// }
//
//
