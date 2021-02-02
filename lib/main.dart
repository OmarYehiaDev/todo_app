import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';
import 'package:todo_app/screens/appDrawer.dart';
import 'package:todo_app/screens/todoList.dart';
import 'package:todo_app/utils/constants.dart';
import 'package:todo_app/utils/sharedPrefsUtils.dart';
import 'package:todo_app/utils/theme/themeProvider.dart';
import 'package:todo_app/widgets/themeSwitch.dart';
import 'package:package_info/package_info.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SharedPrefsUtils.init();
  final SharedPrefsUtils _sharedPrefs = SharedPrefsUtils.getInstance();
  var isDarkTheme = _sharedPrefs.getData(SharedPreferencesKeys.isDarkTheme);
  ThemeData theme;
  if (isDarkTheme != null) {
    theme = isDarkTheme ? kDarkTheme : kLightTheme;
  } else {
    theme = kLightTheme;
  }
  runApp(
    MultiProvider(
      providers: <SingleChildWidget>[
        ChangeNotifierProvider<ThemeNotifier>(
          create: (_) => ThemeNotifier(theme),
        ),
      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Simple Todo',
      theme: themeData(context),
      debugShowCheckedModeBanner: false,
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  void initState() {
    PackageInfo.fromPlatform().then(
      (PackageInfo packageInfo) {
        appName = packageInfo.appName;
        version = packageInfo.version;
        buildNumber = packageInfo.buildNumber;
      },
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Todos"),
        actions: [
          ThemeSwitch(),
        ],
      ),
      body: TodoList(),
      drawer: AppDrawer(),
    );
  }
}

ThemeData themeData(context) {
  final themeNotifier = Provider.of<ThemeNotifier>(context);
  return themeNotifier.getTheme();
}
