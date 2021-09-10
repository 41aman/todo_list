class Todo {
  String id;
  String title;
  String desc;
  bool completed;

  Todo({
    required this.title,
    this.desc = '',
    this.completed = false,
    this.id = '',
  });

  void setTitle(String title) {
    this.title = title;
  }

  void setDescription(String desc) {
    this.desc = desc;
  }
}
