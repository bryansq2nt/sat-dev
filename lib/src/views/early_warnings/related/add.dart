import 'package:awesome_dialog/awesome_dialog.dart';
// import 'package:flappy_search_bar/flappy_search_bar.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sat/src/models/form/form_v1.dart';
import 'package:sat/src/providers/early_warning.dart';
import 'package:sat/src/services/early_warnings.dart';
import 'package:sat/src/utilities/screenSize.dart';

class AddRelatedEarlyWarningView extends StatefulWidget {
  final int formId;

  const AddRelatedEarlyWarningView({Key? key,required this.formId}) : super(key: key);
  @override
  _AddRelatedEarlyWarningViewState createState() =>
      _AddRelatedEarlyWarningViewState();
}

class _AddRelatedEarlyWarningViewState
    extends State<AddRelatedEarlyWarningView> {
  // final SearchBarController<FormModel> _searchBarController =
  //     SearchBarController();
  late String lastSearch;
  bool loading = false;


  Future<List<FormModel>> _searchForm(String text) async {
    List<FormModel>? forms = await EarlyWarningsService()
        .searchRelatedForm(fatherId: widget.formId, delegate: text);

    if (forms == null) {
      throw Error();
    }

    setState(() {
      lastSearch = text;
    });
    return forms;
  }

  Future<void> _addToRelatedCases(int formId) async {
    setState(() {
      loading = true;
    });

    bool added = await EarlyWarningsService().addToRelatedForms(fatherId: widget.formId,childId: formId);

    added ? related() : error();

    setState(() {
      loading = false;
    });

  }

  related(){
    final provider = Provider.of<EarlyWarningProvider>(
        context,
        listen: false);
    provider.get();
    AwesomeDialog(
        isDense: true,
        context: context,
        dialogType: DialogType.SUCCES,
        padding: EdgeInsets.all(20.0),
        animType: AnimType.BOTTOMSLIDE,
        title: "SAT PDDH",
        desc: "Caso relacionado correctamente.",
        btnOkOnPress: () {},
        btnOkColor: Color(0xFFF2B10F)
    )..show();
  }

  error(){
    AwesomeDialog(
        isDense: true,
        context: context,
        dialogType: DialogType.ERROR,
        padding: EdgeInsets.all(20.0),
        animType: AnimType.BOTTOMSLIDE,
        title: "SAT PDDH",
        desc: "Lo sentimos ha ocurrido un error al intentar relacionar los casos.",
        btnOkOnPress: () {},
        btnOkColor: Color(0xFFF2B10F)
    )..show();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: Color(0xff0a58ca),
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        backgroundColor: Colors.white,
        centerTitle: true,
        title: Text(
          "Agregar Caso",
          style: TextStyle(color: Color(0xff1f0757)),
        ),
      ),
      backgroundColor: Colors.white,
      // body: SafeArea(
      //   child: !loading ?  SearchBar<FormModel>(
      //     minimumChars: 1,
      //     searchBarPadding: EdgeInsets.symmetric(horizontal: 10),
      //     headerPadding: EdgeInsets.symmetric(horizontal: 10),
      //     listPadding: EdgeInsets.symmetric(horizontal: 10),
      //     onSearch: _searchForm,
      //     searchBarController: _searchBarController,
      //     placeHolder: Center(
      //       child: Text(
      //         "Buscar Caso",
      //         style: TextStyle(
      //             color: Color(0xff1f0757), fontWeight: FontWeight.bold),
      //       ),
      //     ),
      //     //cancellationText: ,
      //     cancellationWidget:
      //         Text("Cancelar", style: TextStyle(fontWeight: FontWeight.bold)),
      //     emptyWidget: Center(
      //       child: Container(
      //           width: 80 * SizeConfig.blockSizeHorizontal,
      //           child: Text("No se encontraron resultados.",
      //               textAlign: TextAlign.center,
      //               style: TextStyle(
      //                   color: Color(0xff1f0757),
      //                   fontWeight: FontWeight.bold))),
      //     ),
      //
      //     onError: (error) {
      //       return Center(
      //         child: Container(
      //             width: 80 * SizeConfig.blockSizeHorizontal,
      //             child: Text(
      //               "Lo sentimos ha ocurrido un error al intentar procesar su busqueda.",
      //               textAlign: TextAlign.center,
      //               style: TextStyle(
      //                   color: Color(0xff1f0757), fontWeight: FontWeight.bold),
      //             )),
      //       );
      //     },
      //     onItemFound: (FormModel form, int index) {
      //       return _tableData(form: form, index: index);
      //     },
      //   ) : Center(child: CircularProgressIndicator(),),
      // ),
    );
  }

  Widget _tableData({required FormModel form, required int index}) {
    return Column(
      children: [
        Container(
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
                      color: Color(0xff0a58ca),
                      shape: BoxShape.circle,
                    ),
                    child: IconButton(
                      icon: Icon(Icons.add, color: Colors.white,),
                      onPressed: (){
                        _addToRelatedCases(form.formId);
                      },
                    )
                ),
              ),



            ],
          ),
        ),
        Divider(thickness: 2.0,)
      ],
    );
  }
}
