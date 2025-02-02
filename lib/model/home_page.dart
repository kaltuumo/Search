import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool _isSearching = false;
  TextEditingController _searchController = TextEditingController();
  List<Map<String, dynamic>> _users = [];
  List<Map<String, dynamic>> _filteredUsers = [];

  @override
  void initState() {
    super.initState();
    _fetchUsers();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  // Fetch users from Firestore
  void _fetchUsers() async {
    FirebaseFirestore.instance
        .collection('users')
        .snapshots()
        .listen((snapshot) {
      List<Map<String, dynamic>> userList = snapshot.docs.map((doc) {
        var data = doc.data();
        return {"id": doc.id, ...data};
      }).toList();

      setState(() {
        _users = userList;
        _filteredUsers = userList; // Initially show all users
      });
    });
  }

  // Filter users based on search query
  void _filterUsers(String query) {
    setState(() {
      _filteredUsers = _users.where((user) {
        String uid =
            user['uid'] ?? ''; // Ensure uid is a string and correctly accessed
        String name = user['name'] ?? '';
        String email = user['email'] ?? '';
        String phone = user['phone'] ?? '';

        return uid.contains(query) || // Search by uid
            name.toLowerCase().contains(query.toLowerCase()) ||
            email.toLowerCase().contains(query.toLowerCase()) ||
            phone.toLowerCase().contains(query.toLowerCase());
      }).toList();
    });
  }

  // Delete a user
  void _deleteUser(String userId) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Confirm Deletion"),
        content: Text("Do You  Want To Delete This User?"),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context); // Close dialog
            },
            child: Text("Cancel"),
          ),
          TextButton(
            onPressed: () async {
              try {
                await FirebaseFirestore.instance
                    .collection('users')
                    .doc(userId)
                    .delete();
                ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text("User deleted successfully")));
              } catch (e) {
                ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text("Error deleting user: $e")));
              }
              Navigator.pop(context); // Close dialog after deletion
            },
            child: Text("Delete", style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  // Update user (navigate to a new page to edit user)
  void _updateUser(Map<String, dynamic> user) {
    // Create controllers for text fields
    TextEditingController nameController =
        TextEditingController(text: user['name']);
    TextEditingController emailController =
        TextEditingController(text: user['email']);
    TextEditingController phoneController =
        TextEditingController(text: user['phone']);
    TextEditingController ageController =
        TextEditingController(text: user['age'].toString());
    TextEditingController passwordController =
        TextEditingController(text: user['password']);

    bool _isPasswordVisible = false;

    // Show all the user information when update button is clicked
    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) {
          return AlertDialog(
            title: Text('Update User'),
            content: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextField(
                    controller: nameController,
                    decoration: InputDecoration(labelText: 'Name'),
                  ),
                  TextField(
                    controller: emailController,
                    decoration: InputDecoration(labelText: 'Email'),
                  ),
                  TextField(
                    controller: passwordController,
                    obscureText: !_isPasswordVisible,
                    decoration: InputDecoration(
                      labelText: 'Password',
                      suffixIcon: IconButton(
                        icon: Icon(
                          _isPasswordVisible
                              ? Icons.visibility
                              : Icons.visibility_off,
                        ),
                        onPressed: () {
                          setState(() {
                            _isPasswordVisible = !_isPasswordVisible;
                          });
                        },
                      ),
                    ),
                  ),
                  TextField(
                    controller: ageController,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(labelText: 'Age'),
                  ),
                  TextField(
                    controller: phoneController,
                    decoration: InputDecoration(labelText: 'Phone'),
                  ),
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: () {
                  // Update the user data in Firestore
                  FirebaseFirestore.instance
                      .collection('users')
                      .doc(user['id'])
                      .update({
                    'name': nameController.text,
                    'email': emailController.text,
                    'phone': phoneController.text,
                    'age': int.tryParse(ageController.text) ?? 0,
                    'password': passwordController.text,
                  }).then((_) {
                    ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text("User updated successfully")));
                    Navigator.pop(context); // Close the dialog
                  }).catchError((e) {
                    ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text("Error updating user: $e")));
                  });
                },
                child: Text('Save'),
              ),
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text('Cancel'),
              ),
            ],
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Users'),
        actions: [
          // Search Button
          IconButton(
            icon: Icon(_isSearching ? Icons.close : Icons.search),
            onPressed: () {
              setState(() {
                _isSearching = !_isSearching;
                _searchController.clear();
                _filteredUsers = _users; // Reset list when closing search
              });
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // Search Bar
          if (_isSearching)
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                controller: _searchController,
                decoration: InputDecoration(
                  labelText: 'Search users...',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.search),
                ),
                onChanged: _filterUsers,
              ),
            ),

          // User List
          Expanded(
            child: _filteredUsers.isEmpty
                ? Center(child: Text("No users found"))
                : ListView.builder(
                    itemCount: _filteredUsers.length,
                    itemBuilder: (context, index) {
                      var user = _filteredUsers[index];
                      // Set a simple counter for uidNumber starting from 1
                      int uidNumber = index + 101; // Start from 1

                      return Card(
                        margin:
                            EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                        child: ListTile(
                          leading: CircleAvatar(
                            child: Icon(Icons.person),
                          ),
                          title: Text(user['name'] ?? 'Name'),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Email: ${user['email'] ?? 'Email'}'),
                              Text(
                                  'Password: ${user['password'] ?? 'Password'}'),
                              Text('Phone: ${user['phone'] ?? 'Phone'}'),
                              Text('Age: ${user['age'] ?? 'Age'}'),
                              Text(
                                  'UID Number: $uidNumber'), // Display UID number starting from 1
                            ],
                          ),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              // Update Button with Green color
                              IconButton(
                                icon: Icon(Icons.edit),
                                color: Colors.green, // Green color
                                onPressed: () {
                                  _updateUser(user);
                                },
                              ),
                              // Delete Button with Red color
                              IconButton(
                                icon: Icon(Icons.delete),
                                color: Colors.red, // Red color
                                onPressed: () {
                                  _deleteUser(user['id']);
                                },
                              ),
                            ],
                          ),
                          onTap: () {
                            // Optionally navigate to user details
                          },
                        ),
                      );
                    },
                  ),
          )
        ],
      ),
    );
  }
}
