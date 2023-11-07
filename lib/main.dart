import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:project1/authentication/authentication_provider/authentication_provider.dart';
import 'package:project1/authentication/widget/login_screen.dart';
import 'package:project1/splash_screen.dart';
import 'package:project1/translations/language.dart';
import 'package:animated_splash_screen/animated_splash_screen.dart';

import 'myApp/widget/home.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await EasyLocalization.ensureInitialized();

  runApp(
    EasyLocalization(
        supportedLocales: Language.all,
        path: 'assets/translations', // <-- change the path of the translation files
        fallbackLocale: Language.all[0],
        child: MyApp()
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      localizationsDelegates: context.localizationDelegates,
      supportedLocales: context.supportedLocales,
      locale: context.locale,
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: AnimatedSplashScreen(
          duration: 5000,
          splash: const SplashScreen(title:"screen"),
          nextScreen: const MyHomePage(title: 'Flutter Demo'),
          backgroundColor: Colors.black12,
          centered: true,
          splashIconSize: 400,
          splashTransition: SplashTransition.fadeTransition,
      )
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  @override
  Widget build(BuildContext context) {
    return  FutureBuilder<bool> (
        future: AuthenticationProvider.isUserLogged(),
        builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
          Widget child;
          if (snapshot.hasData) {
            if (true == snapshot.data) {
              child = const Home(title: 'Bonjour');
            } else {
              child = const LoginScreen(title: 'Bienvenue');
            }
          } else {
            child =  const SplashScreen(title:"screen");
          }

          return child;
        }
    );
  }
}
