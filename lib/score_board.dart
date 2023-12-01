import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:flutter_word_game/colors_items.dart';
import 'package:flutter_word_game/game.dart';

class ScoreBoard extends StatefulWidget {
  double? subBlockWidth;
  int? scor;

  ScoreBoard({Key? key, this.subBlockWidth, this.scor}) : super(key: key);

  @override
  State<ScoreBoard> createState() => ScoreBoardState();
}

class ScoreBoardState extends State<ScoreBoard> {
  GameState gameState = GameState();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: ColorsItems.lavenderPastel,
        elevation: 0,
        title: const Text(
          "Score Board",
          style: TextStyle(
            color: ColorsItems.black,
            fontWeight: FontWeight.bold,
            fontFamily: 'carter2',
            fontSize: 40,
            letterSpacing: 2,
          ),
        ),
      ),
      body: Container(
        color: ColorsItems.purpleBlue,
        child: Padding(
          padding: const EdgeInsets.only(top: 50.0),
          child: Container(
            transformAlignment: Alignment.bottomCenter,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: ColorsItems.purpleBlue,
              borderRadius: BorderRadius.circular(5.0),
            ),
            child: Column(
              children: [
                SizedBox(
                  height: 120,
                  width: 200,
                  child: Container(
                    decoration: const BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(30)),
                      color: ColorsItems.lavenderPastel,
                    ),
                    // color: Colors.red,
                    child: const Padding(
                      padding: EdgeInsets.only(top: 30, bottom: 30),
                      child: Center(
                        child: Text(
                          "TOP 5 ",
                          style: TextStyle(
                            color: ColorsItems.black,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'carter2',
                            fontSize: 40,
                            letterSpacing: 2,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 30,
                ),
                SizedBox(
                  height: 400,
                  width: 350,
                  child: Container(
                    color: ColorsItems.lavenderPastel,
                    child: Column(
                      children: [
                        ScoreBoardText("First :", whoIsLeader[0]!),
                        ScoreBoardText("Second :", whoIsLeader[1]!),
                        ScoreBoardText("Third :", whoIsLeader[2]!),
                        ScoreBoardText("Fourth :", whoIsLeader[3]!),
                        ScoreBoardText("Fifth :", whoIsLeader[4]!),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget ScoreBoardText(String rank, int score) {
    return Stack(
      children: <Widget>[
        // Stroked text as border.
        Center(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  rank.toString(),
                  style: const TextStyle(
                    color: ColorsItems.black,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'carter2',
                    fontSize: 40,
                    letterSpacing: 2,
                  ),
                ),
                const SizedBox(
                  height: 50,
                  width: 50,
                ),
                // Solid text as fill.
                Text(
                  score.toString(),
                  style: const TextStyle(
                    color: ColorsItems.black,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'carter2',
                    fontSize: 40,
                    letterSpacing: 2,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  scoreBoardShow(int score) {
    whoIsLeader.insert(0, score);
    whoIsLeader.sort();
    whoIsLeader = whoIsLeader.reversed.toList();
  }
}
