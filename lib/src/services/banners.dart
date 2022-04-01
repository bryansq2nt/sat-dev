import 'package:dio/dio.dart';
import 'package:sat/src/models/banner.dart';
import 'package:sat/src/providers/api.dart';


class BannersServices {


  Future<List<BannerModel>?> getBanners() async {
    try {
      Response? response = await ApiProvider().makeRequest(type: MethodType.GET,endPoint: '/banner',okCode: 200);

      return List<BannerModel>.from(response?.data['bannerList'].map((element) => BannerModel.fromJson(element)));
    } catch (e){
      return null;
    }

  }
}