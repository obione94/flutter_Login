
import 'package:project1/authentication/Adaptater/user_credential_interface.dart';

class UserCredential implements UserCredentialInterface {
  final String token;
  final String email;
  final String provider;
  final bool success;
  final String error;
  final String password;

  UserCredential({required this.token, required this.email, required this.password, required this.provider, required this.success, this.error = ""});

  Map<String, dynamic> toJson()
  {
    final Map<String, dynamic> user = <String, dynamic>{};
    user["token"] = token;
    user["email"] = email;
    user["provider"] = provider;
    user["success"] = success;
    user["error"] = error;
    user["password"] = password;

    return user;
  }

  static UserCredential fromJson(Map<String, dynamic> user)
  {
    return UserCredential(
        email: user["email"],
        token: user["token"],
        success: user["success"],
        provider: user["provider"],
        error: user["error"]??"",
        password: user["password"]
    );
  }
}