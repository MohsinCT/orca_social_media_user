class PostModel {
  final String id;
  final String userId;
  final String image;
  final String caption;
  final String date;
  final List<String> likedUsers; // Changed to a list of liked users

   
  PostModel({
    required this.id,
    required this.userId,
    required this.image,
    required this.caption,
    required this.date,
    required this.likedUsers,
  }); 
 
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'userId':userId,
      'image': image,
      'caption': caption,
      'date': date,
      'likedUsers': likedUsers, // Update field
    };
  }

  static PostModel fromMap(Map<String, dynamic> map) {
    return PostModel(
      id: map['id'],
      userId: map['userId'],
      image: map['image'],
      caption: map['caption'],
      date: map['date'],
      likedUsers: List.from(map['likedUsers'] ?? []), // Parse as list
    );
  }
}
