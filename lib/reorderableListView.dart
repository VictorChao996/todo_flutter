/*
 * 時間: 2021/9/1 
 * 更動項目: 1. 建立ReorderableListView 在listView的外層，這樣listView中的 todo list 就可以拖動
 *          2. listView外層原本用Expansion包住，現在改回 slidable ，因為 expansion 會跟 ReorderableListView 的 拖動動作有衝突
 * 時間: 2021/9/2
 * 更動項目: 1.ReorderableListView中的buildDefaultDragHandles可以設為false關閉預設拖動事件，
 *            自己重新定義一個(使用ReorderableDragStartListener或 ReorderableDelayedDragStartListener包住要拖動的widget,前者處理
 *              短按事件，後者為long pressed事件)，這邊使用後者，這樣才不會跟Slidable的手勢有所衝突
 *          2.Hive.box 資料的清除&存取成功(clear()返回一個future，所以要await之後再add資料進去才不會抱錯)
 */

import 'todo.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:hive/hive.dart';

class BuildReorderableListView extends StatefulWidget {
  final BuildContext context;
  final Box settings;
  final Widget? child;
  final List<ToDo> todos;
  const BuildReorderableListView(
      this.context, this.settings, this.child, this.todos,
      {Key? key})
      : super(key: key);

  @override
  _BuildReorderableListViewState createState() =>
      _BuildReorderableListViewState();
}

class _BuildReorderableListViewState extends State<BuildReorderableListView> {
  late var deadlineDate;

  //method for refresh individual Hive data
  refreshHiveData() async {
    //clear返回一個Future，這邊 await 一下 不然在清除之前就執行下面的add 方法會報錯
    await Hive.box<ToDo>('todos').clear();
    for (var todo in widget.todos) {
      Hive.box<ToDo>('todos').add(todo);
    }
  }

  @override
  Widget build(BuildContext context) {
    return ReorderableListView.builder(
        buildDefaultDragHandles: false, //取消預設的拖動&樣式，改成自定義
        itemCount: widget.todos.length,
        itemBuilder: (context, index) {
          var todo = widget.todos[index];
          //deadline 可為空，所以複寫要顯示的Data
          if (todo.deadline == null) {
            deadlineDate = 'deadline: 無';
          } else {
            deadlineDate = 'deadline: ' +
                todo.deadline!.year.toString() +
                '/' +
                todo.deadline!.month.toString() +
                '/' +
                todo.deadline!.day.toString();
          }
          return Column(
            key: Key('$index'),
            children: [
              //使listtile可以滑動
              Slidable(
                key: Key('$index'),
                //把listile用這個widget包住(在長按下拖動的 widget)，如果是ReorderableDragStartListener會跟自定義的slidable有手勢衝突
                child: ReorderableDelayedDragStartListener(
                  index: index,
                  child: CheckboxListTile(
                    value: todo.done,
                    onChanged: (value) async {
                      print('checked');
                      todo.done = value!;
                      print(todo.done);
                      refreshHiveData();
                    },
                    dense: true,
                    contentPadding: EdgeInsets.symmetric(horizontal: 8.0),
                    controlAffinity: ListTileControlAffinity.trailing,
                    title: Text(
                      todo.name,
                      style: Theme.of(context).textTheme.headline5,
                    ),
                    secondary: Icon(Icons.task),
                    subtitle: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '建立日期: ${todo.createdTime!.year}/${todo.createdTime!.month}/${todo.createdTime!.day}',
                          ),
                          Text(deadlineDate)
                        ]),
                  ),
                ),
                actionPane: SlidableDrawerActionPane(),
                actionExtentRatio: 0.25,
                secondaryActions: [
                  IconSlideAction(
                    caption: 'DELETE',
                    color: Colors.red,
                    icon: Icons.delete,
                    onTap: () {
                      print('new delete button');
                      Hive.box<ToDo>('todos').deleteAt(index);
                    },
                  )
                ],
              ),
              Divider(
                height: 0,
              ),
            ],
          );
        },
        onReorder: (int oldIndex, int newIndex) async {
          setState(() {
            if (oldIndex < newIndex) {
              newIndex -= 1;
            }
            final todoTemp = widget.todos[oldIndex];
            widget.todos.removeAt(oldIndex);
            widget.todos.insert(newIndex, todoTemp);

            for (int i = 0; i < widget.todos.length; i++) {
              print(widget.todos[i].name);
            }
          });
          refreshHiveData();
        });
  }
}
