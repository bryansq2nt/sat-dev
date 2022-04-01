

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sat/src/models/user.dart';
import 'package:sat/src/providers/auth.dart';

class BottomBarProvider with ChangeNotifier {

  bool firstTime = true;

  int _selectedIndex = 0;

  int get selectedIndex => _selectedIndex;

  void logOut(){
    _selectedIndex = 0;
    notifyListeners();
  }

  void onTap({required int index,required BuildContext context}){
    firstTime = false;

    if(_checkRoute(context)){
      AwesomeDialog(
          isDense: true,
          context: context,
          dialogType: DialogType.QUESTION,
          padding: const EdgeInsets.all(20.0),
          animType: AnimType.BOTTOMSLIDE,
          title: "SAT PDDH",
          desc: "Esta seguro que desea salir?",
          btnOkText: "Si",
          btnCancelText: "No",
          btnOkOnPress: () {
            _changeView(context: context,index: index);
          },
          btnCancelOnPress: (){
            return;
          },
          btnOkColor: const Color(0xFFF2B10F)
      ).show();

    } else {
      _changeView(context: context,index: index);
    }

  }

  void _changeView({required int index,required BuildContext context}){
    final UserModel? user = Provider.of<AuthProvider>(context, listen: false).user;
    int lastIndex = _selectedIndex;
    switch(index){
      case 0:
        if(user?.modules.singleWhere((element) => element.moduleId == 3) != null){
          _selectedIndex = index;
          notifyListeners();
          Navigator.pushReplacementNamed(context, '/dashboard');
        } else {
          _accessDenied(context);
        }
        break;
      case 1:
        if(lastIndex != index){
          if(user?.modules.singleWhere((element) => element.moduleId == 1) != null){
            _selectedIndex = index;
            notifyListeners();
            Navigator.pushReplacementNamed(context, '/earlyWarnings');
          }else {
            _accessDenied(context);
          }
        }
        break;
      case 2:
        if(lastIndex != index){
          if(user?.modules.singleWhere((element) => element.moduleId == 2) != null){
            _selectedIndex = index;
            notifyListeners();
            Navigator.pushReplacementNamed(context, '/crisisAttention');
          }else {
            _accessDenied(context);
          }
        }
        break;
      case 3:
        if(lastIndex != index){
          if(user?.modules.singleWhere((element) => element.moduleId == 7) != null){
            _selectedIndex = index;
            notifyListeners();
            Navigator.pushReplacementNamed(context, '/caseProcessing');
          }else {
            _accessDenied(context);
          }

        }
        break;
    }
  }

  void _accessDenied(BuildContext context){
    AwesomeDialog(
      isDense: true,
      context: context,
      dialogType: DialogType.INFO,
      padding: const EdgeInsets.all(20.0),
      animType: AnimType.BOTTOMSLIDE,
      title: "SAT PDDH",
      desc: "Lo sentimos usted no tiene acceso a este modulo.",
      btnOkOnPress: () {},
      btnOkColor: Color(0xFFF2B10F)
    ).show();

  }

  bool _checkRoute(BuildContext context){
    String? routeName = ModalRoute.of(context)?.settings.name;
    List<String> routesToCheck = ["/addEarlyWarning","/modifyEarlyWarning","/addCrisisAttention","/modifyCrisisAttention","/addCaseProcessing","/addInvolved"];

    if(routesToCheck.contains(routeName)){

      return true;
    }

    return false;

  }
}