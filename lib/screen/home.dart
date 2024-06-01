import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

import 'package:notes/screen/Category_Screen.dart';
import 'package:notes/screen/add_Screen.dart';
import 'package:notes/widget/stream_note.dart';

class Home_Screen extends StatefulWidget {
  const Home_Screen({super.key});
  @override
  State<Home_Screen> createState() => _Home_ScreenState();
}

class _Home_ScreenState extends State<Home_Screen> {
  @override
  bool show = true;
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text('Home'),
        backgroundColor: Colors.blueAccent,
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: Padding(
        padding: const EdgeInsets.all(9.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Semantics(
              label:
                  'главная страница коснитесь дважды для перехода на главную страницу',
              button: true,
              child: Visibility(
                visible: show,
                child: FloatingActionButton(
                  onPressed: () {
                    Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => CategoryPage(),
                    ));
                  },
                  backgroundColor: Colors.blue,
                  child: const Icon(
                    Icons.home_rounded,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
            Semantics(
              label:
                  'добавления кнопка коснитесь дважды для добавления заметки',
              button: true,
              child: Visibility(
                visible: show,
                child: FloatingActionButton(
                  onPressed: () {
                    Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => Add_Screen(),
                    ));
                    // Add your add note logic here
                  },
                  backgroundColor: Colors.blueAccent,
                  child: const Icon(
                    Icons.add_rounded,
                    size: 30,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      body: SafeArea(
        // hide add buttun while scrolling
        child: NotificationListener<UserScrollNotification>(
          onNotification: (notification) {
            if (notification.direction == ScrollDirection.forward) {
              setState(() {
                show = true;
              });
            }
            if (notification.direction == ScrollDirection.reverse) {
              setState(() {
                show = false;
              });
            }
            return true;
          },
          child: Column(
            children: [
              Stream_note(false),
              Text(
                'isDone',
                style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey.shade500,
                    fontWeight: FontWeight.bold),
              ),
              Stream_note(true),
            ],
          ),
        ),
      ),
    );
  }
}
