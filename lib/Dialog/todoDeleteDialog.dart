import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:todo_app/model/todo.dart';

class todoDeleteDialog extends StatelessWidget {
  const todoDeleteDialog({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('要刪除所有的todo嗎?'),
      actions: [
        TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: Text('CANCEL')),
        TextButton(
            onPressed: () {
              //onPressed事件: 清除box 中的資料(上方 valueListenable會監聽事件，根據事件重新build )
              print('delete all toDo');
              Hive.box<ToDo>('todos').clear();
              Navigator.of(context).pop();
            },
            child: Text(
              'DELETE ALL',
              style: TextStyle(color: Theme.of(context).primaryColor),
            )),
      ],
    );
  }
}
