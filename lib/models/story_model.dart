class StoryModel {
  final String id;
  final String image;
  final String caption;
  final String date;

  StoryModel(
      {required this.id,
      required this.image,
      required this.caption,
      required this.date});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'image': image,
      'caption': caption,
      'date': date,
    };
  }

  factory StoryModel.fromMap(Map<String, dynamic> map) {
    return StoryModel(
        id: map['id'],
        image: map['image'],
        caption: map['caption'],
        date: map['date']);
  }
}
