import 'dart:io';

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
// import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:flutter_svg/svg.dart';
import 'package:sat/src/views/home/components/bottom_bar.dart';
import 'package:webview_flutter/webview_flutter.dart';

class DashboardView extends StatefulWidget {
  @override
  _DashboardViewState createState() => _DashboardViewState();
}

class _DashboardViewState extends State<DashboardView> {
  final GlobalKey webViewKey = GlobalKey();

  // late InAppWebViewController webViewController;
  // InAppWebViewGroupOptions options = InAppWebViewGroupOptions(
  //     crossPlatform: InAppWebViewOptions(
  //       useShouldOverrideUrlLoading: true,
  //       mediaPlaybackRequiresUserGesture: false,
  //     ),
  //     android: AndroidInAppWebViewOptions(
  //       useHybridComposition: true,
  //     ),
  //     ios: IOSInAppWebViewOptions(
  //       allowsInlineMediaPlayback: true,
  //     ));
  //
  // late PullToRefreshController pullToRefreshController;
  String url = "";
  double progress = 0;
  final urlController = TextEditingController();

  var timeout = Duration(seconds: 3);
  var ms = Duration(milliseconds: 1);

  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    if (Platform.isAndroid) WebView.platform = AndroidWebView();
  }



  @override
  void dispose() {
    super.dispose();
  }

  bool hasError = false;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        leading: Container(),
        backgroundColor: Colors.white,
        centerTitle: true,
        title: const Text(
          "Dashboard",
          style: TextStyle(color: Color(0xff1f0757)),
        ),
      ),
      backgroundColor: const Color(0xFFe2e9fe),
      body: Stack(
        children: [
          const WebView(
            initialUrl: "https://app.powerbi.com/view?r=eyJrIjoiZmE1Mzc1ZWYtN2I4OC00YjQ2LTgwMzYtZjk5ZWM1ZWE5MDEyIiwidCI6ImRlMjI0OGJlLTY4ZTktNDNlNi04ZmU2LTUxYzFhZjc5ZGE1MSJ9",
          ),
          // InAppWebView(
          //   key: webViewKey,
          //   initialUrlRequest: URLRequest(
          //       url: Uri.parse(
          //           "https://app.powerbi.com/view?r=eyJrIjoiZmE1Mzc1ZWYtN2I4OC00YjQ2LTgwMzYtZjk5ZWM1ZWE5MDEyIiwidCI6ImRlMjI0OGJlLTY4ZTktNDNlNi04ZmU2LTUxYzFhZjc5ZGE1MSJ9")),
          //   initialOptions: options,
          //   pullToRefreshController: pullToRefreshController,
          //   onWebViewCreated: (controller) {
          //     webViewController = controller;
          //   },
          //   onLoadStart: (controller, url) {
          //     setState(() {
          //       this.url = url.toString();
          //       urlController.text = this.url;
          //       hasError = false;
          //     });
          //   },
          //   androidOnPermissionRequest: (controller, origin, resources) async {
          //     return PermissionRequestResponse(
          //         resources: resources,
          //         action: PermissionRequestResponseAction.GRANT);
          //   },
          //   onLoadStop: (controller, url) async {
          //     pullToRefreshController.endRefreshing();
          //     setState(() {
          //       this.url = url.toString();
          //       urlController.text = this.url;
          //     });
          //   },
          //   onLoadError: (controller, url, code, message) {
          //     pullToRefreshController.endRefreshing();
          //     setState(() {
          //       hasError = true;
          //     });
          //   },
          //   onProgressChanged: (controller, progress) {
          //     if (progress == 100) {
          //       pullToRefreshController.endRefreshing();
          //     }
          //     setState(() {
          //       this.progress = progress / 100;
          //       urlController.text = this.url;
          //     });
          //   },
          //   onUpdateVisitedHistory: (controller, url, androidIsReload) {
          //     setState(() {
          //       this.url = url.toString();
          //       urlController.text = this.url;
          //     });
          //   },
          //   onConsoleMessage: (controller, consoleMessage) {
          //     print(consoleMessage);
          //   },
          // ),
          hasError
              ? Container(
                  color: Colors.white,
                  width: MediaQuery.of(context).size.width,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Center(
                              child: Container(
                                width: size.width * 0.8,
                                child: Text(
                                  'Iniciaste sesión sin acceso a internet.'
                                      .toUpperCase(),
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      fontSize: 22,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            Center(
                              child: Container(
                                padding: EdgeInsets.symmetric(
                                    vertical: 8, horizontal: 3),
                                decoration: BoxDecoration(
                                    color: Colors.grey.withOpacity(0.6),
                                    borderRadius: BorderRadius.circular(5)),
                                width: size.width * 0.8,
                                child: Text(
                                  'Todos los datos se guardan de manera local y seran sincronizados cuando tengas conexión a internnet.'
                                      .toUpperCase(),
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      fontSize: 11,
                                      fontWeight: FontWeight.normal),
                                ),
                              ),
                            ),
                            Center(
                              child: Container(
                                height: size.height * 0.4,
                                width: size.width * 0.7,
                                child:
                                    SvgPicture.asset('assets/images/local.svg'),
                              ),
                            ),
                            isLoading
                                ? Container(
                                    child: Center(
                                      child: CircularProgressIndicator(),
                                    ),
                                  )
                                : Center(
                                    child: ElevatedButton(
                                      onPressed: () async {
                                        isLoading = true;
                                        setState(() {});

                                        try {
                                          final result =
                                              await InternetAddress.lookup(
                                                  'google.com');
                                          if (result.isNotEmpty &&
                                              result[0].rawAddress.isNotEmpty) {
                                            setState(() {
                                              hasError = true;
                                              isLoading = false;
                                            });
                                            Navigator.pushReplacement(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (BuildContext
                                                            context) =>
                                                        super.widget));
                                          }
                                        } on SocketException catch (_) {
                                          print('No hay conexión a internet.');

                                          dialog(
                                              'Aún no tienes acceso a internet , inténtalo más tarde.',
                                              context);

                                          setState(() {});
                                          isLoading = false;
                                        }
                                      },
                                      style: ElevatedButton.styleFrom(
                                          primary: Color(0xFF0234D3)),
                                      child: Text(
                                        'Comporabar Conexión'.toUpperCase(),
                                        style: TextStyle(
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                  )
                          ],
                        ),
                      ),
                    ],
                  ),
                )
              : Container()
        ],
      ),
      bottomNavigationBar: BottomBarWidget(),
    );
  }

  dialog(String value, BuildContext context) {
    AwesomeDialog(
        isDense: true,
        context: context,
        dialogType: DialogType.ERROR,
        padding: EdgeInsets.all(20.0),
        animType: AnimType.BOTTOMSLIDE,
        title: "SAT PDDH",
        desc: value,
        btnOkOnPress: () {},
        btnOkColor: Color(0xFFF2B10F))
      ..show();
  }

  /*SafeArea(
  child: SingleChildScrollView(
  child: Center(
  child: Padding(
  padding: const EdgeInsets.all(8.0),
  child: Column(
  mainAxisAlignment: MainAxisAlignment.start,
  children: [
  LineChartWidget(),
  SizedBox(height: 2 * SizeConfig.blockSizeVertical,),
  PieChartSample2()
  ],
  ),
  )
  ),
  ),
  ),*/

}
