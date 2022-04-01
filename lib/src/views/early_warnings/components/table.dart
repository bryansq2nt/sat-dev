import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sat/src/models/form/form_v1.dart';
import 'package:sat/src/models/user.dart';
import 'package:sat/src/providers/auth.dart';
import 'package:sat/src/providers/early_warning.dart';
import 'package:sat/src/utilities/screenSize.dart';

class EarlyWarningsTableWidget extends StatefulWidget {
  const EarlyWarningsTableWidget({Key? key}) : super(key: key);

  @override
  _EarlyWarningsTableWidgetState createState() =>
      _EarlyWarningsTableWidgetState();
}

class _EarlyWarningsTableWidgetState extends State<EarlyWarningsTableWidget> {
  final ScrollController _controller = ScrollController();

  bool _isLoading = false;
  bool _canEdit = false;

  List<Role> _roles = [];

  @override
  void initState() {
    _controller.addListener(_onScroll);
    _roles = Provider.of<AuthProvider>(context, listen: false).user?.roles ?? [];
    // _canEdit = _roles.singleWhere(
    //             (element) => element.roleId == 2 || element.roleId == 3) !=
    //         null
    //     ? true
    //     : false;
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  _onScroll() {
    if (_controller.offset >= _controller.position.maxScrollExtent &&
        !_controller.position.outOfRange) {
      setState(() {
        _isLoading = true;
      });
      _fetchData();
    }
  }

  Future _fetchData() async {
    final provider = Provider.of<EarlyWarningProvider>(context, listen: false);
    await provider.getMore();
    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<EarlyWarningProvider>(context);

    return Container(
      margin: EdgeInsets.all(2 * SizeConfig.safeBlockVertical),
      child: Card(
        child: Padding(
          padding: EdgeInsets.symmetric(
              horizontal: 1 * SizeConfig.blockSizeHorizontal),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                height: 2 * SizeConfig.blockSizeVertical,
              ),
              //SearchBarWidget(),

              Container(
                color: const Color(0xFFf1f2fb),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _tableOption("# CASO"),
                    _tableOption("Ver"),
                    _canEdit ? _tableOption("Modificar") : Container(),
                    _tableOption("Analizar"),
                  ],
                ),
              ),
              provider.status == EarlyWarningStatus.Ready
                  ? _body(provider)
                  : _loading(),
              SizedBox(
                height: 2 * SizeConfig.blockSizeVertical,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _loading() {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 5 * SizeConfig.blockSizeVertical),
      child: const Center(
        child: CircularProgressIndicator(),
      ),
    );
  }

  Widget _body(EarlyWarningProvider provider) {
    return Container(
      child: provider.forms.isNotEmpty
          ? Padding(
              padding: EdgeInsets.symmetric(
                  horizontal: 1 * SizeConfig.blockSizeHorizontal),
              child: RefreshIndicator(
                onRefresh: provider.get,
                child: SizedBox(
                  height: 0.60 * SizeConfig.screenHeight,
                  child: ListView.builder(
                    controller: _controller,
                    physics: const AlwaysScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: _isLoading
                        ? provider.forms.length + 1
                        : provider.forms.length,
                    itemBuilder: (context, i) {
                      if (provider.forms.length == i) {
                        return const Center(child: CircularProgressIndicator());
                      }
                      // return ExpandableListView(
                      //   form: provider.forms[i],
                      //   index: i,
                      //   canEdit: _canEdit,
                      //   roles: _roles,
                      // );

                      return _tableData(form: provider.forms[i], index: i);
                    },
                  ),
                ),
              ),
            )
          : Padding(
              padding: EdgeInsets.symmetric(
                  vertical: 5 * SizeConfig.blockSizeVertical),
              child: Center(
                  child: Column(
                children: [
                  const Text("No se encontraron registros."),
                  Padding(
                    padding:
                        EdgeInsets.only(top: 5 * SizeConfig.blockSizeVertical),
                    child: IconButton(
                      onPressed: provider.get,
                      icon: const Icon(Icons.autorenew),
                    ),
                  )
                ],
              )),
            ),
    );
  }

  Widget _tableOption(String title) {
    return Container(
      color: const Color(0xFFf1f2fb),
      width: 20 * SizeConfig.blockSizeHorizontal,
      padding: const EdgeInsets.all(10.0),
      alignment: Alignment.center,
      child: Text(
        title,
        style: const TextStyle(fontWeight: FontWeight.bold),
        textAlign: TextAlign.center,
      ),
    );
  }

  Widget _tableData({required FormModel form,required int index}) {
    return Container(
      color: index.isOdd ? const Color(0xFFf1f2fb) : Colors.white,
      padding: const EdgeInsets.all(10.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          form.children.isNotEmpty ?
          Container(
            width: 20 * SizeConfig.blockSizeHorizontal,
            padding: const EdgeInsets.all(10.0),
            alignment: Alignment.center,
            child: Text("${form.formId} +", style: const TextStyle(fontWeight: FontWeight.bold)),
          ) : Container(
            width: 20 * SizeConfig.blockSizeHorizontal,
            padding: const EdgeInsets.all(10.0),
            alignment: Alignment.center,
            child: Text("${form.formId}"),
          ),
          Container(
            width: 20 * SizeConfig.blockSizeHorizontal,
            padding: const EdgeInsets.all(10.0),
            alignment: Alignment.center,
            child: Container(
                decoration: const BoxDecoration(
                  color:  Color(0xff8480ae),
                  shape: BoxShape.circle,
                ),
                child: IconButton(
                  icon: const Icon(
                    Icons.remove_red_eye,
                    color:  Colors.white,
                  ),
                  onPressed: () {
                    Navigator.pushNamed(context, '/showEarlyWarning',
                        arguments: form);
                  },
                )),
          ),
          _canEdit
              ? Container(
                  width: 20 * SizeConfig.blockSizeHorizontal,
                  padding: const EdgeInsets.all(10.0),
                  alignment: Alignment.center,
                  child: Container(
                      decoration: const BoxDecoration(
                        color: Color(0xffffcd39),
                        shape: BoxShape.circle,
                      ),
                      child: IconButton(
                        icon: const Icon(
                          Icons.settings,
                          color: Colors.black,
                        ),
                        onPressed: () async {
                          if (!form.sentToAnalyze) {
                            final sentToAnalyze = await Navigator.pushNamed(
                                context, '/modifyEarlyWarning',
                                arguments: [form, false]);
                            if (sentToAnalyze == true) {
                              final provider =
                                  Provider.of<EarlyWarningProvider>(context,
                                      listen: false);
                              provider.get();
                            }
                          } else {
                            AwesomeDialog(
                                isDense: true,
                                context: context,
                                dialogType: DialogType.WARNING,
                                padding: const EdgeInsets.all(20.0),
                                animType: AnimType.BOTTOMSLIDE,
                                title: "SAT PDDH",
                                desc:
                                    "Lo sentimos la alerta ya ha sido enviada para analisis.",
                                btnOkOnPress: () {},
                                btnOkColor: const Color(0xFFF2B10F))
                              .show();
                          }
                        },
                      )),
                )
              : Container(),

          // Container(
          //   width: 20 * SizeConfig.blockSizeHorizontal,
          //   padding: const EdgeInsets.all(10.0),
          //   alignment: Alignment.center,
          //   child: Container(
          //       decoration: BoxDecoration(
          //         color: const Color(0xff0a58ca),
          //         shape: BoxShape.circle,
          //       ),
          //       child: IconButton(
          //         icon: Icon(Icons.check, color: const Colors.white,),
          //         onPressed: () async {
          //
          //           if(_roles.singleWhere((element) => element.roleId == 3 || element.roleId == 4, orElse: () => null) != null || _canEdit && form.analyzed){
          //             final analyzed = await Navigator.pushNamed(context, '/analyzeEarlyWarning',arguments: form.formId);
          //
          //             if(analyzed == true){
          //               final provider = Provider.of<EarlyWarningProvider>(context,listen: false);
          //               provider.get();
          //             }
          //             return;
          //
          //           }
          //
          //           AwesomeDialog(
          //               isDense: true,
          //               context: context,
          //               dialogType: DialogType.WARNING,
          //               padding: EdgeInsets.all(20.0),
          //               animType: AnimType.BOTTOMSLIDE,
          //               title: "SAT PDDH",
          //               desc: "Lo sentimos la alerta aun no ha sido analizada.",
          //               btnOkOnPress: () {},
          //               btnOkColor: const Color(0xFFF2B10F)
          //           )..show();
          //           return;
          //         },
          //       )
          //   ),
          // ),

          _analyze(form: form)
        ],
      ),
    );
  }

