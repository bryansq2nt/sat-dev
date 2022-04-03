import 'dart:developer';

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:sat/src/models/form/form_v1.dart';
import 'package:sat/src/providers/early_warning.dart';
import 'package:sat/src/services/early_warnings.dart';
import 'package:sat/src/utilities/screenSize.dart';
import 'package:sat/src/views/form/formv1.dart';
import 'package:sat/src/views/home/components/bottom_bar.dart';

class ModifyEarlyWarningView extends StatefulWidget {
  final FormModel form;
  final bool isLocal;

  const ModifyEarlyWarningView(
      {Key? key, required this.form, this.isLocal = false})
      : super(key: key);

  @override
  _ModifyEarlyWarningViewState createState() => _ModifyEarlyWarningViewState();
}

class _ModifyEarlyWarningViewState extends State<ModifyEarlyWarningView> {
  bool modifying = false;
  bool loading = true;
  bool error = false;
  late FormModel? form;
  final _formKey = GlobalKey<FormBuilderState>();

  _getForm() async {
    setState(() {
      loading = true;
      error = false;
    });

    if (widget.isLocal) {
      this.form = await EarlyWarningsService()
          .getLocallyForm(formId: widget.form.formId);
    } else {
      this.form =
          await EarlyWarningsService().getForm(formId: widget.form.formId);
    }

    if (this.form == null) {
      setState(() {
        error = true;
      });
    }
    setState(() {
      loading = false;
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

  okAlert(String text) {
    AwesomeDialog(
        isDense: true,
        context: context,
        dialogType: DialogType.SUCCES,
        padding: EdgeInsets.all(20.0),
        animType: AnimType.BOTTOMSLIDE,
        title: "SAT PDDH",
        desc: text,
        btnOkOnPress: () {
          Navigator.pop(context, this.form?.sentToAnalyze);
        },
        btnOkColor: Color(0xFFF2B10F))
      ..show();
  }

  errorAlert(String text) {
    AwesomeDialog(
        isDense: true,
        context: context,
        dialogType: DialogType.ERROR,
        padding: EdgeInsets.all(20.0),
        animType: AnimType.BOTTOMSLIDE,
        title: "SAT PDDH",
        desc: text,
        btnOkOnPress: () {},
        btnOkColor: Color(0xFFF2B10F))
      ..show();
  }

  void _updateAlert() async {
    if (_validate() && !modifying) {
      setState(() {
        modifying = true;
      });
      FormModel? uploadedForm = await EarlyWarningsService().updateForm(
          form: form!,
          context: context,
          onNetworkNotReachable: _updateAlertLocal);
      setState(() {
        modifying = false;
      });
      if (uploadedForm != null && !uploadedForm.timeOutError) {
        okAlert("Alerta actualizada correctamente.");
      } else {
        if (uploadedForm != null) {
          uploadedForm.timeOutError
              ? {}
              : errorAlert(
                  "Lo sentimos ha ocurrido un error al intentar actualizar la alerta.");
        }
      }
    } else {
      if (!_validate() && !modifying) {
        invalidForm();
      }
    }
  }

  void _updateAlertLocal() async {
    setState(() {
      modifying = true;
    });
    this.form?.formId = (await EarlyWarningProvider().saveToLocal(
        listName: "early_warnings", form: this.form!, context: context))!;

    setState(() {
      modifying = false;
    });
    if (this.form?.formId != null) {
      okAlert("Alerta actualizada correctamente");
    } else {
      errorAlert(
          "Lo sentimos ha ocurrido un error al intentar actualizar la alerta.");
    }
  }

  void _send() async {
    if (_validate() && !modifying) {
      setState(() {
        modifying = true;
      });
      this.form?.sentToAnalyze = await EarlyWarningsService()
          .sendToAnalyze(formId: form?.formId, context: context);
      setState(() {
        modifying = false;
      });
      if (this.form?.sentToAnalyze == true) {
        okAlert("Alerta enviada correctamente.");
      } else {
        errorAlert(
            "Lo sentimos ha ocurrido un error al intentar enviar la alerta.");
      }
    } else {
      if (!_validate() && !modifying) {
        invalidForm();
      }
    }
  }

  void _back(bool? isFalse) {
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
          Navigator.pop(
              context, isFalse == null ? this.form?.sentToAnalyze : false);
        },
        btnCancelOnPress: () {
          return;
        },
        btnOkColor: Color(0xFFF2B10F))
      ..show();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        _back(null);
        return true;
      },
      child: Scaffold(
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
              try {
                _back(null);
              } catch (e) {
                _back(false);
              }
            },
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
            enabled: !form!.sentToAnalyze,
          ),
          !form!.sentToAnalyze ? _submitButton() : Container(),
          !form!.sentToAnalyze && !widget.isLocal
              ? _sendToAnalyze()
              : Container()
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
          onPressed: widget.isLocal ? _updateAlertLocal : _updateAlert,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text("Guardar datos "),
              SizedBox(
                width: 1 * SizeConfig.blockSizeHorizontal,
              ),
              Icon(Icons.arrow_forward)
            ],
          ),
        ),
      ),
    );
  }

  Widget _sendToAnalyze() {
    return Container(
      width: SizeConfig.screenWidth * 0.9,
      height: 50,
      margin: EdgeInsets.only(bottom: 3 * SizeConfig.blockSizeVertical),
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: 0.5 * SizeConfig.blockSizeHorizontal,
        ),
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(primary: Color(0xFFF2B10F)),
          onPressed: _send,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text("Enviar a analisis "),
              SizedBox(
                width: 1 * SizeConfig.blockSizeHorizontal,
              ),
              Icon(Icons.arrow_forward)
            ],
          ),
        ),
      ),
    );
  }
}
