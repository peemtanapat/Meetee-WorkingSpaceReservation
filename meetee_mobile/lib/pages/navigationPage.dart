import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:meetee_mobile/pages/homePage.dart';
import 'package:meetee_mobile/pages/accountPage.dart';
import '../main.dart';
import 'schedulePage.dart';

class NavigationPage extends StatefulWidget {
  final String userName;
  final int userId;
  final int page;

  NavigationPage({
    Key key,
    this.userName,
    this.userId,
    this.page,
  }) : super(key: key);
  @override
  _NavigationPageState createState() => _NavigationPageState();
}

class _NavigationPageState extends State<NavigationPage> {
  int _currentIndex = 0;

  @override
  void initState() {
    var initializationSettingsAndroid =
        new AndroidInitializationSettings('app_icon');
    var initializationSettingsIOS = new IOSInitializationSettings();
    var initializationSettings = InitializationSettings(
        initializationSettingsAndroid, initializationSettingsIOS);

    flutterLocalNotificationsPlugin.initialize(initializationSettings,
        onSelectNotification: onSelectNotification);

    if (widget.page != null) {
      _currentIndex = widget.page;
    }

    super.initState();
  }

  Future onSelectNotification(String payload) async {
    if (payload != null) {
      print('notification payload: ' + payload);
    }
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => NavigationPage(
          userName: widget.userName,
          userId: widget.userId,
          page: 1,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> _menuList = [
      HomePage(
        userName: widget.userName,
        userId: widget.userId,
      ),
      SchedulePage(
        userName: widget.userName,
        userId: widget.userId,
      ),
      AccountPage(
        userName: widget.userName,
        userId: widget.userId,
      ),
    ];

    return Scaffold(
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.white,
        elevation: 0.0,
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            title: Text('Home'),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.schedule),
            title: Text('Schedule'),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_pin),
            title: Text('Account'),
          ),
        ],
      ),
      body: Column(
        children: <Widget>[
          Expanded(
            child: _menuList[_currentIndex],
          ),
          Container(
            height: 0.1,
            color: Colors.black26,
          ),
        ],
      ),
    );
  }
}
