class UserModel {
  final String id;
  final String username;
  final String email;
  final String password;
  final String profilPicture;
  final String bio;
  final String nickname;
  final String location;
  final String date;
  final dynamic timestamp;
  final int followersCount;
  final bool isFollowed;

  UserModel({
    required this.id,
    required this.username,
    required this.email,
    required this.password,
    required this.profilPicture,
    required this.bio,
    required this.nickname,
    required this.location,
    required this.date,
    required this.timestamp,
    required this.followersCount,
    required this.isFollowed,
  });

  // Convert the model to a Map for storage
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'username': username,
      'email': email,
      'password': password,
      'profilePicture': profilPicture,
      'bio': bio,
      'nickname': nickname,
      'location': location,
      'date': date,
      'timestamp': timestamp,
      'followersCount': followersCount,
      'isFollowed': isFollowed,
    };
  }

  // Create a UserModel from a Map
  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      id: map['id'] ?? '',
      username: map['username'] ?? '',
      email: map['email'] ?? '',
      password: map['password'] ?? '',
      profilPicture: map['profilePicture'] ?? '',
      bio: map['bio'] ?? '',
      nickname: map['nickname'] ?? '',
      location: map['location'] ?? '',
      date: map['date'] ?? '',
      timestamp: map['timestamp'],
      followersCount: map['followersCount'] ?? 0,
      isFollowed: map['isFollowed'] ?? false,
    );
  }
}
