import 'dart:developer';

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:sat/src/models/form/section_model.dart';
import 'package:sat/src/providers/case_processing.dart';
import 'package:sat/src/services/case_processing.dart';
import 'package:sat/src/utilities/screenSize.dart';
import 'package:sat/src/views/case_processing/involved/involved_table.dart';
import 'package:sat/src/views/form/area.dart';
import 'package:sat/src/views/form/closed.dart';
import 'package:sat/src/views/form/closed_multiple.dart';
import 'package:sat/src/views/form/closed_with_child.dart';
import 'package:sat/src/views/form/date.dart';
import 'package:sat/src/views/form/date_after.dart';
import 'package:sat/src/views/form/date_before.dart';
import 'package:sat/src/views/form/date_time.dart';
import 'package:sat/src/views/form/date_time_before.dart';
import 'package:sat/src/views/form/image.dart';
import 'package:sat/src/views/form/numeric.dart';
import 'package:sat/src/views/form/open.dart';
import 'package:sat/src/views/form/searchable_dropdown.dart';
import 'package:sat/src/views/form/searchable_dropdown_case_processing.dart';
import 'package:sat/src/views/form/switch.dart';
import 'package:sat/src/views/home/components/bottom_bar.dart';

import '../../models/form/form_v1.dart';
import '../form/numeric_mask.dart';


class CaseProcessingAdd extends StatefulWidget {
  final int formId;
  final bool enabled;

  const CaseProcessingAdd({Key? key,required this.formId, this.enabled = true}) : super(key: key);
  @override
  _CaseProcessingAddState createState() => _CaseProcessingAddState();
}

class _CaseProcessingAddState extends State<CaseProcessingAdd> {
  bool loading = true;
  bool error = false;
  bool added = false;
  FormModel? form;
  FormModel? involvedForm;
  int _currentIndex = 0;

  List<String> _tabs = [
    "Via Entrada",
    "Involucrados",
    "Lugar y Hecho",
    "Enviar"
  ];


  late PageController _controller;

  final GlobalKey<FormBuilderState> _formKey1 = GlobalKey<FormBuilderState>();
  final GlobalKey<FormBuilderState> _formKey2 = GlobalKey<FormBuilderState>();

