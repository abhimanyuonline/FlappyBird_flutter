import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_app_v1/bird.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  double birdYaxis = 0;

  void jump() {
    Timer.periodic(Duration(milliseconds: 500), (timer) {
      setState(() {
        birdYaxis -= 0.1;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Expanded(
              flex: 3,
              child: GestureDetector(
                onTap: jump,
                child: AnimatedContainer(
                  alignment: Alignment(0, birdYaxis),
                  duration: Duration(milliseconds: 0),
                  color: Colors.lightBlueAccent,
                  child: Bird(),
                ),
              )),
          Expanded(
              child: Container(
            color: Colors.brown,
          ))
        ],
      ),
    );
  }
}
