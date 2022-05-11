import 'package:aim_cab/screens/common/SplashScreen.dart';
import 'package:aim_cab/screens/common/UserDocument.dart';
import 'package:aim_cab/screens/common/UserPassword.dart';
import 'package:aim_cab/screens/user/screens/UserPayment.dart';
import 'package:aim_cab/screens/user/model/User.dart';
import 'package:aim_cab/screens/user/screens/support/support_screen.dart';
import 'package:aim_cab/utils/util.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'ProfileSetting.dart';
import 'package:smooth_star_rating/smooth_star_rating.dart';

import 'DashBoard.dart';
import 'chatescrren.dart';

class UserAccount extends StatefulWidget {
  @override
  _UserAccountState createState() => _UserAccountState();
}

class _UserAccountState extends State<UserAccount> {
  User _user;

  @override
  initState() {
    getUser().then((value) => {
          setState(() {
            _user = value;
          }),
        });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size sizeScreen = MediaQuery.of(context).size;

    return Scaffold(
      body: Container(
        height: sizeScreen.height,
        child: Stack(
          children: [
            Positioned(
                top: 0,
                child: SvgPicture.asset(
                  "assets/images/rectangle1.svg",
                )),
            Container(
              alignment: Alignment.topLeft,
              margin: EdgeInsets.only(top: 50, left: 100),
              child: Text(
                "Account",
                style: GoogleFonts.poppins(
                    color: Colors.white,
                    fontSize: 25,
                    fontWeight: FontWeight.bold),
              ),
            ),
            SafeArea(
              child: Column(
                children: [
                  Row(
                    children: [
                      Container(
                        margin: EdgeInsets.all(15),
                        child: Neumorphic(
                          style: NeumorphicStyle(
                            color: Theme.of(context).colorScheme.secondary,
                          ),
                          child: IconButton(
                            icon: Icon(
                              Icons.menu,
                              color: Colors.white,
                            ),
                            onPressed: null,
                          ),
                        ),
                      ),
                    ],
                  ),
                  Column(
                    // Important: Remove any padding from the ListView.

                    children: <Widget>[
                      Container(
                        margin: EdgeInsets.only(top: 100),
                        child: Stack(
                          children: [
                            Center(
                              child: Container(
                                child: Column(
                                  children: [
                                    Image.network(
                                      _user != null ? _user.userimage : "",
                                      width: 100,
                                      height: 100,
                                    ),
                                    SizedBox(
                                      height: 40,
                                    ),
                                    Text(
                                      _user != null ? _user.name : "",
                                      style: GoogleFonts.poppins(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 15,
                                          color: HexColor(textColor)),
                                    ),
                                    SizedBox(
                                      height: 1,
                                    ),
                                    Text(
                                      _user != null ? _user.email : "",
                                      style: GoogleFonts.poppins(
                                          fontWeight: FontWeight.normal,
                                          fontSize: 12,
                                          color: HexColor(textColor)),
                                    ),
                                  ],
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(left: 20),
                        child: Column(
                          children: [
                            DrawerListTile("Profile Setting",
                                "assets/images/profile_icon.svg", () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => ProfileSetting()),
                              );
                            }),
                            DrawerListTile(
                                "Password", "assets/images/password_icon.svg",
                                () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => UserPassword()),
                              );
                            }),
                            DrawerListTile(
                                "Documents", "assets/images/document_icon.svg",
                                () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => UserDocument()),
                              );
                            }),
                            DrawerListTile(
                                "Payments", 'assets/images/payments_icon.svg',
                                () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => UserPayment()),
                              );
                            }),
                            DrawerListTile(
                              "Customer Support",
                              'assets/images/customer_support_icon.svg',
                              () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => SupportScreen()),
                                );
                              },
                            ),
                            DrawerListTile("Chat",
                                'assets/images/customer_support_icon.svg', () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => ChatPage()),
                              );
                            }),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Container(
                margin: EdgeInsets.only(top: 50),
                alignment: Alignment.bottomCenter,
                child: TextButton(
                    onPressed: () async {
                      await logoutUser();
                      Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(
                              builder: (context) => SplashScreen()),
                          (Route<dynamic> route) => false);
                    },
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.logout,
                          color: Theme.of(context).accentColor,
                        ),
                        Text(
                          "Sign out",
                          style: GoogleFonts.poppins(
                              color: Theme.of(context).accentColor,
                              fontSize: 18),
                        ),
                      ],
                    )))
          ],
        ),
      ),
    );
  }
}
