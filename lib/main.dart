import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:insurace/model/dashboard.dart';
import 'package:insurace/model/home_page.dart';
import 'package:insurace/screen/forget.dart';
import 'package:insurace/screen/login.dart';
import 'package:insurace/screen/sign_up.dart';
import 'package:insurace/search/list_page.dart';
import 'package:insurace/search/search_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MaterialApp(
    initialRoute: '/login',
    theme: ThemeData(
      primaryColor: Colors.blueAccent,
      scaffoldBackgroundColor: Colors.white,
    ),
    routes: {
      '/login': (context) => LoginScreen(),
      '/signup': (context) => SignUpScreen(),
      '/forgot_password': (context) => ForgotPasswordScreen(),
      '/dashboard': (context) => DashboardPage(),
      '/home': (context) => HomePage(),
      '/search': (contetx) => SearchPage(),
      '/list': (context) => ListPage(),
      // '/list': (context) => ListPage(searchQuery: searchQuery)
      // '/logout': (contex) => Logout()
    },
  ));
}

// Login Screen
