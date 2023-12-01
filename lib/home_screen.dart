import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:flutter_word_game/colors_items.dart';
import 'package:flutter_word_game/game.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

String isTrueWord = "";
List<String> splitLetters = [];
List<int> sendScoreFunction = [];
Duration duration = Duration(milliseconds: REFRESH_RATE);
int REFRESH_RATE = 400;
List<String> Kelime = [];
bool checkFlag = true;

class _HomeScreenState extends State<HomeScreen> {
  GlobalKey<GameState> _keyGame = GlobalKey();

  @override
  void initState() {
    super.initState();
    loadAsset();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorsItems.lavenderPastel,
      body: Column(
        children: [
          Expanded(
              flex: 9,
              child: Container(
                alignment: Alignment.bottomCenter,
                child: Text(
                  "SKOR : " + '$scor',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontFamily: 'carter2',
                    fontSize: 38,
                    letterSpacing: 2,
                  ),
                ),
              )),
          Expanded(
              flex: 78,
              child: Game(
                key: _keyGame,
              )),
          Expanded(
              flex: 10,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                backgroundColor: ColorsItems.teal,
                                fixedSize: const Size(120, 50),
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(50))),
                            onPressed: () {
                              setState(() {
                                _keyGame.currentState != null &&
                                        _keyGame.currentState!.isPlaying
                                    ? _keyGame.currentState!.endGame()
                                    : _keyGame.currentState!.startGame();
                              });
                            },
                            child: Text(
                              _keyGame.currentState != null &&
                                      _keyGame.currentState!.isPlaying
                                  ? "END"
                                  : "START",
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontFamily: 'comics',
                                fontSize: 23,
                                letterSpacing: 2,
                              ),
                            )),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              backgroundColor: ColorsItems.blue,
                              fixedSize: const Size(120, 50),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(50))),
                          child: const Text(
                            'CHECK',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontFamily: 'comics',
                              fontSize: 21,
                              letterSpacing: 2,
                            ),
                          ),
                          onPressed: () {
                            if (isTrueWord != "") {
                              for (String kelime in Kelime) {
                                if (isTrueWord.length > 2) {
                                  if (isTrueWord ==
                                      kelime.trim().toUpperCase()) {
                                    checkFlag = false;
                                    break;
                                  }
                                }
                              }

                              if (checkFlag == false) {
                                splitLetters = isTrueWord.split("");
                                calculateScor();

                                flag = true;
                                int result = sendScoreFunction.reduce(
                                    (value, element) => value + element);
                                print(result);

                                GameState gameState = GameState();
                                print("result");
                                print(result);
                                setState(() {
                                  gameState.scorUpgrade(result);
                                });

                                print("içeriyor");

                                sendScoreFunction.clear();
                                newWord = "";
                                isTrueWord = "";
                                result = 0;
                                checkFlag = true;
                              } else {
                                setState(() {
                                  wordLocation.clear();
                                  matrix.clear();
                                });
                                newWord = "";
                                isTrueWord = "";
                                print("içermiyor");
                                matrix.clear();
                                if (falseCounter < 3) {
                                  falseCounter++;
                                }
                              }
                            }
                          },
                        ),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              backgroundColor: ColorsItems.red,
                              fixedSize: const Size(120, 50),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(50))),
                          child: const Text(
                            'DELETE',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontFamily: 'comics',
                              fontSize: 20,
                              letterSpacing: 2,
                            ),
                          ),
                          onPressed: () {
                            GameState gameState = GameState();
                            // eğer harf seçilmiş ise son harfin konumunu sil
                            if (wordLocation.isNotEmpty) {
                              wordLocation.removeAt(wordLocation.length - 1);
                              wordLocation.removeAt(wordLocation.length - 1);
                            }

                            if (newWord != "") {
                              newWord =
                                  newWord.substring(0, newWord.length - 1);
                            }
                            isTrueWord = "";
                            print(newWord);
                          },
                        )
                      ]),
                ],
              ))
        ],
      ),
    );
  }
}

Future<void> calculateScor() async {
  for (int i = 0; i < splitLetters.length; i++) {
    for (var randomLetter in randomLetterList) {
      if (splitLetters[i] == randomLetter) {
        sendScoreFunction.add(
            randomNumberList.elementAt(randomLetterList.indexOf(randomLetter)));
        print(sendScoreFunction);
      }
    }
  }
}

Future<void> loadAsset() async {
  if (Kelime.length > 30000) {
  } else {
    String loadedString = await rootBundle.loadString('assets/words.txt');
    loadedString.split('\n').forEach((element) {
      if (element.trim().length <= 2 || element.trim().split(' ').length > 1) {
      } else {
        Kelime.add(element.trim());
      }
    });
  }
}
