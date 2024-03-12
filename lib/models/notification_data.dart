class NotificationData {
  final String id;
  final String name;
  final String description;

  NotificationData({
    required this.id,
    required this.name,
    required this.description,
  });

  factory NotificationData.fromJson(Map<String, dynamic> json) {
    return NotificationData(
      id: json['id'],
      name: json['name'],
      description: json['description'],
    );
  }
}
