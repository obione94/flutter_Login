
import 'package:project1/authentication/Adaptater/user_connexion_interface.dart';

class UserConnexion implements UserConnexionInterface {
  @override
  final String email;
  @override
  final String password;

  UserConnexion({required this.email, required this.password});

  Map<String, dynamic> toJson()
  {
    final Map<String, dynamic> user = <String, dynamic>{};
    user["email"] = email;
    user["password"] = password;

    return user;
  }

  static UserConnexion fromJson(Map<String, dynamic> user)
  {
    return UserConnexion(
        email: user["email"],
        password: user["password"],
    );
  }

}