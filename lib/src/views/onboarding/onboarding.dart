
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sat/src/providers/onboarding.dart';
import 'package:sat/src/utilities/screenSize.dart';

class OnBoardingView extends StatefulWidget {
  @override
  _OnBoardingViewState createState() => _OnBoardingViewState();
}

class _OnBoardingViewState extends State<OnBoardingView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:Color(0xff0a58ca),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            child: Container(
              width: SizeConfig.screenWidth * 0.8,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 1 * SizeConfig.blockSizeVertical,),

                  Container(
                    child: Image(
                      image: AssetImage("assets/images/logo.png"),
                      height: SizeConfig.safeBlockVertical * 40,
                    ),
                  ),
                  SizedBox(height: 1 * SizeConfig.blockSizeVertical,),

                  Text(
                    "BIENVENIDO/A",
                    style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 3 * SizeConfig.safeBlockVertical),
                  ),
                  SizedBox(height: 1 * SizeConfig.blockSizeVertical,),

                  Text('Esta es la App Móvil de la PPDH que fortalece el Sistema de Alerta Temprana sobre riesgos en determinados escenarios de conflictividad. En esta App se reportan casos sobre conflictos en áreas determinadas que puedan constituir potenciales violaciones a derechos humanos, con el objetivo de accionar decisiones sobre su tratamiento por parte de la institución. Esta herramienta es de uso exclusivo del equipo de la PDDH y actores claves identificados por la institucion.',
                  style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w500,
                      fontSize: 2 * SizeConfig.safeBlockVertical),
                    textAlign: TextAlign.justify,
                  ),
                  SizedBox(height: 2 * SizeConfig.blockSizeVertical,),

                  Container(
                    width: SizeConfig.screenWidth * 0.8,
                    child:    new ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            primary: Color(0xFFF2B10F)
                        ),
                        child:Text("Iniciar", style: TextStyle(color: Colors.black, fontSize: 2 * SizeConfig.safeBlockVertical, fontWeight: FontWeight.bold),),
                        onPressed: (){
                          final provider = Provider.of<OnBoardingProvider>(context, listen: false);
                          provider.skip();
                        }
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
