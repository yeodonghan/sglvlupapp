import 'package:flutter/material.dart';

class ProgressBar extends StatelessWidget {
  final int currentScore;

  ProgressBar(this.currentScore);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 25,
      color: Colors.white,
      child: FractionallySizedBox(
        heightFactor: 1,
        widthFactor: currentScore / 10,
        child: Container(
          color: Color(0xFF4CFC0E),
        ),
      ),
    );
  }
}
