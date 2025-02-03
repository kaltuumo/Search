import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:shared_preferences/shared_preferences.dart';
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

  // Hubi haddii user horey u galay
  SharedPreferences prefs = await SharedPreferences.getInstance();
  bool isLoggedIn = prefs.getBool('isLoggedIn') ?? false;

  runApp(MyApp(isLoggedIn: isLoggedIn));
}

class MyApp extends StatelessWidget {
  final bool isLoggedIn;
  MyApp({required this.isLoggedIn});

  // Logout function
  Future<void> logout(BuildContext context) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('isLoggedIn'); // Tir kaydka login

    // Ku celi LoginPage
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => LoginScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: isLoggedIn
          ? '/search'
          : '/login', // Hubi haddii user uu horey u login sameeyay
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
        '/search': (context) =>
            SearchPage(), // Haddii isLoggedIn = true, user-ka wuxuu tagayaa SearchPage
        '/list': (context) => ListPage(),
      },
    );
  }
}
