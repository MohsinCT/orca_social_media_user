class DummyPostModel {
  final String id;
  final String userId;
  final String image;
  final String caption;
  final String date;

  DummyPostModel(
      {required this.id,
      required this.userId,
      required this.image,
      required this.caption,
      required this.date});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'userId': userId,
      'image': image,
      'caption': caption,
      'date': date,
    };
  }

  static DummyPostModel fromMap(Map<String, dynamic> map) {
    return DummyPostModel(
        id: map['id'],
        userId: map['userId'],
        image: map['image'],
        caption: map['caption'],
        date: map['date']);
  }
}
