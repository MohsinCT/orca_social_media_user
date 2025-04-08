class StoryModel {
  final String id;
  final String image;
  final String caption;
  final String date;
  final bool isViewed;

  StoryModel({
    required this.id,
    required this.image,
    required this.caption,
    required this.date,
    this.isViewed = false, // default false
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'image': image,
      'caption': caption,
      'date': date,
      'isViewed': isViewed,
    };
  }

  factory StoryModel.fromMap(Map<String, dynamic> map) {
    return StoryModel(
      id: map['id'],
      image: map['image'],
      caption: map['caption'],
      date: map['date'],
      isViewed: map['isViewed'] ?? false,
    );
  }
}
