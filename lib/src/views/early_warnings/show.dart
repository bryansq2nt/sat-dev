import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:sat/src/services/early_warnings.dart';
import 'package:sat/src/utilities/screenSize.dart';
import 'package:sat/src/models/form/form_v1.dart';
import 'package:sat/src/views/home/components/bottom_bar.dart';

import '../form/formv1.dart';


class ShowEarlyWarningView extends StatefulWidget {
  final FormModel form;

  const ShowEarlyWarningView({Key? key,required this.form}) : super(key: key);

  @override
  _ShowEarlyWarningViewState createState() => _ShowEarlyWarningViewState();
}

class _ShowEarlyWarningViewState extends State<ShowEarlyWarningView> {

  bool loading = true;
  bool error = false;
  late FormModel? form;
  final _formKey = GlobalKey<FormBuilderState>();


  _getForm() async {

    setState(() {
      loading = true;
      error = false;
    });
    form = await EarlyWarningsService().getForm(formId: widget.form.formId);

    if(form == null){
      setState(() {
        error = true;
      });
    }
    setState(() {
      loading = false;
    });

  }

  @override
  void initState() {
    super.initState();
    _getForm();

  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        centerTitle: true,
        title: Text(
          "Alertas",
          style: TextStyle(color: Color(0xff1f0757)),
        ),
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: Color(0xff0a58ca),
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      backgroundColor: Color(0xFFe2e9fe),
      body: !loading && !error ? SafeArea(
          child: SingleChildScrollView(
              physics: AlwaysScrollableScrollPhysics(),
              child: Center(child: _form()))) : !error ? _loading() : _error(),
      bottomNavigationBar: BottomBarWidget(),
    );
  }

  Widget _form() {
    return Container(
      child: Column(
        children: [
          FormWidget(formKey: _formKey,form: form!,enabled: false,),
        ],
      ),
    );
  }

  Widget _loading (){
    return Center(
      child: CircularProgressIndicator(),
    );
  }

  Widget _error(){
    return Center(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 5 * SizeConfig.blockSizeHorizontal),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("Lo sentimos ha ocurrido un error al intentar obtener el formulario", style: TextStyle(fontWeight: FontWeight.bold,color: Color(0xff1f0757)),textAlign: TextAlign.center,),
            IconButton(
              icon: Icon(Icons.autorenew),
              onPressed: _getForm,
            )
          ],
        ),
      ),
    );
  }

}


