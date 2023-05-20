

import 'package:flutter/material.dart';
import '../model/support/Constants.dart';
import '../UI/pages/Layout.dart';

class App extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: Constants.APP_NAME,
      theme: ThemeData(
        primaryColor: Colors.lightGreen,
        backgroundColor: Colors.white,
      ),
      darkTheme: ThemeData(
        primaryColor: Colors.white,
        backgroundColor: Colors.lightGreen,
        canvasColor: Colors.green,
        cardColor: Colors.grey[800],
      ),
      home: Layout(title: Constants.APP_NAME),
    );
  }


}