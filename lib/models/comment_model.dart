class CommentModel {
  final String id;
  final String commmentText;
  final String commentedBy;
  final String date;

  CommentModel(
      {required this.id,
      required this.commmentText,
      required this.commentedBy,
      required this.date});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'commentText': commmentText,
      'commentedBy': commentedBy,
      'date': date
    };
  }

  static CommentModel fromMap(Map<String, dynamic> map) {
    return CommentModel(
        id: map['id'],
        commmentText: map['commentText'],
        commentedBy: map['commentedBy'],
        date: map['date']);
  }
}
