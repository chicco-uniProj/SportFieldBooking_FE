import 'package:flutter/material.dart';

import 'package:progetto/UI/pages/Home.dart';
import 'package:progetto/UI/pages/Search.dart';
import 'package:progetto/UI/pages/UserRegistration.dart';

class Layout extends StatefulWidget {
  final String title;


  Layout({Key key,this.title}) : super(key: key);

  @override
  _LayoutState createState() => _LayoutState(title);
}

class _LayoutState extends State<Layout> {
  String title;

  _LayoutState(String title) {
    this.title = title;
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(
              bottom: Radius.circular(5),
            ),
          ),
          //title: Text(title),
          bottom: TabBar(
            tabs: [
              Tab(text: "Home", icon: Icon(Icons.home_rounded)),
              Tab(text: "Cerca campetto", icon: Icon(Icons.sports_baseball_outlined)),
              Tab(text: "Profilo", icon: Icon(Icons.person_rounded)),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            Home(),
            Search(),
            UserRegistration(),
          ],
        ),
      ),
    );
  }
}
