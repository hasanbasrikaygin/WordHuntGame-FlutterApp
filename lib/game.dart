import 'dart:async';
import 'dart:io';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:flutter_word_game/block.dart';
import 'package:flutter_word_game/colors_items.dart';
import 'package:flutter_word_game/home_screen.dart';
import 'package:flutter_word_game/score_board.dart';
import 'package:flutter_word_game/sub_cell.dart';

enum Collision { LANDED, LANDED_BLOCK, NONE }

const BLOCKS_X = 8;
const BLOCKS_Y = 12;
const GAME_AREA_BORDER_WIDH = 1.0;
const SUB_BLOCK_EDGE_WIDTH = 15.0;
List<int?> whoIsLeader = [0, 0, 0, 0, 0];
List<int?> wordLocation = [];
List<List<int>> matrix = [];
bool flag = false;
List<int?> sortedCoordinates = [];
int i = 1;
int scor = 0;
List<String> showString = [];
String newWord = "";
int timerFlag = 0;
int falseCounter = 0;
List<int> maxNumbers = [];
List<List<int>> rowBlockMatris = [];

class Game extends StatefulWidget {
  Game({Key? key}) : super(key: key);

  @override
  State<Game> createState() => GameState();
}

class GameState extends State<Game> {
  GlobalKey _keyGameArea = GlobalKey();
  late double subBlockWidth;
  Block? block;
  Block? blocRow;
  Timer? timer;
  late Timer? timer2;
  late Timer? timer3;
  late Timer? timer4;
  late Timer? timer5;
  bool isPlaying = false;
  bool isGameOver = false;
  bool cleanWordLocation = true;
  int? score = 0;
  bool? elementFlag;
  late List<SubBlock> oldSubBlocks;
  int? tempX;
  int? tempy;

  List<int> randomCreateBlockNumber = [];
  void startGame() {
    timerFlag = 0;
    Timer.periodic(Duration(milliseconds: 500), (timer2) {
      onPlay(timer2);
      if (timerFlag == 1) {
        timer2.cancel();
      }
    });
    oldSubBlocks = <SubBlock>[];
    for (int i = 0; i < 25; i++) {
      randomCreateBlockNumber.add(Random().nextInt(30));
    }
    for (int i = 0; i < 8; i++) {
      for (int j = 11; j > 8; j--) {
        oldSubBlocks.add(SubBlock(i, j, randomLetterList[Random().nextInt(29)],
            randomNumberList[Random().nextInt(29)], 1, false));
      }
    }
    isGameOver = false;
    isPlaying = true;
    RenderBox renderBoxGame =
        _keyGameArea.currentContext!.findRenderObject() as RenderBox;
    subBlockWidth =
        (renderBoxGame.size.width - GAME_AREA_BORDER_WIDH * 2) / BLOCKS_X;
    block = getNewBlock()!;
  }

////////   endGame
  void endGame() {
    setState(() {
      wordLocation.clear();
      timerFlag = 1;
      isTrueWord = "";
      newWord = "";
      isPlaying = false;
      flag = false;
      falseCounter = 0;
      GameState gameState = GameState();
      ScoreBoardState scoreBoard = new ScoreBoardState();
      scoreBoard.scoreBoardShow(scor);
      isGameOver = true;
      score = scor;
    });
    scor = 0;
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => ScoreBoard(
                scor: score,
                subBlockWidth: subBlockWidth,
              )),
    );
  }

