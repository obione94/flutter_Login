import 'package:flutter/cupertino.dart';
import 'package:project1/authentication/my_api.dart';
import 'package:flutter_session_manager/flutter_session_manager.dart';
import 'package:project1/authentication/Adaptater/credential/user_credential.dart';
import 'package:project1/authentication/Adaptater/user_connexion_interface.dart';
import '../Adaptater/inscription/user_inscription.dart';
import 'authentication_interface.dart';
import 'dart:convert';

class AuthenticationProvider
{
  final List <AuthenticationInterface> authentications = [
    MyAPI(),
  ];

   static Future<bool> isUserLogged() async
   {
     if (true == await SessionManager().containsKey("user")) {
       UserCredential auth = UserCredential.fromJson(await SessionManager().get('user'));
       return auth.success;
     }

     return false;
   }

  static Future<void> LogOut() async
  {
    await SessionManager().destroy();
  }

  Future<UserCredential> onSignup(UserInscription userInscription, String provider) async
  {
    for (var authentication in authentications) {
      if (true == authentication.support(provider)) {
        return authentication.onSignup(userInscription).then((value) {
          SessionManager().set('user', value);
          return value;
        });
      }
    }

    throw Exception("none provider");
  }

  /*
  * pattern strategy/iterate
  * provider = type de connexion
  * */
  Future<UserCredential> refreshToken(UserConnexionInterface user, String provider) async
  {
    for (var authentication in authentications) {
      if (true == authentication.support(provider)) {
        return authentication.authUser(user).then((value) async {
          return await SessionManager().set('user', value).then((value)
          async {
            return UserCredential.fromJson(await SessionManager().get('user'));
          }
          );
        });
      }
    }

    throw Exception("none provider");
  }

  /*
  * pattern strategy/iterate
  * provider = type de connexion
  * */
  Future<UserCredential> authUser(UserConnexionInterface user, String provider) async
  {
    for (var authentication in authentications) {
      if (true == authentication.support(provider)) {
        print("rrrr");

        return authentication.authUser(user).then((value) async {
          print(value.success);
          print(value.password);
          print(value.token);

          return await SessionManager().set('user', value).then((value)
            async {
              return UserCredential.fromJson(await SessionManager().get('user'));
            }
          );
        });
      }
    }

    throw Exception("none provider");
  }

}