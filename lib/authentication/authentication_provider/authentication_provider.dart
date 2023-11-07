import 'package:project1/authentication/my_api.dart';
import 'package:flutter_session_manager/flutter_session_manager.dart';
import 'package:project1/authentication/user_credential.dart';
import 'package:project1/authentication/Adaptater/user_connexion_interface.dart';


import 'authentication_interface.dart';

class AuthenticationProvider
{
  final List <AuthenticationInterface> authentications = [
    MyAPI(),
  ];

   static Future<bool> isUserLogged() async
   {
     if (true == await SessionManager().containsKey("user")) {
       UserCredential auth = await SessionManager().get("user").then((value) {
         return UserCredential.fromJson(value);
       });

       return auth.success;
     }

     return false;
   }

  Future<UserCredential> authUser(UserConnexionInterface user, String provider) async
  {
    for (var authentication in authentications) {
      if (true == authentication.support(provider)) {
        return authentication.authUser(user).then((value) {
          return SessionManager().set('user', value).then((_) {
            return SessionManager().get("user").then((value) {
              return UserCredential.fromJson(value);
            });
          });
        });
      }
    }

    throw Exception("none provider");
  }

}