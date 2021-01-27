import 'package:flutter/material.dart';
import 'package:package_info/package_info.dart';
import 'package:todo_app/screens/todoList.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Todo App',
      theme: ThemeData(
        primarySwatch: Colors.green,
      ),
      debugShowCheckedModeBanner: false,
      home: MyHomePage(title: 'Todos'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String appName, version, buildNumber;
  @override
  void initState() {
    PackageInfo.fromPlatform().then((PackageInfo packageInfo) {
      appName = packageInfo.appName;
      version = packageInfo.version;
      buildNumber = packageInfo.buildNumber;
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        actions: [
          IconButton(
            icon: Icon(Icons.info),
            onPressed: () {
              showAboutDialog(
                context: context,
                applicationName: appName,
                applicationVersion: "$version+$buildNumber",
                applicationIcon: CircleAvatar(
                  backgroundImage: AssetImage("assets/images/to-do-list.png"),
                ),
                children: [
                  Text(
                    "All rights reserved to Omar Yehia and © 2021 SpiderDevsTechnologies Inc.",
                  ),
                ],
              );
            },
          ),
        ],
      ),
      body: TodoList(),
    );
  }
}
