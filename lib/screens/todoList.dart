import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:todo_app/models/todo.dart';
import 'package:todo_app/screens/todoDetails.dart';
import 'package:todo_app/utils/appLocals.dart';
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
      todos = [];
      getData();
    }
  }

  @override
  Widget build(BuildContext context) {
    var appLocale = AppLocalizations.of(context);
    return Scaffold(
      body: todos.length == 0
          ? Center(
              child: Text(
                appLocale.translate("emptyList"),
              ),
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
                    setState(() {
                      this.todos.removeAt(position);
                    });
                    if (result != 0) {
                      Fluttertoast.showToast(
                        msg: appLocale.translate("todoDeletion"),
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
                            child: Text(
                              appLocale.translate("delete"),
                            ),
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
      floatingActionButton: FloatingActionButton.extended(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15.0),
        ),
        onPressed: () {
          navigateToDetails(
            Todo(
              '',
              3,
              '',
            ),
          );
        },
        tooltip: appLocale.translate("addNew"),
        icon: Icon(Icons.add),
        label: Text(
          appLocale.translate("addNew"),
        ),
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
            List<Todo> todoList = [];
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
