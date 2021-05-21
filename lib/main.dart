import 'package:SGLvlUp/audio/SoundsHandler.dart';
import 'package:SGLvlUp/information_tab//information.dart';
import 'package:SGLvlUp/leaderboard_tab/leaderboard.dart';
import 'package:SGLvlUp/login/login_page.dart';
import 'package:SGLvlUp/settings_tab/settings.dart';
import 'package:SGLvlUp/shared/UserPreferences.dart';
import 'package:SGLvlUp/shared/UserProfile.dart';
import 'package:flame/flame.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

import 'category/categories_layout.dart';

const String testDevice = 'Mobile_id';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  MobileAds.instance.initialize();
  await UserPreferences().init();
  String email = await UserPreferences.getStringData('email');
  String userId = await UserPreferences.getStringData('userId');
  String username = await UserPreferences.getStringData('username');
  String profile = await UserPreferences.getStringData('profile');
  String accType = await UserPreferences.getStringData('accType');
  String date = await UserPreferences.getStringData('date');
  String coin = await UserPreferences.getStringData('coin');
  String notification = await UserPreferences.getStringData('notification');
  UserProfile _userDetail = UserProfile(
      user_id: 0,
      user_pictureurl: '',
      user_name: '',
      user_email: '',
      user_accounttype: '',
      user_registerdate: '',
      user_coins: 0,
      user_notification: 0);
  if (email.isNotEmpty) {
    _userDetail = UserProfile(
        user_id: int.parse(userId),
        user_pictureurl: profile,
        user_name: username,
        user_email: email,
        user_accounttype: accType,
        user_registerdate: date,
        user_coins: int.parse(coin),
        user_notification: int.parse(notification));
  }
  runApp(MyApp(user: _userDetail));
}

class MyApp extends StatefulWidget {
  final UserProfile user;

  MyApp({Key key, @required this.user}) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  Widget _defaultWidgets = LoginPage();

  @override
  void initState() {
    if (widget.user.user_email.isNotEmpty) {
      _defaultWidgets = MyHomePage(
        user: widget.user,
        isFrom: 'main',
      );
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        fontFamily: "Londrina",
        primarySwatch: Colors.yellow,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: _defaultWidgets,
    );
  }
}

class MyHomePage extends StatefulWidget {
  UserProfile user;
  String isFrom = '';

  MyHomePage({Key key, @required this.user, this.isFrom}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _selectedIndex = 0;
  List<Widget> _widgetOptions = [];

  @override
  void initState() {
    if (widget.isFrom == 'main') {
      Flame.audio.loadAll(['bgm.mp3', 'tap.ogg']);
      SoundsHandler().playBGM();
    }
    _widgetOptions = [
      HomeWidget(user: widget.user),
      InformationWidget(user: widget.user),
      SettingWidget(user: widget.user),
      LeaderboardWidget(),
    ];
    super.initState();
  }

  void _onItemTapped(int index) {
    SoundsHandler().playTap();
    setState(() {
      if (index == 1 && widget.user.user_name == "Guest") {
        Navigator.pop(context);
      } else {
        _selectedIndex = index;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(child: _widgetOptions.elementAt(_selectedIndex)),
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

class HomeWidget extends StatelessWidget {
  final UserProfile user;

  const HomeWidget({Key key, @required this.user}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Container(
        alignment: Alignment.center,
        decoration: BoxDecoration(
          image: DecorationImage(
              image: AssetImage('assets/background/home_bg.png'),
              fit: BoxFit.cover),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            ElevatedButton(
              onPressed: () {
                SoundsHandler().playTap();
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => CategoriesLayout(user)),
                );
              },
              child: Text("Classic"),
              style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.only(left: 50, right: 50),
                  primary: Color(0xFFFFC823),
                  textStyle: TextStyle(fontSize: 22)),
            ),
            ElevatedButton(
              onPressed: () {
                //SoundsHandler().playTap();
              },
              child: Text("Challenges"),
              style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.only(left: 50, right: 50),
                  primary: Colors.grey,
                  textStyle: TextStyle(fontSize: 22)),
            ),
            SizedBox(
              height: 20,
            ),
          ],
        ),
      ),
      backgroundColor: Color(0xff47443F),
      //bottomNavigationBar: NavBar(),
      // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
