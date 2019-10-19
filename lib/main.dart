import 'package:flutter/material.dart';
import 'package:surfaceair/pages/home.dart';
import 'package:surfaceair/pages/bottomNavigation.dart';
import 'package:surfaceair/pages/test.dart';

void main() {
  runApp(
    MaterialApp(
      debugShowCheckedModeBanner: false,
      debugShowMaterialGrid: false,
      home: BottomNavigation(),
      routes: <String, WidgetBuilder>{
        '/bottomNavigation':(context)=> BottomNavigation(),
        '/home': (context)=> HomePage(),
        '/test':(context)=> MeasuresPage(),
      },)
  );
}