import 'dart:developer';

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:sat/src/models/form/form_v1.dart';
import 'package:sat/src/services/crisis_attention.dart';
import 'package:sat/src/utilities/screenSize.dart';
import 'package:sat/src/views/home/components/bottom_bar.dart';

import '../../providers/crisis_attention.dart';
import 'package:sat/src/views/form/formv1.dart';

class ModifyCrisisAttentionView extends StatefulWidget {
  final FormModel form;
  final bool isLocal;

  const ModifyCrisisAttentionView(
      {Key? key, required this.form, this.isLocal = false})
      : super(key: key);

  @override
  _ModifyCrisisAttentionViewState createState() =>
      _ModifyCrisisAttentionViewState();
}

class _ModifyCrisisAttentionViewState extends State<ModifyCrisisAttentionView> {
  bool modifying = false;
  bool loading = true;
  bool error = false;
  FormModel? form;
  final _formKey = GlobalKey<FormBuilderState>();

  _getForm() async {
    setState(() {
      loading = true;
      error = false;
    });
    if (widget.isLocal) {
      this.form = await CrisisAttentionService()
          .getLocallyForm(formId: widget.form.formId);
    } else {
      this.form =
          await CrisisAttentionService().getForm(formId: widget.form.formId);
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
          Navigator.pop(context, this.form!.sentToAnalyze);
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

  void _send() {
    AwesomeDialog(
        isDense: true,
        context: context,
        dialogType: DialogType.QUESTION,
        padding: EdgeInsets.all(20.0),
        animType: AnimType.BOTTOMSLIDE,
        title: "SAT PDDH",
        desc: "Esta seguro que desea enviar el formulario a SIGI ?",
        btnOkText: "Si",
        btnCancelText: "No",
        btnOkOnPress: () async {
          if (_validate() && !modifying) {
            setState(() {
              modifying = true;
            });
            this.form?.sentToAnalyze = await CrisisAttentionService()
                .sendToSigi(formId: form!.formId, context: context);
            setState(() {
              modifying = false;
            });
            if (this.form?.sentToAnalyze == true) {
              okAlert("Formulario enviado correctamente.");
            } else {
              errorAlert(
                  "Lo sentimos ha ocurrido un error al intentar enviar el formulario.");
            }
          } else {
            if (!_validate() && !modifying) {
              invalidForm();
            }
          }
        },
        btnCancelOnPress: () {
          return;
        },
        btnOkColor: Color(0xFFF2B10F))
      ..show();
  }

  void _updateForm() async {
    if (_validate() && !modifying) {
      setState(() {
        modifying = true;
      });
      FormModel? uploadedForm = await CrisisAttentionService().updateForm(
          form: form!, context: context, onNetworkNotReachable: _updateAlert);
      setState(() {
        modifying = false;
      });
      if (uploadedForm != null && !uploadedForm.timeOutError) {
        okAlert("Formulario actualizado correctamente.");
      } else {
        if (uploadedForm != null) {
          uploadedForm.timeOutError
              ? {}
              : errorAlert(
                  "Lo sentimos ha ocurrido un error al intentar actualizar el formulario.")();
        }
      }
    } else {
      if (!_validate() && !modifying) {
        invalidForm();
      }
    }
  }

  void _updateAlert() async {
    setState(() {
      modifying = true;
    });

    this.form?.formId = (await CrisisAttentionProvider().saveToLocal(
        listName: "crisis_attention", form: this.form!, context: context))!;

    setState(() {
      modifying = false;
    });
    if (this.form?.formId != null) {
      okAlert("Formulario actualizado correctamente");
    } else {
      errorAlert(
          "Lo sentimos ha ocurrido un error al intentar actualizar el formulario.");
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
          Navigator.pop(context, this.form?.sentToAnalyze);
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
        _back();
        return true;
      },
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          centerTitle: true,
          title: Text(
            "Atención a Crisis",
            style: TextStyle(color: Color(0xff1f0757)),
          ),
          leading: IconButton(
            icon: Icon(
              Icons.arrow_back,
              color: Color(0xff0a58ca),
            ),
            onPressed: _back,
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
          onPressed: widget.isLocal ? _updateAlert : _updateForm,
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
              Text("Enviar a SIGI "),
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
