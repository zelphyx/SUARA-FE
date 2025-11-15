class NotificationModel {
  final String id;
  final String type;
  final Map<String, dynamic> data;
  final DateTime readAt;
  final DateTime createdAt;

  NotificationModel({
    required this.id,
    required this.type,
    required this.data,
    required this.readAt,
    required this.createdAt,
  });

  bool get isRead => readAt.isBefore(createdAt) == false;

  factory NotificationModel.fromJson(Map<String, dynamic> json) {
    return NotificationModel(
      id: json['id'] as String,
      type: json['type'] as String,
      data: json['data'] as Map<String, dynamic>,
      readAt: json['read_at'] != null
          ? DateTime.parse(json['read_at'] as String)
          : DateTime.fromMillisecondsSinceEpoch(0),
      createdAt: DateTime.parse(json['created_at'] as String),
    );
  }
}

