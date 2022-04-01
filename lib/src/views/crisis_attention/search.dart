
import 'package:awesome_dialog/awesome_dialog.dart';
// import 'package:flappy_search_bar/flappy_search_bar.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sat/src/models/form/form_v1.dart';
import 'package:sat/src/providers/bottom_bar.dart';
import 'package:sat/src/services/crisis_attention.dart';
import 'package:sat/src/utilities/screenSize.dart';


class SearchCrisisAttentionView extends StatefulWidget {
  @override
  _SearchCrisisAttentionViewState createState() => _SearchCrisisAttentionViewState();
}

class _SearchCrisisAttentionViewState extends State<SearchCrisisAttentionView> {
  // final SearchBarController<FormModel> _searchBarController = SearchBarController();

  late String lastSearch;

  Future<List<FormModel>> _searchForm(String text) async {

    List<FormModel>? forms = await CrisisAttentionService().searchForms(delegate: text);

    if(forms == null){
      throw Error();
    }

    setState(() {
      lastSearch = text;
    });
    return forms;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Color(0xff0a58ca),),
          onPressed: (){
            final bottomBarProvider = Provider.of<BottomBarProvider>(context,listen: false);
            bottomBarProvider.onTap(context: context, index: 2);
            Navigator.pop(context);
          },
        ),
        backgroundColor: Colors.white,
        centerTitle: true,
        title: Text("Buscar", style: TextStyle(color: Color(0xff1f0757)),),
      ),
      backgroundColor: Colors.white,
      // body: SafeArea(
      //   child: SearchBar<FormModel>(
      //     minimumChars: 1,
      //     searchBarPadding: EdgeInsets.symmetric(horizontal: 10),
      //     headerPadding: EdgeInsets.symmetric(horizontal: 10),
      //     listPadding: EdgeInsets.symmetric(horizontal: 10),
      //     onSearch: _searchForm,
      //     searchBarController: _searchBarController,
      //     placeHolder: Center(child: Text("Buscar Formulario", style: TextStyle(color: Color(0xff1f0757),fontWeight: FontWeight.bold),),),
      //     cancellationWidget: Text("Cancelar",style: TextStyle(fontWeight: FontWeight.bold)),
      //     emptyWidget:  Center(
      //       child: Container(
      //           width: 80 * SizeConfig.blockSizeHorizontal,
      //           child: Text("No se encontraron resultados.", textAlign: TextAlign.center,style: TextStyle(color: Color(0xff1f0757),fontWeight: FontWeight.bold))
      //       ),
      //     ),
      //
      //     onError: (error){
      //       return Center(
      //         child: Container(
      //             width: 80 * SizeConfig.blockSizeHorizontal,
      //             child: Text("Lo sentimos ha ocurrido un error al intentar procesar su busqueda.", textAlign: TextAlign.center,style: TextStyle(color: Color(0xff1f0757),fontWeight: FontWeight.bold),)
      //         ),
      //       );
      //     },
      //     onItemFound: (FormModel form, int index) {
      //       return _tableData(form: form,index: index);
      //     },
      //   ),
      // ),
    );
  }

  Widget _tableData({required FormModel form,required int index}){
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
                  icon: Icon(Icons.remove_red_eye, color: Colors.white,),
                  onPressed: (){
                    Navigator.pushNamed(context, '/showCrisisAttention',arguments: form);

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
                  color: Color(0xffffcd39),
                  shape: BoxShape.circle,
                ),
                child: IconButton(
                  icon: Icon(Icons.settings, color: Colors.black,),
                  onPressed: (){
                    if(!form.analyzed){
                      Navigator.pushNamed(context, '/modifyCrisisAttention',arguments: form);
                    } else {
                      AwesomeDialog(
                          isDense: true,
                          context: context,
                          dialogType: DialogType.WARNING,
                          padding: EdgeInsets.all(20.0),
                          animType: AnimType.BOTTOMSLIDE,
                          title: "SAT PDDH",
                          desc: "Lo sentimos el formulario ya ha sido analizado.",
                          btnOkOnPress: () {},
                          btnOkColor: Color(0xFFF2B10F)
                      )..show();
                    }
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
                  icon: Icon(Icons.check, color: Colors.white,),
                  onPressed: () async {
                    final analyzed = await Navigator.pushNamed(context, '/analyzeCrisisAttention',arguments: form.formId);

                    if(analyzed == true){
                      _searchForm(lastSearch);
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

