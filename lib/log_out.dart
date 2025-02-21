import 'package:flutter/material.dart';
import 'login.dart'; // Import the login page
import 'my_account.dart'; // Import the My Account page

class LogoutPage extends StatelessWidget {
  const LogoutPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Logout'),
        backgroundColor: Colors.teal,
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            _showExitConfirmationDialog(context);
          },
          child: Text('Logout'),
        ),
      ),
    );
  }

  // Function to show a confirmation dialog
  void _showExitConfirmationDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Exit?"),
          content: Text("Are you sure you want to log out?"),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                // If "Yes" is pressed, navigate to the LoginPage
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => LoginPage()),
                );
              },
              child: Text("Yes"),
            ),
            TextButton(
              onPressed: () {
                // If "No" is pressed, navigate to MyAccountPage
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => ProfilePage()),
                );
              },
              child: Text("No"),
            ),
          ],
        );
      },
    );
  }
}
