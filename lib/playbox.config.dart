import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:mpcore/mpcore.dart';

Future<Widget?>? main(List<String> args) async {
  final appConfig = PlayBoxAppConfig(
    appId: 'stopwatch',
    coverInfo: PlayBoxCoverInfo(
      name: 'StopWatch',
      color: Colors.amber,
      icon: MaterialIcons.alarm_add,
    ),
    categoryInfo: PlayBoxCategoryInfo(name: 'Tools'),
  );
  print(json.encode(appConfig));
  return null;
}
