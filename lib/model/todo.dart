//輸入: flutter packages pub run build_runner build 來產生 todo.g.dart 檔案

import 'package:hive/hive.dart';

part 'todo.g.dart';

@HiveType(typeId: 0)
//extends HiveObject來使用其中的某些 method
class ToDo extends HiveObject {
  @HiveField(0)
  late String name;

  @HiveField(1)
  DateTime? createdTime;

  @HiveField(2)
  DateTime? deadline;

  @HiveField(3)
  bool done = false;

  @HiveField(4)
  late int listIconType;
}
