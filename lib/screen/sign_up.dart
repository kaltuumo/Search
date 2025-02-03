import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  String name = '';
  String email = '';
  String password = '';
  String phone = '';
  String age = '';
  bool _isPasswordVisible = false;
  bool _isLoading = false; // Add loading state
  String? nameError;
  String? emailError;
  String? passwordError;
  String? phoneError;
  String? ageError;

  void _showMessage(String message, bool isSuccess) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(isSuccess ? "Success" : "Error"),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                if (isSuccess) {
                  Navigator.pushReplacementNamed(context, '/login');
                }
              },
              child: Text("OK"),
            ),
          ],
        );
      },
    );
  }

  // Generate and retrieve the next UID from Firestore
  Future<String> _getNextUid() async {
    try {
      DocumentReference uidDoc =
          _firestore.collection('uid_tracker').doc('current_uid');
      DocumentSnapshot snapshot = await uidDoc.get();

      if (snapshot.exists && snapshot.data() != null) {
        Map<String, dynamic> data = snapshot.data() as Map<String, dynamic>;
        if (data.containsKey('uid')) {
          int currentUid = data['uid'] ?? 100; // Default to 100 if null
          int nextUid = currentUid + 1;

          await uidDoc.update({'uid': nextUid});
          return nextUid.toString();
        } else {
          await uidDoc.set({'uid': 101});
          return '101';
        }
      } else {
        await uidDoc.set({'uid': 101});
        return '101';
      }
    } catch (e) {
      print("🔥 ERROR fetching next UID: $e");
      return "ERROR: ${e.toString()}"; // Return the actual error message
    }
  }

  Future<void> _signUp() async {
    setState(() {
      nameError = null;
      emailError = null;
      passwordError = null;
      phoneError = null;
      ageError = null;
    });

    if (name.isEmpty) {
      setState(() {
        nameError = "Name is required.";
      });
      return;
    }
    if (email.isEmpty) {
      setState(() {
        emailError = "Email is required.";
      });
      return;
    }
    if (password.isEmpty) {
      setState(() {
        passwordError = "Password is required.";
      });
      return;
    }
    if (phone.isEmpty) {
      setState(() {
        phoneError = "Phone number is required.";
      });
      return;
    }
    if (age.isEmpty) {
      setState(() {
        ageError = "Age is required.";
      });
      return;
    }

    setState(() {
      _isLoading = true; // Show loading indicator
    });

    try {
      UserCredential userCredential =
          await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      // Get the next UID
      String newUid = await _getNextUid();

      // Store the user in Firestore with the generated UID
      await _firestore.collection('users').doc(userCredential.user!.uid).set({
        'name': name,
        'email': email,
        'password': password,
        'phone': phone,
        'age': age,
        'uid': newUid, // Use the generated UID
        'createdAt': FieldValue.serverTimestamp(),
      });

      _showMessage("User Registered Successfully", true);
    } catch (e) {
      _showMessage("User Registration Failed: ${e.toString()}", false);
    } finally {
      setState(() {
        _isLoading = false; // Hide loading indicator
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Sign Up")),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(height: 50),
            Image.asset('images/baraka_logo_full.png', height: 100),
            SizedBox(height: 50),
            Padding(
              padding:
                  const EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
              child: TextField(
                decoration: InputDecoration(
                  labelText: "Full Name",
                  prefixIcon: Icon(Icons.person),
                  errorText: nameError,
                ),
                onChanged: (value) {
                  setState(() {
                    name = value;
                    nameError = null;
                  });
                },
              ),
            ),
            Padding(
              padding:
                  const EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
              child: TextField(
                decoration: InputDecoration(
                  labelText: "Email",
                  prefixIcon: Icon(Icons.email),
                  errorText: emailError,
                ),
                keyboardType: TextInputType.emailAddress,
                onChanged: (value) {
                  setState(() {
                    email = value;
                    emailError = null;
                  });
                },
              ),
            ),
            Padding(
              padding:
                  const EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
              child: TextField(
                obscureText: !_isPasswordVisible,
                decoration: InputDecoration(
                  labelText: "Password",
                  prefixIcon: Icon(Icons.lock),
                  suffixIcon: IconButton(
                    icon: Icon(_isPasswordVisible
                        ? Icons.visibility
                        : Icons.visibility_off),
                    onPressed: () {
                      setState(() {
                        _isPasswordVisible = !_isPasswordVisible;
                      });
                    },
                  ),
                  errorText: passwordError,
                ),
                onChanged: (value) {
                  setState(() {
                    password = value;
                    passwordError = null;
                  });
                },
              ),
            ),
            Padding(
              padding:
                  const EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
              child: TextField(
                decoration: InputDecoration(
                  labelText: "Age",
                  prefixIcon: Icon(Icons.calendar_today),
                  errorText: ageError,
                ),
                keyboardType: TextInputType.number,
                onChanged: (value) {
                  setState(() {
                    age = value;
                    ageError = null;
                  });
                },
              ),
            ),
            Padding(
              padding:
                  const EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
              child: TextField(
                decoration: InputDecoration(
                  labelText: "Phone Number",
                  prefixIcon: Icon(Icons.phone),
                  errorText: phoneError,
                ),
                keyboardType: TextInputType.phone,
                onChanged: (value) {
                  setState(() {
                    phone = value;
                    phoneError = null;
                  });
                },
              ),
            ),
            Padding(
              padding:
                  const EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
              child: SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  onPressed: _isLoading ? null : _signUp,
                  child: _isLoading
                      ? CircularProgressIndicator(
                          color: Colors.white,
                        ) // Show loading spinner when submitting
                      : Text("Sign Up",
                          style: TextStyle(fontSize: 16, color: Colors.white)),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
