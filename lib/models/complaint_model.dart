class ComplaintModel {
  final String id;
  final String complaint;
  final String replayComplaint;
  final String date;

  ComplaintModel(
      {required this.id,
      required this.complaint,
      required this.replayComplaint,
      required this.date});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'complaint': complaint,
      'replayComplaint': replayComplaint,
      'Date': date
    };
  }

  factory ComplaintModel.fromMap(Map<String, dynamic> map) {
    return ComplaintModel(
        id: map['id'] ?? '',
        complaint: map['complaint'] ?? '',
        replayComplaint: map['replayComplaint'] ?? '',
        date: map['date'] ?? '');
  }
}
