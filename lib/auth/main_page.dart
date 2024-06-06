import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:notes/auth/auth_page.dart';
import 'package:notes/screen/home.dart';

import '../screen/Category_Detail_Page.dart';

class Main_Page extends StatelessWidget {
  const Main_Page({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return const Home_Screen();
          } else {
            return const Auth_Page();
          }
        },
      ),
    );
  }
}
