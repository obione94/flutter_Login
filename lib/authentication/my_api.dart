import 'dart:io';

import 'package:dio/io.dart';
import 'package:flutter_session_manager/flutter_session_manager.dart';
import 'package:project1/api/request/request_manager.dart';
import 'package:project1/authentication/authentication_provider/authentication_interface.dart';
import 'package:project1/authentication/Adaptater/user_connexion_interface.dart';
import 'package:project1/authentication/Adaptater/credential/user_credential.dart';
import 'Adaptater/inscription/user_inscription.dart';
import 'package:dio/dio.dart';

class MyAPI implements AuthenticationInterface
{
  static const supportAuthentication = "myapi";
  static UserCredential? _auth;
  SessionManager sessionManager = SessionManager();

  @override
  bool support(String authProvider)
  {
    return (supportAuthentication == authProvider) ;
  }

  @override
  Future<bool> isUserLogged() async
  {
    if (true == await SessionManager().containsKey("user")) {
      UserCredential auth = await SessionManager().get("user");
      return auth.success;
    }

    return false;
  }

  @override
  Future<UserCredential> onSignup(UserInscription userInscription) async
  {

    try {
      final dio = Dio(
        BaseOptions(
          baseUrl: 'https://obione-lab.ovh/',
          connectTimeout: Duration(seconds: 5),
          receiveTimeout: Duration(seconds: 10),
        ),
      );
      (dio.httpClientAdapter as DefaultHttpClientAdapter).onHttpClientCreate =
      (HttpClient dioClient) {
        dioClient.badCertificateCallback = ((X509Certificate cert, String host, int port) => true);
        return dioClient;
      };

      final response = await  dio.put(
        '/api/registration',
        data: {
          'userName': userInscription.email,
          'password': userInscription.password
        },
        options: Options(
          headers: {
            "content-type": "application/ld+json",
            "accept": "application/json",
          },
        ),
      );

      return UserCredential(
          email: userInscription.email,
          token: "",
          provider: supportAuthentication,
          success: false,
          error: response.statusMessage??"",
          password: userInscription.password
      );

    } on DioException catch (e) {
      String msg = "error inconnue";
      if (e.response != null) {
        msg = e.response?.data["detail"];
      }

      return UserCredential(
          email: userInscription.email,
          token: "",
          provider: supportAuthentication,
          success: false,
          error: msg,
          password: userInscription.password
      );
    }
  }

  @override
  Future<void> LogOut() async
  {
    await SessionManager().destroy();
  }

  @override
  Future<UserCredential> authUser(UserConnexionInterface user) async
  {
    print("authUser");

    UserCredential eeeee = await RequestManager.dio.post(
          'authentication_token',
          data: {'userName': user.email,'password': user.password},
        ).then((Response <dynamic> value) => UserCredential(
            email: user.email,
            token: value.data["token"],
            provider: supportAuthentication,
            success: true,
            error: value.statusMessage??"",
            password: user.password
        )).onError((DioException error, StackTrace stackTrace) {
        print("onError");

        return  UserCredential(
            email: user.email,
            token: "",
            provider: supportAuthentication,
            success: false,
            error: error.response?.data["message"] ?? "error inconnue",
            password: user.password
          );
        }
      )
    ;

    return eeeee;
  }

}