/*
 * 時間: 2021/8/29
 * 練習項目: 參考網路上toDoList的範例code來實現 hive Box 的 操作 
 *          1. 使用 ValueListenableBuilder 來監聽 Hive.box
 *          2. 測試結果下來沒有遇到其他的問題(網頁的部分也沒有遇到任何問題)
 *          3. 輸入字串的 Dialog 完成
 * 
 * 時間:2021/8/30
 * 練習項目: 1.自定義 class 存取到 Hive 中
 *          2.修改 Hive.box 的操作
 *          3. toDo 的 資料新增 createaTime、completeTime、Done 等參數
 */

import 'dart:async';


import 'todo.dart';
import 'toDoDialog.dart';
import 'reorderableListView.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';

//參考網路上的範例code

class ToDoMainScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('todo', style: GoogleFonts.dancingScript(fontSize: 30)),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: ValueListenableBuilder(
            valueListenable: Hive.box<ToDo>('todos').listenable(), //監聽指定box 的資料
            builder: _buildWithBox,
          ),
        ),
      ),
      floatingActionButton: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton(
            onPressed: () {
              //onPressed事件: 開啟一個可以輸入字串的Dialog
              print('add Button Presss');
              showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return ToDoDialog();
                  });
            },
            child: Icon(Icons.add),
          ),
          FloatingActionButton(
            onPressed: () {
              print('delete all toDo');
              //onPressed事件: 清除box 中的資料(上方 valueListenable會監聽事件，根據事件重新build )
              Hive.box<ToDo>('todos').clear();
            },
            child: Icon(Icons.delete),
          )
        ],
      ),
    );
  }
}

Widget _buildWithBox(BuildContext context, Box settings, Widget? child) {
  // late var deadlineDate;
  return Column(
    crossAxisAlignment: CrossAxisAlignment.center,
    children: [
      Expanded(
        child: ValueListenableBuilder(
          valueListenable: Hive.box<ToDo>('todos').listenable(),
          builder: (BuildContext context, dynamic box, Widget? child) {
            //var todoString = box.values.toList().cast<String>();
            List<ToDo> todos = box.values.toList(); //轉換提取的資料
            //根據資料是否存在決定要渲染的畫面
            if (todos.isEmpty) {
              return Center(
                child: Text(
                  'Nothing to do.... Nice!',
                  style: TextStyle(fontSize: 30),
                ),
              );
            } else {
              // return _buildListView(context, settings, child, todos);
              return BuildReorderableListView(context, settings, child, todos);
            }
          },
        ),
      )
    ],
  );
}

// // 當todo 內有資料的時候 建立 listView 的 method
// Widget _buildListView(
//     BuildContext context, Box settings, Widget? child, List<ToDo> todos) {
//   late var deadlineDate;
//   return ListView.builder(
//       itemCount: todos.length,
//       itemBuilder: (context, index) {
//         var todo = todos[index];
//         //deadline 可為空，所以複寫要顯示的Data
//         if (todo.deadline == null) {
//           deadlineDate = '沒有選擇deadline';
//         } else {
//           deadlineDate = 'deadline: ' +
//               todo.deadline!.year.toString() +
//               '/' +
//               todo.deadline!.month.toString() +
//               '/' +
//               todo.deadline!.day.toString();
//         }
//         return Column(
//           children: [
//             ExpansionTile(
//               leading: Icon(Icons.task),
//               title: Text(todo.name),
//               children: [
//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                   children: [
//                     Text(
//                       '建立日期: ${todo.createdTime!.year}/${todo.createdTime!.month}/${todo.createdTime!.day}',
//                       style: Theme.of(context).textTheme.subtitle1,
//                     ),
//                     Text(deadlineDate,
//                         style: Theme.of(context).textTheme.subtitle1),
//                     ElevatedButton(
//                       style: ElevatedButton.styleFrom(primary: Colors.red),
//                       onPressed: () {
//                         print('delete pressed');
//                         Hive.box<ToDo>('todos').deleteAt(index);
//                       },
//                       child: Text(
//                         'DELETE',
//                         style: TextStyle(
//                           fontWeight: FontWeight.bold,
//                           color: Colors.white,
//                         ),
//                       ),
//                     )
//                   ],
//                 )
//               ],
//             ),
//             Divider(
//               height: 0.0,
//             )
//           ],
//         );
//       });
// }
