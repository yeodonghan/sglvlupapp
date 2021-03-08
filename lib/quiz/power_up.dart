import 'package:flutter/material.dart';

class PowerUp extends StatelessWidget {
  final Icon icon;
  PowerUp(this.icon);
  @override
  Widget build(BuildContext context) {
    return Container(
        width: 40,
        height: 40,
        padding: EdgeInsets.only(top: 5),
        decoration:
            BoxDecoration(shape: BoxShape.circle, color: Color(0xFF8CC5E1)),
        child: icon);
  }
}
