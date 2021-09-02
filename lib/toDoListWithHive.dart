/*
 *  時間: 2021/8/27
 *  練習項目: toDoListWith hive package , 新增的list可以儲存到 local了
 *             安卓機上可以成功運行，不過Edge & Chrome 都失敗了 (大概是抓不到hive資料)，
 *            另外的還有一個問題是listView.builder的繪製會優先於 HiveBox資料的提取(看之後要怎麼解決)
 *  預計計畫: 可以自定義增加的list string
 */

import 'todo.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'toDoMainScreen.dart';

class toDoListWithHive extends StatefulWidget {
  toDoListWithHive({Key? key}) : super(key: key);

  @override
  _toDoListWithHiveState createState() => _toDoListWithHiveState();
}

class _toDoListWithHiveState extends State<toDoListWithHive> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        //future: Hive.openBox<List<String>>('string'),
        future: Future.wait([Hive.openBox<ToDo>('todos')]), //Hive.box資料的提取
        builder: (context, snapshot) {
          //根據 future 結果對應到不同的畫面
          if (snapshot.connectionState == ConnectionState.done) {
            print(snapshot.connectionState);
            if (snapshot.error != null) {
              print(snapshot.error);
              return Scaffold(
                body: Center(
                  child: Text('Something went wrong\n Please Restart the app'),
                ),
              );
            } else {
              return ToDoMainScreen(); // shnpshot成功獲取時加載 toDoMainScreen()
            }
          } else {
            //當snapshot.connectionState 不為 Done 的時候顯示的畫面 (等待中)
            print(snapshot.connectionState);
            return Scaffold(
              body: Center(
                child: Text(
                  'data loading...',
                  style: TextStyle(fontSize: 40),
                ),
              ),
            );
          }
        });
  }
}
