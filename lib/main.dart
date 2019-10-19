import 'package:flutter/material.dart';
import 'package:surfaceair/pages/home.dart';
import 'package:surfaceair/pages/test.dart';

void main() {
  runApp(
    MaterialApp(
      debugShowCheckedModeBanner: false,
      debugShowMaterialGrid: false,
      home: HomePage(),
      routes: <String, WidgetBuilder>{
        '/home': (context)=> HomePage(),
        '/test':(context)=> MeasuresPage(),
      },)
  );
}