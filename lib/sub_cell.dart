import 'package:flutter/material.dart';

class SubBlock {
  int? x;
  int? y;
  int? letterPoint;
  String? Letter;
  int? checkRemove;
  bool? buttonColorController;

  SubBlock(this.x, this.y, this.Letter, this.letterPoint, this.checkRemove,
      this.buttonColorController) {}
  void updateCheckRemove(int newCheckRemove) {
    checkRemove = newCheckRemove;
  }

  void updateButtonColorController(bool newButtonColorController) {
    buttonColorController = newButtonColorController;
  }
}
