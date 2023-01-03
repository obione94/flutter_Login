
class UserCredential {
  final String token;
  final String email;
  final String provider;

  UserCredential({required this.token, required this.email, required this.provider});

  Map<String, dynamic> toJson()
  {
    final Map<String, dynamic> user = <String, dynamic>{};
    user["token"] = token;
    user["email"] = email;
    user["provider"] = provider;
    return user;
  }

  static UserCredential fromJson(Map<String, dynamic> user)
  {
    return UserCredential( email: user["email"], token: user["token"], provider: user["provider"]);
  }
}