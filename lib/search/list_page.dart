import 'package:flutter/material.dart';

class ListPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Get the user data passed as arguments
    final Map<String, dynamic> userData =
        ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>;

    return Scaffold(
      appBar: AppBar(
        title: Text('User Details'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 40),
              // Image at the top of the page
              Center(
                child: Image.asset(
                  'images/download.png', // Path to your image
                  height: 150, // Adjust the height as needed
                ),
              ),
              SizedBox(height: 40),

              // Container with shadow box
              Center(
                child: Container(
                  padding: EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.2),
                        spreadRadius: 2,
                        blurRadius: 5,
                        offset: Offset(0, 3),
                      ),
                    ],
                  ),
                  // height: 350,
                  // width: 350,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Add a Table to display the data
                      Table(
                        border: TableBorder.all(
                          color: Colors.grey.withOpacity(0.3), // Border color
                          width: 1, // Border width
                          borderRadius: BorderRadius.circular(
                              12), // Rounded corners for the table
                        ),
                        columnWidths: {
                          0: FixedColumnWidth(
                              100), // Set fixed width for the first column
                          1: FlexColumnWidth(), // The second column takes up remaining space
                        },
                        children: [
                          TableRow(
                            decoration: BoxDecoration(
                              color: Colors.blue.withOpacity(
                                  0.1), // Background color for the row
                            ),
                            children: [
                              Padding(
                                padding: EdgeInsets.all(8.0),
                                child: Text(
                                  'UID:',
                                  style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.all(8.0),
                                child: Text(
                                  '${userData['uid']}',
                                  style: TextStyle(fontSize: 18),
                                ),
                              ),
                            ],
                          ),
                          TableRow(
                            decoration: BoxDecoration(
                              color: Colors.blue.withOpacity(
                                  0.05), // Lighter background for alternating rows
                            ),
                            children: [
                              Padding(
                                padding: EdgeInsets.all(8.0),
                                child: Text(
                                  'Name:',
                                  style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.all(8.0),
                                child: Text(
                                  '${userData['name']}',
                                  style: TextStyle(fontSize: 18),
                                ),
                              ),
                            ],
                          ),
                          TableRow(
                            decoration: BoxDecoration(
                              color: Colors.blue
                                  .withOpacity(0.1), // Alternate row color
                            ),
                            children: [
                              Padding(
                                padding: EdgeInsets.all(8.0),
                                child: Text(
                                  'Email:',
                                  style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.all(8.0),
                                child: Text(
                                  '${userData['email']}',
                                  style: TextStyle(fontSize: 18),
                                ),
                              ),
                            ],
                          ),
                          TableRow(
                            decoration: BoxDecoration(
                              color: Colors.blue
                                  .withOpacity(0.05), // Lighter row color
                            ),
                            children: [
                              Padding(
                                padding: EdgeInsets.all(8.0),
                                child: Text(
                                  'Age:',
                                  style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.all(8.0),
                                child: Text(
                                  '${userData['age']}',
                                  style: TextStyle(fontSize: 18),
                                ),
                              ),
                            ],
                          ),
                          TableRow(
                            decoration: BoxDecoration(
                              color: Colors.blue
                                  .withOpacity(0.1), // Row color change
                            ),
                            children: [
                              Padding(
                                padding: EdgeInsets.all(8.0),
                                child: Text(
                                  'Phone:',
                                  style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.all(8.0),
                                child: Text(
                                  '${userData['phone']}',
                                  style: TextStyle(fontSize: 18),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),

              SizedBox(height: 30),

              // ElevatedButton
              SizedBox(
                height: 50,
                width: 350,
                child: ElevatedButton(
                  onPressed: () {
                    // Handle button press action here
                    Navigator.pushNamed(context, '/search');
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green, // Button background color
                    padding: EdgeInsets.symmetric(
                        horizontal: 50, vertical: 15), // Padding around button
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(
                          12), // Rounded corners for the button
                    ),
                  ),
                  child: Text(
                    'Done',
                    style: TextStyle(
                        fontSize: 18, color: Colors.white), // Button text style
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
