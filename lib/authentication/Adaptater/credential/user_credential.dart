
import 'package:project1/authentication/Adaptater/user_credential_interface.dart';

class UserCredential implements UserCredentialInterface {
  final String token;
  final String email;
  final String provider;
  final bool success;

  UserCredential({required this.token, required this.email, required this.provider, required this.success});

  Map<String, dynamic> toJson()
  {
    final Map<String, dynamic> user = <String, dynamic>{};
    user["token"] = token;
    user["email"] = email;
    user["provider"] = provider;
    user["success"] = success;

    return user;
  }

  static UserCredential fromJson(Map<String, dynamic> user)
  {
    return UserCredential(
        email: user["email"],
        token: user["token"],
        success: user["success"],
        provider: user["provider"]
    );
  }
}