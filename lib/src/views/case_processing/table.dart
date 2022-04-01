import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sat/src/models/user.dart';
import 'package:sat/src/providers/auth.dart';
import 'package:sat/src/providers/case_processing.dart';
import 'package:sat/src/utilities/screenSize.dart';
import 'package:sat/src/views/case_processing/add.dart';

import '../../models/form/form_v1.dart';

class CaseProcessingTableWidget extends StatefulWidget {
  const CaseProcessingTableWidget({Key? key}) : super(key: key);

  @override
  _CaseProcessingTableWidgetState createState() =>
      _CaseProcessingTableWidgetState();
}

class _CaseProcessingTableWidgetState
    extends State<CaseProcessingTableWidget> {
  final ScrollController _controller = ScrollController();

  final bool _isLoading = false;
  bool _canEdit = false;

  List<Role> _roles = [];

  @override
  void initState() {

    _roles = Provider.of<AuthProvider>(context, listen: false).user?.roles ?? [];
    _canEdit = _roles.singleWhere(
                (element) => element.roleId == 2 || element.roleId == 3) !=
            null
        ? true
        : false;

    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }



  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<CaseProcessingProvider>(context);

    return Container(
      margin: EdgeInsets.all(2 * SizeConfig.safeBlockVertical),
      child: Card(
        child: Padding(
          padding: EdgeInsets.symmetric(
              horizontal: 1 * SizeConfig.blockSizeHorizontal),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                height: 2 * SizeConfig.blockSizeVertical,
              ),
              //SearchBarWidget(),
              Container(
                color: Color(0xFFf1f2fb),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _tableOption("# CASO"),
                    _tableOption("Ver"),
                    _canEdit ? _tableOption("Modificar") : Container(),
                  ],
                ),
              ),

              provider.status == CaseProcessingStatus.Ready
                  ? _body(provider)
                  : _loading(),
              SizedBox(
                height: 2 * SizeConfig.blockSizeVertical,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _loading() {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 5 * SizeConfig.blockSizeVertical),
      child: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }

  Widget _body(CaseProcessingProvider provider) {
    return Container(
      child: provider.forms.isNotEmpty
          ? Padding(
              padding: EdgeInsets.symmetric(
                  horizontal: 1 * SizeConfig.blockSizeHorizontal),
              child: RefreshIndicator(
                onRefresh: provider.get,
                child: Container(
                  height: 0.60 * SizeConfig.screenHeight,
                  child: ListView.builder(
                    controller: _controller,
                    physics: AlwaysScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: _isLoading
                        ? provider.forms.length + 1
                        : provider.forms.length,
                    itemBuilder: (context, i) {
                      if (provider.forms.length == i)
                        return Center(child: CircularProgressIndicator());

                      return _tableData(form: provider.forms[i],index: i);
                    },
                  ),
                ),
              ),
            )
          : Padding(
              padding: EdgeInsets.symmetric(
                  vertical: 5 * SizeConfig.blockSizeVertical),
              child: Center(
                  child: Column(
                children: [
                  Text("No se encontraron registros."),
                  Padding(
                    padding:
                        EdgeInsets.only(top: 5 * SizeConfig.blockSizeVertical),
                    child: IconButton(
                      onPressed: provider.get,
                      icon: Icon(Icons.autorenew),
                    ),
                  )
                ],
              )),
            ),
    );
  }

  Widget _tableOption(String title) {
    return Container(
      color: Color(0xFFf1f2fb),
      width: 20 * SizeConfig.blockSizeHorizontal,
      padding: EdgeInsets.all(10.0),
      alignment: Alignment.center,
      child: Text(
        title,
        style: TextStyle(fontWeight: FontWeight.bold),
        textAlign: TextAlign.center,
      ),
    );
  }

  Widget _tableData({required FormModel form,required int index}) {
    final provider = Provider.of<CaseProcessingProvider>(context);

    return Container(
      color: index.isOdd ? Color(0xFFf1f2fb) : Colors.white,
      padding: EdgeInsets.all(10.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Container(
            width: 20 * SizeConfig.blockSizeHorizontal,
            padding: EdgeInsets.all(10.0),
            alignment: Alignment.center,
            child: Text("${form.formId}"),
          ),
          Container(
            width: 20 * SizeConfig.blockSizeHorizontal,
            padding: EdgeInsets.all(10.0),
            alignment: Alignment.center,
            child: Container(
                decoration: BoxDecoration(
                  color: Color(0xff8480ae),
                  shape: BoxShape.circle,
                ),
                child: IconButton(
                  icon: Icon(
                    Icons.remove_red_eye,
                    color: Colors.white,
                  ),
                  onPressed: () {
                    Navigator.pushNamed(context, "/showCaseProcessing", arguments: form.formId,);
                  },
                )),
          ),
          _canEdit
              ? Container(
                  width: 20 * SizeConfig.blockSizeHorizontal,
                  padding: EdgeInsets.all(10.0),
                  alignment: Alignment.center,
                  child: Container(
                      decoration: BoxDecoration(
                        color: Color(0xffffcd39),
                        shape: BoxShape.circle,
                      ),
                      child: IconButton(
                        icon: Icon(
                          Icons.settings,
                          color: Colors.black,
                        ),
                        onPressed: () async {
                          final sent = await Navigator.pushNamed(context, "/addCaseProcessing", arguments:form.formId);
                          if (sent == true){
                            provider.get();
                          }
                        },
                      )),
                )
              : Container(),

          Container(
            width: 20 * SizeConfig.blockSizeHorizontal,
            padding: EdgeInsets.all(10.0),
            alignment: Alignment.center,
            child: Container(
                decoration: BoxDecoration(
                  color: Colors.red,
                  shape: BoxShape.circle,
                ),
                child: IconButton(
                  icon: Icon(Icons.delete, color: Colors.white,),
                  onPressed: () async {
                    if(_canEdit){
                      AwesomeDialog(
                          isDense: true,
                          context: context,
                          dialogType: DialogType.QUESTION,
                          padding: EdgeInsets.all(20.0),
                          animType: AnimType.BOTTOMSLIDE,
                          title: "SAT PDDH",
                          desc: "Esta seguro que desea eliminar la información del caso?",
                          btnOkOnPress: () async {
                            await provider.deleteFromLocal(listName: "case_processing",form: form);
                            provider.get();
                          },
                          btnCancelOnPress: () {
                            return;
                          },
                          btnOkColor: Color(0xFFF2B10F),
                          btnCancelText: "Cancelar",
                          btnOkText: "Continuar"
                      )..show();

                    }

                  },
                )
            ),
          ),


        ],
      ),
    );
  }


}


