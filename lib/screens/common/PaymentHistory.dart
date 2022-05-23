import 'dart:convert';

import 'package:aim_cab/utils/ScreenHelper.dart';
import 'package:aim_cab/utils/util.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

import 'PaymentFilter.dart';
import 'Varibles.dart';

class PaymentHistory extends StatefulWidget {
  String sId;

  PaymentHistory({String this.sId});

  @override
  _PaymentHistoryState createState() => _PaymentHistoryState();
}

class _PaymentHistoryState extends State<PaymentHistory> {
  List<String> Ammount = [];
  List<String> createdAt = [];
  List<String> statement = [];
  List<String> location = [];
  String driverWalletBalance = "";
 
  bool isExpanded = false;
  int selIndex;

  @override
  void initState() {
    getwalltedeatisl();
    fetchBalance();
    super.initState();
  }

  Future<dynamic> getwalltedeatisl() async {
    var dio = Dio();

    // var user=await getUser();
    var token = await getToken();
    var response = await dio.get(
      'http://api.cabandcargo.com/v1.0/get-wallet-details?user_id=' +
          widget.sId +
          '&offset=0',
      options: Options(
        headers: {
          "Authorization": token // set content-length
        },
      ),
    );
    List userwalltedata = jsonDecode(response.toString())['data'];

    setState(() {
      for (var i = 0; i < userwalltedata.length; i++) {
        Ammount.add(userwalltedata[i]['credit_amount'].toString());
        createdAt.add(userwalltedata[i]['createdAt'].toString());
        statement.add(userwalltedata[i]['statement'].toString());
        location.add(userwalltedata[i]['location'].toString());
      }
    });
  }