  Widget _analyze({required FormModel form}) {
    return Container(
      width: 20 * SizeConfig.blockSizeHorizontal,
      padding: const EdgeInsets.all(10.0),
      alignment: Alignment.center,
      child: Container(
          decoration: const BoxDecoration(
            color: Color(0xff0a58ca),
            shape: BoxShape.circle,
          ),
          child: Padding(
            padding: const EdgeInsets.all(5.0),
            child: InkWell(
              child: const Icon(
                Icons.check,
                color: Colors.white,
                size: 40,
              ),
              onLongPress: () {
                if (form.analyzed) {
                  Navigator.pushNamed(context, '/relatedEarlyWarning',
                      arguments: form.formId);

                  return;
                }
              },
              onTap: () async {
                // if (_roles.singleWhere(
                //             (element) => element.roleId == 3 || element.roleId == 4) !=
                //         null && form.sentToAnalyze || form.analyzed) {
                //   final analyzed = await Navigator.pushNamed(
                //       context, '/analyzeEarlyWarning',
                //       arguments: form.formId
                //   );
                //
                //   if (analyzed == true) {
                //     final provider = Provider.of<EarlyWarningProvider>(context,
                //         listen: false);
                //     provider.get();
                //   }
                //   return;
                // }

                AwesomeDialog(
                    isDense: true,
                    context: context,
                    dialogType: DialogType.WARNING,
                    padding: const EdgeInsets.all(20.0),
                    animType: AnimType.BOTTOMSLIDE,
                    title: "SAT PDDH",
                    desc: form.sentToAnalyze ? "Lo sentimos la alerta aun no ha sido analizada." : "Lo sentimos la alerta aun no ha sido enviada para analisis." ,
                    btnOkOnPress: () {},
                    btnOkColor: const Color(0xFFF2B10F))
                  .show();
                return;
              },
            ),
          )),
    );
  }
}

