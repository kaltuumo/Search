import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  TextEditingController _searchController = TextEditingController();
  String? errorMessage; // Variable to hold error message for empty input

  Future<void> _validateAndSearch() async {
    String searchQuery = _searchController.text.trim();
    if (searchQuery.isEmpty) {
      setState(() {
        errorMessage =
            'Please enter an ID, Name, or Phone'; // Show this error message for empty input
      });
      return;
    }

    // Fetch user data from Firestore
    Map<String, dynamic>? userData = await _fetchUserData(searchQuery);

    if (userData != null) {
      // Navigate to ListPage and send user data
      Navigator.pushNamed(
        context,
        '/list',
        arguments: userData,
      );
    } else {
      setState(() {
        errorMessage =
            'ID, Name, or Phone does not exist'; // Show this error message if user is not found
      });
    }
  }

  Future<Map<String, dynamic>?> _fetchUserData(String query) async {
    try {
      // 1️⃣ Check by UID (Assuming UID is the document ID)
      QuerySnapshot uidSnapshot = await FirebaseFirestore.instance
          .collection('users')
          .where('uid', isEqualTo: query)
          .get();

      if (uidSnapshot.docs.isNotEmpty) {
        return uidSnapshot.docs.first.data() as Map<String, dynamic>;
      }

      // 2️⃣ Check by Name
      QuerySnapshot nameSnapshot = await FirebaseFirestore.instance
          .collection('users')
          .where('name', isEqualTo: query)
          .get();

      if (nameSnapshot.docs.isNotEmpty) {
        return nameSnapshot.docs.first.data() as Map<String, dynamic>;
      }

      // 3️⃣ Check by Phone
      QuerySnapshot phoneSnapshot = await FirebaseFirestore.instance
          .collection('users')
          .where('phone', isEqualTo: query)
          .get();

      if (phoneSnapshot.docs.isNotEmpty) {
        return phoneSnapshot.docs.first.data() as Map<String, dynamic>;
      }

      return null;
    } catch (e) {
      print('Error fetching Firestore data: $e');
      return null;
    }
  }

  // Handle back button press (when user presses the back button)
  Future<bool> _onWillPop() async {
    // Navigate back to login screen when back button is pressed
    Navigator.pushReplacementNamed(context, '/login');
    return false; // Prevent default back behavior
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onWillPop, // Handle back button press
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Search User'),
          centerTitle: true,
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 90),
              const Center(
                child: Text(
                  'Search By ID, Name, or Phone',
                  style: TextStyle(fontSize: 20, color: Colors.black),
                ),
              ),
              const SizedBox(height: 20),
              TextField(
                controller: _searchController,
                decoration: const InputDecoration(
                  labelText: "Enter ID, Name, or Phone",
                  prefixIcon: Icon(Icons.search),
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: _validateAndSearch,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text(
                    "Search",
                    style: TextStyle(fontSize: 16, color: Colors.white),
                  ),
                ),
              ),
              // Display error message centered for empty input or no result
              if (errorMessage != null)
                Center(
                  child: Padding(
                    padding: const EdgeInsets.only(top: 20),
                    child: Text(
                      errorMessage!,
                      style: const TextStyle(fontSize: 16, color: Colors.red),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
