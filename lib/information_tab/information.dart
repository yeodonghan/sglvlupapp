
import 'package:SGLvlUp/information_tab/accountform.dart';
import 'package:SGLvlUp/information_tab/policy_dialogue.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

class InformationWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Container (

        alignment: Alignment.center,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/background/informationBG.png'),
            fit: BoxFit.cover
          ),
        ),

            child: Scaffold(
              resizeToAvoidBottomInset: false,

              backgroundColor: Colors.transparent,
              appBar: AppBar(
                automaticallyImplyLeading: false,
                centerTitle: true,
                title: Text('Profile'),
                backgroundColor: Colors.transparent,
              ),
              body: Container(
                // Center is a layout widget. It takes a single child and positions it
                // in the middle of the parent.
                alignment: Alignment.center,
                child: ListView(
                  children: [

                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            Row(
                              children: [
                                Container(
                                  height: 40,
                                ),
                              ],
                            ),

                            Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    height: 100,
                                    width: 100,
                                    decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        image: DecorationImage(
                                            fit: BoxFit.cover,
                                            image: AssetImage('assets/profile_picture_sample.jpg')
                                        )
                                    ),
                                  ),
                                ]
                            ),

                            Row(
                              children: [
                                Container(
                                  height: 40,
                                ),
                              ],
                            ),

                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [

                                MyAccountForm(),




                              ],
                            ),

                            Row(
                              children: [
                                Container(
                                  height: 40,
                                ),
                              ],
                            ),

                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              crossAxisAlignment: CrossAxisAlignment.end,
                            )



                          ],
                        )
                    ]

                    )

                )

              ),

              //bottomNavigationBar: NavBar(),
              // This trailing comma makes auto-formatting nicer for build methods.
            );





  }
}