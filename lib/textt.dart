import 'package:flutter/material.dart';

Widget txt({ required String name,Color color=Colors.white,textAlign: TextAlign.start,})
  =>Text(name,
    style: TextStyle(
        color:color,
        fontSize: 20,
        letterSpacing: 1.2,
        fontWeight: FontWeight.bold,
    decorationThickness: 50.0),

  );
