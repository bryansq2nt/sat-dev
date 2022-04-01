import 'package:flutter/material.dart';
import 'package:sat/src/utilities/screenSize.dart';


class SearchBarWidget extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: 2 * SizeConfig.blockSizeVertical, left: 1 * SizeConfig.blockSizeHorizontal),
      child: InkWell(
        onTap: (){
          Navigator.pushNamed(context, '/searchCrisisAttention');
        },
        child: Container(
          child: Row(
            children: [
              Text("Buscar: ", style: TextStyle(color: Color(0xff1f0757), fontWeight: FontWeight.bold)),
              SizedBox(width: 10,),
              Container(
                width: 0.2 * SizeConfig.screenWidth,
                height: 0.03 * SizeConfig.screenHeight,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5.0),
                    border: Border.all(color: Colors.black12)
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
