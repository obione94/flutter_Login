import 'package:flutter/material.dart';
import 'package:flutter_login/flutter_login.dart';
import 'package:project1/authentication/Adaptater/inscription/user_inscription.dart';
import 'package:project1/authentication/authentication_provider/authentication_provider.dart';
import 'package:project1/authentication/Adaptater/connexion/user_connexion.dart';
import 'package:project1/main.dart';
import 'package:project1/myApp/widget/home.dart';
import 'package:dio/dio.dart';

const users = {
  'dribbble@gmail.com': '12345',
  'hunter@gmail.com': 'hunter',
  'toto@gmail.com': 'azerty',
};


class LoginScreen extends StatefulWidget {
  final String title;
  const LoginScreen({super.key, required this.title});
  @override
  State<LoginScreen> createState() => _LoginScreen();
}


class _LoginScreen extends State<LoginScreen> {

  static const String routeName = "login";

  Future <void> _isLogged() async {
    if (await AuthenticationProvider.isUserLogged()) {
      Future(() {
        Navigator.of(context).pushReplacement(MaterialPageRoute(
          builder: (context) => const Home(title: "rrrr"),
        ));
      });
    }
  }
  
  Duration get loginTime => const Duration(milliseconds: 2250);

  Future<String?> _authUser (LoginData data) {
    return AuthenticationProvider().authUser(
        UserConnexion(email: data.name, password: data.password),
        "myapi"
    ).then((_) async {
      if (true == await AuthenticationProvider.isUserLogged()) {
        return null;
      }
      return _.error;
    });
  }

  Future<String?> _signupUser(SignupData data) {
    return AuthenticationProvider().onSignup(
        UserInscription(email: data.name??"", password: data.password??""),
        "myapi"
    ).then((_) async {
      if (true == await AuthenticationProvider.isUserLogged()) {
        return null;
      }
      return _.error;
    });
  }

  Future<String?> _recoverPassword(String name) {
    debugPrint('Name: $name');
    return Future.delayed(loginTime).then((_) {
      if (!users.containsKey(name)) {
        return 'User not exists';
      }
      return null;
    });
  }
// totoro@opmail.com
  Future<String?>? _confirmSignup(String msg, LoginData loginData) {
    return Future.delayed(loginTime).then((_) {
      return null;
    });
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_){
      _isLogged();
    });
  }

  @override
  Widget build(BuildContext context) {
    return FlutterLogin(
      title: 'MyApp',
      logo: const AssetImage('assets/logo.png'),
      onLogin: (_) => _authUser(_),
      onSignup: (_) =>_signupUser(_),
      //onConfirmSignup: (String msg, LoginData loginData) =>_confirmSignup(msg, loginData),
      onSubmitAnimationCompleted: () async {
          Navigator.of(context).pushReplacement(MaterialPageRoute(
            builder: (context) => const LoginScreen(title: 'sss'),
          ));
      },
      onRecoverPassword: (_) => _recoverPassword(_),
      messages: LoginMessages(
        userHint: 'User',
        passwordHint: 'Pass',
        confirmPasswordHint: 'Confirm',
        loginButton: 'LOG IN',
        signupButton: 'REGISTER',
        forgotPasswordButton: 'Forgot huh?',
        recoverPasswordButton: 'HELP ME',
        goBackButton: 'GO BACK',
        confirmPasswordError: 'Not match!',
        recoverPasswordDescription:
        'Lorem Ipsum is simply dummy text of the printing and typesetting industry',
        recoverPasswordSuccess: 'Password rescued successfully',
      ),
    );
  }
}