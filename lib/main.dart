import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:notes/auth/auth_page.dart';
import 'package:notes/auth/main_page.dart';
import 'package:notes/calendar/calendar.dart';
import 'package:notes/screen/add_Screen.dart';
import 'package:notes/screen/home.dart';
import 'package:notes/screen/login_Page.dart';
import 'package:notes/screen/singUP.dart';
import 'package:notes/widget/task_widgets.dart';
import 'firebase_options.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(); // Ensure Firebase is initialized
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Home_Screen(),
    );
  }
}
