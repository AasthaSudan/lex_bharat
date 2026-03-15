class Message {
  final String id;
  final String text;
  final bool isUser;
  final DateTime timestamp;
  final bool hasActions;
  final List<String>? actionButtons;

  Message({
    required this.id,
    required this.text,
    required this.isUser,
    required this.timestamp,
    this.hasActions = false,
    this.actionButtons,
  });

  Map<String, dynamic> toJson() => {
    'id': id,
    'text': text,
    'isUser': isUser,
    'timestamp': timestamp.toIso8601String(),
    'hasActions': hasActions,
    'actionButtons': actionButtons,
  };

  factory Message.fromJson(Map<String, dynamic> json) => Message(
    id: json['id'],
    text: json['text'],
    isUser: json['isUser'],
    timestamp: DateTime.parse(json['timestamp']),
    hasActions: json['hasActions'] ?? false,
    actionButtons: json['actionButtons'] != null
        ? List<String>.from(json['actionButtons'])
        : null,
  );
}