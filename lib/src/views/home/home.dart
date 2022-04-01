import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sat/src/models/user.dart';
import 'package:sat/src/providers/auth.dart';
import 'package:sat/src/providers/banners.dart';
import 'package:sat/src/providers/bottom_bar.dart';
import 'package:sat/src/providers/crisis_attention.dart';
import 'package:sat/src/providers/early_warning.dart';
import 'package:sat/src/utilities/screenSize.dart';
import 'package:sat/src/views/home/components/bottom_bar.dart';
import 'package:sat/src/views/home/components/carousel.dart';

class HomeView extends StatefulWidget {
  @override
  _HomeViewState createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    final bottomBarProvider = Provider.of<BottomBarProvider>(context, listen: false);
    /*Future.delayed(Duration(milliseconds: 500),() {
    bottomBarProvider.onTap(index: 0,context: context);
    });*/
    final earlyWarningProvider = Provider.of<EarlyWarningProvider>(context,listen: false);
    if(earlyWarningProvider.status == EarlyWarningStatus.NotReady) earlyWarningProvider.init();

    final crisisAttentionProvider = Provider.of<CrisisAttentionProvider>(context,listen: false);
    if(crisisAttentionProvider.status == CrisisAttentionStatus.NotReady) crisisAttentionProvider.init();

    final bannersProvider = Provider.of<BannersProvider>(context,listen: false);
    if(bannersProvider.status == BannersStatus.NotReady) bannersProvider.init();

  }
  @override
  Widget build(BuildContext context) {

    final List<Role> _roles = Provider.of<AuthProvider>(context).user?.roles ?? [];
    final UserModel? user = Provider.of<AuthProvider>(context, listen: false).user;

    return Scaffold(

      body: SafeArea(
        child: Stack(
          alignment: Alignment.center,
          children: [
            Align(
              alignment: Alignment.topCenter,
              child: Container(
                width: double.infinity,
                child: Container(
                  height: 13 * SizeConfig.blockSizeHorizontal,
                  child: Card(
                    child:  Padding(
                      padding: EdgeInsets.symmetric(horizontal: 10 * SizeConfig.blockSizeHorizontal, vertical: 1 * SizeConfig.blockSizeVertical),
                      child: Image.asset('assets/images/logo-header.png', fit: BoxFit.contain,alignment: Alignment.centerLeft,),
                    ),
                  ),
                ),
              ),
            ),
            Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    SizedBox(height: 10 * SizeConfig.blockSizeVertical,),
                    CarouselWidget(),
                    SizedBox(height: 15 * SizeConfig.blockSizeVertical,),

                   _roles.singleWhere((element) => element.roleId == 2 || element.roleId == 3) != null ? Container(
                      width: SizeConfig.screenWidth * 0.8,
                      child: Column(
                        children: [
                          user?.modules.singleWhere((element) => element.moduleId == 1) != null ? ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                  primary: Color(0xFF0036B4)
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                children: [
                                  Icon(Icons.notifications, color: Colors.white,),
                                  Text("Agregar Alerta Temprana", style: TextStyle(color: Colors.white),)
                                ],
                              ),
                              onPressed: (){
                                final bottomBarProvider = Provider.of<BottomBarProvider>(context, listen: false);
                                bottomBarProvider.onTap(context: context, index: 1);
                                Navigator.pushNamed(context, '/addEarlyWarning');
                              }
                          ) : Container(),
                          user?.modules.singleWhere((element) => element.moduleId == 2) != null ? ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                  primary: Color(0xFFF2B10F)
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                children: [
                                  Icon(Icons.api, color: Colors.black,),
                                  Text("Agregar Atención A Crisis", style: TextStyle(color: Colors.black),)
                                ],
                              ),
                              onPressed: (){
                                final bottomBarProvider = Provider.of<BottomBarProvider>(context, listen: false);
                                bottomBarProvider.onTap(context: context, index: 2);
                                Navigator.pushNamed(context, '/addCrisisAttention');
                              }
                          ) : Container(),
                        ],
                      )
                    ) : Container(),

                  ],
                )
            ),
          ],
        )
      ),
      bottomNavigationBar: BottomBarWidget(),
    );
  }
}
