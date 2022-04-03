import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:provider/provider.dart';
import 'package:sat/src/models/form/form_v1.dart';
import 'package:sat/src/models/user.dart';
import 'package:sat/src/providers/auth.dart';
import 'package:sat/src/services/crisis_attention.dart';
import 'package:sat/src/utilities/screenSize.dart';
import 'package:sat/src/views/form/formv1.dart';
import 'package:sat/src/views/home/components/bottom_bar.dart';

class AnalyzeCrisisAttentionView extends StatefulWidget {
  final int formId;

  const AnalyzeCrisisAttentionView({Key? key, required this.formId})
      : super(key: key);
  @override
  _AnalyzeCrisisAttentionViewState createState() =>
      _AnalyzeCrisisAttentionViewState();
}

class _AnalyzeCrisisAttentionViewState
    extends State<AnalyzeCrisisAttentionView> {
  bool analyzing = false;
  bool analyzed = false;
  bool wasAnalyzed = false;
  bool loading = true;
  bool error = false;
  FormModel? form;
  final _formKey = GlobalKey<FormBuilderState>();

  _getForm() async {
    setState(() {
      loading = true;
      error = false;
    });
    this.form = await CrisisAttentionService()
        .getFormToAnalyze(formId: widget.formId, context: context);
    this.analyzed = this.form != null ? this.form!.analyzed : false;
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

  formAnalyzed() {
    setState(() {
      analyzed = true;
      wasAnalyzed = true;
    });
    AwesomeDialog(
        isDense: true,
        context: context,
        dialogType: DialogType.SUCCES,
        padding: EdgeInsets.all(20.0),
        animType: AnimType.BOTTOMSLIDE,
        title: "SAT PDDH",
        desc: "Formulario analizado correctamente",
        btnOkOnPress: () {},
        btnOkColor: Color(0xFFF2B10F))
      ..show();
  }

  errorAnalysingForm() {
    AwesomeDialog(
        isDense: true,
        context: context,
        dialogType: DialogType.ERROR,
        padding: EdgeInsets.all(20.0),
        animType: AnimType.BOTTOMSLIDE,
        title: "SAT PDDH",
        desc:
            "Lo sentimos ha ocurrido un error al intentar analizar el formulario.",
        btnOkOnPress: () {},
        btnOkColor: Color(0xFFF2B10F))
      ..show();
  }

  void _analyzeForm() async {
    if (_validate() && !analyzing) {
      setState(() {
        analyzing = true;
      });
      bool analyzed = await CrisisAttentionService()
          .analyzeForm(form: form!, context: context);
      setState(() {
        analyzing = false;
      });
      if (analyzed) {
        formAnalyzed();
      } else {
        errorAnalysingForm();
      }
    } else {
      invalidForm();
    }
  }

  @override
  Widget build(BuildContext context) {
    final List<Role> _roles =
        Provider.of<AuthProvider>(context).user?.roles ?? [];

    return WillPopScope(
      onWillPop: () async {
        Navigator.pop(context, wasAnalyzed);
        return true;
      },
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          centerTitle: true,
          title: Text(
            "Análisis de Alertas",
            style: TextStyle(color: Color(0xff1f0757)),
          ),
          leading: IconButton(
            icon: Icon(
              Icons.arrow_back,
              color: Color(0xff0a58ca),
            ),
            onPressed: () {
              Navigator.pop(context, wasAnalyzed);
            },
          ),
          actions: [
            _roles.singleWhere((element) =>
                            element.roleId == 3 || element.roleId == 4) !=
                        null &&
                    analyzed
                ? IconButton(
                    icon: Icon(
                      Icons.link,
                      color: Color(0xff0a58ca),
                    ),
                    onPressed: () async {
                      Navigator.pushNamed(context, '/relatedCrisisAttention',
                          arguments: this.form!.formId);
                    },
                  )
                : Container()
          ],
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
            enabled: !analyzed,
          ),
          !analyzed ? _submitButton() : Container()
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
          onPressed: _analyzeForm,
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
