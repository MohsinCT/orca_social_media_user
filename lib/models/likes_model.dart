class LikesModel {
  final String id;
  final List<String> likedUsers;
  final int likesCount;

  LikesModel({
    required this.id,
    required this.likedUsers,
    this.likesCount = 0,
  });

  // Convert LikesModel to Map
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'likedUsers': likedUsers,
      'likesCount': likesCount,
    };
  }

  // Create LikesModel from Map
  factory LikesModel.fromMap(Map<String, dynamic> map) {
    return LikesModel(
      id: map['id'],
      likedUsers: List<String>.from(map['likedUsers'] ?? []),
      likesCount: map['likesCount'] ?? 0,
    );
  }
}
