import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sat/src/models/user.dart';
import 'package:sat/src/providers/auth.dart';
import 'package:sat/src/providers/bottom_bar.dart';
import 'package:sat/src/providers/case_processing.dart';
import 'package:sat/src/views/case_processing/add.dart';
import 'package:sat/src/views/case_processing/table.dart';
import 'package:sat/src/views/home/components/bottom_bar.dart';

class CaseProcessingView extends StatefulWidget {
  @override
  _CaseProcessingViewState createState() => _CaseProcessingViewState();
}

class _CaseProcessingViewState extends State<CaseProcessingView> {

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    final provider = Provider.of<CaseProcessingProvider>(context,listen: false);
    provider.init();

  }

  @override
  Widget build(BuildContext context) {
    final List<Role> _roles = Provider.of<AuthProvider>(context).user?.roles ?? [];

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Color(0xff0a58ca),),
          onPressed: (){
            final bottomBarProvider = Provider.of<BottomBarProvider>(context,listen: false);
            bottomBarProvider.onTap(context: context, index: 0);
          },
        ),
        actions: [
          _roles.singleWhere((element) => element.roleId == 2 || element.roleId == 3) != null ? InkWell(
            onTap: () async {

              final added = await Navigator.pushNamed(context, "/addCaseProcessing");
              if(added == true){
                final provider = Provider.of<CaseProcessingProvider>(context,listen: false);
                provider.get();
              }
            },
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                  decoration: BoxDecoration(
                      color: Color(0xff0a58ca),
                      borderRadius: BorderRadius.circular(10.0)
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Icon(Icons.add, color: Colors.white, size: 15.0,),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text("Nueva", style: TextStyle(color: Colors.white),),
                      )
                    ],
                  )
              ),
            ),
          ) : Container()
        ],
        backgroundColor: Colors.white,
        centerTitle: true,
        title: Text("Tramitaci??n de Casos", style: TextStyle(color: Color(0xff1f0757)),),
      ),
      backgroundColor: Color(0xFFe2e9fe),
      body: SafeArea(
          child:SingleChildScrollView(child: Center(child: CaseProcessingTableWidget()))
      ),
      bottomNavigationBar: BottomBarWidget(),
      // floatingActionButton: _roles.singleWhere((element) => element.roleId == 2 || element.roleId == 3, orElse: () => null) != null ? FloatingActionButton(
      //   backgroundColor: Color(0xff0a58ca),
      //   child: IconButton(
      //     icon: Icon(Icons.save_alt,color: Colors.white,),
      //     onPressed: () => Navigator.pushNamed(context, '/locallyCaseProcessing'),
      //   ),
      // ) : Container(),
    );
  }
}
