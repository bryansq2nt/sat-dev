import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sat/src/models/user.dart';
import 'package:sat/src/providers/auth.dart';
import 'package:sat/src/providers/early_warning.dart';
import 'related_table.dart';
import 'package:sat/src/views/home/components/bottom_bar.dart';

class RelatedEarlyWarningsView extends StatefulWidget {
  final int formId;

  const RelatedEarlyWarningsView({Key? key,required this.formId}) : super(key: key);
  @override
  _RelatedEarlyWarningsViewState createState() => _RelatedEarlyWarningsViewState();
}

class _RelatedEarlyWarningsViewState extends State<RelatedEarlyWarningsView> {

  @override
  Widget build(BuildContext context) {
    final List<Role> _roles = Provider.of<AuthProvider>(context).user?.roles ?? [];

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Color(0xff0a58ca),),
          onPressed: (){
            Navigator.pop(context);
          },
        ),
        actions: [
          _roles.singleWhere((element) => element.roleId == 3 || element.roleId == 4) != null
              ? IconButton(
            icon: Icon(Icons.add, color: Color(0xff0a58ca),),
            onPressed:  () async {
              final added = await Navigator.pushNamed(context, '/addRelatedEarlyWarning', arguments: widget.formId);
              if(added == true){
                final provider = Provider.of<EarlyWarningProvider>(context,listen: false);
                provider.get();
              }
            },
          )
              : Container()        ],
        backgroundColor: Colors.white,
        centerTitle: true,
        title: Text("Casos Relacionados", style: TextStyle(color: Color(0xff1f0757)),),
      ),
      backgroundColor: Color(0xFFe2e9fe),
      body: SafeArea(
          child:SingleChildScrollView(child: Center(child: EarlyWarningsRelatedTableWidget(formId: widget.formId,)))
      ),
      bottomNavigationBar: BottomBarWidget(),

    );
  }
}
