class Message {
  Message({
    required this.msg,
    required this.toId,
    required this.read,
    required this.type,
    required this.sent,
    required this.fromId,
  });

  final String msg;
  final String toId;
  final String? read;
  final Type type;
  final String sent;
  final String fromId;

  factory Message.fromJson(Map<String, dynamic> json) {
    return Message(
      msg: json["msg"],
      toId: json["toId"],
      read: json["read"],
      type: Type.values.firstWhere(
        (e) => e.toString().split('.').last == json["type"],
        orElse: () => Type.text,
      ),
      sent: json["sent"],
      fromId: json["fromId"],
    );
  }

  Map<String, dynamic> toJson() {
    final data = <String , dynamic>{};
     data['toId'] = toId;
     data['msg'] = msg;
     data['read'] = read;
     data['type'] = type.name;
     data['fromId'] = fromId;
     data['sent'] = sent;
     return data;
  }
}

enum Type { text, image }