  Future<dynamic> fetchBalance() async {
    var dio = Dio();
    var token = await getToken();

    print("user_id_ride:" + widget.sId);
    String urlis = widget.sId;

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
        Varibles.DRIVER_WALLET_BALLANCE =
            userwalltedata[i]['wallet_amount'].toString();
        driverWalletBalance = userwalltedata[i]['wallet_amount'].toString();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    Size sizeScreen = MediaQuery.of(context).size;
    return Scaffold(
      body: Container(
        child: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  margin:
                      EdgeInsets.only(top: 10, left: 15, right: 15, bottom: 50),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                          child: Neumorphic(
                              child: IconButton(
                        icon: Icon(
                          Icons.arrow_back_ios,
                          color: Theme.of(context).accentColor,
                          size: 25,
                        ),
                        onPressed: () {
                          Navigator.pop(context);
                        },
                      ))),
                      Expanded(
                          child: Center(
                              child: Text(
                        "Payment History",
                        style: GoogleFonts.poppins(
                            fontSize: 25,
                            fontWeight: FontWeight.bold,
                            color: Theme.of(context).accentColor),
                      )))
                    ],
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Container(),
                    Neumorphic(
                      style: NeumorphicStyle(
                        depth: -7,
                        shape: NeumorphicShape.convex,
                        boxShape: NeumorphicBoxShape.roundRect(
                          BorderRadius.circular(180),
                        ),
                        lightSource: LightSource.topLeft,
                        intensity: 20,
                        shadowDarkColor:
                            Theme.of(context).colorScheme.secondary,
                        shadowDarkColorEmboss: Theme.of(context)
                            .colorScheme
                            .secondary
                            .withAlpha(1)
                            .withOpacity(0.5),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.only(
                          left: 16,
                          right: 16,
                          top: 7,
                        ),
                        child: Container(
                          width: 200,
                          padding:
                              EdgeInsets.symmetric(vertical: 5, horizontal: 20),
                          child: Column(
                            children: [
                              Container(
                                alignment: Alignment.topLeft,
                                child: Text(
                                  "Wallet balance",
                                  style: GoogleFonts.poppins(
                                      fontSize: 12,
                                      color: Theme.of(context)
                                          .colorScheme
                                          .secondary,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                              Container(
                                alignment: Alignment.topLeft,
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Container(
                                      padding: EdgeInsets.symmetric(
                                        horizontal: 10,
                                        vertical: 3,
                                      ),
                                      color: Theme.of(context)
                                          .colorScheme
                                          .secondary,
                                      child: Text(
                                        "INR",
                                        style: GoogleFonts.poppins(
                                          fontSize: 11,
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                    Container(
                                      margin: EdgeInsets.all(5),
                                      padding: EdgeInsets.all(2),
                                      child: Text(
                                        driverWalletBalance,
                                        style: GoogleFonts.poppins(
                                            fontSize: 20,
                                            color: Theme.of(context)
                                                .colorScheme
                                                .secondary,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    )
                                  ],
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                    IconButton(
                        icon: Icon(
                          Icons.filter_alt_rounded,
                          color: Theme.of(context).colorScheme.secondary,
                        ),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => PaymentFilter()),
                          );
                        })
                  ],
                ),
                SizedBox(height: 20),
                Container(
                  padding: EdgeInsets.all(10),
                  child: Row(
                    children: [
                      Container(
                        width: Screen.width(context) / 4 - 10,
                        // color: Colors.red,
                        child: Center(
                          child: Text(
                            "Date & Time",
                            style: GoogleFonts.poppins(
                                fontSize: 12,
                                fontWeight: FontWeight.normal,
                                color: Theme.of(context).primaryColor),
                          ),
                        ),
                      ),
                      Container(
                        width: Screen.width(context) / 4,
                        // color: Colors.blue,
                        child: Center(
                          child: Text(
                            "Location",
                            style: GoogleFonts.poppins(
                                fontSize: 12,
                                fontWeight: FontWeight.normal,
                                color: Theme.of(context).primaryColor),
                          ),
                        ),
                      ),
                      Container(
                        width: Screen.width(context) / 4,
                        // color: Colors.yellow,
                        child: Center(
                          child: Text(
                            " Paid by",
                            style: GoogleFonts.poppins(
                                fontSize: 12,
                                fontWeight: FontWeight.normal,
                                color: Theme.of(context).primaryColor),
                          ),
                        ),
                      ),
                      Container(
                        width: Screen.width(context) / 4 - 10,
                        // color: Colors.red,
                        child: Center(
                          child: Text(
                            "Amount",
                            style: GoogleFonts.poppins(
                                fontSize: 12,
                                fontWeight: FontWeight.normal,
                                color: Theme.of(context).primaryColor),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  height: sizeScreen.height - 275,
                  child: ListView.builder(
                      scrollDirection: Axis.vertical,
                      itemCount: Ammount.length,
                      itemBuilder: (context, index) {
                        return InkWell(
                          onTap: () {
                            setState(() {
                              if (!isExpanded) {
                                selIndex = index;
                                isExpanded = true;
                              } else {
                                selIndex = null;
                                isExpanded = false;
                              }
                            });
                          },
                          child: AnimatedContainer(
                            duration: Duration(milliseconds: 350),
                            height: isExpanded && selIndex == index
                                ? 200
                                : Screen.height(context) * 0.065,
                            padding: EdgeInsets.symmetric(
                                horizontal: 10, vertical: 10),
                            margin: EdgeInsets.symmetric(
                                vertical: 10, horizontal: 10),
                            decoration: BoxDecoration(
                              color: isExpanded && selIndex == index
                                  ? Theme.of(context).primaryColor
                                  : Colors.white,
                              borderRadius: BorderRadius.all(
                                Radius.circular(10),
                              ),
                              border: Border.all(
                                color: HexColor('#E6E6E6'),
                              ),
                            ),
                            child: isExpanded && selIndex == index
                                ? FutureBuilder<bool>(
                                    future: Future.delayed(
                                        Duration(milliseconds: 250), () {
                                      return true;
                                    }),
                                    builder: (context, snapshot) {
                                      if (!snapshot.hasData) {
                                        return Container();
                                      }
                                      return Container(
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 16, vertical: 16),
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Column(
                                                  mainAxisSize:
                                                      MainAxisSize.min,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      "Date & Time",
                                                      style:
                                                          GoogleFonts.poppins(
                                                        fontSize: 12,
                                                        fontWeight:
                                                            FontWeight.w600,
                                                        color: Colors.white,
                                                      ),
                                                    ),
                                                    SizedBox(height: 8),
                                                    Text(
                                                      DateFormat.yMMMd().format(
                                                        DateTime.parse(
                                                          createdAt[index],
                                                        ).toLocal(),
                                                      ),
                                                      style:
                                                          GoogleFonts.poppins(
                                                              fontSize: 12,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .normal,
                                                              color:
                                                                  Colors.white),
                                                    ),
                                                    Text(
                                                      DateFormat.jm().format(
                                                        DateTime.parse(
                                                          createdAt[index],
                                                        ).toLocal(),
                                                      ),
                                                      style:
                                                          GoogleFonts.poppins(
                                                        fontSize: 7,
                                                        fontWeight:
                                                            FontWeight.normal,
                                                        color: Colors.white,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                Column(
                                                  mainAxisSize:
                                                      MainAxisSize.min,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      "Amount",
                                                      style:
                                                          GoogleFonts.poppins(
                                                        fontSize: 10,
                                                        fontWeight:
                                                            FontWeight.w600,
                                                        color: Colors.white,
                                                      ),
                                                    ),
                                                    SizedBox(height: 6),
                                                    Text(
                                                      '\$ ${Ammount[index]}',
                                                      style:
                                                          GoogleFonts.poppins(
                                                        fontSize: 16,
                                                        fontWeight:
                                                            FontWeight.w600,
                                                        color: Colors.white,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            ),
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Column(
                                                  mainAxisSize:
                                                      MainAxisSize.min,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      "Location",
                                                      style:
                                                          GoogleFonts.poppins(
                                                        fontSize: 12.18,
                                                        fontWeight:
                                                            FontWeight.w600,
                                                        color: Colors.white,
                                                      ),
                                                    ),
                                                    SizedBox(height: 4),
                                                    Text(
                                                      'Ikeja island - abroad',
                                                      style:
                                                          GoogleFonts.poppins(
                                                        fontSize: 10,
                                                        fontWeight:
                                                            FontWeight.w600,
                                                        color: Colors.white,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                Column(
                                                  mainAxisSize:
                                                      MainAxisSize.min,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      "Paid By",
                                                      style:
                                                          GoogleFonts.poppins(
                                                        fontSize: 12.18,
                                                        fontWeight:
                                                            FontWeight.w600,
                                                        color: Colors.white,
                                                      ),
                                                    ),
                                                    SizedBox(height: 4),
                                                    Text(
                                                      'Card',
                                                      style:
                                                          GoogleFonts.poppins(
                                                        fontSize: 10,
                                                        fontWeight:
                                                            FontWeight.w600,
                                                        color: Colors.white,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                Column(
                                                  mainAxisSize:
                                                      MainAxisSize.min,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      "Transfer",
                                                      style:
                                                          GoogleFonts.poppins(
                                                        fontSize: 12.18,
                                                        fontWeight:
                                                            FontWeight.w600,
                                                        color: Colors.white,
                                                      ),
                                                    ),
                                                    SizedBox(height: 4),
                                                    Text(
                                                      'Wallet',
                                                      style:
                                                          GoogleFonts.poppins(
                                                        fontSize: 10,
                                                        fontWeight:
                                                            FontWeight.w600,
                                                        color: Colors.white,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      );
                                    })
                                : Row(
                                    // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                    children: [
                                      Container(
                                        width: Screen.width(context) / 4 - 20,
                                        // color: Colors.red,
                                        child: Center(
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                DateFormat.yMMMd().format(
                                                  DateTime.parse(
                                                    createdAt[index],
                                                  ).toLocal(),
                                                ),
                                                style: GoogleFonts.poppins(
                                                  fontSize: 12,
                                                  fontWeight: FontWeight.w600,
                                                  color: isExpanded &&
                                                          index == selIndex
                                                      ? Colors.white
                                                      : Colors.black,
                                                ),
                                              ),
                                              Text(
                                                DateFormat.jm().format(
                                                  DateTime.parse(
                                                    createdAt[index],
                                                  ).toLocal(),
                                                ),
                                                style: GoogleFonts.poppins(
                                                  fontSize: 7,
                                                  fontWeight: FontWeight.w600,
                                                  color: isExpanded &&
                                                          index == selIndex
                                                      ? Colors.white
                                                      : Colors.black,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                      Container(
                                        width: Screen.width(context) / 4,
                                        // color: Colors.pink,
                                        child: Center(
                                          child: Text(
                                            location[index] == ""
                                                ? "Ikeja - Island"
                                                : location[index],
                                            style: GoogleFonts.poppins(
                                              fontSize: 12,
                                              fontWeight: FontWeight.w600,
                                              color: isExpanded &&
                                                      index == selIndex
                                                  ? Colors.white
                                                  : Colors.black,
                                            ),
                                          ),
                                        ),
                                      ),
                                      Container(
                                        width: Screen.width(context) / 4,
                                        // color: Colors.blue,
                                        child: Center(
                                          child: Text(
                                            // statement[index],
                                            "Card",
                                            style: GoogleFonts.poppins(
                                              fontSize: 12,
                                              fontWeight: FontWeight.w600,
                                              color: isExpanded &&
                                                      index == selIndex
                                                  ? Colors.white
                                                  : Colors.black,
                                            ),
                                          ),
                                        ),
                                      ),
                                      Container(
                                        width: Screen.width(context) / 4 - 22,
                                        // color: Colors.amber,
                                        child: Center(
                                          child: Text(
                                            '\$ ${Ammount[index]}',
                                            overflow: TextOverflow.ellipsis,
                                            style: GoogleFonts.poppins(
                                              fontSize: 12,
                                              fontWeight: FontWeight.w600,
                                              color: isExpanded &&
                                                      index == selIndex
                                                  ? Colors.white
                                                  : Colors.black,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                          ),
                        );
                      }),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
