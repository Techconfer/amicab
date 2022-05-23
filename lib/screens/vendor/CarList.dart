import 'dart:convert';

import 'package:aim_cab/screens/common/cardWidget.dart';
import 'package:aim_cab/utils/util.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';

import 'AddCar.dart';
import 'VendorShowVehicleRequest.dart';

class CarList extends StatefulWidget {
  @override
  _UserDocumentState createState() => _UserDocumentState();
}

class _UserDocumentState extends State<CarList> {
  List<String> vehicle_type = [];
  List<String> brand_name = [];
  List<String> model = [];
  List<String> year = [];
  List<String> plate_number = [];
  List<String> rating = [];
  List<String> rent = [];
  List<String> isAvailable = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();

    getcar();
  }

  Future<dynamic> getcar() async {
    var user = await getUserType();
    var token = await getToken();
    print("user_id_ride:" + user);
    print("user_id_ride:" + token);

    var dio = Dio();
    var response = await dio.get(
      'http://api.cabandcargo.com/v1.0/get-transportor-cars?offset=0',
      options: Options(
        headers: {
          "Authorization":token
              //'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJlbWFpbCI6InRyYW5zcG9ydG9yMTEyMkB5b3BtYWlsLmNvbSIsImlkIjoiNjFlZmE1MDI1MWFhZTdhNTM0OTA4MzAyIiwiaWF0IjoxNjQzMDk1NjgzLCJleHAiOjE2NDU2ODc2ODN9.3P2xPVWDFDATIrsgUjFlcaj8c-YDTNyiRFuQNMZlBfk'
          // set content-length
        },
      ),
    );
    List userwalltedata = jsonDecode(response.toString())['data'];

    setState(() {
      for (var i = 0; i < userwalltedata.length; i++) {
        vehicle_type.add(userwalltedata[i]['vehicle_type'].toString());
        brand_name.add(userwalltedata[i]['brand_name'].toString());
        model.add(userwalltedata[i]['model'].toString());
        year.add(userwalltedata[i]['year'].toString());
        plate_number.add(userwalltedata[i]['plate_number'].toString());
        rating.add(userwalltedata[i]['rating'].toString());
        rent.add(userwalltedata[i]['rent'].toString());
        isAvailable.add(userwalltedata[i]['isAvailable'].toString());
      }
      setState(() {
        isLoading = false;
      });
    });

    /* setState(() {
      for (var i = 0; i < 2; i++) {
        brand_name.add('testsss');

      }
    });*/
  }

  @override
  Widget build(BuildContext context) {
    Size sizeScreen = MediaQuery.of(context).size;
    return Scaffold(
      body: Stack(
        children: [
          Container(
            child: SafeArea(
              child: Stack(
                children: [
                  SingleChildScrollView(
                    child: Container(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Container(
                            margin: EdgeInsets.only(
                                top: 10, left: 15, right: 15, bottom: 5),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                                Text(
                                  "Car Details",
                                  style: GoogleFonts.poppins(
                                      fontSize: 25,
                                      fontWeight: FontWeight.bold,
                                      color: Theme.of(context).accentColor),
                                ),
                                GestureDetector(
                                    onTap: () {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) => AddCar()));
                                    },
                                    child: Text(
                                      "Add Car",
                                      style: GoogleFonts.poppins(
                                          fontSize: 13,
                                          fontWeight: FontWeight.normal,
                                          color: HexColor(textColor)),
                                    ))
                              ],
                            ),
                          ),
                          Column(
                            children: [
                              Container(
                                height: MediaQuery.of(context).size.height - 95,
                                child: ListView.builder(
                                    itemBuilder: (context, index) {
                                      return CardWidget(
                                              "",
                                              "",
                                              "",
                                              "",
                                              plate_number[index],
                                              vehicle_type[index],
                                              "",
                                              brand_name[index],
                                              model[index],
                                              year[index],
                                              rent[index],
                                              "Delete","",(){},
                                              () {})
                                          /* Card(
                                          elevation: 4.0,
                                          child: Container(
                                            padding: EdgeInsets.fromLTRB(
                                                10, 0, 0, 0),
                                            child: Column(
                                              children: [
                                                Container(
                                                  padding: EdgeInsets.all(2),
                                                  alignment:
                                                      Alignment.centerLeft,
                                                  child: Text('Brand Name: ' +
                                                      brand_name[index]),
                                                ),
                                                Container(
                                                  padding: EdgeInsets.all(2),
                                                  alignment:
                                                      Alignment.centerLeft,
                                                  child: Text('Vehicle Type: ' +
                                                      vehicle_type[index]),
                                                ),
                                                Container(
                                                  padding: EdgeInsets.all(2),
                                                  alignment:
                                                      Alignment.centerLeft,
                                                  child: Text(
                                                      'Model: ' + model[index]),
                                                ),
                                                Container(
                                                  padding: EdgeInsets.all(2),
                                                  alignment:
                                                      Alignment.centerLeft,
                                                  child: Text(
                                                      'year: ' + year[index]),
                                                ),
                                                Container(
                                                  padding: EdgeInsets.all(2),
                                                  alignment:
                                                      Alignment.centerLeft,
                                                  child: Text('Plate Number: ' +
                                                      plate_number[index]),
                                                ),
                                                Container(
                                                  padding: EdgeInsets.all(2),
                                                  alignment:
                                                      Alignment.centerLeft,
                                                  child: Text(
                                                      'Rent: ' + rent[index]),
                                                ),
                                                ButtonBar(
                                                  children: [
                                                    TextButton(
                                                      child:
                                                          const Text('Delete'),
                                                      onPressed: () {

                                                      },
                                                    )
                                                  ],
                                                )
                                              ],
                                            ),
                                          ));*/
                                          ;
                                    },
                                    itemCount: brand_name.length),
                              )
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Visibility(
              visible: isLoading,
              child: Container(
                height: double.infinity,
                width: double.infinity,
                color: Colors.white.withOpacity(0.8),
                child: Center(
                  child: Container(
                      height: 60,
                      width: 60,
                      child: CircularProgressIndicator()),
                ),
              ))
        ],
      ),
      floatingActionButton: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            decoration: BoxDecoration(
              color:  Theme.of(context).accentColor,
              borderRadius: BorderRadius.all(Radius.circular(20)),
            ),
            child: GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => VendorShowVehicleRequest()),
                );
              },
              child: Container(
                margin: EdgeInsets.all(10),
                child: Row(
                  children: [
                    Neumorphic(
                        style: NeumorphicStyle(color: HexColor("#E3EDF7")),
                        child: Container(
                            padding: EdgeInsets.all(10),
                            child: SvgPicture.asset(
                              "assets/images/home_icon.svg",
                              height: 25,
                              width: 25,
                            ))),
                    SizedBox(
                      width: 20,
                    ),
                    Text("Show Your Request",
                        style: GoogleFonts.poppins(
                            fontSize: 13, color:Colors.white))
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
