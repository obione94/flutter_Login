import 'package:project1/authentication/Adaptater/user_connexion_interface.dart';
import 'package:project1/authentication/Adaptater/credential/user_credential.dart';

import '../Adaptater/inscription/user_inscription.dart';

abstract class AuthenticationInterface {

  bool support(String authProvider);
  Future<bool> isUserLogged();
  Future<void> LogOut();
  Future<UserCredential> authUser(UserConnexionInterface user);
  Future<UserCredential> onSignup(UserInscription userInscription);

}