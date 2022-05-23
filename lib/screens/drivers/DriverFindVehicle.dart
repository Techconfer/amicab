import 'dart:convert';

import 'package:aim_cab/screens/common/cardWidget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:geolocator/geolocator.dart' as geo;
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import 'DriverDashBoard.dart';
import 'DriverFindVehicleShowDetails.dart';
import 'DriverShowVehicleRequest.dart';
import 'model/DriverFindVehicleModel.dart';

class DriverFindVehicle extends StatefulWidget {
  @override
  _DriverFindVehicleState createState() => _DriverFindVehicleState();
}

class _DriverFindVehicleState extends State<DriverFindVehicle> {
  DriverFindVehicleModel driverFindVehicleModel = DriverFindVehicleModel();

  @override
  void initState() {
    fetchVehicle();
    super.initState();
  }

  Future<String> getToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    print("token:" + prefs.getString("token"));
    return prefs.getString("token");
  }

  fetchVehicle() async {
    var token = await getToken();
    var loc = await geo.Geolocator.getCurrentPosition(
        desiredAccuracy: geo.LocationAccuracy.low);
    Map<String, dynamic> body = {
      'latitude': loc.latitude,
      'longitude': loc.longitude,
    };
    if (loc != null) {
      final headers = {
        'Content-Type': 'application/json',
        "Authorization": "$token"
      };
      String jsonBody = json.encode(body);
      final encoding = Encoding.getByName('utf-8');
      var response = await http.post(
        Uri.parse("http://api.cabandcargo.com/v1.0/get-transporter-for-driver"),
        headers: headers,
        body: jsonBody,
        encoding: encoding,
      );
      if (response != null && response.statusCode == 200) {
        driverFindVehicleModel =
            DriverFindVehicleModel.fromJson(jsonDecode(response.body));
        if (driverFindVehicleModel.status) {
          setState(() {});
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
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
                        "Find Vehicle",
                        style: GoogleFonts.poppins(
                            fontSize: 25,
                            fontWeight: FontWeight.bold,
                            color: Theme.of(context).accentColor),
                      )
                          ))
                    ],
                  ),
                ),
                driverFindVehicleModel.data != null
                    ? Container(
                        height: MediaQuery.of(context).size.height - 95,
                        child: ListView.builder(
                            itemBuilder: (context, index) {
                              return CardWidget(
                                  driverFindVehicleModel.data[index].userimage,
                                  driverFindVehicleModel.data[index].name,
                                  driverFindVehicleModel.data[index].mobile,
                                  driverFindVehicleModel.data[index].username,
                                  driverFindVehicleModel
                                      .data[index].licenceNumber,
                                  driverFindVehicleModel.data[index].type,
                                  driverFindVehicleModel.data[index].email,
                                  "",
                                  "",
                                  "",
                                  "",
                                  "Show Details",
                                  "", () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          DriverFindVehicleShowDetails(
                                            driverFindVehicleModel
                                                .data[index].sId,
                                          )),
                                );
                              }, () {});
                              /*Card(
                                  elevation: 4.0,
                                  child: Container(
                                    padding: EdgeInsets.fromLTRB(10, 0, 10, 10),
                                    child: Column(
                                      children: [
                                        Row(
                                          children: [
                                            Container(
                                              height:50,
                                              child: Image.network(
                                                  driverFindVehicleModel
                                                      .data[index].userimage),
                                            ),
                                            Container(
                                              padding: EdgeInsets.all(2),
                                              alignment: Alignment.centerLeft,
                                              child:Text(
                                                driverFindVehicleModel
                                                    .data[index].name,
                                                style: GoogleFonts.poppins(
                                                    fontSize: 18,
                                                    fontWeight: FontWeight.bold,
                                                    color: Theme.of(context).accentColor),
                                              ),
                                            ),
                                          ],
                                        ),


                                        Container(
                                          padding: EdgeInsets.all(2),
                                          alignment: Alignment.centerLeft,
                                          child: Text( 'mobile: ' +driverFindVehicleModel
                                              .data[index].mobile,
                                              style: GoogleFonts.poppins(
                                                  fontSize: 13, color: HexColor("#8B9EB0"))),
                                        ),
                                        Container(
                                          padding: EdgeInsets.all(2),
                                          alignment: Alignment.centerLeft,
                                          child: Text('email: ' +
                                              driverFindVehicleModel
                                                  .data[index].email, style: GoogleFonts.poppins(
                                              fontSize: 13, color: HexColor("#8B9EB0"))),
                                        ),
                                        Container(
                                          padding: EdgeInsets.all(2),
                                          alignment: Alignment.centerLeft,
                                          child: Text('username: ' +
                                              driverFindVehicleModel
                                                  .data[index].username, style: GoogleFonts.poppins(
                                              fontSize: 13, color: HexColor("#8B9EB0"))),
                                        ),
                                        Container(
                                          padding: EdgeInsets.all(2),
                                          alignment: Alignment.centerLeft,
                                          child: Text('Plate Number: ' +
                                              driverFindVehicleModel
                                                  .data[index].licenceNumber, style: GoogleFonts.poppins(
                                              fontSize: 13, color: HexColor("#8B9EB0"))),
                                        ),
                                        Container(
                                          padding: EdgeInsets.all(2),
                                          alignment: Alignment.centerLeft,
                                          child: Text('type: ' +
                                              driverFindVehicleModel
                                                  .data[index].type, style: GoogleFonts.poppins(
                                              fontSize: 13, color: HexColor("#8B9EB0"))),
                                        ),
                                        ButtonBar(
                                          children: [
                                            TextButton(
                                              child:
                                              const Text('Show Details'),
                                              onPressed: () {
                                                Navigator.push(
                                                  context,
                                                  MaterialPageRoute(builder: (context) => DriverFindVehicleShowDetails(driverFindVehicleModel.data[index].sId,
                                                  )),
                                                );
                                              },
                                            )
                                          ],
                                        )
                                      ],
                                    ),
                                  ));*/
                            },
                            itemCount: driverFindVehicleModel.data.length),
                      )
                    : Container(
                        child: Center(
                          child: Container(
                              height: 60,
                              width: 60,
                              child: CircularProgressIndicator()),
                        ),
                      )
              ],
            ),
          ),
        ),
      ),
      floatingActionButton: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          DrawerListTile("Show Your Request", "assets/images/home_icon.svg",
              () {
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => DriverShowVehicleRequest()),
            );
          }),
        ],
      ),
    );
  }
}
