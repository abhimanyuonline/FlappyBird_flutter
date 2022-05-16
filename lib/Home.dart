import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_app_v1/barriers.dart';
import 'package:flutter_app_v1/bird.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  static double birdYaxis = 0;
  double time = 0;
  double height = 0;
  late int score = 0;
  late int bestScore = 0;
  double initialHeight = birdYaxis;
  bool gameHasStarted = false;
  static double barrierXone = 2;
  double barrierXtwo = barrierXone + 1.5;
  void jump() {
    setState(() {
      time = 0;
      score += 1;
      initialHeight = birdYaxis;
    });
    if (score >= bestScore) {
      bestScore = score;
    }
  }

  bool birdIsDead() {
    if (birdYaxis > 1 || birdYaxis < -1) {
      return true;
    } else {
      return false;
    }
  }

  void startGame() {
    gameHasStarted = true;
    score = 0;
    Timer.periodic(const Duration(milliseconds: 50), (timer) {
      time += 0.04;
      height = -4.9 * time * time + 2.8 * time;
      setState(() {
        birdYaxis = initialHeight - height; // jump
        setState(() {
          if (barrierXone < -1.1) {
            barrierXone += 2.2;
          } else {
            barrierXone -= 0.05;
          }
        });

        if (birdIsDead()) {
          timer.cancel();
          _showDialoug();
        }

        setState(() {
          if (barrierXtwo < -1.1) {
            barrierXtwo += 2.2;
          } else {
            barrierXtwo -= 0.05;
          }
        });
      });
      if (birdYaxis > 1) {
        timer.cancel();
        gameHasStarted = false;
      }
    });
  }

  void resetGame() {
    Navigator.pop(context);
    setState(() {
      birdYaxis = 0;
      gameHasStarted = false;
      time = 0;
      initialHeight = birdYaxis;
    });
  }

  void _showDialoug() {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return AlertDialog(
            backgroundColor: Colors.black54,
            title: Center(
                child: Image.asset(
              'lib/images/gameOver.png',
              width: 190,
            )),
            actions: [
              GestureDetector(
                onTap: resetGame,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(5),
                  child: Container(
                    padding: EdgeInsets.all(10),
                    color: Colors.white,
                    child: const Text(
                      'Start Again',
                      style: TextStyle(
                          color: Colors.amber,
                          fontSize: 16,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              )
            ],
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (gameHasStarted) {
          jump();
        } else {
          startGame();
        }
      },
      child: Scaffold(
        body: Column(
          children: [
            Expanded(
              flex: 3,
              child: Stack(
                children: [
                  AnimatedContainer(
                    alignment: Alignment(0, birdYaxis),
                    duration: const Duration(milliseconds: 0),
                    color: Colors.lightBlueAccent,
                    child: Bird(),
                  ),
                  Container(
                    alignment: Alignment(0, -0.65),
                    child: gameHasStarted
                        ? Text("")
                        : Image.asset('lib/images/Play.png'),
                  ),
                  AnimatedContainer(
                    alignment: Alignment(barrierXone, 1.1),
                    duration: const Duration(milliseconds: 0),
                    child: Barriers(
                      size: 200.0,
                    ),
                  ),
                  AnimatedContainer(
                    alignment: Alignment(barrierXone, -1.3),
                    duration: const Duration(milliseconds: 0),
                    child: Barriers(
                      size: 200.0,
                    ),
                  ),
                  AnimatedContainer(
                    alignment: Alignment(barrierXtwo, 1.2),
                    duration: const Duration(milliseconds: 0),
                    child: Barriers(
                      size: 150.0,
                    ),
                  ),
                  AnimatedContainer(
                    alignment: Alignment(barrierXtwo, -1.2),
                    duration: const Duration(milliseconds: 0),
                    child: Barriers(
                      size: 250.0,
                    ),
                  )
                ],
              ),
            ),
            Container(
              height: 10,
              color: Colors.amberAccent,
            ),
            Expanded(
                child: Container(
              color: Colors.brown,
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text('Score',
                            style: TextStyle(
                                color: Colors.amber,
                                fontSize: 20,
                                fontWeight: FontWeight.bold)),
                        const SizedBox(height: 20),
                        Text(score.toString(),
                            style: const TextStyle(
                                color: Colors.amber,
                                fontSize: 35,
                                fontWeight: FontWeight.bold))
                      ],
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text('Best',
                            style: TextStyle(
                                color: Colors.amber,
                                fontSize: 20,
                                fontWeight: FontWeight.bold)),
                        const SizedBox(height: 20),
                        Text(bestScore.toString(),
                            style: const TextStyle(
                                color: Colors.amber,
                                fontSize: 35,
                                fontWeight: FontWeight.bold))
                      ],
                    )
                  ]),
            ))
          ],
        ),
      ),
    );
  }
}
