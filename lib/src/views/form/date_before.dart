// import 'package:flutter/material.dart';
// import 'package:flutter_form_builder/flutter_form_builder.dart';
// import 'package:form_builder_validators/form_builder_validators.dart';
// import 'package:sat/src/models/form/questions/date.dart';
// import 'package:sat/src/utilities/screenSize.dart';
//
//
// class DateBeforeFieldWidget extends StatefulWidget {
//   const DateBeforeFieldWidget({Key? key,required this.question, required this.formKey}) : super(key: key);
//
//   final DateQuestion question;
//   final GlobalKey<FormBuilderState> formKey;
//
//   @override
//   State<DateBeforeFieldWidget> createState() => _DateBeforeFieldWidgetState();
// }
//
// class _DateBeforeFieldWidgetState extends State<DateBeforeFieldWidget> {
//   final TextEditingController _controller = TextEditingController();
//
//   DateTime? getDate(){
//     if(widget.question.answer != null){
//       if(widget.question.answer is String){
//         return DateTime.tryParse(widget.question.answer.toString());
//       } else if(widget.question.answer is DateTime){
//         return widget.question.answer;
//       }
//     }
//     return null;
//   }
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
//               Expanded(child: Text(widget.question.questionTitle, style: const TextStyle(color: Color(0xff8480ae), fontSize: 14, fontWeight: FontWeight.w400),)),
//               Text(
//                 widget.question.required  ? "(*)" : "",
//                 style: const TextStyle(color: Colors.red),
//               ),
//
//             ],
//           ),
//           const SizedBox(height: 5.0,),
//           FormBuilderDateTimePicker(
//             controller: _controller,
//
//             initialEntryMode: DatePickerEntryMode.calendar,
//             enabled: widget.question.enabled,
//             initialValue: getDate(),
//             name: '${widget.question.questionId}',
//             onChanged: (val) => widget.question.answer = val,
//             onSaved: (val) => widget.question.answer = val,
//             inputType: InputType.date,
//             lastDate: DateTime.now(),
//             validator: widget.question.required ? FormBuilderValidators.required(context,errorText:
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
//                 ),
//               suffixIcon: IconButton(
//                 icon: const Icon(Icons.clear,color: Colors.grey,),
//                 onPressed: (){
//
//                   setState(() {
//                     _controller.clear();
//                     widget.question.answer = null;
//                   });
//                 },
//               ),
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
