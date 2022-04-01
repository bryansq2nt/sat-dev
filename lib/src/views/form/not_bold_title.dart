import 'package:flutter/material.dart';
import 'package:sat/src/utilities/screenSize.dart';

class NotBoldTitleWidget extends StatelessWidget {
  final String title;

  const NotBoldTitleWidget({Key? key,required this.title}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      color: const Color(0xffe2e3e5),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
      child: Container(
        width: double.infinity,
        alignment: Alignment.centerLeft,
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Text(
            title,
            style: TextStyle(fontSize: 2 * SizeConfig.safeBlockVertical),
          ),
        ),
      ),
    );
  }
}
