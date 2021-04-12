import 'package:flutter/material.dart';

class PowerUp extends StatefulWidget {
  final Icon icon;

  PowerUp(this.icon);

  @override
  _PowerUpState createState() => _PowerUpState();
}

class _PowerUpState extends State<PowerUp> {
  @override
  Widget build(BuildContext context) {
    return Container(
        width: 40,
        height: 40,
        padding: EdgeInsets.only(top: 5),
        decoration:
            BoxDecoration(shape: BoxShape.circle, color: Color(0xFF8CC5E1)),
        child: widget.icon);
  }
}
