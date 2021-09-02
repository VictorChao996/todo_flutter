/*
 * 時間: 2021/8/29
 * 輸入代辦清單的 Dialog 
 */
import 'todo.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

class ToDoDialog extends StatefulWidget {
  ToDoDialog({Key? key}) : super(key: key);

  @override
  _ToDoDialogState createState() => _ToDoDialogState();
}

class _ToDoDialogState extends State<ToDoDialog> {
  //設置textEditingController來獲取textField中的文字
  TextEditingController textController = TextEditingController();
  DateTime? pickDate; //pickDate就是completeDate (to do 的deadline)

  @override
  Widget build(BuildContext context) {
    //自定義AlertDialog來輸入to do的字串
    return Container(
      child: AlertDialog(
        title: Text('建立一個toDo 項目'),
        contentPadding: EdgeInsets.fromLTRB(20, 24, 20, 0),

        //height: MediaQuery.of(context).size.height / 6,
        content: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            TextField(
              decoration: InputDecoration(
                hintText: '輸入代辦事項',
                border: OutlineInputBorder(),
              ),
              controller: textController,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                    onPressed: () async {
                      print('openDatePicker');
                      pickDate = await showDatePicker(
                          context: context,
                          initialDate: DateTime.now(),
                          firstDate: DateTime(2000),
                          lastDate: DateTime(2030));
                    },
                    child: Text('選擇到期日')),
              ],
            ),
          ],
        ),
        actions: [
          TextButton(
              onPressed: () => Navigator.of(context).pop(), child: Text('取消')),
          TextButton(
              onPressed: () {
                print('Dialog 確定');
                //判斷textField中的文字是否為空，如果不存在就不需要更新list
                if (textController.text.isNotEmpty) {
                  // Hive.box('todos').add(textController.text);
                  // print('輸入的字串: ' + textController.text);
                  var todo = ToDo()
                    ..name = textController.text
                    ..createdTime = DateTime.now()
                    ..deadline = pickDate
                    ..done = false;
                  Hive.box<ToDo>('todos').add(todo);
                }
                Navigator.of(context).pop();
              },
              child: Text('確定'))
        ],
      ),
    );
  }
}
