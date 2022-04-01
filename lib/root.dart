import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sat/src/providers/auth.dart';
import 'package:sat/src/providers/onboarding.dart';
import 'package:sat/src/utilities/loading.dart';
import 'package:sat/src/utilities/screenSize.dart';
import 'package:sat/src/views/home/home.dart';
import 'package:sat/src/views/login/login.dart';
import 'package:sat/src/views/onboarding/onboarding.dart';

class Root extends StatefulWidget {
  @override
  _RootState createState() => _RootState();
}

class _RootState extends State<Root> {

  @override
  void initState() {
    super.initState();

  }
  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    AuthProvider authProvider = Provider.of<AuthProvider>(context);
    OnBoardingProvider onBoardingProvider = Provider.of<OnBoardingProvider>(context);

    switch(authProvider.status){
      case Status.Authenticated :
         return HomeView();
        break;
      case Status.Unauthenticated:
        if(onBoardingProvider.shown ){
           return LoginView();
        }
        return OnBoardingView();
        break;
      case Status.Authenticating:
        return LoginView();
        break;
      default:
        return LoadingView();
    }
  }
}