  void _getForm() async {
    setState(() {
      loading = true;
      error = false;
    });



    if (widget.formId == null) {
      this.form = await CaseProcessingService().getFormToFill();

    } else {

      this.form =
      await CaseProcessingService().getLocallyForm(formId: widget.formId);

      // if (form == null) {
      //   this.form =
      //   await CaseProcessingService().getForm(formId: widget.formId);
      // }
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

  Future<bool> _saveToLocal() async {

    try {
      this.form?.formId = (await CaseProcessingProvider().saveToLocal(
          listName: "case_processing", form: this.form!, context: context))!;
      if (this.form?.formId != 0 && this.form?.formId != null) {
        added = true;

      }

      return true;
    } catch (e) {
      print(e);
      errorCreatingCase(
          "Lo sentimos ha ocurrido un error al intentar guardar el formulario.");
      return false;
    }


  }

  void _sendToSigi() async {

    FormModel? tempForm = await CaseProcessingService().sendToSigi(
      form: this.form!,
      context: context
    );

    if(tempForm == null){
      errorCreatingCase("Lo sentimos ha ocurrido un error al intentar enviar el caso al SIGI.");
      return;
    }

    setState(() {
      added = true;
    });
    caseCreated("El caso ha sido enviado correctamente al SIGI.");
  }

  caseCreated(String text) {

    AwesomeDialog(
        isDense: true,
        context: context,
        dismissOnBackKeyPress: false,
        dismissOnTouchOutside: false,
        onDissmissCallback: (val){
          Navigator.pop(context,added);
        },
        dialogType: DialogType.SUCCES,
        padding: EdgeInsets.all(20.0),
        animType: AnimType.BOTTOMSLIDE,
        title: "SAT PDDH",
        desc: text,
        btnOkOnPress: () {},
        btnOkColor: Color(0xFFF2B10F))
      ..show();
  }

  errorCreatingCase(String text) {
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

  void _nextTab(GlobalKey<FormBuilderState> formKey) async  {
    if(widget.enabled && formKey != null && !_validate(formKey)){
      invalidForm();
      return;
    }

    bool saved = await _saveToLocal();

    if(saved){
      if (_currentIndex <= 3) {
        int tempIndex = _currentIndex + 1;
        _controller.animateToPage(tempIndex, duration: const Duration(milliseconds: 500), curve: Curves.easeInOutCubic);
        await Future.delayed(const Duration(microseconds: 500), (){
          setState(() {
            _currentIndex ++;
          });
        });
      }
    }

  }

  void _lastTab() async {
    if (_currentIndex > 0) {
      int tempIndex = _currentIndex - 1;
      _controller.animateToPage(tempIndex, duration: const Duration(milliseconds: 500), curve: Curves.easeInOutCubic);
      await Future.delayed(const Duration(microseconds: 500), (){
        setState(() {
          _currentIndex --;
        });
      });
    }
  }

  bool _validate(var _formKey) {
    if (_formKey.currentState.validate()) {
      _formKey.currentState.saveAndValidate();
      return true;
    } else {
      return false;
    }
  }

  void initiPageViewController(){
    Future.delayed(Duration(milliseconds: 50),(){
      setState(() {
        _controller = PageController(
          keepPage: true,
          initialPage:  0,
        );
      });

    });



  }

  void _back() {
    if(widget.enabled){
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
            Navigator.pop(context, added);
          },
          btnCancelOnPress: (){
            return;
          },
          btnOkColor: Color(0xFFF2B10F)
      )..show();
    } else {
      Navigator.pop(context, added);
    }

  }

  @override
  void initState() {
    _getForm();

   // initiPageViewController();
    _controller = PageController() //
      ..addListener(() {
        final _newPage = _controller.page?.round();
        if (_currentIndex != _newPage) {
          setState(() => _currentIndex = _newPage!);
        }
      });
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
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
            "Tramitación de Casos",
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
        //backgroundColor: Color(0xFFe2e9fe),
        body: !loading && !error
            ? SafeArea(
            child: _form())
            : !error
            ? _loading()
            : _error(),
        bottomNavigationBar: BottomBarWidget(),
      ),
    );
  }

  Widget _sectionTab(int index) {
    bool selected = _currentIndex == index ? true : false;

    return Container(
      child: Center(
          child: Text(
            _tabs[index],
            style: TextStyle(
                fontSize:  2 * SizeConfig.safeBlockVertical,
                color: Colors.white,
                fontWeight: !selected ? FontWeight.normal : FontWeight.bold),
          )),
      padding: EdgeInsets.all(10.0),
      decoration: BoxDecoration(
          color: Color(0xff0a58ca),
          border: Border.all(
              color: Colors.transparent,
              width: 0),
          borderRadius: BorderRadius.zero),
    );
  }

  Widget _form() {
    return Column(
      children: [
        Container(
          padding: EdgeInsets.symmetric(
              horizontal: 1 * SizeConfig.blockSizeHorizontal),
          margin: EdgeInsets.symmetric(
              vertical: 1 * SizeConfig.blockSizeVertical),
          height: SizeConfig.blockSizeVertical * 6,
          child: ListView.builder(
            shrinkWrap: true,
            scrollDirection: Axis.horizontal,
            itemCount: 4,
            itemBuilder: (BuildContext context, int index) =>
                _sectionTab(index),
          ),
        ),
        Expanded(
          child: PageView(
            controller:  _controller,
            physics: NeverScrollableScrollPhysics(),
            children: [
              KeepAlivePage(child: _questions(formKey: _formKey1, section: 0),),
              KeepAlivePage(child: _involvedSection()),
              KeepAlivePage(child: _questions(formKey: _formKey2, section: 1),),
              _section4()
            ],
          ),
        )
      ],
    );
  }

  Widget _section4() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [ widget.enabled ? _submitButton() : Container(), _tabArrows(formKey: _controller.page! <= 0 ? _formKey1 : _formKey2)],
      ),
    );
  }

  Widget _involvedSection(){
    return Column(
      children: [
        InvolvedTableWidget(caseId: this.form!.formId,enabled: widget.enabled,),

        _tabArrows(formKey: _controller.page! <= 0 ? _formKey1 : _formKey2)
      ],
    );
  }

  Widget _questions({required GlobalKey<FormBuilderState> formKey,required int section}) {
    return Padding(
      padding:
      EdgeInsets.symmetric(horizontal: 5 * SizeConfig.blockSizeHorizontal),
      child: FormBuilder(
        key: formKey,
        enabled: widget.enabled,
        onChanged: () {
          setState(() {});
        },
        child: ListView.builder(
          //physics: NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          itemCount: form?.sections != null ? form!.sections[section].questions.length + 1 : 0,
          itemBuilder: (BuildContext context, int question) {

            if(question < form!.sections[section].questions.length){
              bool show = false;
              dynamic currentQuestion =
              form!.sections[section].questions[question];
              if (currentQuestion.dependent ||
                  currentQuestion.dependentMultiple) {
                for (SectionModel sectionToCheck in form!.sections) {
                  if (sectionToCheck.sectionId ==
                      currentQuestion.dependentSectionId) {
                    for (dynamic questionToCheck
                    in sectionToCheck.questions) {
                      if (questionToCheck.questionId ==
                          currentQuestion.dependentQuestionId) {
                        if (form!.sections[section].questions[question]
                            .dependent) {
                          if (questionToCheck.answer ==
                              currentQuestion.dependentAnswer) {

                            show = true;
                          }
                        } else {
                          if (currentQuestion.dependentAnswer
                              .contains(questionToCheck.answer)) {
                            show = true;
                          }
                        }
                      }
                    }
                  }
                }
              } else {
                show = true;
              }

              if (show ) {
                switch (
                    form!.sections[section].questions[question].questionType) {
                  case "open":
                    return OpenFieldWidget(
                      question: currentQuestion.question,
                      properties: currentQuestion.defaultProperties,

                    );
                  case "numeric":
                    return NumericFieldWidget(
                        question: currentQuestion.question,
                        properties: currentQuestion.defaultProperties,
                        numericProperties: currentQuestion.numericProperties
                    );
                  case "numeric_mask":
                    return NumericMaskFieldWidget(
                        question: currentQuestion.question,
                        properties: currentQuestion.defaultProperties
                    );
                  case "area":
                    return AreaFieldWidget(
                      question: currentQuestion.question,
                      properties: currentQuestion.defaultProperties,

                    );
                  case "closed":
                    return ClosedFieldWidget(
                      question: currentQuestion.question,
                      properties: currentQuestion.defaultProperties,
                      dropdownProperties: currentQuestion.dropdownProperties,
                    );
                  case "closed_multiple":
                    return ClosedMultipleFieldWidget(
                      question: currentQuestion.question,
                      properties: currentQuestion.defaultProperties,
                      dropdownProperties: currentQuestion.dropdownProperties,
                    );
                  case "closed_searchable":
                    return SearchableDropdownField(
                      question: currentQuestion.question,
                      properties: currentQuestion.defaultProperties,
                      dropdownProperties: currentQuestion.dropdownProperties,
                    );
                  case "closed_searchable_case_processing":
                    return SearchableDropdownFieldCaseProcessing(
                      question: currentQuestion.question,
                      properties: currentQuestion.defaultProperties,
                      dropdownProperties: currentQuestion.dropdownProperties,
                    );
                  case "closed_with_child":
                    return ClosedWithChildField(
                      question: currentQuestion.question,
                      properties: currentQuestion.defaultProperties,
                      dropdownProperties: currentQuestion.dropdownProperties,
                      form: form!,
                      formKey: formKey,
                    );
                  case "switch":
                    return SwitchFieldWidget(
                      question: currentQuestion.question,
                      properties: currentQuestion.defaultProperties,
                      booleanProperties: currentQuestion.booleanProperties,
                    );
                  case "date":
                    return DateFieldWidget(
                      question: currentQuestion.question,
                      properties: currentQuestion.defaultProperties,
                      dateProperties: currentQuestion.dateProperties,
                    );

                  case "image":
                    return ImageFieldWidget(
                      question: currentQuestion.question,
                      properties: currentQuestion.defaultProperties,
                    );
                  default:
                    return OpenFieldWidget(
                      question: currentQuestion.question,
                      properties: currentQuestion.defaultProperties,
                    );
                }
              } else {
                return Container();
              }
            } else {
              return _tabArrows(formKey: formKey);

            }

          },
        ),
      ),
    );
  }

  Widget _tabArrows({required GlobalKey<FormBuilderState> formKey}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _currentIndex > 0
            ? Container(
          width: SizeConfig.screenWidth * 0.4,
          height: 100,
          child: Padding(
            padding: EdgeInsets.symmetric(
                horizontal: 0.5 * SizeConfig.blockSizeHorizontal,
                vertical: 3 * SizeConfig.blockSizeVertical),
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(primary: Color(0xff0a58ca)),
              onPressed: _lastTab,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.arrow_back),
                  SizedBox(
                    width: 1 * SizeConfig.blockSizeHorizontal,
                  ),
                  Text(" Atras"),
                ],
              ),
            ),
          ),
        )
            : Container(),
        _currentIndex  < 3
            ? Container(
          width: SizeConfig.screenWidth * 0.4,
          height: 100,
          child: Padding(
            padding: EdgeInsets.symmetric(
                horizontal: 0.5 * SizeConfig.blockSizeHorizontal,
                vertical: 3 * SizeConfig.blockSizeVertical),
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(primary: Color(0xff0a58ca)),
              onPressed: () {
                _nextTab(formKey);
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("Siguiente "),
                  SizedBox(
                    width: 1 * SizeConfig.blockSizeHorizontal,
                  ),
                  Icon(Icons.arrow_forward)
                ],
              ),
            ),
          ),
        )
            : Container()
      ],
    );
  }

  Widget _submitButton() {
    return Container(
      width: SizeConfig.screenWidth * 0.4,
      height: 100,
      child: Padding(
        padding: EdgeInsets.symmetric(
            horizontal: 0.5 * SizeConfig.blockSizeHorizontal,
            vertical: 3 * SizeConfig.blockSizeVertical),
        child: ElevatedButton(
            style: ElevatedButton.styleFrom(primary: Color(0xff0a58ca)),
            onPressed:_sendToSigi,
            child: Text("Enviar a SIGI")),
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


}

class KeepAlivePage extends StatefulWidget {
  KeepAlivePage({
    Key? key,
    required this.child,
  }) : super(key: key);

  final Widget child;

  @override
  _KeepAlivePageState createState() => _KeepAlivePageState();
}

class _KeepAlivePageState extends State<KeepAlivePage>
    with AutomaticKeepAliveClientMixin {
  @override
  Widget build(BuildContext context) {
    /// Dont't forget this
    super.build(context);

    return widget.child;
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}
