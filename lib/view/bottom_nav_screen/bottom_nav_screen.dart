import 'package:flutter/material.dart';
import 'package:mini_project/utils/color_constant/color_constant.dart';
import 'package:mini_project/view/home_screen/home_screen.dart';
import 'package:mini_project/view/todo_screen/todo_screen.dart';

class BottomNavScreen extends StatefulWidget {
  const BottomNavScreen({super.key});

  @override
  State<BottomNavScreen> createState() => _BottomNavScreenState();
}

class _BottomNavScreenState extends State<BottomNavScreen> {
  var indexNum = 0;
  List tabWidgetsList = [
    HomeScreen(),
    TodoScreen(),
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomNavigationBar(
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.event_note_outlined),
            label: "NOTES",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.check_box_outlined),
            label: "TODO",
          ),
        ],
        type: BottomNavigationBarType.fixed,
        selectedItemColor: ColorConstant.colorTheme,
        unselectedItemColor: ColorConstant.colorTheme,
        iconSize: 28,
        selectedIconTheme: IconThemeData(size: 35),
        selectedLabelStyle:
            TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
        unselectedLabelStyle:
            TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
        currentIndex: indexNum,
        onTap: (int index) {
          setState(() {
            indexNum = index;
          });
        },
      ),
      body: tabWidgetsList.elementAt(indexNum),
    );
  }
}
