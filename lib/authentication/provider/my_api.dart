import 'package:flutter_session_manager/flutter_session_manager.dart';
import 'package:project1/authentication/authentication_interface.dart';
import 'package:project1/authentication/user_connexion_interface.dart';
import 'package:project1/authentication/user_credential.dart';

class MyAPI implements AuthenticationInterface
{
  static const supportAuthentication = "myapi";
  static UserCredential? _auth;
  SessionManager sessionManager = SessionManager();

  bool support(String authProvider)
  {
    return (supportAuthentication == authProvider) ;
  }

  @override
  Future<bool> isUserLogged() async
  {
    if (true == await SessionManager().containsKey("user")) {
      UserCredential _auth = await SessionManager().get("user");

      return true;
    }

    return false;
  }

  @override
  Future<void> signOut() async
  {
    await SessionManager().destroy();
    _auth = null;
  }

  @override
  Future<UserCredential> signUp(UserConnexionInterface user) async
  {
    return UserCredential(
        email: user.email, token: "John", provider: supportAuthentication
    );
    throw Exception('FooException');
  }

}