import 'package:aim_cab/screens/common/custom_appbar.dart';
import 'package:aim_cab/utils/util.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:google_fonts/google_fonts.dart';
import 'UserCreatePassword.dart';

class PaymentFilter extends StatefulWidget {
  @override
  _PaymentFilterState createState() => _PaymentFilterState();
}

class _PaymentFilterState extends State<PaymentFilter> {
  double sliderValue = 0;
  String paidBy;
  @override
  Widget build(BuildContext context) {
    Size sizeScreen = MediaQuery.of(context).size;

    return Scaffold(
      appBar: PrimaryCustomAppbar(title: 'Filter'),
      body: Container(
        child: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              children: [
                // Container(
                //   margin:
                //       EdgeInsets.only(top: 10, left: 15, right: 15, bottom: 16),
                //   child: Stack(
                //     children: [
                //       Align(
                //         alignment: Alignment.topLeft,
                //         child: Container(
                //             child: Neumorphic(
                //                 child: IconButton(
                //           icon: Icon(
                //             Icons.arrow_back_ios,
                //             color: Theme.of(context).accentColor,
                //             size: 25,
                //           ),
                //           onPressed: () {
                //             Navigator.pop(context);
                //           },
                //         ))),
                //       ),
                //       Align(
                //         alignment: Alignment.center,
                //         child: Center(
                //           child: Text(
                //             "Filter",
                //             style: GoogleFonts.poppins(
                //                 fontSize: 25,
                //                 fontWeight: FontWeight.bold,
                //                 color: Theme.of(context).accentColor),
                //           ),
                //         ),
                //       )
                //     ],
                //   ),
                // ),

                Container(
                  margin: EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        alignment: Alignment.topRight,
                        // margin:
                        child: IconButton(
                          icon: Icon(
                            Icons.filter_alt_rounded,
                            color: Theme.of(context).primaryColor,
                            size: 28,
                          ),
                          onPressed: () {},
                        ),
                      ),
                      Text(
                        'Date',
                        style: GoogleFonts.poppins(
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      SizedBox(height: 8),
                      Container(
                        child: Neumorphic(
                          style: NeumorphicStyle(
                            depth: -7,
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(4.0),
                            child: TextFormField(
                              keyboardType: TextInputType.datetime,
                              decoration: InputDecoration(
                                // isDense: true,
                                border: InputBorder.none,
                                focusedBorder: InputBorder.none,
                                enabledBorder: InputBorder.none,
                                errorBorder: InputBorder.none,
                                prefixIcon: Icon(Icons.date_range),
                                hintText: "Enter Date",
                              ),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 24),
                      Text(
                        'Time',
                        style: GoogleFonts.poppins(
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      SizedBox(height: 8),
                      Container(
                        child: Neumorphic(
                          style: NeumorphicStyle(
                            depth: -7,
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(4.0),
                            child: TextFormField(
                              keyboardType: TextInputType.datetime,
                              decoration: InputDecoration(
                                border: InputBorder.none,
                                focusedBorder: InputBorder.none,
                                enabledBorder: InputBorder.none,
                                errorBorder: InputBorder.none,
                                prefixIcon: Icon(Icons.timer),
                                hintText: "Enter Time",
                              ),
                            ),
                          ),
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.symmetric(vertical: 10),
                        child: Column(
                          children: [
                            Container(
                                margin: EdgeInsets.symmetric(vertical: 5),
                                alignment: Alignment.topLeft,
                                child: Text("Distance",
                                    style: GoogleFonts.poppins(
                                        fontSize: 13,
                                        fontWeight: FontWeight.bold,
                                        color: HexColor(textColor)))),
                            Neumorphic(
                              style: NeumorphicStyle(
                                depth: -7,
                              ),
                              child: NeumorphicSlider(
                                min: 0,
                                max: 250,
                                value: sliderValue,
                                onChanged: (val) {
                                  setState(() {
                                    sliderValue = val;
                                  });
                                },
                              ),
                            ),
                            Container(
                                margin: EdgeInsets.symmetric(vertical: 5),
                                alignment: Alignment.topRight,
                                child: Text("${sliderValue.ceil()} KM",
                                    style: GoogleFonts.poppins(
                                        fontSize: 13,
                                        fontWeight: FontWeight.bold,
                                        color: HexColor(textColor)))),
                          ],
                        ),
                      ),
                      Container(
                        width: double.infinity,
                        child: Column(
                          children: [
                            Container(
                                margin: EdgeInsets.symmetric(vertical: 5),
                                alignment: Alignment.topLeft,
                                child: Text("Paid by",
                                    style: GoogleFonts.poppins(
                                        fontSize: 13,
                                        fontWeight: FontWeight.bold,
                                        color: HexColor(textColor)))),
                            Container(
                              width: double.infinity,
                              child: Neumorphic(
                                style: NeumorphicStyle(
                                  depth: -7,
                                ),
                                child: Container(
                                  margin: EdgeInsets.symmetric(
                                    horizontal: 10,
                                    vertical: 4,
                                  ),
                                  child: DropdownButtonFormField<String>(
                                    value: paidBy,
                                    elevation: 16,
                                    style: GoogleFonts.poppins(
                                        fontSize: 13,
                                        fontWeight: FontWeight.bold,
                                        color: HexColor(textColor)),
                                    // underline: Container(
                                    //   height: 0,
                                    // ),
                                    onChanged: (String newValue) {
                                      setState(() {
                                        paidBy = newValue;
                                      });
                                    },
                                    decoration: InputDecoration(
                                      border: InputBorder.none,
                                      hintText: 'Please select',
                                      hintStyle: GoogleFonts.raleway(
                                        fontSize: 13,
                                        fontWeight: FontWeight.w500,
                                        color: HexColor('#8B9EB0'),
                                      ),
                                    ),
                                    icon: Icon(
                                      Icons.keyboard_arrow_down_rounded,
                                      // size: 30,
                                    ),
                                    items: <String>['Cash', 'Card', 'MoMo']
                                        .map<DropdownMenuItem<String>>(
                                            (String value) {
                                      return DropdownMenuItem<String>(
                                        value: value,
                                        child: Text(
                                          value,
                                          style: GoogleFonts.poppins(
                                              fontSize: 13,
                                              fontWeight: FontWeight.bold,
                                              color: HexColor(textColor)),
                                        ),
                                      );
                                    }).toList(),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 100),
                      Container(
                        child: NeumorphicButton(
                          style: NeumorphicStyle(
                            boxShape: NeumorphicBoxShape.roundRect(
                              BorderRadius.circular(10),
                            ),
                          ),
                          child: Container(
                            padding: EdgeInsets.all(4),
                            child: Center(
                              child: Text(
                                "DONE",
                                style: GoogleFonts.poppins(
                                  color: HexColor("#8B9EB0"),
                                  fontSize: 18,
                                ),
                              ),
                            ),
                          ),
                          onPressed: () {},
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
