import 'package:flutter/material.dart';
import 'package:orientx/simon_directory/sign_in.dart';
import 'package:orientx/fredrik_directory/destination.dart';
import 'profile_page.dart';
import 'package:orientx/fredrik_directory/track_page.dart';
import 'settings_page.dart';
import 'sign_in.dart';

class FirstScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _FirstScreenState();
  }
}

class _FirstScreenState extends State<FirstScreen>
    with TickerProviderStateMixin {

  List<Destination> _destinations;
  List<AnimationController> _faders;
  List<Key> _destinationKeys;
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();

    _destinations = <Destination>[
      Destination(0, 'Hem', Icons.home, ProfilePage()),
      Destination(1, 'Lopp', Icons.flag, TrackPage()),
      Destination(2, 'Stationer', Icons.camera, SettingsPage()),
    ];

    _faders = _destinations.map<AnimationController>((Destination destination) {
      return AnimationController(
          vsync: this, duration: Duration(milliseconds: 250));
    }).toList();
    _faders[_currentIndex].value = 1.0;
    _destinationKeys =
        List<Key>.generate(_destinations.length, (int index) => GlobalKey())
            .toList();
  }

  @override
  void dispose() {
    for (AnimationController controller in _faders) controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("ThinQRight"),
      ),
      body: WillPopScope(
          onWillPop: () async {
            return Future.value(false);
          },
          child: Stack(
            fit: StackFit.expand,
            children: _destinations.map((Destination destination) {
              final Widget view = FadeTransition(
                opacity: _faders[destination.index]
                    .drive(CurveTween(curve: Curves.fastOutSlowIn)),
                child: KeyedSubtree(
                    key: _destinationKeys[destination.index],
                    child: destination.screen),
              );
              if (destination.index == _currentIndex) {
                _faders[destination.index].forward();
                return view;
              } else {
                _faders[destination.index].reverse();
                if (_faders[destination.index].isAnimating) {
                  return IgnorePointer(child: view);
                }
                return Offstage(child: view);
              }
            }).toList(),
          )),
      bottomNavigationBar: BottomNavigationBar(
          currentIndex: _currentIndex,
          onTap: (int index) {
            setState(() {
              _currentIndex = index;
            });
          },
          items: _destinations.map((Destination destination) {
            return BottomNavigationBarItem(
              icon: Icon(destination.icon),
              title: Text(destination.title),
            );
          }).toList()),
      drawer: _drawerList(context),
    );
  }

  void signOut() {
    signOutGoogle();
    Navigator.pushNamed(context, "/");
  }

  Drawer _drawerList(BuildContext context) {
    return Drawer(
      child: SafeArea(
        top: true,
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            Container(
              height: 50,
              width: 100,
              child: Center(
                  child: Text(
                "Menu",
                style: TextStyle(fontSize: 16),
              )),
            ),
            _createDrawerItem(
                icon: Icons.arrow_forward,
                text: "Logga ut",
                onTap: () => signOut()),
          ],
        ),
      ),
    );
  }

  Widget _createDrawerItem(
      {IconData icon, String text, GestureTapCallback onTap}) {
    return ListTile(
      title: Row(
        children: <Widget>[
          Icon(icon),
          Padding(padding: EdgeInsets.only(left: 8.0), child: Text(text))
        ],
      ),
      onTap: () {
        onTap();
      },
    );
  }
}
