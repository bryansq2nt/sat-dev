import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sat/src/models/user.dart';
import 'package:sat/src/providers/auth.dart';
import 'package:sat/src/utilities/screenSize.dart';
import 'package:sat/src/views/home/components/bottom_bar.dart';

class ProfileView extends StatefulWidget {
  @override
  _ProfileViewState createState() => _ProfileViewState();
}

class _ProfileViewState extends State<ProfileView> {
  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<AuthProvider>(context);

    return Scaffold(
      backgroundColor: Color(0xFFe2e9fe),
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: () async {
            provider.getUpdateUser(context: context);
          },
          child: provider.user != null ?  SingleChildScrollView(
            physics: AlwaysScrollableScrollPhysics(),
            child: Stack(
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
                      _form(provider.user!)
                    ],
                  ),
                )
              ],
            ),
          ) : Center(child: CircularProgressIndicator(),),
        )
      ),
      bottomNavigationBar: BottomBarWidget(),
    );
  }

  Widget _form(UserModel user){
    return Container(
      child: Column(
        children: [
          _userName(user),
          SizedBox(height:  2 * SizeConfig.blockSizeVertical,),
          Container(
            width: SizeConfig.screenWidth * 0.8,
            child: Card(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 5 * SizeConfig.blockSizeHorizontal, vertical: 3 * SizeConfig.blockSizeVertical),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _entryField('Nombre de usuario', "${user.name}"),
                    _entryField('Correo electrónico', "${user.email}"),
                    _entryField('Sexo', "${user.gender}"),
                    _entryField('Teléfono', "${user.phone}"),


                  ],
                ),
              ),
            ),
          ),
          _logOutButton()
        ],
      ),
    );
  }

  Widget _userName(UserModel user){
    return Container(
      width: SizeConfig.screenWidth * 0.8,
      child: Card(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 5 * SizeConfig.blockSizeHorizontal),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(height: 2 * SizeConfig.blockSizeVertical,),
              Text("${user.name}", style: TextStyle(fontWeight: FontWeight.w500, fontSize: 3 * SizeConfig.safeBlockVertical),),
              SizedBox(height: 1 * SizeConfig.blockSizeVertical,),
              Text("${user.position}", style: TextStyle(color: Colors.black38,fontWeight: FontWeight.w400, fontSize: 2 * SizeConfig.safeBlockVertical),),
              SizedBox(height: 2 * SizeConfig.blockSizeVertical,),

            ],
          ),
        ),
      ),
    );
  }

  Widget _entryField(String title, String value) {
    return Container(
      width: 80 * SizeConfig.blockSizeHorizontal,
     margin: EdgeInsets.symmetric(vertical: 1 * SizeConfig.blockSizeVertical),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title,style: TextStyle(
            color: Colors.grey,
            fontWeight: FontWeight.bold
          ),),
          SizedBox(height: 10,),
          Container(
            decoration: BoxDecoration(
                border: Border.all(color: Colors.transparent),
                borderRadius: BorderRadius.circular(10.0),
              color: Color(0xFFCCEE5FF)
            ),
            child: TextFormField(
              style: TextStyle(
                height: 1.2,
                color: Colors.black,

              ),
              enabled: false,
              decoration: InputDecoration(

                contentPadding: EdgeInsets.all(10.0),
                hintText: value,
                hintStyle: TextStyle(color: Colors.black),
                disabledBorder: InputBorder.none
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget _logOutButton(){
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 5 * SizeConfig.blockSizeHorizontal, vertical: 3 * SizeConfig.blockSizeVertical),
      child: Container(
        width: 77 * SizeConfig.blockSizeHorizontal,
        height: 7 * SizeConfig.blockSizeVertical,
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
              primary: Color(0xff0a58ca)
          ),
          onPressed: (){
            final provider = Provider.of<AuthProvider>(context, listen: false);
            provider.logOut(context);


          },
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text("Salir"),
              SizedBox(width: 1 * SizeConfig.blockSizeHorizontal,),
              Icon(Icons.arrow_forward)
            ],
          ),
        ),
      ),
    );
  }
}
