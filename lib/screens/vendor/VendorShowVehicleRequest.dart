import 'dart:convert';
import 'dart:io';

import 'package:aim_cab/screens/common/cardWidget.dart';
import 'package:aim_cab/screens/user/model/DriverRegisterModal.dart';
import 'package:aim_cab/utils/util.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geolocator/geolocator.dart' as geo;
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:socket_io_client/socket_io_client.dart';

import 'VendorModel/VendorShowVehicleRequestModel.dart';


class VendorShowVehicleRequest extends StatefulWidget {
  @override
  _VendorShowVehicleRequestState createState() => _VendorShowVehicleRequestState();
}

class _VendorShowVehicleRequestState extends State<VendorShowVehicleRequest> {
  VendorShowVehicleRequestModel driverFindVehicleModel = VendorShowVehicleRequestModel();
  String msg="";
  bool isLoading=false;
  bool hasText=false;
  Driverdata _transporter;
  Socket socket;

  @override
  void initState() {
    fetchVehicle();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      _transporter = await getTransporter();
      connectToServer();
    });
    super.initState();
  }
  void connectToServer() {
    try {
      // Configure socket transports must be sepecified
      socket = io('http://api.cabandcargo.com/socket_chat', <String, dynamic>{
        'transports': ['websocket'],
        'query': {"id": _transporter.sId},
        'autoConnect': true,
      });

      // Connect to websocket
      socket.connect();
      socket.onConnect(
              (data) => {print("VendorSocketConnected:" + socket.connected.toString())});

      // Handle socket events

    } catch (e) {
      print(e.toString());
    }
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
        Uri.parse(appUrl+"/get-requests?type=transporter"),
        headers: headers,

      );
      var rr=jsonDecode(response.body);
      if (response != null && response.statusCode == 200) {

        if (rr["status"]) {
          driverFindVehicleModel=VendorShowVehicleRequestModel.fromJson(rr);
          isLoading=false;

          setState(() {});
        }else{
          msg=rr["msg"];
          if(rr["msg"]!=null)hasText=true;
          isLoading=false;
          setState(() {

          });
        }
      }
  }

  StatusChange(String string, String sId) async {
    var token = await getToken();
    var  _driver = await getDriver();

    Map<String, dynamic> body = {
      'RequestId': sId,
      'Status':string,

    };

    final headers = {
      'Content-Type': 'application/json',
      "Authorization": "$token"
    };
    String jsonBody = json.encode(body);
    final encoding = Encoding.getByName('utf-8');
    var response = await http.post(
      Uri.parse(appUrl+"/change-request-status"),
      headers: headers,
      body: jsonBody,
      encoding: encoding,
    );
    var rr= jsonDecode(response.body);
    if (response != null && response.statusCode == 200 && rr['status']) {
      socket.emit('OnRequestAcceptTransportor',rr['data']);
      fetchVehicle();
      Fluttertoast.showToast(msg: rr["msg"]);

    }else{
      fetchVehicle();
      Fluttertoast.showToast(msg: rr["msg"]);
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
                                fontSize: 20,
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
                                  return Padding(
                                    padding: const EdgeInsets.only(bottom: 22.0),
                                    child:CardWidget("", "", "", "", driverFindVehicleModel
                                        .data[index].carId.plateNumber, driverFindVehicleModel
                                        .data[index].carId.vehicleType, "",  driverFindVehicleModel
                                        .data[index].carId.brandName, driverFindVehicleModel
                                        .data[index].carId.model,  driverFindVehicleModel
                                        .data[index].carId.year.toString(), "", "Accept Request","Cancel Request",(){
                                      StatusChange("cancel", driverFindVehicleModel
                                          .data[index].sId);
                                    }, (){
                                      StatusChange("accept", driverFindVehicleModel
                                          .data[index].sId);
                                    },)
                                    /* Card(
                                        elevation: 4.0,
                                        child: Container(
                                          padding: EdgeInsets.fromLTRB(10, 0, 10, 10),
                                          child: Column(
                                            children: [

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
                                                        .data[index].carId.vehicleType),
                                              ),
                                              Container(
                                                padding: EdgeInsets.all(2),
                                                alignment: Alignment.centerLeft,
                                                child: Text('brand_name: ' +
                                                    driverFindVehicleModel
                                                        .data[index].carId.brandName),
                                              ),
                                              Container(
                                                padding: EdgeInsets.all(2),
                                                alignment: Alignment.centerLeft,
                                                child: Text('model: ' +
                                                    driverFindVehicleModel
                                                        .data[index].carId.model),
                                              ),
                                              Container(
                                                padding: EdgeInsets.all(2),
                                                alignment: Alignment.centerLeft,
                                                child: Text('year: ' +
                                                    driverFindVehicleModel
                                                        .data[index].carId.year.toString()),
                                              ),
                                              Container(
                                                padding: EdgeInsets.all(2),
                                                alignment: Alignment.centerLeft,
                                                child: Text('type: ' +
                                                    driverFindVehicleModel
                                                        .data[index].carId.plateNumber),
                                              ),
                                              Row(
                                                mainAxisAlignment: MainAxisAlignment.end,
                                                children: [
                                                  ButtonBar(
                                                    children: [
                                                      TextButton(
                                                        child:
                                                        const Text('Accept Request'),
                                                        onPressed: () {
                                                          StatusChange("accept", driverFindVehicleModel
                                                              .data[index].sId);
                                                        },
                                                      )
                                                    ],
                                                  ),
                                                  ButtonBar(
                                                    children: [
                                                      TextButton(
                                                        child:
                                                        const Text('Cancel Request'),
                                                        onPressed: () {
                                                         StatusChange("cancel", driverFindVehicleModel
                                                             .data[index].sId);
                                                        },
                                                      )
                                                    ],
                                                  ),
                                                ],
                                              )
                                            ],
                                          ),
                                        )),*/
                                  );
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
              Visibility(visible: hasText,child: Container(color: Colors.white,height: double.infinity,width: double.infinity,child: Center(child:Text("No Data Found") ,),))

            ],
          ),
        ),
      ),
    );
  }
}

