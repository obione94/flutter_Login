import 'package:project1/authentication/user_connexion_interface.dart';
import 'package:project1/authentication/user_credential.dart';

abstract class AuthenticationInterface {

  bool support(String authProvider);
  Future<bool> isUserLogged();
  Future<void> signOut();
  Future<UserCredential> signUp(UserConnexionInterface user);

}