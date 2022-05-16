import 'package:aim_cab/screens/common/UserSelection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
        body: Container(
      height: size.height,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          SvgPicture.asset(
            "assets/images/rectangle1.svg",
            width: size.width,
          ),
          Image.asset(
            "assets/images/aimlogo.jpeg",
            height: 150,
            width: 150,
          ),
          Container(
            child: Stack(
              children: [
                SvgPicture.asset(
                  "assets/images/rectangle3.svg",
                  width: size.width,
                ),
                Align(
                  alignment: Alignment.bottomRight,
                  child: Container(
                    margin: EdgeInsets.only(top: 50, right: 20),
                    child: OutlinedButton(
                        style: TextButton.styleFrom(
                          primary: Colors.white,
                          side: BorderSide(color: Colors.white, width: 2),
                          padding: EdgeInsets.all(10),
                          shape: const RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(10.0)),
                          ),
                        ),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => UserSelection()),
                          );
                        },
                        child: Text("Get Started")),
                  ),
                )
              ],
            ),
          )
        ],
      ),
    ));
  }
}
