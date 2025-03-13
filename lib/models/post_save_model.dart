class PostSaveModel {
  final String id;
  final String postId;
  final String image;
  final String username;
  final String caption;

  PostSaveModel({
    required this.id,
    required this.postId,
    required this.image,
    required this.username,
    required this.caption,
  });

  // Convert PostSaveModel to Map
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'postId': postId,
      'image': image,
      'username': username,
      'caption': caption,
    };
  }

  // Create PostSaveModel from Map
  factory PostSaveModel.fromMap(Map<String, dynamic> map) {
    return PostSaveModel(
      id: map['id'] ?? '',
      postId: map['postId'] ?? '',
      image: map['image'] ?? '',
      username: map['username'] ?? '',
      caption: map['caption'] ?? '',
    );
  }
}
