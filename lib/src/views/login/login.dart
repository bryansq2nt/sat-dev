import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sat/src/providers/auth.dart';
import 'package:sat/src/providers/case_processing.dart';
import 'package:sat/src/providers/crisis_attention.dart';
import 'package:sat/src/providers/early_warning.dart';
import 'package:sat/src/utilities/screenSize.dart';

class LoginView extends StatefulWidget {
  const LoginView({Key? key}) : super(key: key);

  @override
  _LoginViewState createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  final _formKey = GlobalKey<FormState>();

  bool autoValidate = false;

  bool obscureText = true;

  late String email;
  late String password;
  bool loading = false;

  bool validate() {
    if (_formKey.currentState!.validate() == true) {
      _formKey.currentState!.save();
      return true;
    } else {
      setState(() {
        autoValidate = true;
      });
      return false;
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    tempCrisis = Provider.of<CrisisAttentionProvider>(context);
    tempWarning = Provider.of<EarlyWarningProvider>(context);
    tempCase = Provider.of<CaseProcessingProvider>(context);
    return Scaffold(
      body: SafeArea(
          child: Center(
        child: SingleChildScrollView(child: _loginBody()),
      )),
    );
  }

  Widget _loginBody() {
    return Form(
      key: _formKey,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          _title(),
          _entryField("USUARIO"),
          SizedBox(
            height: 2 * SizeConfig.blockSizeVertical,
          ),
          _entryField("CONTRASEÑA", isPassword: true),
          _submitButton(),
        ],
      ),
    );
  }

  Widget _title() {
    return Column(
      children: <Widget>[
        Text(
          "INICIO DE SESIÓN",
          style: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.bold,
              fontSize: 2.5 * SizeConfig.safeBlockVertical),
        ),
        Image(
          image: const AssetImage("assets/images/logo.png"),
          height: SizeConfig.safeBlockVertical * 40,
        ),
      ],
    );
  }

  Widget _entryField(String title, {bool isPassword = false}) {
    return Container(
      width: 80 * SizeConfig.blockSizeHorizontal,
      decoration: BoxDecoration(
          border: Border.all(), borderRadius: BorderRadius.circular(10.0)),
      child: TextFormField(
        style: const TextStyle(
          height: 1.2,
          color: Colors.black,
        ),
        obscureText: isPassword && obscureText ? true : false,
        keyboardType:
            !isPassword ? TextInputType.emailAddress : TextInputType.text,
        textInputAction: !isPassword ? TextInputAction.next : TextInputAction.done,
        onSaved: (value) {
          if (isPassword) {
            setState(() {
              password = value!;
            });
          } else {
            email = value!;
          }
        },
        validator: (value) {
          if (value != null && isPassword && value.length < 6) {
            return "Debe contener al menos 6 caracteres";
          } else if (!isPassword && value != null && value.length < 3) {
            return "Debe ser un usuario válido";
          } else {
            return null;
          }
        },
        onFieldSubmitted: (val){
          if(isPassword){
            if (validate()) {
              AuthProvider authProvider =
              Provider.of<AuthProvider>(context, listen: false);
              authProvider.login(
                  email: email,
                  password: password,
                  context: context,
                  warnProv: tempWarning,
                  crisisProv: tempCrisis,
                  caseProv: tempCase);
            }
          } else {

          }
        },
        decoration: InputDecoration(
          contentPadding: const EdgeInsets.all(10.0),
          labelText: title,
          labelStyle: const TextStyle(color: Colors.black),
          enabledBorder: InputBorder.none,
          focusedBorder: InputBorder.none,
        ),
      ),
    );
  }

  late CrisisAttentionProvider tempCrisis;
  late EarlyWarningProvider tempWarning;
  late CaseProcessingProvider tempCase;

  Widget _submitButton() {
    AuthProvider authProvider =
        Provider.of<AuthProvider>(context, listen: false);

    return Padding(
      padding: EdgeInsets.symmetric(vertical: 2 * SizeConfig.blockSizeVertical),
      child: SizedBox(
        width: 80 * SizeConfig.blockSizeHorizontal,
        height: 7 * SizeConfig.blockSizeVertical,
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(primary: const Color(0xFF0234D3)),
          onPressed: () {
            if (validate()) {
              authProvider.login(
                  email: email,
                  password: password,
                  context: context,
                  warnProv: tempWarning,
                  crisisProv: tempCrisis,
                  caseProv: tempCase);
            }
          },
          child: const Text(
            "INGRESAR",
            style: TextStyle(color: Colors.white),
          ),
        ),
      ),
    );
  }
}
