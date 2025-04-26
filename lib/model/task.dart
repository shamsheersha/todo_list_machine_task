class Task {
  String id;
  String title;
  String description;
  bool isCompleted;
  DateTime createdAt;
  String userId;
  List<String> sharedWith;

  Task({
    required this.id,
    required this.title,
    required this.description,
     this.isCompleted = false,
    required this.createdAt,
    required this.userId,
     this.sharedWith = const [],
  });

  factory Task.fromJson(Map<String, dynamic> json) {
    return Task(
      id: json['id'],
      title: json['title'],
      description: json['description'],
      isCompleted: json['isCompleted'] ?? false,
      createdAt: DateTime.parse(json['createdAt']),
      userId: json['userId'],
      sharedWith: List<String>.from(json['sharedWith'] ?? []),
    );
  }
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'isCompleted': isCompleted,
      'createdAt': createdAt.toIso8601String(),
      'userId': userId,
      'sharedWith': sharedWith,
    };
  }

  Task copyWith({
    String? id,
    String? title,
    String? description,
    bool? isCompleted,
    DateTime? createdAt,
    String? userId,
    List<String>? sharedWith,
  }) {
    return Task(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      isCompleted: isCompleted ?? this.isCompleted,
      createdAt: createdAt ?? this.createdAt,
      userId: userId ?? this.userId,
      sharedWith: sharedWith ?? this.sharedWith,
    );
  }
}