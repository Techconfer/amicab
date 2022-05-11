import 'package:aim_cab/utils/ScreenHelper.dart';
import 'package:flutter/material.dart';

import 'dart:ui';

import 'package:aim_cab/screens/common/custom_appbar.dart';
import 'package:aim_cab/utils/util.dart';

class AccidentTellMoreScreen extends StatelessWidget {
  const AccidentTellMoreScreen({Key key}) : super(key: key);

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
                'I was involved in an accident',
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
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'DATE',
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w700,
                            color: HexColor('#3E4958'),
                          ),
                        ),
                        SizedBox(height: 7),
                        TextField(
                          decoration: InputDecoration(
                            filled: true,
                            fillColor: HexColor('#F7F8F9'),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(15),
                              borderSide: BorderSide(
                                color: HexColor('#D5DDE0'),
                                width: 0.5,
                              ),
                            ),
                            contentPadding: EdgeInsets.zero,
                            errorBorder: InputBorder.none,
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(15),
                              borderSide: BorderSide(
                                color: HexColor('#D5DDE0'),
                                width: 0.5,
                              ),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(15),
                              borderSide: BorderSide(
                                color: HexColor('#D5DDE0'),
                                width: 0.5,
                              ),
                            ),
                            disabledBorder: InputBorder.none,
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'TIME',
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w700,
                            color: HexColor('#3E4958'),
                          ),
                        ),
                        SizedBox(height: 7),
                        TextField(
                          decoration: InputDecoration(
                            filled: true,
                            fillColor: HexColor('#F7F8F9'),
                            contentPadding: EdgeInsets.zero,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(15),
                              borderSide: BorderSide(
                                color: HexColor('#D5DDE0'),
                              ),
                            ),
                            errorBorder: InputBorder.none,
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(15),
                              borderSide: BorderSide(
                                color: HexColor('#D5DDE0'),
                                width: 0.5,
                              ),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(15),
                              borderSide: BorderSide(
                                color: HexColor('#D5DDE0'),
                                width: 0.5,
                              ),
                            ),
                            disabledBorder: InputBorder.none,
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              ),
              SizedBox(height: 17),
              Text(
                'PLACE',
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                  color: HexColor('#3E4958'),
                ),
              ),
              SizedBox(height: 7),
              TextField(
                decoration: InputDecoration(
                  contentPadding: EdgeInsets.zero,
                  filled: true,
                  fillColor: HexColor('#F7F8F9'),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                    borderSide: BorderSide(
                      color: HexColor('#D5DDE0'),
                    ),
                  ),
                  errorBorder: InputBorder.none,
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                    borderSide: BorderSide(
                      color: HexColor('#D5DDE0'),
                      width: 0.5,
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                    borderSide: BorderSide(
                      color: HexColor('#D5DDE0'),
                      width: 0.5,
                    ),
                  ),
                  disabledBorder: InputBorder.none,
                ),
              ),
              SizedBox(height: 38),
              Text(
                'HAVE YOU BEEN HURT?',
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                  color: HexColor('#3E4958'),
                ),
              ),
              Row(
                children: [
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Checkbox(
                        value: true,
                        onChanged: (value) {},
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(180),
                        ),
                      ),
                      Text(
                        'Yes',
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w400,
                          color: HexColor('#3E4958'),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    width: Screen.width(context) * 0.3,
                  ),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Checkbox(
                        value: false,
                        onChanged: (value) {},
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(180),
                        ),
                      ),
                      Text(
                        'No',
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w400,
                          color: HexColor('#3E4958'),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              SizedBox(height: 20),
              Text(
                'HAVE THE ACCIDENT OCCURED?',
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                  color: HexColor('#3E4958'),
                ),
              ),
              SizedBox(height: 8),
              TextField(
                decoration: InputDecoration(
                  contentPadding: EdgeInsets.zero,
                  filled: true,
                  fillColor: HexColor('#F7F8F9'),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                    borderSide: BorderSide(
                      color: HexColor('#D5DDE0'),
                    ),
                  ),
                  errorBorder: InputBorder.none,
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                    borderSide: BorderSide(
                      color: HexColor('#D5DDE0'),
                      width: 0.5,
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                    borderSide: BorderSide(
                      color: HexColor('#D5DDE0'),
                      width: 0.5,
                    ),
                  ),
                  disabledBorder: InputBorder.none,
                ),
              ),
              SizedBox(height: 20),
              Container(
                width: Screen.width(context),
                height: Screen.height(context) * 0.2,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  color: HexColor('#F7F8F9'),
                  border: Border.all(
                    color: HexColor('#D5DDE0'),
                  ),
                ),
                child: Center(
                  child: Icon(
                    Icons.camera_alt,
                    color: HexColor('#D5DDE0'),
                    size: 40,
                  ),
                ),
              ),
              SizedBox(height: 70),
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
                  onPressed: () {},
                ),
              ),
              SizedBox(height: 70),
            ],
          ),
        ),
      ),
    );
  }
}
