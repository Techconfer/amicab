import 'package:flutter/material.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:smooth_star_rating/smooth_star_rating.dart';

import '../../../utils/util.dart';
import '../../common/SplashScreen.dart';
import '../../user/model/DriverRegisterModal.dart';
import '../../user/screens/userTerms.dart';
import '../CarList.dart';
import '../VendorAccount.dart';
import 'drawerlistTile.dart';

class VendorDashDrawer extends StatelessWidget {
  const VendorDashDrawer({
    Key key,
    @required Driverdata transporter,
  }) : _transporter = transporter, super(key: key);

  final Driverdata _transporter;

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: SafeArea(
        child: ListView(
          // Important: Remove any padding from the ListView.
          padding: EdgeInsets.zero,
          children: <Widget>[
            Container(
              margin: EdgeInsets.only(top: 50),
              child: Stack(
                children: [
                  Align(
                    alignment: Alignment.topRight,
                    child: Container(
                      margin: EdgeInsets.only(right: 20),
                      child: Neumorphic(
                        child: IconButton(
                            icon: Icon(Icons.arrow_back_ios),
                            onPressed: () {
                              Navigator.pop(context);
                            }),
                      ),
                    ),
                  ),
                  Center(
                    child: Column(
                      children: [
                        Image.network(
                          _transporter != null ? _transporter.userimage : "",
                          width: 100,
                          height: 100,
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Text(
                          _transporter != null ? _transporter.name : "",
                          style: GoogleFonts.poppins(
                              fontWeight: FontWeight.bold,
                              fontSize: 15,
                              color: HexColor(textColor)),
                        ),
                        SizedBox(
                          height: 3,
                        ),
                        SmoothStarRating(
                          starCount: 5,
                          isReadOnly: true,
                          color: Theme.of(context).accentColor,
                          rating: 4.5,
                        )
                      ],
                    ),
                  )
                ],
              ),
            ),
            DrawerListTile("Home", "assets/images/home_icon.svg", () {
              Navigator.pop(context);
            }),
            DrawerListTile("Rides", "assets/images/car_icon.svg", () {}),
            DrawerListTile("Car", "assets/images/car_icon.svg", () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => CarList()),
              );
            }),
            DrawerListTile("Account", "assets/images/account.svg", () {
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => VendorAccount()),
              );
            }),
            DrawerListTile("Support", "assets/images/support_icon.svg", () {
              Navigator.pop(context);
            }),
            DrawerListTile("About", 'assets/images/about_icon.svg', () {
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => UserTerms("About")),
              );
            }),
            DrawerListTile(
                "Terms & Condition", 'assets/images/terms_icon.svg', () {
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => UserTerms("Terms & Conditions")),
              );
            }),
            DrawerListTile(
                "Privacy Policy", 'assets/images/privacy_policy_icon.svg',
                    () {
                  Navigator.pop(context);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => UserTerms("Privacy Policy")),
                  );
                }),
            DrawerListTile("Logout", 'assets/images/sign_out_icon.svg',
                    () async {
                  await logoutUser();
                  Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(builder: (context) => SplashScreen()),
                          (Route<dynamic> route) => false);
                }),
          ],
        ),
      ),
    );
  }
}