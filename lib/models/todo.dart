import 'package:cloud_firestore/cloud_firestore.dart';

class Todo {
  String id;
  String title;
  String desc;
  bool completed;
  DocumentSnapshot? documentSnapshot;

  Todo({
    required this.title,
    this.desc = '',
    this.completed = false,
    this.id = '',
    this.documentSnapshot = null,
  });

  void setTitle(String title) {
    this.title = title;
  }

  void setDescription(String desc) {
    this.desc = desc;
  }
}
