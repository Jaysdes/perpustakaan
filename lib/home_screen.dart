import 'package:flutter/material.dart';
import 'profile.dart';
import 'buku.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3, // Number of tabs
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.blue,
          title: Center(
            child: Text(
              'Home',
              style: TextStyle(color: Colors.white),
            ),
          ),
          bottom: TabBar(
            tabs: [
              Tab(icon: Icon(Icons.home), text: 'Home'),
              Tab(icon: Icon(Icons.book), text: 'List Buku'),
              Tab(icon: Icon(Icons.person), text: 'Profile'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            HomeTab(),
            BukuList(),
            ProfileTab(),
          ],
        ),
      ),
    );
  }
}

class HomeTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Icon(Icons.home, size: 100, color: Colors.blue),
          Text('Welcome to the Home Page!'),
        ],
      ),
    );
  }
}
