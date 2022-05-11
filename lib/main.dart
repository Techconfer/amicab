import 'dart:io';

import 'package:aim_cab/screens/common/SplashScreen.dart';
import 'package:aim_cab/screens/drivers/DriverDashBoard.dart';
import 'package:aim_cab/screens/user/screens/DashBoard.dart';
import 'package:aim_cab/screens/user/screens/UserLocationScreen.dart';
import 'package:aim_cab/screens/user/api/api_service.dart';
import 'package:aim_cab/screens/user/model/User.dart';
import 'package:aim_cab/screens/vendor/VendorDashBoard.dart';
import 'package:aim_cab/utils/util.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:location/location.dart';
import 'package:logging/logging.dart';
import 'package:provider/provider.dart';

var mainUser;
PermissionStatus permissionGranted;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  _setupLogging();
  mainUser = await getUserType();
  Location location = new Location();

  bool _serviceEnabled;

  LocationData _locationData;
  permissionGranted = await location.hasPermission();
  HttpOverrides.global = new MyHttpOverrides();

  runApp(MyApp());
}

void _setupLogging() {
  Logger.root.level = Level.ALL;
  Logger.root.onRecord.listen((record) {
    print('${record.level.name}: ${record.time}: ${record.message}');
  });
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return Provider(
      create: (_) => ApiService.create(),
      // Always call dispose on the ChopperClient to release resources
      dispose: (context, ApiService service) => service.client.dispose(),
      child: NeumorphicApp(
        debugShowCheckedModeBanner: false,
        title: 'AIM CAB',
        themeMode: ThemeMode.light,
        theme: NeumorphicThemeData(
          baseColor: Colors.white,
          lightSource: LightSource.topLeft,
          depth: 10,
          variantColor: HexColor("1B4670"),
          accentColor: HexColor("1B4670"),
        ),

//       theme: ThemeData(
//
//         // This is the theme of your application.
//         //
//         // Try running your application with "flutter run". You'll see the
//         // application has a blue toolbar. Then, without quitting the app, try
//         // changing the primarySwatch below to Colors.green and then invoke
//         // "hot reload" (press "r" in the console where you ran "flutter run",
//         // or simply save your changes to "hot reload" in a Flutter IDE).
//         // Notice that the counter didn't reset back to zero; the application
//         // is not restarted.
// primaryColor: HexColor("1B4670"),
//         primarySwatch: Colors.blue,
//       ),
        home: mainUser == null
            ? SplashScreen()
            : mainUser == "user"
                ? permissionGranted == PermissionStatus.granted
                    ? DashBoard()
                    : UserLocationScreen()
                : mainUser == "driver"
                    ? DriverDashBoard()
                    : VendorDashBoard(),
      ),
    );
  }
}

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }
}
