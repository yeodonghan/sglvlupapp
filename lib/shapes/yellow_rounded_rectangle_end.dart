import 'package:flutter/material.dart';

class YellowRoundedRectangleEnd extends StatelessWidget {
  final String message;
  YellowRoundedRectangleEnd(this.message);

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
        child: Container(
          width: double.infinity,
        color: Color(0xFFFFC823),
        padding: EdgeInsets.only(
          left: 15,
          right: 15,
          top: 10,
          bottom: 10,
        ),
          child: SingleChildScrollView(
            child: Text(
              this.message,
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 18),
            ),
          ),
        ),
        /*
        decoration: BoxDecoration(color: Color(0xFFFFC823), boxShadow: [
          BoxShadow(
            color: Colors.green.withOpacity(0),
            spreadRadius: 5,
            blurRadius: 7,
            offset: Offset(0, 3),
          ),
        ]),

         */
      );

  }

  Widget _customButtonWidget(String label, {Function onPress}) {
    return ElevatedButton(
        child: Text(label,
            style: TextStyle(fontSize: 18)),
        style: ButtonStyle(
            padding: MaterialStateProperty.all<EdgeInsets>(
                EdgeInsets.only(left: 30, right: 30.0,top: 10.0,bottom: 10.0)),
            backgroundColor: MaterialStateProperty.all<Color>( Color(0xFFFFC823)),
            shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(20.0)),
                ))),
        onPressed: () => onPress());
  }
}
