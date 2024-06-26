import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class ProfileTab extends StatefulWidget {
  @override
  _ProfileTabState createState() => _ProfileTabState();
}

class _ProfileTabState extends State<ProfileTab> {
  String _name = '';
  String _email = '';

  @override
  void initState() {
    super.initState();
    _loadProfile();
  }

  Future<void> _loadProfile() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');

    if (token != null) {
      final response = await http.get(
        Uri.parse('http://10.0.2.2:8100/profile'),
        headers: {
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        setState(() {
          _name = data['name'];
          _email = data['email'];
        });
      } else {
        // Handle error
        print('Failed to load profile: ${response.body}');
      }
    } else {
      // Handle error
      print('No token found');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Icon(Icons.person, size: 100, color: Colors.blue),
          SizedBox(height: 20),
          Text(
            'Nama: $_name',
            style: TextStyle(fontSize: 20),
          ),
          SizedBox(height: 10),
          Text(
            'Email: $_email',
            style: TextStyle(fontSize: 20),
          ),
        ],
      ),
    );
  }
}
