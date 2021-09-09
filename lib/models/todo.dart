class Todo {
  DateTime? createdTime;
  String? title;
  String? desc;
  bool? completed;

  Todo({
    required this.createdTime,
    required this.title,
    this.desc = '',
    this.completed = false,
  });
}
