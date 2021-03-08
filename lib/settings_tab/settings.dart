import 'package:SGLvlUp/information_tab/policy_dialogue.dart';
import 'package:flutter/material.dart';
//import 'package:share/share.dart';

class SettingWidget extends StatefulWidget {
  SettingWidget({Key key}) : super(key: key);

  @override
  _SettingWidgetState createState() => _SettingWidgetState();
}

class _SettingWidgetState extends State<SettingWidget> {
  // To get data from a saved appdata

  bool sound = true;
  bool backgroundSound = true;
  bool pushNotification = true;

  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Container(
        alignment: Alignment.center,
        decoration: BoxDecoration(
          image: DecorationImage(
              image: AssetImage('assets/background/informationBG.png'),
              fit: BoxFit.cover),
        ),
        child: SafeArea(
            child: Scaffold(
              resizeToAvoidBottomInset: false,
          backgroundColor: Colors.transparent,
              appBar: AppBar(
                automaticallyImplyLeading: false,
                centerTitle: true,
                title: Text('Settings'),
                backgroundColor: Colors.transparent,
              ),
              body: SingleChildScrollView(
                padding: EdgeInsets.all(16),
            // Center is a layout widget. It takes a single child and positions it
            // in the middle of the parent.
                child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  "Game Settings",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                SwitchListTile(
                  dense: true,
                  activeColor: Color(0xFFFFC823),
                  contentPadding: EdgeInsets.all(0),
                  value: sound,
                  title: Text("Sound"),
                  onChanged: (val) {
                    setState(() {
                      sound = val;
                    });
                  },
                  secondary: const Icon(Icons.volume_up_outlined),
                ),
                SwitchListTile(
                  dense: true,
                  activeColor: Color(0xFFFFC823),
                  contentPadding: EdgeInsets.all(0),
                  value: backgroundSound,
                  title: Text("Background Music"),
                  onChanged: (val) {
                    setState(() {
                      backgroundSound = val;
                    });
                  },
                  secondary: const Icon(Icons.music_note_outlined),
                ),
                const SizedBox(
                  height: 40,
                ),
                Text(
                  "Notification Settings",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                SwitchListTile(
                  dense: true,
                  activeColor: Color(0xFFFFC823),
                  contentPadding: EdgeInsets.all(0),
                  value: pushNotification,
                  title: Text("Push Notification"),
                  onChanged: (val) {
                    setState(() {
                      pushNotification = val;
                    });
                  },
                  secondary: const Icon(Icons.notifications_none),
                ),
                const SizedBox(
                  height: 30,
                ),
                Divider(
                  height: 15,
                  thickness: 2,
                ),
                SizedBox(
                  height: 20,
                ),
                buildFeedback(context),
                SizedBox(
                  height: 20,
                ),
                buildPrivacyPolicy(context),
                SizedBox(
                  height: 20,
                ),
                buildTosPolicy(context),
                SizedBox(
                  height: 20,
                ),
                buildShare(context),
                SizedBox(
                  height: 20,
                ),
                Divider(
                  height: 15,
                  thickness: 2,
                ),
                buildLogout(context),

              ],
            ),
          ),

          //bottomNavigationBar: NavBar(),
          // This trailing comma makes auto-formatting nicer for build methods.
        )));
  }

  GestureDetector buildFeedback(BuildContext context) {
    return GestureDetector(
      onTap: () {
        showDialog(
            context: context,
            builder: (BuildContext context) {
              return SingleChildScrollView(
                child: Dialog(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8)),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        SizedBox(height: 15,),
                        Text('Feedback', style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),),
                        SizedBox(height: 15,),
                        Divider(
                          height: 15,
                          thickness: 1,
                        ),
                        TextField(
                          maxLines: 10,
                          decoration: InputDecoration(
                            contentPadding: EdgeInsets.all(15.0),
                            border: InputBorder.none,
                            focusedBorder: InputBorder.none,
                            enabledBorder: InputBorder.none,
                            errorBorder: InputBorder.none,
                            disabledBorder: InputBorder.none,
                            hintText: "Please leave a feedback",
                            hintStyle: TextStyle(
                              fontSize: 13,
                              color: Colors.grey,
                            ),
                          ),
                        ),
                        Divider(
                          height: 15,
                          thickness: 1,
                        ),

                        SizedBox(height: 15,),

                        ElevatedButton(onPressed: () {},
                          child: Text('Submit'),
                          style: ElevatedButton.styleFrom(
                            padding: EdgeInsets.fromLTRB(30, 10, 30, 10),
                            primary: Color(0xFFFFC823),
                          ),),

                        SizedBox(height: 30,),

                        FlatButton(
                            padding: EdgeInsets.all(0),
                            color: Theme
                                .of(context)
                                .buttonColor,
                            onPressed: () => Navigator.of(context).pop(),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.only(
                                    bottomRight: Radius.circular(8),
                                    bottomLeft: Radius.circular(8)
                                )
                            ),
                            child: Container(
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.only(
                                      bottomRight: Radius.circular(8),
                                      bottomLeft: Radius.circular(8)
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

                ),
              );
            });
      },
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'Feedback',
            style: TextStyle(fontSize: 13),
          ),
          Icon(
            Icons.arrow_forward_ios,
            color: Colors.grey,
          )
        ],
      ),
    );



}

  GestureDetector buildPrivacyPolicy(BuildContext context) {
    return GestureDetector(
      onTap: () {
        showDialog(context: context, builder:(context) {
          return PolicyDialog(mdFileName: 'privacy_policy.md');
        },);
      },
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'Privacy Policy',
            style: TextStyle(fontSize: 13),
          ),
          Icon(
            Icons.arrow_forward_ios,
            color: Colors.grey,
          )
        ],
      ),
    );
  }

  GestureDetector buildTosPolicy(BuildContext context) {
    return GestureDetector(
      onTap: () {
        showDialog(context: context, builder:(context) {
          return PolicyDialog(mdFileName: 'terms_and_services.md');
        },);
      },
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'Terms and Services',
            style: TextStyle(fontSize: 13),
          ),
          Icon(
            Icons.arrow_forward_ios,
            color: Colors.grey,
          )
        ],
      ),
    );
  }

  GestureDetector buildShare(BuildContext context) {
    return GestureDetector(
      onTap: () => share(context),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'Share this App',
            style: TextStyle(fontSize: 13),
          ),
          Icon(
            Icons.arrow_forward_ios,
            color: Colors.grey,
          )
        ],
      ),
    );
  }

  void share(BuildContext context) {
    final RenderBox box = context.findRenderObject();
    final String text = "Check out SGLVLUP app!";

    /*Share.share(
      text,
      sharePositionOrigin: box.localToGlobal(Offset.zero) & box.size,
    );
    */

  }

  GestureDetector buildLogout(BuildContext context) {
    return GestureDetector(
      onTap: () => share(context),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'Logout',
            style: TextStyle(fontSize: 13),
          ),
          Icon(
            Icons.arrow_forward_ios,
            color: Colors.grey,
          )
        ],
      ),
    );
  }

}

