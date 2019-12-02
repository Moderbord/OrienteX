import 'package:flutter/material.dart';
import 'package:orientx/map_view.dart';

import 'package:flutter_background_geolocation/flutter_background_geolocation.dart' as bg;

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {

    bg.BackgroundGeolocation.ready(bg.Config(
        desiredAccuracy: bg.Config.DESIRED_ACCURACY_HIGH,
        distanceFilter: 10.0,
        stopOnTerminate: false,
        startOnBoot: true,
        debug: true,
        logLevel: bg.Config.LOG_LEVEL_VERBOSE
    )).then((bg.State state) {
      if (!state.enabled) {
        bg.BackgroundGeolocation.start();
      }
    });

    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
          primarySwatch: Colors.blue),
      home: Scaffold(
        appBar: AppBar(
          title: Text("OrientX"),
        ),
        body: MapView(),
      ),
    );
  }
}
