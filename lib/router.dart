import 'package:flutter/material.dart';
import 'package:sat/root.dart';
import 'package:sat/src/views/case_processing/add.dart';
import 'package:sat/src/views/case_processing/involved/add.dart';
import 'package:sat/src/views/case_processing/list.dart';
import 'package:sat/src/views/crisis_attention/add.dart';
import 'package:sat/src/views/crisis_attention/analyze.dart';
import 'package:sat/src/views/crisis_attention/list.dart';
import 'package:sat/src/views/crisis_attention/modify.dart';
import 'package:sat/src/views/crisis_attention/related/add.dart';
import 'package:sat/src/views/crisis_attention/related/list.dart';
import 'package:sat/src/views/crisis_attention/search.dart';
import 'package:sat/src/views/crisis_attention/show.dart';
import 'package:sat/src/views/dashboard/dashboard.dart';
import 'package:sat/src/views/early_warnings/add.dart';
import 'package:sat/src/views/early_warnings/analyze.dart';
import 'package:sat/src/views/early_warnings/list.dart';
import 'package:sat/src/views/early_warnings/modify.dart';
import 'package:sat/src/views/early_warnings/related/add.dart';
import 'package:sat/src/views/early_warnings/related/list.dart';
import 'package:sat/src/views/early_warnings/search.dart';
import 'package:sat/src/views/early_warnings/show.dart';
import 'package:sat/src/views/home/home.dart';
import 'package:sat/src/views/login/login.dart';
import 'package:sat/src/views/profile/profile.dart';
import 'package:sat/src/models/form/form_v1.dart';



Route<dynamic> generateRoutes(RouteSettings settings) {
  switch (settings.name) {
    case '/root':
      return MaterialPageRoute(builder: (context) => Root());
    case '/login':
      return MaterialPageRoute(builder: (context) => LoginView());
    case '/home':
      return PageRouteBuilder(pageBuilder: (context, __, ___) => HomeView());
    case '/earlyWarnings':
      return PageRouteBuilder(pageBuilder: (context, __, ___) => EarlyWarningsView());
      break;
    case '/addEarlyWarning':
      return PageRouteBuilder(
          pageBuilder: (context, __, ___) => AddEarlyWarningView(),
        settings: settings
      );
      break;
    case '/showEarlyWarning':
      return PageRouteBuilder(
          pageBuilder: (context, __, ___) =>
              ShowEarlyWarningView(form: settings.arguments as FormModel));
      break;
    case '/modifyEarlyWarning':
      return PageRouteBuilder(
          pageBuilder: (context, __, ___) => ModifyEarlyWarningView(
                form: (settings.arguments as List)[0],
                isLocal: (settings.arguments as List)[1],
              ),settings: settings);
      break;
    case '/analyzeEarlyWarning':
      return PageRouteBuilder(
          pageBuilder: (context, __, ___) => AnalyzeEarlyWarningView(
                formId: settings.arguments as int,
              ));
      break;
    case '/relatedEarlyWarning':
      return PageRouteBuilder(
          pageBuilder: (context, __, ___) => RelatedEarlyWarningsView(
                formId: settings.arguments as int)
              );
      break;
    case '/addRelatedEarlyWarning':
      return PageRouteBuilder(
          pageBuilder: (context, __, ___) => AddRelatedEarlyWarningView(
                formId: settings.arguments as int,
              ));
      break;
    case '/searchEarlyWarning':
      return PageRouteBuilder(
          pageBuilder: (context, __, ___) => SearchEarlyWarningView());
      break;

    case '/crisisAttention':
      return PageRouteBuilder(
          pageBuilder: (_, __, ___) => CrisisAttentionView());
      break;

    case '/addCrisisAttention':
      return PageRouteBuilder(
          pageBuilder: (_, __, ___) => AddCrisisAttentionWarningView(),settings: settings);
      break;

    case '/showCrisisAttention':
      return PageRouteBuilder(
          pageBuilder: (_, __, ___) => ShowCrisisAttentionView(
                form: settings.arguments as FormModel,
              ));
      break;

    case '/modifyCrisisAttention':
      return PageRouteBuilder(
          pageBuilder: (_, __, ___) => ModifyCrisisAttentionView(
                form: (settings.arguments as List)[0],
                isLocal: (settings.arguments as List)[1],
              ),settings: settings);
      break;

    case '/analyzeCrisisAttention':
      return PageRouteBuilder(
          pageBuilder: (_, __, ___) => AnalyzeCrisisAttentionView(
                formId: settings.arguments as int,
              ));
      break;
    case '/relatedCrisisAttention':
      return PageRouteBuilder(
          pageBuilder: (_, __, ___) => RelatedCrisisAttentionView(
                formId: settings.arguments as int,
              ));
      break;
    case '/addRelatedCrisisAttention':
      return PageRouteBuilder(
          pageBuilder: (_, __, ___) => AddRelatedCrisisAttentionView(
                formId: settings.arguments as int,
              ));
      break;
    case '/searchCrisisAttention':
      return PageRouteBuilder(
          pageBuilder: (_, __, ___) => SearchCrisisAttentionView());
      break;

    case '/caseProcessing':
      return PageRouteBuilder(
          pageBuilder: (_, __, ___) => CaseProcessingView());
      break;

    case '/addCaseProcessing':
      return PageRouteBuilder(
          pageBuilder: (_, __, ___) => CaseProcessingAdd(
                formId:settings.arguments as int,
            enabled:  true,
              ),settings: settings);
      break;
    case '/showCaseProcessing':
      return PageRouteBuilder(
          pageBuilder: (_, __, ___) => CaseProcessingAdd(
            formId: settings.arguments as int,
            enabled: false,
          ),settings: settings);
      break;
    case '/addInvolved':
      return PageRouteBuilder(
          pageBuilder: (_, __, ___) => AddInvolvedView(
                caseId: (settings.arguments as List)[0],
            formId: (settings.arguments as List)[1],
            enabled: (settings.arguments as List)[2] ?? true,
              ),settings: settings);
      break;

    case '/dashboard':
      return PageRouteBuilder(pageBuilder: (_, __, ___) => DashboardView());
      break;
    case '/profile':
      return PageRouteBuilder(pageBuilder: (_, __, ___) => ProfileView());
      break;
    default:
      return MaterialPageRoute(builder: (context) => Root());
  }
}
