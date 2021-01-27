import 'package:flutter/material.dart';
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
                return Card(
                  elevation: 2.0,
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundColor: getColor(
                        this.todos[position].priority,
                      ),
                      child: Text(
                        this.todos[position].priority.toString(),
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                    title: Text(
                      this.todos[position].title,
                    ),
                    subtitle: Text(
                      this.todos[position].description,
                    ),
                    trailing: Text(
                      this.todos[position].date,
                    ),
                    onTap: () {
                      debugPrint(
                        "Tapped on " + this.todos[position].id.toString(),
                      );
                      navigateToDetails(
                        this.todos[position],
                      );
                    },
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
              debugPrint(
                todoList[i].title,
              );
            }
            setState(
              () {
                todos = todoList;
                count = count;
              },
            );
            debugPrint(
              "Items " + count.toString(),
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
