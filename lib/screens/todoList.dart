import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:todo_app/models/todo.dart';
import 'package:todo_app/screens/todoDetails.dart';
import 'package:todo_app/utils/dbHelper.dart';

class TodoList extends StatefulWidget {
  @override
  _TodoListState createState() => _TodoListState();
}

class _TodoListState extends State<TodoList> {
  DbHelper helper = DbHelper();
  List<Todo> todos;
  int count = 0;

  @override
  void initState() {
    super.initState();
    if (todos == null) {
      todos = List<Todo>();
      getData();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: todos.length == 0
          ? Center(
              child: Text("Add a todo!"),
            )
          : ListView.builder(
              itemCount: count,
              itemBuilder: (BuildContext context, int position) {
                final todo = this.todos[position];
                return Dismissible(
                  direction: DismissDirection.startToEnd,
                  onDismissed: (direction) async {
                    int result;
                    result = await helper.deleteTodo(todo.id);
                    this.todos.removeAt(position);
                    if (result != 0) {
                      Fluttertoast.showToast(
                        msg: "The Todo has been deleted",
                        toastLength: Toast.LENGTH_SHORT,
                        gravity: ToastGravity.CENTER,
                        textColor:
                            Theme.of(context).primaryTextTheme.subtitle1.color,
                      );
                    }
                  },
                  background: Container(
                    color: Colors.red,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10.0,
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 2.0,
                            ),
                            child: Icon(Icons.delete),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 2.0,
                            ),
                            child: Text("Delete"),
                          ),
                        ],
                      ),
                    ),
                  ),
                  key: Key(
                    todo.id.toString(),
                  ),
                  child: Card(
                    elevation: 2.0,
                    child: ListTile(
                      leading: CircleAvatar(
                        backgroundColor: getColor(
                          todo.priority,
                        ),
                        child: Text(
                          todo.priority.toString(),
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                      title: Text(
                        todo.title,
                      ),
                      subtitle: Text(
                        todo.description,
                      ),
                      trailing: Text(
                        todo.date,
                      ),
                      onTap: () {
                        debugPrint(
                          "Tapped on " + todo.id.toString(),
                        );
                        navigateToDetails(
                          todo,
                        );
                      },
                    ),
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          navigateToDetails(
            Todo(
              '',
              3,
              '',
            ),
          );
        },
        tooltip: "Add new todo",
        child: new Icon(Icons.add),
      ),
    );
  }

  void getData() {
    final dbFuture = helper.initDb();
    dbFuture.then(
      (result) {
        final todosFuture = helper.getTodos();
        todosFuture.then(
          (result) {
            List<Todo> todoList = List<Todo>();
            count = result.length;
            for (int i = 0; i < count; i++) {
              todoList.add(
                Todo.fromObject(
                  result[i],
                ),
              );
            }
            setState(
              () {
                todos = todoList;
                count = count;
              },
            );
          },
        );
      },
    );
  }

  Color getColor(int priority) {
    switch (priority) {
      case 1:
        return Colors.red;
        break;
      case 2:
        return Colors.orange;
        break;
      case 3:
        return Colors.green;
        break;
      default:
        return Colors.green;
    }
  }

  void navigateToDetails(Todo todo) async {
    bool result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => TodoDetails(todo),
      ),
    );
    if (result == true) {
      getData();
    }
  }
}
