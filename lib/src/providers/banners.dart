

import 'package:flutter/material.dart';
import 'package:sat/src/models/banner.dart';
import 'package:sat/src/services/banners.dart';

enum BannersStatus { NotReady, Getting, Ready, Error }

class BannersProvider with ChangeNotifier {
  List<BannerModel> _banners = [];
  List<BannerModel> get banners => _banners;
  BannersStatus _status = BannersStatus.NotReady;
  BannersStatus get status => _status;

  int _current = 0;
  int get current => _current;

  set current (int index){
    _current = index;
    notifyListeners();
  }


  void init() async {

    _banners = await BannersServices().getBanners() ?? [];
    _status = BannersStatus.Ready;
    notifyListeners();

  }


}