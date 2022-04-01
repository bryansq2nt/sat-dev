

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class OnBoardingProvider with ChangeNotifier {
  bool _shown = false;

  bool get shown => _shown;

  OnBoardingProvider(){
    init();
  }

  init () async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    _shown = prefs.getBool('shown') ?? false;
    notifyListeners();
  }

  skip() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool('shown',true);
    _shown = true;
    notifyListeners();
  }

}