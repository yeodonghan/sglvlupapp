import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_markdown/flutter_markdown.dart';

class PolicyDialog extends StatelessWidget {
  const PolicyDialog({
    Key key,
    this.radius = 8,
    @required this.mdFileName,
  }) : super(key: key);

  final double radius;
  final String mdFileName;


  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Dialog(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(radius)),
        child: Column(
            children: [
            Expanded(
              child: FutureBuilder(
                future: Future.delayed(Duration(milliseconds: 50)).then((value) {
                  return rootBundle.loadString('assets/policies/$mdFileName');
                }),
                builder: (context,snapshot) {
                  if(snapshot.hasData) {
                    return Markdown(
                      data: snapshot.data
                    );
                  }
                  return Center(child: CircularProgressIndicator(),);
                }
              ),
            ),
            FlatButton(
                padding: EdgeInsets.all(0),
                color: Theme
                    .of(context)
                    .buttonColor,
                onPressed: () => Navigator.of(context).pop(),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.only(
                        bottomRight: Radius.circular(radius),
                        bottomLeft: Radius.circular(radius)
                    )
                ),
                child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.only(
                        bottomRight: Radius.circular(radius),
                        bottomLeft: Radius.circular(radius)
                      )
                    ),
                    alignment: Alignment.center,
                    height: 50,
                    width: double.infinity,
                    child: Text(
                      "Close",
                      style: TextStyle(fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).textTheme.button.color,
                    ),
    ),
    )
        )],
    )

    );
    throw UnimplementedError(
    );
  }
}