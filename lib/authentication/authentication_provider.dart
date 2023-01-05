import 'package:project1/authentication/my_api.dart';
import 'package:flutter_session_manager/flutter_session_manager.dart';
import 'package:project1/authentication/user_credential.dart';
import 'package:project1/authentication/user_connexion_interface.dart';


import 'authentication_interface.dart';

class AuthenticationProvider
{
  static UserCredential? _auth;

  final List <AuthenticationInterface> authentications = [
    MyAPI(),
  ];

   Future<bool> isUserLogged() async
   {
     if (true == await SessionManager().containsKey("user")) {
       UserCredential _auth = await SessionManager().get("user");

       return true;
     }

     return false;
   }

  Future<bool> signUp(UserConnexionInterface user, String provider) async
  {
    for (var authentication in authentications) {
      if (true == authentication.support(provider)) {
        AuthenticationInterface currentAuthentication = authentication;
        await SessionManager().set('user', currentAuthentication.signUp(user));
        UserCredential _auth = UserCredential.fromJson(await SessionManager().get("user"));
        break;
      }
    }

    return true;
  }

}