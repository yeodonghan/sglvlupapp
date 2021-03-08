import 'package:SGLvlUp/information_tab//information.dart';
import 'package:SGLvlUp/leaderboard_tab/leaderboard.dart';
import 'package:SGLvlUp/login/login_page.dart';
import 'package:SGLvlUp/settings_tab/settings.dart';
import 'package:flutter/material.dart';
import 'category/categories_layout.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        fontFamily: "Londrina",
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.yellow,
        // This makes the visual density adapt to the platform that you run
        // the app on. For desktop platforms, the controls will be smaller and
        // closer together (more dense) than on mobile platforms.
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),


      //home: MyHomePage(title: 'Flutter Demo Home Page'),
      home: LoginPage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  _NavBarState createState() => _NavBarState();
}

class HomeWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      resizeToAvoidBottomInset: false,

      body: Container(
        // Center is a layout widget. It takes a single child and positions it
        // in the middle of the parent.

        alignment: Alignment.center,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/background/home_bg.png'),
            fit: BoxFit.cover
          ),

        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => CategoriesLayout()),
                );
              },
              child: Text("Classic"),
              style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.only(left: 50, right: 50),
                  primary: Color(0xFFFFC823),
                  textStyle: TextStyle(fontSize: 22)),
            ),
            ElevatedButton(

              onPressed: () => CategoriesLayout(),
              child: Text("Challenges"),
              style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.only(left: 50, right: 50),
                  primary: Color(0xFFFFC823),
                  textStyle: TextStyle(fontSize: 22)),
            ),
            SizedBox(
              height: 50,
            )
          ],
        ),
      ),

      backgroundColor: Color(0xff47443F),
      //bottomNavigationBar: NavBar(),
      // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}

/*

class NavBar extends StatefulWidget {
  NavBar();

  @override
  _NavBarState createState() => _NavBarState();
}

*/

class _NavBarState extends State<MyHomePage> {
  int _selectedIndex = 0;
  static List<Widget> _widgetOptions = <Widget>[
    new HomeWidget(),
    new InformationWidget(),
    new SettingWidget(),
    new LeaderboardWidget(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: _widgetOptions.elementAt(_selectedIndex)
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        backgroundColor: Color(0xff47443F),
        unselectedItemColor: Colors.white,
        selectedItemColor: Colors.yellow,
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
          BottomNavigationBarItem(
            icon: Icon(Icons.info),
            label: "Information",

          ),
          BottomNavigationBarItem(
              icon: Icon(Icons.settings), label: "Settings"),
          BottomNavigationBarItem(
              icon: Icon(Icons.leaderboard), label: "Leaderboard"),
        ],
      ),
    );
  }
}