class ExpandableListView extends StatefulWidget {
  final FormModel form;
  final int index;
  final List<Role> roles;
  final bool canEdit;

  const ExpandableListView(
      {Key? key,required this.form,required this.index, required this.roles,required this.canEdit})
      : super(key: key);

  @override
  _ExpandableListViewState createState() =>  _ExpandableListViewState();
}

class _ExpandableListViewState extends State<ExpandableListView> {
  bool expandFlag = false;

  @override
  Widget build(BuildContext context) {
    return  Column(
      children: <Widget>[
        InkWell(
          child: TableRowWidget(
            form: widget.form,
            index: widget.index,
            roles: widget.roles,
            canEdit: widget.canEdit,
            isExpanded: expandFlag,
          ),
          onTap: () {
            setState(() {
              expandFlag = !expandFlag;
            });
          },
        ),
        widget.form.children.isNotEmpty
            ? ExpandableContainer(
                expanded: expandFlag,
                expandedHeight: 100.0 * widget.form.children.length,
                child:  ListView.builder(
                  itemCount: widget.form.children.length,
                  itemBuilder: (BuildContext context, int index) {
                    return ExpandableListView(
                      form: widget.form.children[index],
                      index: index,
                      canEdit: widget.canEdit,
                      roles: widget.roles,
                    );
                  },
                ))
            : Container()
      ],
    );
  }
}

class ExpandableContainer extends StatelessWidget {
  final bool expanded;
  final double collapsedHeight;
  final double expandedHeight;
  final Widget child;

  ExpandableContainer({
    required this.child,
    this.collapsedHeight = 0.0,
    this.expandedHeight = 100.0,
    this.expanded = true,
  });

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    return  AnimatedContainer(
      duration: const Duration(milliseconds: 500),
      curve: Curves.easeInOut,
      width: screenWidth,
      height: expanded ? expandedHeight : collapsedHeight,
      child:  Container(
        child: child,
        //decoration: new BoxDecoration(border: new Border.all(width: 1.0, color: const Colors.blue)),
      ),
    );
  }
}

class TableRowWidget extends StatelessWidget {
  final FormModel form;
  final int index;
  final List<Role> roles;
  final bool canEdit;
  final bool isExpanded;

