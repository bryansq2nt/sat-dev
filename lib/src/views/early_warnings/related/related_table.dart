import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sat/src/models/form/form_v1.dart';
import 'package:sat/src/models/user.dart';
import 'package:sat/src/providers/auth.dart';
import 'package:sat/src/providers/early_warning.dart';
import 'package:sat/src/services/early_warnings.dart';
import 'package:sat/src/utilities/screenSize.dart';


class EarlyWarningsRelatedTableWidget extends StatefulWidget {
  final int formId;

  const EarlyWarningsRelatedTableWidget({Key? key,required this.formId}) : super(key: key);

  @override
  _EarlyWarningsRelatedTableWidgetState createState() => _EarlyWarningsRelatedTableWidgetState();
}

class _EarlyWarningsRelatedTableWidgetState extends State<EarlyWarningsRelatedTableWidget> {

  bool _isLoading = false;

  List<FormModel> _relatedForms = [];

  Future<void> _getRelatedForms() async {
    setState(() {
      _isLoading = true;
    });

    this._relatedForms = await EarlyWarningsService().getRelatedForms(formId: widget.formId) ?? [];

    setState(() {
      _isLoading = false;
    });
  }

  Future<void> _removeRelatedForm(int childId) async {
    AwesomeDialog(
        isDense: true,
        context: context,
        dialogType: DialogType.QUESTION,
        padding: EdgeInsets.all(20.0),
        animType: AnimType.BOTTOMSLIDE,
        title: "SAT PDDH",
        desc: "Esta seguro que desea remover el caso relacionado ?",
        btnOkOnPress: () async {
          setState(() {
            _isLoading = true;
          });

          bool removed = await EarlyWarningsService().removeRelatedForm(fatherId: widget.formId, childId: childId);

          if(removed){
            this._relatedForms = await EarlyWarningsService().getRelatedForms(formId: widget.formId) ?? [];
            final provider = Provider.of<EarlyWarningProvider>(
                context,
                listen: false);
            provider.get();
          } else {
            AwesomeDialog(
                isDense: true,
                context: context,
                dialogType: DialogType.ERROR,
                padding: EdgeInsets.all(20.0),
                animType: AnimType.BOTTOMSLIDE,
                title: "SAT PDDH",
                desc: "Lo sentimos ha ocurrido un error al intentar remover el caso de la lista de casos relacionados.",
                btnOkOnPress: () {},
                btnOkColor: Color(0xFFF2B10F)
            )..show();
          }

          setState(() {
            _isLoading = false;
          });
        },
        btnCancelOnPress: () {
          return;
        },
        btnOkColor: Color(0xFFF2B10F),
        btnCancelText: "Cancelar",
        btnOkText: "Continuar"
    )..show();

  }

  @override
  void initState() {
    _getRelatedForms();
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    final List<Role> _roles = Provider.of<AuthProvider>(context).user?.roles ?? [];

    return Container(
      margin: EdgeInsets.all(2 * SizeConfig.safeBlockVertical),

      child: Card(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 1 * SizeConfig.blockSizeHorizontal),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,

            children: [
              SizedBox(height: 2 * SizeConfig.blockSizeVertical,),
              //SearchBarWidget(),
              Container(
                color: Color(0xFFf1f2fb),
                child: _roles.singleWhere((element) => element.roleId == 3 || element.roleId == 4) != null
                    ? Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _tableOption("# CASO"),
                    _tableOption("Ver"),
                    _tableOption("Remover")
                  ],
                ) : Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _tableOption("# CASO"),
                    _tableOption("Ver")
                  ],
                ),
              ),
              !_isLoading ? _body() : _loading(),
              SizedBox(height: 2 * SizeConfig.blockSizeVertical,),

            ],
          ),
        ),
      ),
    );
  }

  Widget _loading(){
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 5 * SizeConfig.blockSizeVertical),
      child: Center( child: CircularProgressIndicator(),),
    );
  }

  Widget _body (){
    return Container(
      child: _relatedForms.isNotEmpty ? Padding(
        padding: EdgeInsets.symmetric(horizontal: 1 * SizeConfig.blockSizeHorizontal),
        child: RefreshIndicator(
          onRefresh: _getRelatedForms,
          child: Container(
            height: 0.60 * SizeConfig.screenHeight,
            child: ListView.builder(
              physics: AlwaysScrollableScrollPhysics(),
              shrinkWrap: true,
              itemCount:  _relatedForms.length,
              itemBuilder: (context,i){
                return _tableData(form: _relatedForms[i], index: i);
              },
            ),
          ),
        ),
      ) : Padding(
        padding: EdgeInsets.symmetric(vertical: 5 * SizeConfig.blockSizeVertical),
        child: Center(
            child: Column(
              children: [
                Text("No se encontraron registros."),

                Padding(
                  padding: EdgeInsets.only(top: 5 * SizeConfig.blockSizeVertical),
                  child: IconButton(
                    onPressed: _getRelatedForms,
                    icon: Icon(Icons.autorenew),
                  ),
                )
              ],
            )
        ),
      ),
    );
  }

  Widget _tableOption(String title){
    return Container(
      color: Color(0xFFf1f2fb),
      width: 20 * SizeConfig.blockSizeHorizontal,
      padding: EdgeInsets.all(10.0),
      alignment: Alignment.center,
      child: Text(title, style: TextStyle(fontWeight: FontWeight.bold), textAlign: TextAlign.center,),
    );
  }

  Widget _tableData({required FormModel form,required int index}){
    final List<Role> _roles = Provider.of<AuthProvider>(context).user?.roles ?? [];

    return Container(
      color: index.isOdd ? Color(0xFFf1f2fb) : Colors.white,
      padding: EdgeInsets.all(10.0),
      child:_roles.singleWhere((element) => element.roleId == 3 || element.roleId == 4) != null
          ? Row(
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
                  icon: Icon(Icons.remove_red_eye, color: Colors.white,),
                  onPressed: (){
                    Navigator.pushNamed(context, '/showEarlyWarning',arguments: form);

                  },
                )
            ),
          ),
          Container(
            width: 20 * SizeConfig.blockSizeHorizontal,
            padding: EdgeInsets.all(10.0),
            alignment: Alignment.center,
            child: Container(
                decoration: BoxDecoration(
                  color: Colors.redAccent,
                  shape: BoxShape.circle,
                ),
                child: IconButton(
                  icon: Icon(Icons.delete, color: Colors.white,),
                  onPressed: () {
                    _removeRelatedForm(form.formId);
                  },
                )
            ),
          ),


        ],
      ) : Row(
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
                  icon: Icon(Icons.remove_red_eye, color: Colors.white,),
                  onPressed: (){
                    Navigator.pushNamed(context, '/showEarlyWarning',arguments: form);

                  },
                )
            ),
          ),



        ],
      ),
    );
  }
}
