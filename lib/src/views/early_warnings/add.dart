import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:sat/src/models/form/form_v1.dart';
import 'package:sat/src/providers/early_warning.dart';
import 'package:sat/src/services/early_warnings.dart';
import 'package:sat/src/utilities/screenSize.dart';
import 'package:sat/src/views/home/components/bottom_bar.dart';

import '../form/formv1.dart';

class AddEarlyWarningView extends StatefulWidget {
  @override
  _AddEarlyWarningViewState createState() => _AddEarlyWarningViewState();
}

class _AddEarlyWarningViewState extends State<AddEarlyWarningView> {
  bool adding = false;
  bool added = false;
  bool saved = false;
  bool loading = true;
  bool error = false;
  FormModel? form;

  final _formKey = GlobalKey<FormBuilderState>();

  _getForm() async {
    setState(() {
      loading = true;
      error = false;
    });
    this.form = await EarlyWarningsService().getFormToFill(context: context);



    setState(() {
      loading = false;
      error = this.form == null ? true : false;
    });
  }

  bool _validate() {
    if (_formKey.currentState?.validate() == true) {
      _formKey.currentState?.saveAndValidate();
      return true;
    } else {
      return false;
    }
  }

  @override
  void initState() {
    super.initState();
    _getForm();
  }

  invalidForm() {
    AwesomeDialog(
        isDense: true,
        context: context,
        dialogType: DialogType.WARNING,
        padding: EdgeInsets.all(20.0),
        animType: AnimType.BOTTOMSLIDE,
        title: "SAT PDDH",
        desc: "Algunos campos de este formulario son obligatorios.",
        btnOkOnPress: () {},
        btnOkColor: Color(0xFFF2B10F))
      ..show();
  }

  alertCreated() async {
    setState(() {
      added = true;
    });
    AwesomeDialog(
        isDense: true,
        context: context,
        dialogType: DialogType.SUCCES,
        padding: EdgeInsets.all(20.0),
        animType: AnimType.BOTTOMSLIDE,
        title: "SAT PDDH",
        desc: "Alerta creada correctamente",
        btnOkOnPress: () {
          Navigator.pop(context, true);
        },
        btnOkColor: Color(0xFFF2B10F))
      ..show();
  }

  errorCreatingAlert() {
    AwesomeDialog(
        isDense: true,
        context: context,
        dialogType: DialogType.ERROR,
        padding: EdgeInsets.all(20.0),
        animType: AnimType.BOTTOMSLIDE,
        title: "SAT PDDH",
        desc: "Lo sentimos ha ocurrido un error al intentar crear la alerta.",
        btnOkOnPress: () {},
        btnOkColor: Color(0xFFF2B10F))
      ..show();
  }

  void _createAlert() async {
    if (_validate() && !adding) {
      setState(() {
        adding = true;
      });

      FormModel? uploadedForm = await EarlyWarningsService().uploadForm(
          form: form!, context: context, onNetworkNotReachable: _saveToLocal);

      setState(() {
        adding = false;
      });
      if (uploadedForm != null && !uploadedForm.timeOutError) {
        alertCreated();
      } else {
        if (uploadedForm != null) {
          uploadedForm.timeOutError ? {} : errorCreatingAlert();
        }
      }
    } else {
      if (!_validate() && !adding) {
        invalidForm();
      }
    }
  }

  void _saveToLocal() async {
    setState(() {
      adding = true;
    });

    this.form?.formId = (await EarlyWarningProvider().saveToLocal(
        listName: "early_warnings", form: this.form!, context: context))!;

    if (this.form?.formId != 0 && this.form?.formId != null) {
      added = true;
    }

    setState(() {
      adding = false;
    });
    if (added) {
      alertCreated();
    } else {
      errorCreatingAlert();
    }
  }

  void _back() {
    AwesomeDialog(
        isDense: true,
        context: context,
        dialogType: DialogType.QUESTION,
        padding: EdgeInsets.all(20.0),
        animType: AnimType.BOTTOMSLIDE,
        title: "SAT PDDH",
        desc: "Esta seguro que desea salir?",
        btnOkText: "Si",
        btnCancelText: "No",
        btnOkOnPress: () {
          Navigator.pop(context, !added && !saved ? false : true);
        },
        btnCancelOnPress: (){
          return;
        },
        btnOkColor: Color(0xFFF2B10F)
    )..show();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        _back();
        return true;
      },
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: Icon(
              Icons.arrow_back,
              color: Color(0xff0a58ca),
            ),
            onPressed: _back,
          ),
          backgroundColor: Colors.white,
          centerTitle: true,
          title: Text(
            "Alertas",
            style: TextStyle(color: Color(0xff1f0757)),
          ),
        ),
        backgroundColor: Color(0xFFe2e9fe),
        body: !loading && !error
            ? SafeArea(
                child: SingleChildScrollView(
                    physics: AlwaysScrollableScrollPhysics(),
                    child: Center(child: _form())))
            : !error
                ? _loading()
                : _error(),
        bottomNavigationBar: BottomBarWidget(),
      ),
    );
  }

  Widget _loading() {
    return Center(
      child: CircularProgressIndicator(),
    );
  }

  Widget _error() {
    return Center(
      child: Padding(
        padding: EdgeInsets.symmetric(
            horizontal: 5 * SizeConfig.blockSizeHorizontal),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Lo sentimos ha ocurrido un error al intentar obtener el formulario",
              style: TextStyle(
                  fontWeight: FontWeight.bold, color: Color(0xff1f0757)),
              textAlign: TextAlign.center,
            ),
            IconButton(
              icon: Icon(Icons.autorenew),
              onPressed: _getForm,
            )
          ],
        ),
      ),
    );
  }

  Widget _form() {
    return Container(
      child: Column(
        children: [
          FormWidget(
            formKey: _formKey,
            form: form!,
            enabled: !added,
          ),
          !added ? _submitButton() : Container()
        ],
      ),
    );
  }

  Widget _submitButton() {
    return Container(
      width: SizeConfig.screenWidth * 0.9,
      height: 100,
      child: Padding(
        padding: EdgeInsets.symmetric(
            horizontal: 0.5 * SizeConfig.blockSizeHorizontal,
            vertical: 3 * SizeConfig.blockSizeVertical),
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(primary: Color(0xff0a58ca)),
          onPressed: _createAlert,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text("Cargar datos "),
              SizedBox(
                width: 1 * SizeConfig.blockSizeHorizontal,
              ),
              Icon(Icons.cloud)
            ],
          ),
        ),
      ),
    );
  }
}