  const TableRowWidget(
      {Key? key,
        required this.form,
        required this.index,
      this.canEdit = false,
        required this.roles,
      this.isExpanded = false})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: index.isOdd ? const Color(0xFFf1f2fb) : Colors.white,
      padding: const EdgeInsets.all(10.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          form.children.isNotEmpty
              ? Column(
                  children: [
                    Container(
                      width: 20 * SizeConfig.blockSizeHorizontal,
                      padding: const EdgeInsets.all(10.0),
                      alignment: Alignment.center,
                      child: Text(
                        "${form.formId}",
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                    Icon(!isExpanded
                        ? Icons.arrow_drop_down
                        : Icons.arrow_drop_up)
                  ],
                )
              : Container(
                  width: 20 * SizeConfig.blockSizeHorizontal,
                  padding: const EdgeInsets.all(10.0),
                  alignment: Alignment.center,
                  child: Text(
                    "${form.formId}",
                  ),
                ),
          Container(
            width: 20 * SizeConfig.blockSizeHorizontal,
            padding: const EdgeInsets.all(10.0),
            alignment: Alignment.center,
            child: Container(
                decoration: const BoxDecoration(
                  color: Color(0xff8480ae),
                  shape: BoxShape.circle,
                ),
                child: IconButton(
                  icon: const Icon(
                    Icons.remove_red_eye,
                    color: Colors.white,
                  ),
                  onPressed: () {
                    Navigator.pushNamed(context, '/showEarlyWarning',
                        arguments: form);
                  },
                )),
          ),
          canEdit
              ? Container(
                  width: 20 * SizeConfig.blockSizeHorizontal,
                  padding: const EdgeInsets.all(10.0),
                  alignment: Alignment.center,
                  child: Container(
                      decoration: const BoxDecoration(
                        color: Color(0xffffcd39),
                        shape: BoxShape.circle,
                      ),
                      child: IconButton(
                        icon: const Icon(
                          Icons.settings,
                          color: Colors.black,
                        ),
                        onPressed: () async {
                          if (!form.analyzed) {
                            final analyzed = await Navigator.pushNamed(
                                context, '/modifyEarlyWarning',
                                arguments: [form, false]);

                            if (analyzed == true) {
                              final provider =
                                  Provider.of<EarlyWarningProvider>(context,
                                      listen: false);
                              provider.get();
                            }
                          } else {
                            AwesomeDialog(
                                isDense: true,
                                context: context,
                                dialogType: DialogType.WARNING,
                                padding: const EdgeInsets.all(20.0),
                                animType: AnimType.BOTTOMSLIDE,
                                title: "SAT PDDH",
                                desc:
                                    "Lo sentimos la alerta ya ha sido analizada.",
                                btnOkOnPress: () {},
                                btnOkColor: const Color(0xFFF2B10F))
                              .show();
                          }
                        },
                      )),
                )
              : Container(),
          Container(
            width: 20 * SizeConfig.blockSizeHorizontal,
            padding: const EdgeInsets.all(10.0),
            alignment: Alignment.center,
            child: Container(
                decoration: const BoxDecoration(
                  color: Color(0xff0a58ca),
                  shape: BoxShape.circle,
                ),
                child: IconButton(
                  icon: const Icon(
                    Icons.check,
                    color: Colors.white,
                  ),
                  onPressed: () async {
                    // if (roles.singleWhere(
                    //             (element) =>
                    //                 element.roleId == 3 || element.roleId == 4) !=
                    //         null ||
                    //     canEdit && form.analyzed) {
                    //   final analyzed = await Navigator.pushNamed(
                    //       context, '/analyzeEarlyWarning',
                    //       arguments: form.formId);
                    //
                    //   if (analyzed == true) {
                    //     final provider = Provider.of<EarlyWarningProvider>(
                    //         context,
                    //         listen: false);
                    //     provider.get();
                    //   }
                    //   return;
                    // }

                    AwesomeDialog(
                        isDense: true,
                        context: context,
                        dialogType: DialogType.WARNING,
                        padding: const EdgeInsets.all(20.0),
                        animType: AnimType.BOTTOMSLIDE,
                        title: "SAT PDDH",
                        desc: "Lo sentimos la alerta aun no ha sido analizada.",
                        btnOkOnPress: () {},
                        btnOkColor: const Color(0xFFF2B10F))
                      .show();
                    return;
                  },
                )),
          ),
        ],
      ),
    );
  }
}
