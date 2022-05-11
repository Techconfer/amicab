import 'package:aim_cab/screens/drivers/DriverLogin.dart';
import 'package:aim_cab/screens/user/screens/UserLogin.dart';
import 'package:aim_cab/screens/vendor/VendorLogin.dart';
import 'package:flutter/material.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';

class UserSelection extends StatefulWidget {
  @override
  _UserSelectionState createState() => _UserSelectionState();
}

class _UserSelectionState extends State<UserSelection> {
  double selected_user_angle = 0;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: Stack(
        children: [
          Positioned(
            left: 0,
            right: 0,
            top: -10,
            child: SvgPicture.asset(
              "assets/images/rectangle1.svg",
              width: size.width,
            ),
          ),
          Align(
              alignment: Alignment.topCenter,
              child: Column(
                children: [
                  Container(
                      margin: EdgeInsets.only(top: 60),
                      child: Text(
                        "Selection",
                        style: GoogleFonts.poppins(
                            fontSize: 25,
                            color: Colors.white,
                            fontWeight: FontWeight.bold),
                      )),
                  Container(
                      margin: EdgeInsets.only(top: 20),
                      child: Text(
                        "You are",
                        style: GoogleFonts.poppins(
                            fontSize: 18,
                            color: Colors.white,
                            fontWeight: FontWeight.normal),
                      )),
                ],
              )),
          SafeArea(
              child: Container(
                  height: size.height,
                  child: SingleChildScrollView(
                      physics: BouncingScrollPhysics(),
                      child: Column(children: <Widget>[
                        Container(
                          margin: EdgeInsets.only(left: 10),
                          child: Container(
                              margin: EdgeInsets.all(15),
                              child: Neumorphic(
                                  style: NeumorphicStyle(
                                      boxShape: NeumorphicBoxShape.roundRect(
                                          BorderRadius.circular(15)),
                                      color: Theme.of(context).accentColor),
                                  child: IconButton(
                                    onPressed: () {
                                      Navigator.pop(context);
                                    },
                                    icon: Icon(
                                      Icons.arrow_back_ios,
                                      color: Colors.white,
                                    ),
                                  ))),
                        ),
                      ])))),
          Align(
            alignment: Alignment.bottomCenter,
            child: Stack(
              alignment: Alignment.bottomCenter,
              children: [
                Container(
                    child: SvgPicture.asset(
                  "assets/images/Selection.svg",
                  width: size.width,
                )),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: Container(
                    alignment: Alignment.bottomCenter,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          alignment: Alignment.center,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              Container(
                                margin: EdgeInsets.only(top: 100),
                                height: 120,
                                width: 120,
                                child: Transform.rotate(
                                  angle: 320,
                                  child: InkWell(
                                    onTap: () {
                                      setState(() {
                                        selected_user_angle = 320;
                                      });
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                DriverLogin()),
                                      );
                                    },
                                    child: Container(
                                      color: Colors.transparent,
                                      child: Column(
                                        children: [
                                          Container(
                                              child: SvgPicture.asset(
                                            "assets/images/car_icon.svg",
                                            height: 40,
                                            width: 40,
                                          )),
                                          Text(
                                            "Driver",
                                            style: GoogleFonts.poppins(
                                                fontSize: 18),
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              Container(
                                margin: EdgeInsets.only(top: 0),
                                height: 120,
                                width: 120,
                                child: Transform.rotate(
                                  angle: 0,
                                  child: InkWell(
                                    onTap: () {
                                      setState(() {
                                        selected_user_angle = 0;
                                      });
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => UserLogin()),
                                      );
                                    },
                                    child: Container(
                                      child: Column(
                                        children: [
                                          Container(
                                              child: SvgPicture.asset(
                                            "assets/images/user_icon.svg",
                                            height: 40,
                                            width: 40,
                                          )),
                                          Text(
                                            "Select User",
                                            style: GoogleFonts.poppins(
                                                fontSize: 18),
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              Container(
                                height: 120,
                                width: 120,
                                margin: EdgeInsets.only(top: 100),
                                child: Transform.rotate(
                                  angle: 120,
                                  child: InkWell(
                                    onTap: () {
                                      setState(() {
                                        selected_user_angle = 120;
                                      });
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                VendorLogin()),
                                      );
                                    },
                                    child: Container(
                                      child: Column(
                                        children: [
                                          Container(
                                              child: SvgPicture.asset(
                                            "assets/images/vendor_icon.svg",
                                            height: 50,
                                            width: 50,
                                          )),
                                          Text(
                                            "Transporter",
                                            style: GoogleFonts.poppins(
                                                fontSize: 18),
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                        Transform.rotate(
                          angle: selected_user_angle,
                          child: Container(
                              margin: EdgeInsets.only(top: 10),
                              alignment: Alignment.center,
                              child: SvgPicture.asset(
                                  "assets/images/selection_tick.svg")),
                        )
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
