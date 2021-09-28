import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:todo_list/models/todo.dart';
import 'package:todo_list/screens/todowidget.dart';

class PaginatedList extends StatefulWidget {
  final bool completed;
  PaginatedList({required this.completed, Key? key}) : super(key: key);
  static FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
  static CollectionReference _todos =
      PaginatedList.firebaseFirestore.collection('todos');
  static final List<Todo> todoList = [];

  static void addTodo(Todo todo) => todoList.insert(0, todo);

  static void editTodo(Todo todo) {
    int index = todoList.indexWhere((element) => element.id == todo.id);
    todoList[index].title = todo.title;
    todoList[index].desc = todo.desc;
  }

  static void removeTodo(String id) {
    todoList.removeWhere((element) => element.id == id);
  }

  static void toggleTodo(String id) {
    int index = todoList.indexWhere((element) => element.id == id);
    todoList[index].completed = !(todoList[index].completed);
  }

  @override
  _PaginatedListState createState() => _PaginatedListState();
}

class _PaginatedListState extends State<PaginatedList>
    with AutomaticKeepAliveClientMixin<PaginatedList> {
  static const int limit = 8;
  final ScrollController _scrollController = ScrollController();

  DocumentSnapshot? lastTodo;
  DocumentSnapshot? lastComplete;

  bool isLoading = false;
  bool hasMore = true;

  getTodos() async {
    print('get todos');
    List<Todo> todos = PaginatedList.todoList
        .where((element) => element.completed == false)
        .toList();
    List<Todo> completedTodos = PaginatedList.todoList
        .where((element) => element.completed == true)
        .toList();
    lastTodo = todos.length == 0 ? null : todos.last.documentSnapshot;
    lastComplete = completedTodos.length == 0
        ? null
        : completedTodos.last.documentSnapshot;
    if (!hasMore) return;
    if (isLoading) return;
    setState(() => isLoading = true);
    QuerySnapshot querySnapshot;
    if (widget.completed ? (lastComplete == null) : (lastTodo == null)) {
      querySnapshot = await PaginatedList._todos
          .where('completed', isEqualTo: widget.completed)
          .orderBy('created_time', descending: true)
          .limit(limit)
          .get();
    } else {
      querySnapshot = await PaginatedList._todos
          .where('completed', isEqualTo: widget.completed)
          .orderBy('created_time', descending: true)
          .startAfterDocument(widget.completed ? lastComplete! : lastTodo!)
          .limit(limit)
          .get();
    }
    if (querySnapshot.size < limit) hasMore = false;
    if (widget.completed)
      lastComplete = querySnapshot.size != 0
          ? querySnapshot.docs[querySnapshot.size - 1]
          : lastComplete;
    querySnapshot.docs.forEach((element) {
      Todo temp = Todo(
          title: element['title'],
          desc: element['desc'],
          completed: element['completed'],
          id: element.id,
          documentSnapshot: element);
      PaginatedList.todoList.add(temp);
    });
    setState(() => isLoading = false);
  }

  @override
  void initState() {
    super.initState();
    getTodos();
    _scrollController.addListener(() {
      double maxScroll = _scrollController.position.maxScrollExtent;
      double currScroll = _scrollController.position.pixels;
      double delta = MediaQuery.of(context).size.height * 0.20;
      if (maxScroll - currScroll <= delta) {
        getTodos();
      }
    });
  }

  setPaginatedViewState() {
    setState(() {
      List<Todo> todos = PaginatedList.todoList
          .where((element) => element.completed == widget.completed)
          .toList();
      if (todos.length < limit) getTodos();
    });
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    List<Todo> displayList = [];
    PaginatedList.todoList
        .where((element) => element.completed == widget.completed)
        .forEach((todo) => displayList.add(todo));
    return Column(
      children: [
        Expanded(
          child: displayList.length == 0
              ? Center(
                  child: Text('No to-dos'),
                )
              : ListView.separated(
                  controller: _scrollController,
                  itemCount: displayList.length,
                  separatorBuilder: (context, index) => Container(
                    height: 5,
                  ),
                  itemBuilder: (context, index) {
                    Todo todo = displayList[index];
                    return TodoWidget(
                        todo: todo,
                        setPaginatedViewState: setPaginatedViewState);
                  },
                ),
        ),
        isLoading
            ? Container(
                width: MediaQuery.of(context).size.width,
                padding: EdgeInsets.all(5),
                color: Colors.yellowAccent,
                child: Text(
                  'Loading...',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              )
            : Container(),
      ],
    );
  }

  @override
  bool get wantKeepAlive => true;
}
