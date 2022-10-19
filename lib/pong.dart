import 'package:flutter/material.dart';
import 'ball.dart';
import 'bat.dart';

class Pong extends StatefulWidget {
  @override
  _PongState createState() => _PongState();
}

class _PongState extends State<Pong> {
  late double width;
  late double height;
  double posX = 0;
  double posY = 0;
  double batWidth = 0;
  double batHeight = 0;
  double batPosition = 0;
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (BuildContext context, constraints) {
      height = constraints.maxHeight;
      width = constraints.maxWidth;
      batWidth = width / 5;
      batHeight = height / 30;
      return Stack(
        children: <Widget>[
          Positioned(child: Ball(), top: 0),
          Positioned(
              child: Bat(batWidth, batHeight),
              bottom: 0,
              left: constraints.maxWidth / 2 - 50),
        ],
      );
    });
  }
}
