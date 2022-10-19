import 'package:flutter/material.dart';
import 'ball.dart';
import 'bat.dart';
import 'dart:math';

enum Direction { left, right, up, down }

class Pong extends StatefulWidget {
  @override
  _PongState createState() => _PongState();
}

class _PongState extends State<Pong> with SingleTickerProviderStateMixin {
  double? width;
  double? height;
  late double posX;
  late double posY;
  late double batWidth;
  late double batHeight;
  int score = 0;
  double randX = 1;
  double randY = 1;
  double batPosition = 0;
  double increment = 5;
  Direction vDir = Direction.down;
  Direction hDir = Direction.right;
  late Animation<double> animation;
  late AnimationController controller;

  @override
  void initState() {
    posX = 0;
    posY = 0;

    controller = AnimationController(
      vsync: this,
      duration: Duration(minutes: 10000),
    );
    animation = Tween<double>(begin: 0, end: 100).animate(controller);

    animation.addListener(() {
      safeSetState(
        () {
          (hDir == Direction.right)
              ? posX += ((increment * randX).round())
              : posX -= ((increment * randX).round());
          (vDir == Direction.down)
              ? posY += ((increment * randY).round())
              : posY -= ((increment * randY).round());
        },
      );
      checkBorders();
    });
    controller.forward();
    super.initState();
  }

  void checkBorders() {
    if (width == null || height == null) return;
    double diameter = 50;
    double batHeight = 20;
    if (posX <= 0 && hDir == Direction.left) {
      hDir = Direction.right;
      randX = randomNumber();
    }
    if (posX >= width! - diameter && hDir == Direction.right) {
      hDir = Direction.left;
      randX = randomNumber();
    }
    if (posY >= height! - diameter - batHeight && vDir == Direction.down) {
      if (posX >= (batPosition - diameter) &&
          posX <= (batPosition + batWidth + diameter)) {
        vDir = Direction.up;
        randY = randomNumber();
        safeSetState(() {
          score++;
        });
      } else {
        controller.stop();
        showMessage(context);
      }
    }
    if (posY <= 0 && vDir == Direction.up) {
      vDir = Direction.down;
      randY = randomNumber();
    }
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (BuildContext context, constraints) {
      height = constraints.maxHeight;
      width = constraints.maxWidth;
      batWidth = width! / 5;
      batHeight = height! / 30;
      return Stack(
        children: <Widget>[
          Positioned(
            top: 0,
            right: 24,
            child: Text('Score: ' + score.toString()),
          ),
          Positioned(child: Ball(), top: posY, left: posX),
          Positioned(
              child: GestureDetector(
                  onHorizontalDragUpdate: ((details) => updateBat(details)),
                  child: Bat(batWidth, batHeight)),
              bottom: 0,
              left: batPosition),
        ],
      );
    });
  }

  void updateBat(DragUpdateDetails details) {
    safeSetState(() {
      batPosition += details.delta.dx;
    });
  }

  void safeSetState(Function function) {
    if (mounted && controller.isAnimating) {
      setState(() {
        function();
      });
    }
  }

  double randomNumber() {
    var random = Random();
    int myNum = random.nextInt(101);
    return (50 + myNum) / 100;
  }

  void showMessage(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Game Over'),
          content: Text('Would you like to play again?'),
          actions: <Widget>[
            ElevatedButton(
              child: Text('Yes'),
              onPressed: () {
                setState(() {
                  posX = 0;
                  posY = 0;
                  score = 0;
                });
                Navigator.of(context).pop();
                controller.repeat();
              },
            ),
            ElevatedButton(
              child: Text('No'),
              onPressed: () {
                Navigator.of(context).pop();
                dispose();
              },
            )
          ],
        );
      },
    );
  }

  @override
  void dipose() {
    controller.dispose();
    super.dispose();
  }
}
