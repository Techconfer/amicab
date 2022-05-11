import 'dart:ui';

import 'package:aim_cab/screens/common/custom_appbar.dart';
import 'package:aim_cab/screens/user/screens/support/accident_tell_more_screen.dart';
import 'package:aim_cab/utils/util.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class LeftItemTellMoreScreen extends StatelessWidget {
  const LeftItemTellMoreScreen({Key key}) : super(key: key);

  final leftAnItemStr =
      '''If you've lost an item you will need to send us an message immediately, please remembering to provide us with as many details as possible about your lost item and the ride you took. If we find it we’ll connect you with the driver directly to get it back.''';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CustomAppbar(
        title: 'Tell More',
      ),
      body: Container(
        padding: EdgeInsets.only(top: 19, left: 20, right: 20),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'I left an item',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                  color: HexColor('#3E4958'),
                ),
              ),
              SizedBox(height: 18),
              Text(
                leftAnItemStr,
                style: TextStyle(
                  fontSize: 15,
                  height: 1.3,
                  fontWeight: FontWeight.w400,
                  color: HexColor('#3E4958'),
                  letterSpacing: 0.7,
                  wordSpacing: 0.1,
                ),
              ),
              SizedBox(height: 50),
              Text(
                'TELL US',
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                  color: HexColor('#3E4958'),
                ),
              ),
              SizedBox(height: 8),
              TextField(
                maxLines: 12,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: HexColor('#F7F8F9'),
                  hintText: 'Your message here...',
                  hintStyle: TextStyle(
                    color: HexColor('#97ADB6'),
                    fontSize: 15,
                    fontWeight: FontWeight.w400,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(
                      color: HexColor('#D5DDE0'),
                    ),
                  ),
                  errorBorder: InputBorder.none,
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(
                      color: HexColor('#D5DDE0'),
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(
                      color: HexColor('#D5DDE0'),
                    ),
                  ),
                  disabledBorder: InputBorder.none,
                ),
              ),
              SizedBox(height: 90),
              Container(
                alignment: Alignment.center,
                child: TextButton(
                  style: TextButton.styleFrom(
                    padding: EdgeInsets.symmetric(vertical: 15, horizontal: 30),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12), // <-- Radius
                    ),
                    // color: Theme.of(context).accentColor,
                    backgroundColor: Theme.of(context).colorScheme.secondary,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Submit",
                        style: TextStyle(
                          fontWeight: FontWeight.w700,
                          fontSize: 17,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => AccidentTellMoreScreen(),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
