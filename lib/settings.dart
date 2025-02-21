import 'package:flutter/material.dart';
import 'my_account.dart';
import 'upload_page.dart';
import 'home_page.dart'; // Import HomePage

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  bool _isDarkMode = false;
  bool _isNotificationsEnabled = true;
  int _selectedIndex = 0;

  void _toggleDarkMode(bool value) {
    setState(() {
      _isDarkMode = value;
    });
  }

  void _toggleNotifications(bool value) {
    setState(() {
      _isNotificationsEnabled = value;
    });
  }

  // Function for Bottom Navigation Bar to redirect to HomePage
  // Function for Bottom Navigation Bar to redirect to different pages
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });

    // Navigate based on the selected tab
    if (index == 0) {
      // Navigate to HomePage
      Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => HomePage()), // Navigate to HomePage
      );
    } else if (index == 1) {
      // Navigate to UploadPage
      Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => UploadPage()), // Navigate to UploadPage
      );
    } else if (index == 2) {
      // Navigate to MyAccountPage (Profile)
      Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => ProfilePage()), // Navigate to MyAccountPage
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Settings'),
        backgroundColor: Colors.teal,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            ListTile(
              title: Text('Dark Mode'),
              trailing: Switch(
                value: _isDarkMode,
                onChanged: _toggleDarkMode,
              ),
            ),
            Divider(),
            ListTile(
              title: Text('Enable Notifications'),
              trailing: Switch(
                value: _isNotificationsEnabled,
                onChanged: _toggleNotifications,
              ),
            ),
            Divider(),
            ListTile(
              title: Text('Account Settings'),
              trailing: Icon(Icons.arrow_forward_ios),
            ),
            Divider(),
            ListTile(
              title: Text('Privacy Settings'),
              trailing: Icon(Icons.arrow_forward_ios),
            ),
            Divider(),
            ListTile(
              title: Text('Language'),
              trailing: Icon(Icons.arrow_forward_ios),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        selectedItemColor: Colors.teal,
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.upload),
            label: 'Upload',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}



//settings.dart with bottom navigation and without redirect
/*
import 'package:flutter/material.dart';

class SettingsPage extends StatefulWidget {
  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  bool _isDarkMode = false;  // To manage theme toggling
  bool _isNotificationsEnabled = true;  // To manage notifications toggle
  int _selectedIndex = 0;  // For the BottomNavigationBar

  // Function to toggle dark mode
  void _toggleDarkMode(bool value) {
    setState(() {
      _isDarkMode = value;
    });
  }

  // Function to toggle notifications
  void _toggleNotifications(bool value) {
    setState(() {
      _isNotificationsEnabled = value;
    });
  }

  // Function for bottom navigation bar
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Settings'),
        backgroundColor: Colors.teal,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            // Dark Mode Toggle
            ListTile(
              title: Text('Dark Mode'),
              trailing: Switch(
                value: _isDarkMode,
                onChanged: _toggleDarkMode,
              ),
            ),
            Divider(),

            // Notifications Toggle
            ListTile(
              title: Text('Enable Notifications'),
              trailing: Switch(
                value: _isNotificationsEnabled,
                onChanged: _toggleNotifications,
              ),
            ),
            Divider(),

            // Account Settings Button
            ListTile(
              title: Text('Account Settings'),
              trailing: Icon(Icons.arrow_forward_ios),
              onTap: () {
                // Navigate to Account Settings page (e.g., MyAccountPage)
                // Navigator.push(
                //   context,
                //   MaterialPageRoute(builder: (context) => MyAccountPage()),
                // );
              },
            ),
            Divider(),

            // Privacy Settings Button
            ListTile(
              title: Text('Privacy Settings'),
              trailing: Icon(Icons.arrow_forward_ios),
              onTap: () {
                // You can add navigation to a privacy settings page if needed
              },
            ),
            Divider(),

            // Language Selection
            ListTile(
              title: Text('Language'),
              trailing: Icon(Icons.arrow_forward_ios),
              onTap: () {
                // Add functionality for language selection if needed
              },
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        selectedItemColor: Colors.teal,
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.upload),
            label: 'Upload',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}

*/

// settings.dart without bottom navigation
/*import 'package:flutter/material.dart';

class SettingsPage extends StatefulWidget {
  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  bool _isDarkMode = false;  // To manage theme toggling
  bool _isNotificationsEnabled = true;  // To manage notifications toggle

  // Function to toggle dark mode
  void _toggleDarkMode(bool value) {
    setState(() {
      _isDarkMode = value;
    });
  }

  // Function to toggle notifications
  void _toggleNotifications(bool value) {
    setState(() {
      _isNotificationsEnabled = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Settings'),
        backgroundColor: Colors.teal,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            // Dark Mode Toggle
            ListTile(
              title: Text('Dark Mode'),
              trailing: Switch(
                value: _isDarkMode,
                onChanged: _toggleDarkMode,
              ),
            ),
            Divider(),

            // Notifications Toggle
            ListTile(
              title: Text('Enable Notifications'),
              trailing: Switch(
                value: _isNotificationsEnabled,
                onChanged: _toggleNotifications,
              ),
            ),
            Divider(),

            // Account Settings Button
            ListTile(
              title: Text('Account Settings'),
              trailing: Icon(Icons.arrow_forward_ios),
              onTap: () {
                // Navigate to Account Settings page (e.g., MyAccountPage)
                // Navigator.push(
                //   context,
                //   MaterialPageRoute(builder: (context) => MyAccountPage()),
                // );
              },
            ),
            Divider(),

            // Privacy Settings Button
            ListTile(
              title: Text('Privacy Settings'),
              trailing: Icon(Icons.arrow_forward_ios),
              onTap: () {
                // You can add navigation to a privacy settings page if needed
              },
            ),
            Divider(),

            // Language Selection
            ListTile(
              title: Text('Language'),
              trailing: Icon(Icons.arrow_forward_ios),
              onTap: () {
                // Add functionality for language selection if needed
              },
            ),
          ],
        ),
      ),
    );
  }
}
*/