/////// onPlay
  void onPlay(Timer timer2) {
    print(falseCounter);
    SubBlock? temp = null;
    var status = Collision.NONE;
    setState(() {
      if (!CheckAtBootom()) {
        if (!CheckAboveBlock()) {
          block?.move(BlockMovement.DOWN);
        } else {
          status = Collision.LANDED_BLOCK;
        }
      } else {
        status = Collision.LANDED;
      }
// gameover chcecking
      if (status == Collision.LANDED_BLOCK && block!.y! < 1) {
        isGameOver = true;
        endGame();
      } else if (status == Collision.LANDED ||
          status == Collision.LANDED_BLOCK) {
        block!.subBlocks.forEach((subBlock) {
          subBlock.x += block!.x;
          subBlock.y += block!.y;
          oldSubBlocks.add(subBlock);
        });
// 3 wrong answers
        if (falseCounter == 3) {
          newFalseBlock(oldSubBlocks);
          falseCounter = 0;
        }
        block = getNewBlock();
      }

// time upgrade
      if (scor > 0 && flag == true) {
        setState(() {
          if (scor > 10 && scor < 20) {
            //scor > 19 && scor < 30
            timer2.cancel();
            Timer.periodic(Duration(milliseconds: 400), (timer) {
              onPlay(timer);
              print('Timer   çalışıyor...');
              if (timerFlag == 1) {
                timer.cancel();
              }
            });
          }
          if (scor > 19 && scor < 30) {
            //scor > 29 && scor < 40
            timer2.cancel();
            Timer.periodic(Duration(milliseconds: 300), (timer3) {
              onPlay(timer3);
              print('Timer 3  çalışıyor...');
              if (timerFlag == 1) {
                timer3.cancel();
              }
            });
          }
          if (scor > 29 && scor < 40) {
            //scor > 39 && scor < 50
            timer2.cancel();
            Timer.periodic(Duration(milliseconds: 200), (timer4) {
              onPlay(timer4);
              print('Timer 4  çalışıyor...');
              if (timerFlag == 1) {
                timer4.cancel();
              }
            });
          }
          if (scor > 399) {
            //scor > 49
            timer2.cancel();
            Timer.periodic(Duration(milliseconds: 100), (timer5) {
              onPlay(timer5);
              print('Timer 5  çalışıyor...');
              if (timerFlag == 1) {
                timer5.cancel();
              }
            });
          }
        });

        print("wordLocation");
        print(wordLocation);
        removeWords(wordLocation.cast<int>());
        flag = false;
        wordLocation.clear();
      }
      oldSubBlocks.forEach((iceBlock) {
        if (iceBlock.checkRemove == 2) {
          if (iceBlock.y == 11) {
            iceBlock.checkRemove = 2;
          }
        }
        for (var iceBlock in oldSubBlocks) {
          for (var subBlockControl in block!.subBlocks!) {
            if (subBlockControl.checkRemove == 2 && subBlockControl.y != 11) {
              var x = block!.x! + subBlockControl.x;
              var y = block!.y! + subBlockControl.y;
              if (x == iceBlock.x && y + 1 == iceBlock.y) {
                iceBlock.checkRemove = 2;
                iceBlock.buttonColorController = true;
//  control ice letter
                setState(() {
                  oldSubBlocks.forEach((iceLetter) {
                    if (iceLetter.x == iceBlock.x && // alt orta
                        iceLetter.y == iceBlock.y!) {
                      iceLetter.checkRemove = 2;
                    }

                    if (iceLetter.x == iceBlock.x! + 1 && // alt sağ
                        iceLetter.y == iceBlock.y!) {
                      iceLetter.checkRemove = 2;
                    }

                    if (iceLetter.x == iceBlock.x! - 1 && //alt sol
                        iceLetter.y == iceBlock.y!) {
                      iceLetter.checkRemove = 2;
                    }

                    if (iceLetter.x == iceBlock.x! - 1 && // merkez sol
                        iceLetter.y == iceBlock.y! - 1) {
                      iceLetter.checkRemove = 2;
                    }
                    if (iceLetter.x == iceBlock.x! + 1 && // merkez sağ
                        iceLetter.y == iceBlock.y! - 1) {
                      iceLetter.checkRemove = 2;
                    }
                    if (iceLetter.x == iceBlock.x! + 1 && // sağ üst çapraz
                        iceLetter.y == iceBlock.y! - 2) {
                      iceLetter.checkRemove = 2;
                    }
                    if (iceLetter.x == iceBlock.x! - 1 && // sol üst çapraz
                        iceLetter.y == iceBlock.y! - 2) {
                      iceLetter.checkRemove = 2;
                    }
                  });
                });
              }
              temp = subBlockControl;
            }
          }
        }
      });
    });
  }

  void removeWords(
    List<int>? wordLocation,
  ) {
// silinen konumları matrise aktarma
    var status = Collision.NONE;
    for (int i = 0; i < wordLocation!.length; i += 2) {
      matrix.add([wordLocation[i], wordLocation[i + 1]]);
    }
    print("matrix");
    print(matrix);
// matristeki blockları kaldırma
    for (int i = 0; i < matrix.length; i++) {
      for (int j = 0; j < 1; j++) {
        oldSubBlocks.forEach((subBlock) {
          if (subBlock.x == matrix[i][j] &&
              subBlock.y == matrix[i][j + 1] &&
              subBlock.checkRemove == 1) {
            int? tempX = subBlock.x;
            int? tempY = subBlock.y;
            subBlock.x = 0;
            subBlock.y = 12;
          }
        });
      }
    }

    for (int i = 0; i < matrix.length; i++) {
      for (int j = 0; j < 1; j++) {
        oldSubBlocks.forEach((subBlock) {
          if (subBlock.x == matrix[i][j] && subBlock.y! < matrix[i][j + 1]) {
            if (!CheckAtBootom()) {
              if (!CheckAboveBlock()) {
                subBlock.y = subBlock.y! + 1;
              } else {
                status = Collision.LANDED_BLOCK;
              }
            } else {
              status = Collision.LANDED;
            }
          } else {}
        });
      }
    }

    matrix.clear();
  }

  bool CheckAboveBlock() {
    for (var oldSubBlock in oldSubBlocks) {
      for (var subBlock in block!.subBlocks!) {
        var x = block!.x! + subBlock.x;
        var y = block!.y! + subBlock.y;
        if (x == oldSubBlock.x && y + 1 == oldSubBlock.y) {
          return true;
        }
      }
    }
    return false;
  }

  bool CheckAtBootom() {
    return block!.y! + block!.heigtht! == 11;
  }

