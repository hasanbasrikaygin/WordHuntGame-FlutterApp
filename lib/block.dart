import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_word_game/sub_cell.dart';
import 'game.dart';

enum BlockMovement { DOWN }

class Block {
  List<List<SubBlock>> orientations = <List<SubBlock>>[];
  int? x;
  int? y;
  final int orientationIndex;
  Block(
    this.orientations,
    this.orientationIndex,
    this.x,
  ) {
    this.y = 0;
  }

  get subBlocks {
    return orientations[orientationIndex];
  }

  get width {
    int maxX = 0;
    return maxX;
  }

  get heigtht {
    int maxY = 0;
    return maxY;
  }

  void move(BlockMovement blockMovement) {
    switch (blockMovement) {
      case BlockMovement.DOWN:
        y = y! + 1;
        break;
    }
  }
}

bool buttonColorController = false;
int getRandomNumber() {
  Random random = Random();
  int randomNumber =
      random.nextInt(10); // 0 ile 9 arasında rastgele bir sayı seçer

  if (randomNumber < 9) {
    // %90 olasılıkla 1 döndürür
    return 1;
  } else {
    buttonColorController = true;
    return 2;
  }
}

String? name;

int? calculatePoint() {
  for (var randomLetter in randomLetterList) {
    if (name == randomLetter) {
      break;
    }
    return randomNumberList.elementAt(randomLetterList.indexOf(randomLetter));
  }
}

String randomLetters() {
  var r = Random();
  const _chars =
      'AAAAAAAAAABCCÇÇDDEEEEEEEEFGĞHIIIIİİİİİİJKKKKKKLLLMMMNNNOPRRRSSŞŞTTTUVYZ';
  String randomLetter =
      List.generate(1, (index) => _chars[r.nextInt(_chars.length)]).join();
  name != randomLetter;
  return randomLetter;
}

class specialBlock extends Block {
  specialBlock(int orientationIndex, int a)
      : super(
          [
            [
              SubBlock(0, 0, randomLetters(), calculatePoint() as int?,
                  getRandomNumber(), buttonColorController),
            ],
          ],
          orientationIndex,
          a,
        );
}
