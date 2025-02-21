import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class UsersPage extends StatefulWidget {
  @override
  _UsersPageState createState() => _UsersPageState();
}

class _UsersPageState extends State<UsersPage> {
  List users = [];

  Future<void> fetchUsers() async {
    final url = Uri.parse("http://127.0.0.1:8000/api/users/");
    final response = await http.get(url);
    final data = jsonDecode(response.body);

    setState(() {
      users = data["users"];
    });
  }

  @override
  void initState() {
    super.initState();
    fetchUsers();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Users List")),
      body: ListView.builder(
        itemCount: users.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(users[index]["username"]),
            subtitle: Text(users[index]["email"]),
            trailing: Text(users[index]["role"]),
          );
        },
      ),
    );
  }
}