//////   x , y , create container based on letter info
  Widget getPositionedSquareContainer(
    int x,
    int y,
    String Letter,
    int checkRemove,
    SubBlock subBlock,
    bool buttonColorController,
  ) {
    return Container(
      child: Positioned(
        left: x * subBlockWidth,
        top: y * subBlockWidth,
        child: ElevatedButton(
          style: ButtonStyle(
            backgroundColor: MaterialStateProperty.resolveWith<Color>(
                (Set<MaterialState> states) {
              if (checkRemove == 2) {
                return ColorsItems.ice;
              } else if (checkRemove == 1) {
                return ColorsItems.purpleBlue;
              } else {
                return ColorsItems.yellow;
              }
            }),
            minimumSize: MaterialStateProperty.all<Size>(Size(50, 50)),
            shape: MaterialStateProperty.all<RoundedRectangleBorder>(
              RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(
                  checkRemove == 1
                      ? 15
                      : checkRemove == 2
                          ? 30
                          : 5,
                ),
                side: checkRemove == 1
                    ? const BorderSide(color: ColorsItems.black, width: 2)
                    : BorderSide(color: ColorsItems.white, width: 2),
              ),
            ),
          ),
          child: Center(
            child: Text(
              Letter,
              style: TextStyle(
                  fontFamily: checkRemove == 1 ? 'carter' : 'comic2',
                  fontSize: 25,
                  shadows: checkRemove == 2
                      ? [
                          const Shadow(
                            blurRadius: 0.0,
                            color: ColorsItems.black,
                            offset: Offset(1.0, 2.0),
                          ),
                        ]
                      : null,
                  fontWeight:
                      checkRemove == 1 ? FontWeight.w400 : FontWeight.w600),
            ),
          ),
          onPressed: () {
            // buton ile harf seçimi
            if (subBlock.checkRemove == 1) {
              wordLocation.add(x);
              wordLocation.add(y);
              print("wordLocation[i]");
              for (int i = 0; i < wordLocation.length; i++) {
                print(wordLocation[i]);
              }
            }
            if (subBlock.checkRemove == 2) {
              subBlock.checkRemove = 1;
            }
            setState(() {
              isTrueWord += Letter;
              newWord += Letter;
              showString.add(Letter);
              print("is True Word" + isTrueWord);
            });
          },
        ),
      ),
    );
  }

  void scorUpgrade(
    int sendScorefunction,
  ) {
    print("skor kontrol");
    print(scor);
    scor += sendScorefunction;
  }

