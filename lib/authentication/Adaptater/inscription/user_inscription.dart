class UserInscription {
  @override
  final String email;
  @override
  final String password;

  UserInscription({required this.email, required this.password});

  Map<String, dynamic> toJson()
  {
    final Map<String, dynamic> user = <String, dynamic>{};
    user["email"] = email;
    user["password"] = password;

    return user;
  }

  static UserInscription fromJson(Map<String, dynamic> user)
  {
    return UserInscription(
      email: user["email"],
      password: user["password"],
    );
  }
}