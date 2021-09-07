class Todo {
  DateTime? createdTime;
  String? title;
  String? id;
  String? desc;
  bool? completed;

  Todo({
    required this.createdTime,
    required this.title,
    this.desc = '',
    this.id = '',
    this.completed = false,
  });
}
