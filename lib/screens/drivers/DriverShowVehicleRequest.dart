import 'dart:convert';

import 'package:aim_cab/utils/util.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geolocator/geolocator.dart' as geo;
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import 'DriverDashBoard.dart';
import 'DriverFindVehicleShowDetails.dart';
import 'model/DriverFindVehicleModel.dart';
import 'model/DriverShowVehicleRequestModel.dart';

class DriverShowVehicleRequest extends StatefulWidget {
  @override
  _DriverShowVehicleRequestState createState() => _DriverShowVehicleRequestState();
}

class _DriverShowVehicleRequestState extends State<DriverShowVehicleRequest> {
  DriverShowVehicleRequestModel driverFindVehicleModel = DriverShowVehicleRequestModel();
  String msg="";
  bool isLoading=false;
  bool hasText=false;

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
    isLoading=true;
    var token = await getToken();



      final headers = {
        'Content-Type': 'application/json',
        "Authorization": "$token"
      };
      final encoding = Encoding.getByName('utf-8');
      var response = await http.get(
        Uri.parse(appUrl+"/get-assigned-cars?type=driver"),
        headers: headers,

      );
      var rr=jsonDecode(response.body);
      if (response != null && response.statusCode == 200) {

        if (rr["status"]) {
          driverFindVehicleModel=DriverShowVehicleRequestModel.fromJson(rr);
          isLoading=false;
          setState(() {});
        }else{
          msg=rr["msg"];
          isLoading=false;
          hasText=true;
          setState(() {

          });
        }
      }
  }
  returnVehicle(String string) async {
    var token = await getToken();
    var _driver = await getDriver();

    Map<String, dynamic> body = {
      'RequestId': string,
    };

    final headers = {
      'Content-Type': 'application/json',
      "Authorization": "$token"
    };
    String jsonBody = json.encode(body);
    final encoding = Encoding.getByName('utf-8');
    var response = await http.post(
      Uri.parse(appUrl + "/return-to-transportor"),
      headers: headers,
      body: jsonBody,
      encoding: encoding,
    );
    var rr = jsonDecode(response.body);
    if (response != null && response.statusCode == 200 && rr['status']) {
      Fluttertoast.showToast(msg: rr["msg"]);
      fetchVehicle();
    } else {
      Fluttertoast.showToast(msg: rr["msg"]);
      fetchVehicle();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: SafeArea(
          child: Stack(
            children: [
              driverFindVehicleModel!=null? SingleChildScrollView(
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
                            "Show Vehicle Requests",
                            style: GoogleFonts.poppins(
                                fontSize: 25,
                                fontWeight: FontWeight.bold,
                                color: Theme.of(context).accentColor),
                          )))
                        ],
                      ),
                    ),
                    driverFindVehicleModel.data != null
                        ? Container(
                            height: MediaQuery.of(context).size.height - 95,
                            child: ListView.builder(
                                itemBuilder: (context, index) {
                                  return Card(
                                      elevation: 4.0,
                                      child: Container(
                                        padding: EdgeInsets.fromLTRB(10, 0, 10, 10),
                                        child: Column(
                                          children: [
                                            Container(
                                              height:100,
                                              padding: EdgeInsets.all(2),
                                              alignment: Alignment.center,
                                              child: Image.network(
                                                  driverFindVehicleModel
                                                      .data[index].transporterId.userimage),
                                            ),
                                            Container(
                                              padding: EdgeInsets.all(2),
                                              alignment: Alignment.centerLeft,
                                              child: Text('Status: ' +
                                                  driverFindVehicleModel
                                                      .data[index].status),
                                            ),
                                            Container(
                                              padding: EdgeInsets.all(2),
                                              alignment: Alignment.centerLeft,
                                              child: Text('vehicle_type: ' +
                                                  driverFindVehicleModel
                                                      .data[index].vehcileId.vehicleType),
                                            ),
                                            Container(
                                              padding: EdgeInsets.all(2),
                                              alignment: Alignment.centerLeft,
                                              child: Text('brand_name: ' +
                                                  driverFindVehicleModel
                                                      .data[index].vehcileId.brandName),
                                            ),
                                            Container(
                                              padding: EdgeInsets.all(2),
                                              alignment: Alignment.centerLeft,
                                              child: Text('model: ' +
                                                  driverFindVehicleModel
                                                      .data[index].vehcileId.model),
                                            ),
                                            Container(
                                              padding: EdgeInsets.all(2),
                                              alignment: Alignment.centerLeft,
                                              child: Text('year: ' +
                                                  driverFindVehicleModel
                                                      .data[index].vehcileId.year.toString()),
                                            ),
                                            Container(
                                              padding: EdgeInsets.all(2),
                                              alignment: Alignment.centerLeft,
                                              child: Text('type: ' +
                                                  driverFindVehicleModel
                                                      .data[index].vehcileId.plateNumber),
                                            ),
                                            ButtonBar(
                                              children: [
                                                TextButton(
                                                  child:
                                                  const Text('Return To transportor'),
                                                  onPressed: () {
                                                    returnVehicle( driverFindVehicleModel
                                                        .data[index].requestId);
                                                  },
                                                )
                                              ],
                                            )
                                          ],
                                        ),
                                      ));
                                  ;
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
              ):Container(),
              Visibility(visible: hasText,child: Container(color: Colors.white,height: double.infinity,width: double.infinity,child: Center(child:Text("$msg") ,),))


            ],
          ),
        ),
      ),
    );
  }
}

