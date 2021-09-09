import 'package:flutter/material.dart';

class IconType {
  // final int iconTypeIndex;
  // IconType({required this.iconTypeIndex});
  double iconSize = 40;

  //根據選擇的 icontype 選擇返回的 icon樣式
  //在下方自定義 icon 種類
  Icon showIconWithTypeIndex(int iconTypeIndex) {
    switch (iconTypeIndex) {
      case 0:
        return Icon(
          Icons.school,
          size: iconSize,
        );
      case 1:
        return Icon(
          Icons.home,
          size: iconSize,
        );
      case 2:
        return Icon(
          Icons.favorite,
          size: iconSize,
        );
    }
    return Icon(Icons.school);
  }
}
