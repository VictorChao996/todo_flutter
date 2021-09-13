import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:todo_app/toDoListWithHive.dart';
import 'package:todo_app/model/todo.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  Hive.registerAdapter(ToDoAdapter()); //註冊build_runner生成的adapter
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Todo list',
      theme: ThemeData(
          primaryColor: Colors.amber,
          primarySwatch: Colors.orange,
          floatingActionButtonTheme: FloatingActionButtonThemeData(
              elevation: 5,
              foregroundColor: Colors.white,
              backgroundColor: Colors.amber[500])),

      home: toDoListWithHive(), //2021/8/29
    );
  }
}
