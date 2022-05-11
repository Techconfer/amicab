import 'package:aim_cab/screens/user/screens/DashBoard.dart';
import 'package:aim_cab/utils/util.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:location/location.dart';

class UserLocationScreen extends StatefulWidget {
  const UserLocationScreen({Key key}) : super(key: key);

  @override
  _UserLocationScreenState createState() => _UserLocationScreenState();
}


class _UserLocationScreenState extends State<UserLocationScreen> {
  @override
  void initState() {
    // TODO: implement initState
    askLocationPermission();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    var size= MediaQuery.of(context).size;
    return Scaffold(
        body:  Container(



          child: Container(
            margin: EdgeInsets.symmetric(horizontal: 30),
            child: Column(

              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SvgPicture.asset("assets/images/location_circle.svg"),
                Text("Set your location",style: GoogleFonts.poppins(fontWeight: FontWeight.bold,fontSize: 20,color:HexColor("#3E4958")),),
                Text("Enable location sharing so that your driver can see where you are",textAlign: TextAlign.center,
                    style: GoogleFonts.poppins(fontWeight: FontWeight.bold,fontSize: 15,color:HexColor("3E4958")))

              ],
            ),
          ),
        )
    );
  }

  Future<void> askLocationPermission() async {
    Location location = new Location();

    bool _serviceEnabled;
    PermissionStatus _permissionGranted;
    LocationData _locationData;
    _permissionGranted = await location.hasPermission();
    if (_permissionGranted == PermissionStatus.denied) {
      _permissionGranted = await location.requestPermission();
      if (_permissionGranted == PermissionStatus.granted) {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => DashBoard()),
        );
      }

    }
  }
}
