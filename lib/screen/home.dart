import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:notes/const/colors.dart';
import 'package:notes/screen/Category_Screen.dart';
import 'package:notes/screen/add_Screen.dart';
import 'package:notes/data/firestore.dart';

import '../calendar/Calendar.dart';
import '../calendar/Google_Calendar.dart';
import '../widget/stream_note.dart';

// ignore: camel_case_types
class Home_Screen extends StatefulWidget {
  const Home_Screen({super.key});
  @override
  State<Home_Screen> createState() => _Home_ScreenState();
}

// ignore: camel_case_types
class _Home_ScreenState extends State<Home_Screen> {
  bool show = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Home'),
        backgroundColor: Colors.blueAccent,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () async {
              await Firestore_Datasource().signOut();
              Navigator.of(context).pushReplacementNamed('/');
            },
          ),
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: Padding(
        padding: const EdgeInsets.all(9.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Semantics(
              label:
              'Category page double tap to activate',
              button: true,
              child: Visibility(
                visible: show,
                child: FloatingActionButton(
                  onPressed: () {
                    Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => const CategoryPage(),
                    ));
                  },
                  backgroundColor: Colors.blueAccent,
                  child: const Icon(
                    Icons.home_rounded,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
            Semantics(
              label: 'Calendar button double tap to activate',
              button: true,
              child: Visibility(
                visible: show,
                child: FloatingActionButton(onPressed: (){
                  Navigator.of(context).push(MaterialPageRoute(builder: (context) =>  Calendar_Page(),));

                },
                    backgroundColor: Colors.blueAccent,
                    child: const Icon(Icons.calendar_today_rounded,
                      size: 30,
                      color: Colors.white,
                    )
                ),
              ),
            ),
            Semantics(
              label:
              'Add button double tap to activate',
              button: true,
              child: Visibility(
                visible: show,
                child: FloatingActionButton(
                  onPressed: () {
                    Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => const Add_Screen(),
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
              Stream_note(
                false,
              ),
              Text(
                'Done',
                style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey.shade500,
                    fontWeight: FontWeight.bold),
              ),
              Stream_note(
                true,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
