class UserModel {
  final String username;
  final String email;
  final String password;
  final String profilPicture;
  final String bio;
  final String nickname;
  final String location;
  final String date;

  UserModel(
      {required this.email,
      required this.nickname,
      required this.bio,
      required this.location,
      required this.password,
      required this.username,
      required this.profilPicture,
      required this.date
      });

  Map<String, dynamic> toMap() {
    return {
      'username': username,
      'email': email,
      'password': password,
      'profilePicture': profilPicture,
      'bio': bio,
      'nickname': nickname,
      'location': location,
      'date':date
    };
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
        email: map['email'],
        nickname: map['nickname'],
        bio: map['bio'],
        location: map['location'],
        password: map['password'],
        username: map['username'],
        profilPicture: map['profilePicture'], date: map['date']);
  }
}
