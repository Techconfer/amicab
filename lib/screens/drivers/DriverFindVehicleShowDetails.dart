import 'dart:convert';
import 'dart:io';

import 'package:aim_cab/screens/common/cardWidget.dart';
import 'package:aim_cab/screens/user/model/DriverRegisterModal.dart';
import 'package:aim_cab/utils/util.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geolocator/geolocator.dart' as geo;
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:socket_io_client/socket_io_client.dart';

import 'model/DriverFindVehicleModel.dart';
import 'model/DriverFindVehicleShowDetailsModel.dart';

class DriverFindVehicleShowDetails extends StatefulWidget {
  String sId;
  DriverFindVehicleShowDetails(String this.sId);

  @override
  _DriverFindVehicleShowDetailsState createState() => _DriverFindVehicleShowDetailsState();
}

class _DriverFindVehicleShowDetailsState extends State<DriverFindVehicleShowDetails> {
  DriverFindVehicleShowDetailsModel driverFindVehicleModel = DriverFindVehicleShowDetailsModel();
  Driverdata _driver;
  Socket socket;

  @override
  void initState() {


    WidgetsBinding.instance.addPostFrameCallback((_) async {
      _driver = await getDriver();
      connectToServer();
      getcar();


    });
    super.initState();
  }
  Future<dynamic> getcar() async {
    var token = await getToken();


    var dio = Dio();
    var response = await dio.get(
      'http://aim.inawebtech.com/v1.0/get-transportor-cars/${widget.sId}',
      options: Options(
        headers: {
          "Authorization":token
          // set content-length
        },
      ),
    );

    if (response != null && response.statusCode == 200) {
      driverFindVehicleModel = DriverFindVehicleShowDetailsModel.fromJson(jsonDecode(response.toString()));
      if (driverFindVehicleModel.status) {

        setState(() {});
      }
    }

    /* setState(() {
      for (var i = 0; i < 2; i++) {
        brand_name.add('testsss');

      }
    });*/
  }

  Future<String> getToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    print("token:" + prefs.getString("token"));
    return prefs.getString("token");
  }
  void connectToServer() {

    try {
      // Configure socket transports must be sepecified
      socket = io('http://aim.inawebtech.com/socket_chat', <String, dynamic>{
        'transports': ['websocket'],
        'query': {"id": _driver.sId},
        'autoConnect': true,
      });

      // Connect to websocket
      socket.connect();
      socket.onConnect(
              (data) => {print(">>>>>>>>>><<<:" + socket.connected.toString())});
      socket.on('RecivedRequestTransportor ',
              (data)  {
        print("<<Call1111111113>>:"+data.toString());
      });

      // Handle socket events

    } catch (e) {
      print(e.toString());
    }
  }

  sendRequest(String string) async {
    var token = await getToken();
  var  _driver = await getDriver();

    Map<String, dynamic> body = {
      'DriverId': _driver.sId,
      'TransporterId': widget.sId,
      'CarId': string,
    };

      final headers = {
        'Content-Type': 'application/json',
        "Authorization": "$token"
      };
      String jsonBody = json.encode(body);
      final encoding = Encoding.getByName('utf-8');
      var response = await http.post(
        Uri.parse(appUrl+"/send-request-to-transporter"),
        headers: headers,
        body: jsonBody,
        encoding: encoding,
      );
      var rr= jsonDecode(response.body);
      if (response != null && response.statusCode == 200 &&rr['status']) {
            Fluttertoast.showToast(msg: rr["msg"]);

            socket.emit('sendRequestToTransportor',rr['data']);


      }else{
        Fluttertoast.showToast(msg: rr["msg"]);
      }
  }

/*  fetchVehicle() async {
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
        Uri.parse("http://aim.inawebtech.com/v1.0/get-transporter-for-driver"),
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
  }*/

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
                        "Show Vehicle Details",
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
                              return CardWidget("", "", "", "", driverFindVehicleModel
                                  .data[index].plateNumber,  driverFindVehicleModel
                                  .data[index].vehicleType, "", driverFindVehicleModel
                                  .data[index].brandName, driverFindVehicleModel
                                  .data[index].model, driverFindVehicleModel
                                  .data[index].year.toString(), driverFindVehicleModel
                                  .data[index].rent.toString(),"Send Request","",(){ sendRequest(driverFindVehicleModel
                                  .data[index].sId.toString());}, (){

                              })/* Card(
                                  elevation: 4.0,
                                  child: Container(
                                    padding: EdgeInsets.fromLTRB(10, 0, 10, 10),
                                    child: Column(
                                      children: [
                                        // Container(
                                        //   height:100,
                                        //   padding: EdgeInsets.all(2),
                                        //   alignment: Alignment.center,
                                        //   child: Image.network(
                                        //       driverFindVehicleModel
                                        //           .data[index].vehicleImage[0]),
                                        // ),
                                        Container(
                                          padding: EdgeInsets.all(2),
                                          alignment: Alignment.centerLeft,
                                          child: Text('vehicle_type: ' +
                                              driverFindVehicleModel
                                                  .data[index].vehicleType),
                                        ),
                                        Container(
                                          padding: EdgeInsets.all(2),
                                          alignment: Alignment.centerLeft,
                                          child: Text('brand_name: ' +
                                              driverFindVehicleModel
                                                  .data[index].brandName),
                                        ),
                                        Container(
                                          padding: EdgeInsets.all(2),
                                          alignment: Alignment.centerLeft,
                                          child: Text('model: ' +
                                              driverFindVehicleModel
                                                  .data[index].model),
                                        ),
                                        Container(
                                          padding: EdgeInsets.all(2),
                                          alignment: Alignment.centerLeft,
                                          child: Text('year: ' +
                                              driverFindVehicleModel
                                                  .data[index].year.toString()),
                                        ),
                                        Container(
                                          padding: EdgeInsets.all(2),
                                          alignment: Alignment.centerLeft,
                                          child: Text('Plate Number: ' +
                                              driverFindVehicleModel
                                                  .data[index].plateNumber),
                                        ),
                                        Container(
                                          padding: EdgeInsets.all(2),
                                          alignment: Alignment.centerLeft,
                                          child: Text('rent: ' +
                                              driverFindVehicleModel
                                                  .data[index].rent.toString()),
                                        ),
                                        ButtonBar(
                                          children: [
                                            TextButton(
                                              child:
                                              const Text('Send Request'),
                                              onPressed: () {
                                              sendRequest(driverFindVehicleModel
                                                  .data[index].sId.toString());
                                              },
                                            )
                                          ],
                                        )
                                      ],
                                    ),
                                  ));*/
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
          ),
        ),
      ),
    );
  }
}

class mm {
  double lat;
  double long;

  mm(this.lat, this.long);
}
