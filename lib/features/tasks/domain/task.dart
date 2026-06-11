class Task {
  final int id;
  final String title;
  final String? description;
  final bool isCompleted;
  final int? categoryId;
  final String status;
  final String priority;
  final DateTime? dueDate;
  final DateTime createdAt;
  final DateTime updatedAt;

  const Task({
    required this.id,
    required this.title,
    this.description,
    required this.isCompleted,
    this.categoryId,
    required this.status,
    required this.priority,
    this.dueDate,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Task.fromJson(Map<String, dynamic> json) {
    return Task(
      id: json['id'] as int,
      title: json['title'] as String,
      description: json['description'] as String?,
      isCompleted: json['is_completed'] as bool,
      categoryId: json['category_id'] as int?,
      status: json['status'] as String,
      priority: json['priority'] as String,
      dueDate: json['due_date'] == null
          ? null
          : DateTime.parse(json['due_date'] as String),
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'description': description,
      'is_completed': isCompleted,
      'category_id': categoryId,
      'status': status,
      'priority': priority,
      'due_date': dueDate?.toIso8601String(),
    };
  }

  Task copyWith({
    int? id,
    String? title,
    String? description,
    bool? isCompleted,
    int? categoryId,
    String? status,
    String? priority,
    DateTime? dueDate,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Task(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      isCompleted: isCompleted ?? this.isCompleted,
      categoryId: categoryId ?? this.categoryId,
      status: status ?? this.status,
      priority: priority ?? this.priority,
      dueDate: dueDate ?? this.dueDate,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
