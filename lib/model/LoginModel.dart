class User {
  final String username;
  final String password;
  final String? token;

  User({
    required this.username,
    required this.password,
    this.token,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      username: json['username'],
      password: json['password'],
      token: json['token'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'username': username,
      'password': password,
      'token': token,
    };
  }
}

class LoginModel {
  final User? user;
  final String? message;

  LoginModel({this.user, this.message});

  factory LoginModel.fromJson(Map<String, dynamic> json) {
    return LoginModel(
      user: json['user'] != null ? User.fromJson(json['user']) : null,
      message: json['message'],
    );
  }
}
