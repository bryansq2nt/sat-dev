import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:sat/src/providers/case_processing.dart';
import 'package:sat/src/services/case_processing.dart';
import 'package:sat/src/services/save_locally.dart';
import 'package:sat/src/utilities/screenSize.dart';
import 'package:sat/src/views/form/formv1.dart';
import '../../../models/form/form_v1.dart';

class AddInvolvedView extends StatefulWidget {
  final int caseId;
  final int formId;
  final bool enabled;
  const AddInvolvedView(
      {Key? key,
      required this.caseId,
      required this.formId,
      this.enabled = true})
      : super(key: key);
  @override
  _AddInvolvedViewState createState() => _AddInvolvedViewState();
}

class _AddInvolvedViewState extends State<AddInvolvedView> {
  bool loading = true;
  bool error = false;
  bool added = false;
  FormModel? form;
  final _formKey = GlobalKey<FormBuilderState>();

  _getForm() async {
    setState(() {
      loading = true;
      error = false;
    });

    if (widget.caseId == null) {
      this.form = await CaseProcessingService().getInvolvedFormToFill();
    } else {
      this.form = FormModel.fromJson(await SaveLocallyService()
          .readFromLocal(fileName: "form-${widget.caseId}"));
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
      invalidForm();
      return false;
    }
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

  involvedCreated() {
    AwesomeDialog(
        dismissOnTouchOutside: false,
        dismissOnBackKeyPress: false,
        onDissmissCallback: (val) {
          Navigator.pushReplacementNamed(context, "/addCaseProcessing",
              arguments: widget.formId);
        },
        isDense: true,
        context: context,
        dialogType: DialogType.SUCCES,
        padding: EdgeInsets.all(20.0),
        animType: AnimType.BOTTOMSLIDE,
        title: "SAT PDDH",
        desc: "Listo !",
        btnOkOnPress: () {},
        btnOkColor: Color(0xFFF2B10F))
      ..show();
  }

  errorCreatingInvolved() {
    AwesomeDialog(
        isDense: true,
        context: context,
        dialogType: DialogType.ERROR,
        padding: EdgeInsets.all(20.0),
        animType: AnimType.BOTTOMSLIDE,
        title: "SAT PDDH",
        desc:
            "Lo sentimos ha ocurrido un error al intentar agregar el involucrado.",
        btnOkOnPress: () {},
        btnOkColor: Color(0xFFF2B10F))
      ..show();
  }

  void _createInvolved() async {
    if (_validate()) {
      String listName = 'case_involved_' + widget.formId.toString();
      int? uploadedForm = await CaseProcessingProvider()
          .saveToLocal(listName: listName, form: form!, context: context);
      if (uploadedForm != null) {
        involvedCreated();
      } else {
        errorCreatingInvolved();
      }
    }
  }

  void _back() {
    if (widget.enabled) {
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
            Navigator.pushReplacementNamed(context, "/addCaseProcessing",
                arguments: widget.formId);
          },
          btnCancelOnPress: () {
            return;
          },
          btnOkColor: Color(0xFFF2B10F))
        ..show();
    } else {
      Navigator.pushReplacementNamed(context, "/showCaseProcessing",
          arguments: widget.formId);
    }
  }

  @override
  void initState() {
    _getForm();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
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
            "Involucrado",
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
        body: !loading && !error
            ? SingleChildScrollView(
                physics: ScrollPhysics(),
                child: Center(child: _form()),
              )
            : !error
                ? _loading()
                : _error(),
      ),
    );
  }

  Widget _form() {
    return Column(
      children: [
        FormWidget(
          enabled: widget.enabled ? !added : false,
          formKey: _formKey,
          form: form!,
        ),
        widget.enabled && !added ? _submitButton() : Container()
      ],
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
          onPressed: _createInvolved,
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
}
