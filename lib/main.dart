import 'package:finalproject/home.dart';
import 'package:finalproject/thememode.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sqflite/sqflite.dart' as sql;
import 'SQLHelper.dart';

void main() {
  runApp(MyApp());
}



class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => ThemeModel(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Study Planner',
        home: Home(),
      ),
    );
  }
}

