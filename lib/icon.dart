import 'package:flutter/material.dart';

class IconType {
  final int iconTypeIndex;
  IconType({required this.iconTypeIndex});

  //根據選擇的 icontype 選擇返回的 icon樣式
  Icon showIconWithTypeIndex(int iconTypeIndex) {
    switch (iconTypeIndex) {
      case 0:
        return Icon(Icons.school);
      case 1:
        return Icon(Icons.home);
      case 2:
        return Icon(Icons.favorite);
    }
    return Icon(Icons.school);
  }
}