//// drawBlocks
  Widget? drawBlocks() {
    //kontrol, blokların oluşturulma kontrolü
    if (block == null) return null;
    List<Widget> subBlocks = [];

    // geçerli blok
    block?.subBlocks.forEach((subBlock) {
      subBlocks.add(getPositionedSquareContainer(
          subBlock.x + block?.x,
          subBlock.y + block?.y,
          subBlock.Letter,
          subBlock.checkRemove,
          subBlock,
          subBlock.buttonColorController));
    });
    //for old blocks;
    oldSubBlocks.forEach(
      (oldSubBlock) {
        subBlocks.add(getPositionedSquareContainer(
            oldSubBlock.x!,
            oldSubBlock.y!,
            oldSubBlock.Letter!,
            oldSubBlock.checkRemove!,
            oldSubBlock,
            oldSubBlock.buttonColorController!));
      },
    );

    if (isGameOver) {
      setState(() {
        timerFlag = 1;
      });
    }
    return Stack(
      children: subBlocks,
    );
  }

  Widget? inputLettersShowScreen(String letterMerge) {
    return Center(
      child: SizedBox(
        width: 340,
        height: 55,
        child: Container(
          decoration: const BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(20)),
            color: ColorsItems.turquoiseLight,
          ),
          child: Center(
            child: Text(
              letterMerge,
              style: TextStyle(
                fontFamily: 'carter2',
                fontSize: 30,
                letterSpacing: 1,
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        AspectRatio(
          aspectRatio: BLOCKS_X / BLOCKS_Y,
          child: Container(
            key: _keyGameArea,
            decoration: BoxDecoration(
              color: ColorsItems.turquoiseLight,
              border: Border.all(
                  width: GAME_AREA_BORDER_WIDH, color: ColorsItems.white //
                  ),
              borderRadius: BorderRadius.all(Radius.circular(10.0)),
            ),
            child: drawBlocks(),
          ),
        ),
        Container(
            margin: EdgeInsets.only(top: 15.0),
            child: inputLettersShowScreen(newWord))
      ],
    );
  }
}

int temp = 20;
List<int> tempRow = [0, 1, 2, 3, 4, 5, 6, 7];
void newFalseBlock(List<SubBlock>? oldSubBlocks) {
// bloklar içerisinde boş olan sütunların indeksleri
  oldSubBlocks!.forEach((element) {
    for (int i = 0; i < 8; i++) {
      if (i == element.x) {
        tempRow.remove(i);
      }
    }
  });
// her  sütundaki en büyük y'ye sahip blokların indexleri
  for (int i = 0; i < 8; i++) {
    oldSubBlocks.forEach((block) {
      if (block.x == 1) {}
      if (i == block.x) {
        if (temp > block.y!) {
          temp = block.y!;
        }
      }
      if (i == block.x) {}
    });
    rowBlockMatris.add([i, temp]);
    temp = 20;
  }
// blok üzerine bir blok eklenmesi
  for (int k = 0; k < 8; k++) {
    print(rowBlockMatris[k][1]);
    oldSubBlocks.add(SubBlock(
        k,
        rowBlockMatris[k][1] - 1,
        randomLetterList[Random().nextInt(29)],
        randomNumberList[Random().nextInt(29)],
        1,
        false));
  }

// eğer sutunda harf kalmamıssa
  if (tempRow.isNotEmpty) {
    for (int i = 0; i < tempRow.length; i++) {
      oldSubBlocks.add(SubBlock(
          tempRow[i],
          11,
          randomLetterList[Random().nextInt(29)],
          randomNumberList[Random().nextInt(29)],
          1,
          false));
    }
  }
  /*
  print("  *********   rowBlockMatris **********");
  print(rowBlockMatris);
  print("  *********   rowBlockMatris **********");
  */
  rowBlockMatris.clear();
}

/*
0  0
0 11 7 11
*/

Block? getNewBlock() {
  int orientationIndex = Random().nextInt(1);

  return specialBlock(0, Random().nextInt(8));
}

List<int> randomNumberList = [
  1,
  3,
  4,
  4,
  3,
  1,
  7,
  5,
  8,
  5,
  2,
  1,
  10,
  1,
  1,
  2,
  1,
  2,
  7,
  5,
  1,
  2,
  4,
  1,
  2,
  3,
  7,
  3,
  4
];
List<String> randomLetterList = [
  "A",
  "B",
  "C",
  "Ç",
  "D",
  "E",
  "F",
  "G",
  "Ğ",
  "H",
  "I",
  "İ",
  "J",
  "K",
  "L",
  "M",
  "N",
  "O",
  "Ö",
  "P",
  "R",
  "S",
  "Ş",
  "T",
  "U",
  "Ü",
  "V",
  "Y",
  "Z"
];
