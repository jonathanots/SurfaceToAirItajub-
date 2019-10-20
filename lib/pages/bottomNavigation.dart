import 'package:flutter/material.dart';
import 'package:surfaceair/pages/first.dart';
import 'package:surfaceair/pages/home.dart';

class BottomNavigation extends StatefulWidget {
  @override
  _BottomNavigationState createState() => _BottomNavigationState();
}

class _BottomNavigationState extends State<BottomNavigation> {
  
  final List<Widget> pages = [
    FirstPage(
      key : PageStorageKey('page1')
    ),
    HomePage(
      key: PageStorageKey('page2')
    )
  ];

  final PageStorageBucket bucket= PageStorageBucket();
  
  int _selectedIndex = 0;
  
  /*
   *Create widget for bottomNavigation 
  */

  Widget _bottomNavigationBar(int selectedIndex) => 
    BottomNavigationBar(
      onTap: (int index) => setState(()=>_selectedIndex = index),
      currentIndex: selectedIndex,
      items: const <BottomNavigationBarItem>[
        
        BottomNavigationBarItem(
          icon: Icon(Icons.add),
          title: Text("First Page")
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.remove),
          title: Text("Second Page")
        ),

        
      ]
    );
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: _bottomNavigationBar(_selectedIndex),
      body: PageStorage(
        child: pages[_selectedIndex],
        bucket: bucket,
      ),
    );
  }
}