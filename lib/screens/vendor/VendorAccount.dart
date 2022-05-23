import 'dart:convert';

import 'package:aim_cab/screens/common/SplashScreen.dart';
import 'package:aim_cab/screens/common/Varibles.dart';
import 'package:aim_cab/screens/user/screens/UserPayment.dart';
import 'package:aim_cab/screens/user/model/DriverRegisterModal.dart';
import 'package:aim_cab/screens/user/model/Transporter.dart';
import 'package:aim_cab/screens/vendor/DriverHistory.dart';
import 'package:aim_cab/screens/vendor/VendorPayment.dart';
import 'package:aim_cab/screens/vendor/VendorProfileSetting.dart';
import 'package:aim_cab/utils/ScreenHelper.dart';
import 'package:aim_cab/utils/util.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:smooth_star_rating/smooth_star_rating.dart';

import '../common/UserDocument.dart';
import '../common/UserPassword.dart';
import 'VendorDashBoard.dart';

class VendorAccount extends StatefulWidget {
  @override
  _VendorAccountState createState() => _VendorAccountState();
}

class _VendorAccountState extends State<VendorAccount> {
  Driverdata _driver;

  @override
  initState() {
    getTransporter().then((value) => {
          setState(() {
            _driver = value;
            getwalltedeatisl();
          }),
        });

    super.initState();
  }

  Future<dynamic> getwalltedeatisl() async {
    var dio = Dio();
    var token = await getToken();

    print("user_id_ride:" + _driver.sId);
    String urlis = _driver.sId;

    var response = await dio.get(
      'http://api.cabandcargo.com/v1.0/user-data/' + urlis,
      options: Options(
        headers: {
          "Authorization": token // set content-length
        },
      ),
    );
    List userwalltedata = jsonDecode(response.toString())['data'];
    // print("res_wallete_data:"+userwalltedata.toString());

    setState(() {
      for (var i = 0; i < userwalltedata.length; i++) {
        Varibles.TRANSPORTER_WALLET_BALLANCE =
            userwalltedata[i]['wallet_amount'].toString();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    Size sizeScreen = MediaQuery.of(context).size;
    bool isLargePhone = Screen.diagonalInches(context) > 6;
    return Scaffold(
      body: Container(
        height: sizeScreen.height,
        child: Stack(
          children: [
            SvgPicture.asset(
              "assets/images/rectangle1.svg",
            ),
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
                              color: Theme.of(context).colorScheme.secondary),
                          child: IconButton(
                            icon: Icon(
                              Icons.menu,
                              color: Colors.white,
                            ),
                            onPressed: () {},
                          ),
                        ),
                      ),
                    ],
                  ),
                  Column(
                    // Important: Remove any padding from the ListView.

                    children: <Widget>[
                      Container(
                        margin: EdgeInsets.only(top: 20),
                        child: Stack(
                          children: [
                            Center(
                              child: Container(
                                child: Column(
                                  children: [
                                    Container(
                                        margin: EdgeInsets.symmetric(
                                            horizontal: 20),
                                        child: Neumorphic(
                                          child: Container(
                                            width: 200,
                                            padding: EdgeInsets.symmetric(
                                                vertical: 5, horizontal: 20),
                                            decoration: BoxDecoration(
                                                borderRadius: BorderRadius.all(
                                                    Radius.circular(25))),
                                            child: Column(
                                              children: [
                                                Container(
                                                    alignment: Alignment
                                                        .topLeft,
                                                    child: Text(
                                                        "Wallet balance",
                                                        style:
                                                            GoogleFonts.poppins(
                                                                fontSize: 12,
                                                                color: Theme.of(
                                                                        context)
                                                                    .accentColor,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold))),
                                                Container(
                                                  alignment: Alignment.topLeft,
                                                  child: Row(
                                                    mainAxisSize:
                                                        MainAxisSize.min,
                                                    children: [
                                                      Container(
                                                        margin:
                                                            EdgeInsets.all(5),
                                                        padding:
                                                            EdgeInsets.all(2),
                                                        color: Theme.of(context)
                                                            .accentColor,
                                                        child: Text(
                                                          "INR",
                                                          style: GoogleFonts
                                                              .poppins(
                                                                  color: Colors
                                                                      .white,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold),
                                                        ),
                                                      ),
                                                      Container(
                                                        margin:
                                                            EdgeInsets.all(5),
                                                        padding:
                                                            EdgeInsets.all(2),
                                                        child: Text(
                                                          "${Varibles.TRANSPORTER_WALLET_BALLANCE}",
                                                          style: GoogleFonts.poppins(
                                                              fontSize: 20,
                                                              color: Theme.of(
                                                                      context)
                                                                  .accentColor,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold),
                                                        ),
                                                      )
                                                    ],
                                                  ),
                                                )
                                              ],
                                            ),
                                          ),
                                        )),
                                    SizedBox(
                                      height: 10,
                                    ),
                                    Image.network(
                                      _driver != null ? _driver.userimage : "",
                                      width: 100,
                                      height: 100,
                                    ),
                                    SizedBox(
                                      height: 10,
                                    ),
                                    Text(
                                      _driver != null ? _driver.name : "",
                                      style: GoogleFonts.poppins(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 15,
                                          color: HexColor(textColor)),
                                    ),
                                    SizedBox(
                                      height: 1,
                                    ),
                                    Text(
                                      _driver != null ? _driver.email : "",
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
                          height: isLargePhone
                              ? sizeScreen.height * 0.50
                              : sizeScreen.height * 0.35,
                          child: Scrollbar(
                              isAlwaysShown: true,
                              child: SingleChildScrollView(
                                child: Column(
                                  children: [
                                    DrawerListTile("Profile Setting",
                                        "assets/images/profile_icon.svg", () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                VendorProfileSetting()),
                                      );
                                    }),
                                    DrawerListTile("Password",
                                        "assets/images/password_icon.svg", () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                UserPassword()),
                                      );
                                    }),
                                    DrawerListTile("Documents",
                                        "assets/images/document_icon.svg", () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                UserDocument()),
                                      );
                                    }),
                                    DrawerListTile("Payments",
                                        'assets/images/payments_icon.svg', () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                VendorPayment()),
                                      ).then((value) => getwalltedeatisl());
                                    }),
                                    DrawerListTile("Driver Detail",
                                        'assets/images/driver_icon.svg', () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                DriverHistory()),
                                      );
                                    }),
                                    DrawerListTile(
                                        "Customer Support",
                                        'assets/images/customer_support_icon.svg',
                                        () {}),
                                  ],
                                ),
                              ))),
                    ],
                  ),
                ],
              ),
            ),
            Container(
                margin: EdgeInsets.only(bottom: 20),
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
