import 'dart:developer';
import 'dart:io';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
// import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:provider/provider.dart';
import 'package:sat/router.dart' as router;
import 'package:sat/src/providers/auth.dart';
import 'package:sat/src/providers/banners.dart';
import 'package:sat/src/providers/bottom_bar.dart';
import 'package:sat/src/providers/case_processing.dart';
import 'package:sat/src/providers/crisis_attention.dart';
import 'package:sat/src/providers/early_warning.dart';
import 'package:sat/src/providers/onboarding.dart';
import 'package:sat/src/shared_preferences/shared_preferences.dart';

import 'firebase_options.dart';

Future main() async {

  try {

    WidgetsFlutterBinding.ensureInitialized();
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    final _prefs =  PreferenciasUsuario();
    await _prefs.initPrefs();



    // if (Platform.isAndroid) {
    //   await AndroidInAppWebViewController.setWebContentsDebuggingEnabled(true);
    //
    //   var swAvailable = await AndroidWebViewFeature.isFeatureSupported(
    //       AndroidWebViewFeature.SERVICE_WORKER_BASIC_USAGE);
    //   var swInterceptAvailable = await AndroidWebViewFeature.isFeatureSupported(
    //       AndroidWebViewFeature.SERVICE_WORKER_SHOULD_INTERCEPT_REQUEST);
    //
    //   if (swAvailable && swInterceptAvailable) {
    //     AndroidServiceWorkerController serviceWorkerController =
    //     AndroidServiceWorkerController.instance();
    //
    //     serviceWorkerController.serviceWorkerClient = AndroidServiceWorkerClient(
    //       shouldInterceptRequest: (request) async {
    //         print(request);
    //         return null;
    //       },
    //     );
    //   }
    // }

    SystemChrome.setPreferredOrientations(
        [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown])
        .then((_){
      runApp(MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_) => OnBoardingProvider()),
          ChangeNotifierProvider(create: (_) => AuthProvider()),
          ChangeNotifierProvider(create: (_) => BannersProvider()),
          ChangeNotifierProvider(create: (_) => BottomBarProvider()),
          ChangeNotifierProvider(create: (_) => EarlyWarningProvider()),
          ChangeNotifierProvider(create: (_) => CrisisAttentionProvider()),
          ChangeNotifierProvider(create: (_) => CaseProcessingProvider()),
        ],
        child: MaterialApp(
          debugShowCheckedModeBanner: false,
          initialRoute: '/root',
          onGenerateRoute: router.generateRoutes,
          builder: EasyLoading.init(),
        ),
      ));
    }
    );

    configLoading();
  } catch(e){
    log(e.toString());
    return;
  }

}


void configLoading() {
  EasyLoading.instance
    ..indicatorType = EasyLoadingIndicatorType.fadingCircle
    ..userInteractions = false
    ..loadingStyle = EasyLoadingStyle.light;
}
