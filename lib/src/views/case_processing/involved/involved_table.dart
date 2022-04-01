

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sat/src/models/user.dart';
import 'package:sat/src/providers/auth.dart';
import 'package:sat/src/services/case_processing.dart';
import 'package:sat/src/services/save_locally.dart';
import 'package:sat/src/utilities/screenSize.dart';
import 'package:sat/src/views/case_processing/involved/add.dart';

import '../../../models/form/form_v1.dart';

class InvolvedTableWidget extends StatefulWidget {
  final int caseId;
  final bool enabled;


  const InvolvedTableWidget({required this.caseId,required this.enabled});

  @override
  _InvolvedTableWidgetState createState() => _InvolvedTableWidgetState();
}

class _InvolvedTableWidgetState extends State<InvolvedTableWidget> {
  List<Role> _roles = [];
  bool _canEdit = false;

  bool loading = true;
  bool error = false;

  List<FormModel>? _involved = [];


  Future<void> getInvolved() async {
    setState(() {
      loading = true;
      error = false;
    });

    _involved =
        await CaseProcessingService().getLocallyInvolvedForms(widget.caseId);

    if (this._involved == null) {
      error = true;
    }

    loading = false;

    setState(() {});
  }

  Future<void> _openInvolvedForm(int? idPersona) async {
    final result = await Navigator.pushReplacementNamed(context, "/addInvolved",arguments: [idPersona, widget.caseId,widget.enabled,]);

    if (result == true) {
      getInvolved();
    }
  }

  Future<FormModel?> getFormToFill() async {
    FormModel? involvedForm =
        await CaseProcessingService().getInvolvedFormToFill();
    return involvedForm;
  }

  @override
  void initState() {
    getInvolved();
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
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            color: Color(0xFFf1f2fb),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _tableOption("Nombre Completo"),
                //_tableOption("Caso"),
                _tableOption("Relacion"),
               _tableOption( widget.enabled ? "Modificar" : "Ver") ,
              ],
            ),
          ),
          loading
              ? _loading()
              : error
                  ? _error()
                  : _body(),
         widget.enabled ? Container(
            width: SizeConfig.screenWidth * 0.4,
            height: 100,
            child: Padding(
              padding: EdgeInsets.symmetric(
                  horizontal: 0.5 * SizeConfig.blockSizeHorizontal,
                  vertical: 3 * SizeConfig.blockSizeVertical),
              child: ElevatedButton(
                  style: ElevatedButton.styleFrom(primary: Color(0xff0a58ca)),
                  onPressed: () {
                    _openInvolvedForm(null);
                  },
                  child: Text(" + ")),
            ),
          ) : Container()
        ],
      ),
    );
  }

  Widget _body() {
    if (_involved != null && _involved!.isEmpty) {
      return Padding(
        padding:  EdgeInsets.only(top: 3 * SizeConfig.blockSizeVertical),
        child: Center(
          child: Column(
            children: [
              Text("No se encontraron involucrados."),
              IconButton(
                icon: Icon(Icons.autorenew),
                onPressed: getInvolved,
              )
            ],
          ),
        ),
      );
    }
    return RefreshIndicator(
      onRefresh: getInvolved,
      child: Container(
          height: SizeConfig.screenHeight * 0.35,
          child: ListView.builder(
            physics: AlwaysScrollableScrollPhysics(),
            shrinkWrap: true,
            itemCount: this._involved?.length,
            itemBuilder: (context, i) {
              return _tableData(index: i);
            },
          )),
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

  Widget _tableData({required int index}) {
    String fullName = "N/A";
    String relacion = "N/A";

    if(this._involved?[index].sections[1].questions[0].answer != null && this._involved?[index].sections[1].questions[1].answer != null){
      fullName = "${this._involved?[index].sections[1].questions[0].answer} ${this._involved?[index].sections[1].questions[1].answer}";
    }
    else if(this._involved?[index].sections[1].questions[0].answer == null && this._involved?[index].sections[1].questions[1].answer != null)
    {
      fullName = "${this._involved?[index].sections[1].questions[1].answer}";
    }
    else if(this._involved?[index].sections[1].questions[0].answer != null && this._involved?[index].sections[1].questions[1].answer == null)
    {
      fullName = "${this._involved?[index].sections[1].questions[0].answer}";
    }

    switch(this._involved?[index].sections[0].questions[0].answer){
      case "D":
        relacion = "Denunciante";
        break;
      case "V":
        relacion = "Victima";
        break;
      case "A":
        relacion = "Denunciante/Victima";
        break;
      default:
        relacion = "N/A";
        break;
    }

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
            child: Text(fullName),

          ),
          Container(
            width: 20 * SizeConfig.blockSizeHorizontal,
            padding: EdgeInsets.all(10.0),
            alignment: Alignment.center,
            child: Text(relacion),
          ),
          Row(
            children: [
              Container(
                width: 10 * SizeConfig.blockSizeHorizontal,
                padding: EdgeInsets.all(5.0),
                alignment: Alignment.center,
                child: IconButton(
                  onPressed: () {
                    _openInvolvedForm(this._involved?[index].formId);
                  },
                  icon: Icon(
                    widget.enabled ? Icons.settings : Icons.remove_red_eye,
                    color: Colors.black,
                  ),
                ),
              ),
              widget.enabled
                  ?  Container(
                  width: 10 * SizeConfig.blockSizeHorizontal,

                  child: IconButton(
                    icon: Icon(Icons.delete, color: Colors.red,),
                    onPressed: () async {
                      if(_canEdit){

                        AwesomeDialog(
                            isDense: true,
                            context: context,
                            dialogType: DialogType.QUESTION,
                            padding: EdgeInsets.all(20.0),
                            animType: AnimType.BOTTOMSLIDE,
                            title: "SAT PDDH",
                            desc: "Esta seguro que desea remover al involucrado?",
                            btnOkOnPress: () async {
                              await SaveLocallyService().deleteFromLocal(listName: "case_involved_${this._involved?[index].formId}",form: this._involved![index]);
                              getInvolved();
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
              ) : Container()
            ],
          )



        ],
      ),
    );
  }

  Widget _loading() {
    return Padding(
      padding:  EdgeInsets.only(top: 3 * SizeConfig.blockSizeVertical),
      child: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }

  Widget _error() {
    return Center(
      child: Padding(
        padding: EdgeInsets.symmetric(
            horizontal: 5 * SizeConfig.blockSizeHorizontal,
            vertical: 2 * SizeConfig.blockSizeVertical),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Lo sentimos ha ocurrido un error al intentar la lista de involucrados.",
              style: TextStyle(
                  fontWeight: FontWeight.bold, color: Color(0xff1f0757)),
              textAlign: TextAlign.center,
            ),
            IconButton(
              icon: Icon(Icons.autorenew),
              onPressed: getInvolved,
            )
          ],
        ),
      ),
    );
  }
}
