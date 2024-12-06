class UserModel {
  final String username;
  final String email;
  final String password;
  final String profilPicture;

  UserModel(
      {required this.email,
      required this.password,
      required this.username,
      required this.profilPicture});

  Map<String, dynamic> toMap() {
    return {
      'username': username,
      'email': email,
      'password': password,
      'profilePicture': profilPicture
    };
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
        email: map['email'],
        password:map['password'] ,
        username: map['username'],
        profilPicture: map['profilePicture']);
  }
}
