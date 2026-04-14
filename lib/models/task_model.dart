class Task {
  final int? id;
  final String title;
  final String description;
  final int isSynced; // 0 for false, 1 for true

  Task({this.id, required this.title, required this.description, this.isSynced = 0});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'isSynced': isSynced,
    };
  }

  factory Task.fromMap(Map<String, dynamic> map) {
    return Task(
      id: map['id'],
      title: map['title'],
      description: map['description'],
      isSynced: map['isSynced'],
    );
  }
}
