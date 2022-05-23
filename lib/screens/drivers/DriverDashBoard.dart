import 'dart:async';
import 'dart:convert';

import 'package:aim_cab/screens/common/SplashScreen.dart';
import 'package:aim_cab/screens/common/Varibles.dart';
import 'package:aim_cab/screens/drivers/DriverAccount.dart';
import 'package:aim_cab/screens/user/api/api_service.dart';
import 'package:aim_cab/screens/user/model/DriverRegisterModal.dart';
import 'package:aim_cab/screens/user/screens/chatescrren.dart';
import 'package:aim_cab/screens/user/screens/userTerms.dart';
import 'package:aim_cab/screens/vendor/DriverRideHistory.dart';
import 'package:aim_cab/utils/Constant.dart';
import 'package:aim_cab/utils/util.dart';
import 'package:carp_background_location/carp_background_location.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geocoder/geocoder.dart';
import 'package:geolocator/geolocator.dart' as geo;
import 'package:google_fonts/google_fonts.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:smooth_star_rating/smooth_star_rating.dart';
import 'package:socket_io_client/socket_io_client.dart';

import 'DriverFindVehicle.dart';

class DriverDashBoard extends StatefulWidget {
  @override
  _DriverDashBoardState createState() => _DriverDashBoardState();
}

class _DriverDashBoardState extends State<DriverDashBoard> {
  String _mapStyle = "";

  Driverdata _driver;
  bool offlineDriver = false;
  bool isNewBooking = false;
  bool isNewVehicle = false;
  bool hadVendorAccepted = false;
  bool isTripStart = false;
  bool isVehicle = false;
  dynamic vehicleAcceptByVendor;

  PolylinePoints polylinePoints;
  dynamic newUserData;

  dynamic rideData;

  GoogleMapController mapController;
  Set<Marker> markers = {};

  // List of coordinates to join
  List<LatLng> polylineCoordinates = [];

// Map storing polylines created by connecting two points
  Map<PolylineId, Polyline> polylines = {};
  String sourceAddress = "source";
  String destinationAddress = "destination";
  Stream<LocationDto> locationStream;
  StreamSubscription<LocationDto> locationSubscription;
  Socket socket;

  @override
  void initState() {
    // TODO: implement initState
    LocationManager().interval = 50;
    LocationManager().distanceFilter = 0;
    LocationManager().notificationTitle = 'Driver location background';
    LocationManager().notificationMsg = 'CAB is tracking your location';
    locationStream = LocationManager().locationStream;

    locationSubscription = locationStream.listen(onData);

    rootBundle.loadString('assets/map_style.txt').then((string) {
      _mapStyle = string;
    });
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      _driver = await getDriver();
      isVehicle = _driver.is_vehcile??false;
      getRunningRideData();
      connectToServer();

      await getOnline();
      GetID();
    });

    super.initState();
  }

  _createPolylines(
    double startLatitude,
    double startLongitude,
    double destinationLatitude,
    double destinationLongitude,
  ) async {
    // Initializing PolylinePoints
    polylinePoints = PolylinePoints();

    // Generating the list of coordinates to be used for
    // drawing the polylines
    PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
      kgoogleMapKey, // Google Maps API Key
      PointLatLng(startLatitude, startLongitude),
      PointLatLng(destinationLatitude, destinationLongitude),
      travelMode: TravelMode.transit,
    );

    // Adding the coordinates to the list
    if (result.points.isNotEmpty) {
      result.points.forEach((PointLatLng point) {
        polylineCoordinates.add(LatLng(point.latitude, point.longitude));
      });
    }

    // Defining an ID
    PolylineId id = PolylineId('poly');

    // Initializing Polyline
    Polyline polyline = Polyline(
      polylineId: id,
      color: Theme.of(context).accentColor,
      points: polylineCoordinates,
      width: 3,
    );

    // Adding the polyline to the map
    polylines[id] = polyline;

    setState(() {});
  }

  Future<void> getRunningRideData() async {
    showLoader(context);
    var dio = Dio();
    dio.options.baseUrl = appUrl;
    polylineCoordinates.clear();
    markers.clear();

    var token = await getToken();
    DateTime date = DateTime.now();
    print("driverId:" + _driver.sId);

    var response = await dio.post(
      '/get-current-ride',
      data: {"type": "driver", "driver_id": _driver.sId},
      options: Options(
        headers: {
          "Authorization": token // set content-length
        },
      ),
    );
    print("res_data:" + response.data.toString());
    setState(() {
      rideData = response.data;
    });

    dissmissLoader(context);
    if (rideData != null && rideData['data']['booking']['amount'] != null) {
      if (rideData['data']['booking']['is_arrvied']) {
        Marker startMarker = Marker(
          markerId: MarkerId(response.data['data']['booking']['source']),
          position: LatLng(
              response.data['data']['booking']['source_location'][0],
              response.data['data']['booking']['source_location'][1]),
          infoWindow: InfoWindow(
            title: response.data['data']['booking']['source'],
            snippet: response.data['data']['booking']['source'],
          ),
          icon: await BitmapDescriptor.fromAssetImage(
              ImageConfiguration(size: Size(64, 64)),
              'assets/images/car_location.png'),
        );

// Destination Location Marker
        Marker destinationMarker = Marker(
          markerId: MarkerId(response.data['data']['booking']['destination']),
          position: LatLng(
              response.data['data']['booking']['destination_location'][0],
              response.data['data']['booking']['destination_location'][1]),
          infoWindow: InfoWindow(
            title: response.data['data']['booking']['destination'],
            snippet: response.data['data']['booking']['destination'],
          ),
          icon: BitmapDescriptor.defaultMarker,
        );

        markers.add(startMarker);
        markers.add(destinationMarker);
        double startLatitude =
            response.data['data']['booking']['source_location'][0];
        double startLongitude =
            response.data['data']['booking']['source_location'][1];
        double destinationLatitude =
            response.data['data']['booking']['destination_location'][0];
        double destinationLongitude =
            response.data['data']['booking']['destination_location'][1];
        double miny = (startLatitude <= destinationLatitude)
            ? startLatitude
            : destinationLatitude;
        double minx = (startLongitude <= destinationLongitude)
            ? startLongitude
            : destinationLongitude;
        double maxy = (startLatitude <= destinationLatitude)
            ? destinationLatitude
            : startLatitude;
        double maxx = (startLongitude <= destinationLongitude)
            ? destinationLongitude
            : startLongitude;

        double southWestLatitude = miny;
        double southWestLongitude = minx;

        double northEastLatitude = maxy;
        double northEastLongitude = maxx;

// Accommodate the two locations within the
// camera view of the map
        mapController.animateCamera(
          CameraUpdate.newLatLngBounds(
            LatLngBounds(
              northeast: LatLng(northEastLatitude, northEastLongitude),
              southwest: LatLng(southWestLatitude, southWestLongitude),
            ),
            100.0,
          ),
        );
        await _createPolylines(startLatitude, startLongitude,
            destinationLatitude, destinationLongitude);
      } else {
        Marker startMarker = Marker(
          markerId: MarkerId("driver_location"),
          position: LatLng(response.data['data']['driver']['location'][0],
              response.data['data']['driver']['location'][1]),
          infoWindow: InfoWindow(
            title: "Driver location",
            snippet: "Driver location",
          ),
          icon: await BitmapDescriptor.fromAssetImage(
              ImageConfiguration(size: Size(64, 64)),
              'assets/images/car_location.png'),
        );

// Destination Location Marker
        Marker destinationMarker = Marker(
          markerId: MarkerId("pickup_location"),
          position: LatLng(
              response.data['data']['booking']['source_location'][0],
              response.data['data']['booking']['source_location'][1]),
          infoWindow: InfoWindow(
            title: "User location",
            snippet: "user",
          ),
          icon: await BitmapDescriptor.fromAssetImage(
              ImageConfiguration(size: Size(64, 64)),
              'assets/images/rider_location.png'),
        );

        markers.add(startMarker);
        markers.add(destinationMarker);
        double startLatitude = response.data['data']['driver']['location'][0];
        double startLongitude = response.data['data']['driver']['location'][1];
        double destinationLatitude =
            response.data['data']['booking']['source_location'][0];
        double destinationLongitude =
            response.data['data']['booking']['source_location'][1];
        double miny = (startLatitude <= destinationLatitude)
            ? startLatitude
            : destinationLatitude;
        double minx = (startLongitude <= destinationLongitude)
            ? startLongitude
            : destinationLongitude;
        double maxy = (startLatitude <= destinationLatitude)
            ? destinationLatitude
            : startLatitude;
        double maxx = (startLongitude <= destinationLongitude)
            ? destinationLongitude
            : startLongitude;

        double southWestLatitude = miny;
        double southWestLongitude = minx;

        double northEastLatitude = maxy;
        double northEastLongitude = maxx;

// Accommodate the two locations within the
// camera view of the map

        await _createPolylines(startLatitude, startLongitude,
            destinationLatitude, destinationLongitude);
        mapController.animateCamera(
          CameraUpdate.newLatLngBounds(
            LatLngBounds(
              northeast: LatLng(northEastLatitude, northEastLongitude),
              southwest: LatLng(southWestLatitude, southWestLongitude),
            ),
            100.0,
          ),
        );
      }
      print(response);
    }
    print(response);
  }

  driverArrived(String string) async {
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
      Uri.parse(appUrl + "/driver-arrived"),
      headers: headers,
      body: jsonBody,
      encoding: encoding,
    );
    var rr = jsonDecode(response.body);
    if (response != null && response.statusCode == 200 && rr['status']) {
      Fluttertoast.showToast(msg: rr["msg"]);
      var otp = rr['data']['Otp'];
      makeOtpView(otp, string);
    } else {}
  }

  void makeOtpView(otp, String string) {
    print(")))))))))))" + otp);
    TextEditingController otpText = TextEditingController();
    StreamController<ErrorAnimationType> errorController =
        StreamController<ErrorAnimationType>();
    bool hasError = false;
    bool isOtpVisibility = false;
    final _formKey = GlobalKey<FormState>();
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return Dialog(
              backgroundColor: Colors.transparent,
              //this right here
              child: StatefulBuilder(builder: (context, setState) {
                return Container(
                  decoration: new BoxDecoration(
                      color: HexColor("FFFFFF"),
                      borderRadius: BorderRadius.all(Radius.circular(20))),
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Center(
                              child: Text(
                            "Give the OTP to the driver",
                            style: GoogleFonts.poppins(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Theme.of(context).accentColor),
                          )),
                          SizedBox(
                            height: 20,
                          ),
                          Visibility(
                            visible: true,
                            child: Neumorphic(
                              style: NeumorphicStyle(
                                color: HexColor("FFFFFF"),
                              ),
                              child: Container(
                                margin: EdgeInsets.symmetric(
                                    horizontal: 10, vertical: 1),
                                child: PinCodeTextField(
                                  appContext: context,
                                  obscureText: false,
                                  keyboardType: TextInputType.number,
                                  length: 6,
                                  animationType: AnimationType.scale,
                                  controller: otpText,
                                  cursorColor: Theme.of(context).primaryColor,
                                  errorAnimationController: errorController,
                                  pinTheme: PinTheme(
                                      shape: PinCodeFieldShape.box,
                                      borderRadius: BorderRadius.circular(5),
                                      fieldHeight: 50,
                                      fieldWidth: 40,
                                      inactiveColor:
                                          Theme.of(context).primaryColor,
                                      activeFillColor: Colors.blue.shade100),
                                  boxShadows: [
                                    BoxShadow(
                                      offset: Offset(0, 1),
                                      color: HexColor("FFFFFF"),
                                      blurRadius: 25,
                                    )
                                  ],
                                  onChanged: (String value) {},
                                ),
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          Center(
                            child: Container(
                              alignment: Alignment.center,
                              margin: EdgeInsets.only(top: 20, bottom: 20),
                              child: ButtonBar(
                                  alignment: MainAxisAlignment.center,
                                  children: [
                                    FlatButton(
                                      padding: EdgeInsets.symmetric(
                                          vertical: 10, horizontal: 30),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(
                                            10), // <-- Radius
                                      ),
                                      color: Colors.white,
                                      child: Text("DONE",
                                          style: GoogleFonts.poppins(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 15,
                                              color: Theme.of(context)
                                                  .accentColor)),
                                      onPressed: () async {
                                        var token = await getToken();

                                        Map<String, dynamic> body = {
                                          'RequestId': string,
                                          'otp': otpText.text.toString(),
                                        };

                                        final headers = {
                                          'Content-Type': 'application/json',
                                          "Authorization": "$token"
                                        };
                                        String jsonBody = json.encode(body);
                                        final encoding =
                                            Encoding.getByName('utf-8');
                                        var response = await http.post(
                                          Uri.parse(appUrl + "/driver-assign"),
                                          headers: headers,
                                          body: jsonBody,
                                          encoding: encoding,
                                        );
                                        var rr = jsonDecode(response.body);
                                        if (response != null &&
                                            response.statusCode == 200 &&
                                            rr['status']) {
                                          Fluttertoast.showToast(
                                              msg: rr['msg']);
                                          Navigator.pop(context);
                                        } else {
                                          Navigator.pop(context);
                                          Fluttertoast.showToast(
                                              msg: rr['msg']);
                                        }
                                      },
                                    ),
                                    FlatButton(
                                      padding: EdgeInsets.symmetric(
                                          vertical: 10, horizontal: 30),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(
                                            10), // <-- Radius
                                      ),
                                      color: Colors.white,
                                      child: Text("CANCEL",
                                          style: GoogleFonts.poppins(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 15,
                                              color: Theme.of(context)
                                                  .accentColor)),
                                      onPressed: () {
                                        Navigator.pop(context);
                                      },
                                    )
                                  ]),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              }));
        });
  }

  @override
  Widget build(BuildContext context) {
    GoogleMap googleMap;
    Size sizeScreen = MediaQuery.of(context).size;
    if (googleMap == null) {
      googleMap = GoogleMap(
        myLocationEnabled: true,
        markers: Set<Marker>.from(markers),
        polylines: Set<Polyline>.of(polylines.values),
        myLocationButtonEnabled: true,
        initialCameraPosition: CameraPosition(
            bearing: 192.8334901395799,
            target: LatLng(37.43296265331129, -122.08832357078792),
            tilt: 59.440717697143555,
            zoom: 19.151926040649414),
        onMapCreated: (c) {
          mapController = c;

          if (mounted) {
            setState(() {
              c.setMapStyle(_mapStyle);
            });
          }
        },
        mapType: MapType.normal,
        compassEnabled: false,
        padding: EdgeInsets.only(
          top: 1.0,
        ),
        onCameraIdle: () {},
        onCameraMove: ((_positionMoving) {
//          setState(() {
//          });
        }),
      );
    }
    return Scaffold(
      drawer: Drawer(
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
                            _driver != null
                                ? _driver.userimage != null
                                    ? _driver.userimage
                                    : ""
                                : "",
                            width: 100,
                            height: 100,
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Text(
                            _driver != null ? _driver.name : "",
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
              DrawerListTile("Rides", "assets/images/car_icon.svg", () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => DriverRideHistory()),
                );
              }),
              DrawerListTile("Account", "assets/images/account.svg", () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => DriverAccount()),
                ).then((value) => null);
              }),
              isVehicle
                  ? Container()
                  : Container(
                      margin: EdgeInsets.all(10),
                      child: GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => DriverFindVehicle()),
                          );
                        },
                        child: Row(
                          children: [
                            Neumorphic(
                                style:
                                    NeumorphicStyle(color: HexColor("#E3EDF7")),
                                child: Container(
                                    padding: EdgeInsets.all(10),
                                    child: SvgPicture.asset(
                                      "assets/images/search_car.svg",
                                      height: 25,
                                      width: 25,
                                      color: HexColor("#1B4670"),
                                    ))),
                            SizedBox(
                              width: 20,
                            ),
                            Text("Find Vehicle",
                                style: GoogleFonts.poppins(
                                    fontSize: 13, color: HexColor("#8B9EB0")))
                          ],
                        ),
                      ),
                    ),
              DrawerListTile("About", 'assets/images/about_icon.svg', () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => UserTerms("About")),
                );
              }),
              DrawerListTile("Support", "assets/images/support_icon.svg", () {
                Navigator.pop(context);
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
                      builder: (context) => UserTerms("Privacy & Policy")),
                );
              }),
              DrawerListTile("Chat", 'assets/images/customer_support_icon.svg',
                  () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => ChatPage()));
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
      ),
      body: Container(
        child: SafeArea(
          child: Stack(
            children: [
              googleMap,
              Container(
                margin: EdgeInsets.only(top: 20, left: 20),
                child: CircleAvatar(
                  radius: 22,
                  backgroundColor: Theme.of(context).accentColor,
                  child: Builder(
                    builder: (context) => IconButton(
                      icon: CircleAvatar(
                        radius: 22,
                        backgroundColor: Theme.of(context).accentColor,
                        child: Icon(
                          Icons.menu,
                          color: Colors.white,
                        ),
                      ),
                      onPressed: () => Scaffold.of(context).openDrawer(),
                    ),
                  ),
                ),
              ),
              Positioned(
                  bottom: 0,
                  left: 0,
                  right: 0,
                  child: SafeArea(
                      child: AnimatedOpacity(
                    opacity: rideData == null ? 0 : 1,
                    duration: Duration(milliseconds: 200),
                    child: Column(
                      children: [
                        Container(
                          margin: EdgeInsets.all(10),
                          child: ElevatedButton(
                            onPressed: () async {
                              ApiService api = ApiService.create();

                              //showLoader(context);
                              var dio = Dio();
                              dio.options.baseUrl = appUrl;

                              var token = await getToken();
                              DateTime date = DateTime.now();

                              setState(() {
                                isNewVehicle = true;
                              });
                            },
                            child: Column(
                              children: [
                                Text(
                                  "search vehicle",
                                  style: GoogleFonts.poppins(fontSize: 10),
                                )
                              ],
                            ),
                            style: ElevatedButton.styleFrom(
                              padding: EdgeInsets.all(20),
                              primary: HexColor("4B545A"),
                              // <-- Button color
                              onPrimary: Colors.white, // <-- Splash color
                            ),
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.all(10),
                          child: ElevatedButton(
                            onPressed: () async {
                              ApiService api = ApiService.create();

                              showLoader(context);
                              var res = await api.changeOnlineStatus(
                                  _driver.sId, offlineDriver);
                              dissmissLoader(context);
                              print('kjdisj$offlineDriver');

                              if (res.body["status"]) {
                                setState(() {
                                  offlineDriver = !offlineDriver;
                                });
                                setOnlineStatus(offlineDriver);
                                startLocation();
                              }
                            },
                            child: Column(
                              children: [
                                SvgPicture.asset("assets/images/hall_ride.svg"),
                                SizedBox(
                                  height: 2,
                                ),
                                Text(
                                  offlineDriver == true
                                      ? "Go online"
                                      : "Go offline",
                                  style: GoogleFonts.poppins(fontSize: 10),
                                )
                              ],
                            ),
                            style: ElevatedButton.styleFrom(
                              shape: CircleBorder(),
                              padding: EdgeInsets.all(20),
                              primary: HexColor("4B545A"),
                              // <-- Button color
                              onPrimary: Colors.white, // <-- Splash color
                            ),
                          ),
                        ),
                        Container(
                          child: Column(
                            children: <Widget>[
                              GestureDetector(
                                child: Visibility(
                                  visible: true,
                                  child: Container(
                                      width: true ? sizeScreen.width - 5 : 0,
//                                  margin:EdgeInsets.only(left:20),
                                      decoration: BoxDecoration(
                                        color: Theme.of(context).primaryColor,
                                        boxShadow: [
                                          BoxShadow(
                                            color: Colors.grey.withOpacity(0.4),
                                            spreadRadius: 2,
                                            blurRadius: 8,
                                            offset: Offset(0, 5),
                                          )
                                        ],
                                        borderRadius: BorderRadius.only(
                                          topLeft: Radius.circular(5.0),
                                          topRight: Radius.circular(5.0),
                                        ),
                                      ),
                                      child: SingleChildScrollView(
                                        physics: NeverScrollableScrollPhysics(),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: <Widget>[
                                            SizedBox(
                                              height: 10,
                                            ),
                                            Center(
                                                child: Text(
                                                    offlineDriver == true
                                                        ? "You are currently offline"
                                                        : "You are back online",
                                                    style: GoogleFonts.poppins(
                                                        fontSize: 18,
                                                        color: Colors.white))),
                                            Center(
                                              child: Container(
                                                margin: EdgeInsets.symmetric(
                                                    vertical: 20),
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceAround,
                                                  children: [
                                                    Column(
                                                      children: [
                                                        Icon(
                                                          Icons.security,
                                                          color: Colors.white,
                                                        ),
                                                        SizedBox(
                                                          height: 5,
                                                        ),
                                                        Text("95%",
                                                            style: GoogleFonts
                                                                .roboto(
                                                                    fontSize:
                                                                        15,
                                                                    color: Colors
                                                                        .white)),
                                                        SizedBox(
                                                          height: 5,
                                                        ),
                                                        Text("Acceptance",
                                                            style: GoogleFonts
                                                                .roboto(
                                                                    fontSize:
                                                                        15,
                                                                    color: Colors
                                                                        .white))
                                                      ],
                                                    ),
                                                    Container(
                                                      width: 1,
                                                      height: 100,
                                                      color: Colors.grey,
                                                    ),
                                                    Column(
                                                      children: [
                                                        Icon(
                                                          Icons
                                                              .star_rate_outlined,
                                                          color: Colors.white,
                                                        ),
                                                        SizedBox(
                                                          height: 5,
                                                        ),
                                                        Text("4.5",
                                                            style: GoogleFonts
                                                                .roboto(
                                                                    fontSize:
                                                                        15,
                                                                    color: Colors
                                                                        .white)),
                                                        SizedBox(
                                                          height: 5,
                                                        ),
                                                        Text("Rating",
                                                            style: GoogleFonts
                                                                .roboto(
                                                                    fontSize:
                                                                        15,
                                                                    color: Colors
                                                                        .white))
                                                      ],
                                                    ),
                                                    Container(
                                                      width: 1,
                                                      height: 100,
                                                      color: Colors.grey,
                                                    ),
                                                    Column(
                                                      children: [
                                                        Icon(
                                                          Icons
                                                              .cancel_presentation_sharp,
                                                          color: Colors.white,
                                                        ),
                                                        SizedBox(
                                                          height: 5,
                                                        ),
                                                        Text("2%",
                                                            style: GoogleFonts
                                                                .roboto(
                                                                    fontSize:
                                                                        15,
                                                                    color: Colors
                                                                        .white)),
                                                        SizedBox(
                                                          height: 5,
                                                        ),
                                                        Text("Cancelleation",
                                                            style: GoogleFonts
                                                                .roboto(
                                                                    fontSize:
                                                                        15,
                                                                    color: Colors
                                                                        .white))
                                                      ],
                                                    )
                                                  ],
                                                ),
                                              ),
                                            )
                                          ],
                                        ),
                                      )),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ))),
              Visibility(
                visible: true,
                child: Positioned(
                    bottom: 0,
                    left: 0,
                    right: 0,
                    child: SafeArea(
                        child: AnimatedOpacity(
                      opacity: 1,
                      duration: Duration(milliseconds: 200),
                      child: Container(
                        child: Column(
                          children: <Widget>[
                            GestureDetector(
                              child: Visibility(
                                visible: isNewVehicle,
                                child: true
                                    ? Container(
                                        width: true ? sizeScreen.width - 5 : 0,
//                                  margin:EdgeInsets.only(left:20),
                                        decoration: BoxDecoration(
                                          color: Theme.of(context).primaryColor,
                                          boxShadow: [
                                            BoxShadow(
                                              color:
                                                  Colors.grey.withOpacity(0.4),
                                              spreadRadius: 2,
                                              blurRadius: 8,
                                              offset: Offset(0, 5),
                                            )
                                          ],
                                          borderRadius: BorderRadius.only(
                                            topLeft: Radius.circular(5.0),
                                            topRight: Radius.circular(5.0),
                                          ),
                                        ),
                                        child: Center(
                                          child: SingleChildScrollView(
                                            physics:
                                                NeverScrollableScrollPhysics(),
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: <Widget>[
                                                SizedBox(
                                                  height: 10,
                                                ),
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.end,
                                                  children: [
                                                    Center(
                                                        child: Text(
                                                            "You are assign to pick the vehicle",
                                                            style: GoogleFonts.poppins(
                                                                fontWeight:
                                                                    FontWeight
                                                                        .normal,
                                                                fontSize: 18,
                                                                color: Colors
                                                                    .white))),
                                                    IconButton(
                                                        onPressed: () {
                                                          driverArrived(
                                                              vehicleAcceptByVendor[
                                                                  '_id']);
                                                        },
                                                        icon: Icon(
                                                          Icons.add,
                                                          color: Colors.white,
                                                        ))
                                                  ],
                                                ),
                                                Container(
                                                  alignment:
                                                      Alignment.topCenter,
                                                ),
                                                Container(
                                                    alignment:
                                                        Alignment.topCenter,
                                                    margin: EdgeInsets.all(20),
                                                    child: Row(
                                                      children: [
                                                        Column(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .start,
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .start,
                                                          children: [
                                                            Image.network(
                                                              vehicleAcceptByVendor !=
                                                                      null
                                                                  ? vehicleAcceptByVendor[
                                                                          'TransporterId']
                                                                      [
                                                                      'userimage']
                                                                  : "http://api.cabandcargo.com/assets/profile/avatar-icon.png",
                                                              width: 60,
                                                              height: 60,
                                                            ),
                                                            SizedBox(
                                                              height: 10,
                                                            ),
                                                            Text(
                                                              vehicleAcceptByVendor !=
                                                                      null
                                                                  ? vehicleAcceptByVendor[
                                                                          'TransporterId']
                                                                      ['name']
                                                                  : "john doe",
                                                              style: GoogleFonts.poppins(
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold,
                                                                  fontSize: 15,
                                                                  color: Colors
                                                                      .white),
                                                            ),
                                                            SizedBox(
                                                              height: 3,
                                                            ),
                                                            SmoothStarRating(
                                                                starCount: vehicleAcceptByVendor !=
                                                                        null
                                                                    ? vehicleAcceptByVendor[
                                                                            'TransporterId']
                                                                        [
                                                                        'rating']
                                                                    : 0,
                                                                isReadOnly:
                                                                    true,
                                                                color: HexColor(
                                                                    "#0A66C2"),
                                                                rating: 3.5)
                                                          ],
                                                        ),
                                                        Column(
                                                          mainAxisSize:
                                                              MainAxisSize.min,
                                                          children: [
                                                            Row(
                                                              children: [
                                                                Text(
                                                                  "₹" +
                                                                      double.parse(
                                                                              "22")
                                                                          .toStringAsFixed(
                                                                              2),
                                                                  style: GoogleFonts.poppins(
                                                                      fontSize:
                                                                          23,
                                                                      color: Colors
                                                                          .white),
                                                                ),
                                                                SizedBox(
                                                                  width: 20,
                                                                ),
                                                                Text(
                                                                  "4.5km",
                                                                  style: GoogleFonts.poppins(
                                                                      fontSize:
                                                                          23,
                                                                      color: Colors
                                                                          .white),
                                                                )
                                                              ],
                                                            ),
                                                            Container(
                                                              margin: EdgeInsets
                                                                  .symmetric(
                                                                      vertical:
                                                                          0,
                                                                      horizontal:
                                                                          20),
                                                              child: Row(
                                                                children: [
                                                                  CircleAvatar(
                                                                      backgroundColor:
                                                                          Theme.of(context)
                                                                              .accentColor,
                                                                      child: Icon(
                                                                          Icons
                                                                              .location_on)),
                                                                  Container(
                                                                      width:
                                                                          100,
                                                                      child: Text(
                                                                          "712/713 Time Square Arcade Near Thaltej Sindhubhavan Ahemdabad",
                                                                          style: GoogleFonts.poppins(
                                                                              fontWeight: FontWeight.normal,
                                                                              fontSize: 10,
                                                                              color: Colors.white)))
                                                                ],
                                                              ),
                                                            ),
                                                            Container(
                                                              margin: EdgeInsets
                                                                  .symmetric(
                                                                      vertical:
                                                                          0,
                                                                      horizontal:
                                                                          20),
                                                              child: Row(
                                                                children: [
                                                                  CircleAvatar(
                                                                      backgroundColor:
                                                                          Theme.of(context)
                                                                              .primaryColor,
                                                                      child:
                                                                          Icon(
                                                                        Icons
                                                                            .location_on,
                                                                        color: HexColor(
                                                                            "#0A66C2"),
                                                                      )),
                                                                  Container(
                                                                      width:
                                                                          100,
                                                                      child: Text(
                                                                          "Alpha one Mall Near Vastrapur Lake Vastrapur Ahemdabad",
                                                                          style: GoogleFonts.poppins(
                                                                              fontWeight: FontWeight.normal,
                                                                              fontSize: 10,
                                                                              color: Colors.white)))
                                                                ],
                                                              ),
                                                            )
                                                          ],
                                                        )
                                                      ],
                                                    )),
                                                Center(
                                                  child: Container(
                                                    margin: EdgeInsets.all(20),
                                                    alignment: Alignment.center,
                                                    child: hadVendorAccepted
                                                        ? Container(
                                                            alignment: Alignment
                                                                .topRight,
                                                            child:
                                                                ElevatedButton(
                                                                    style: ElevatedButton
                                                                        .styleFrom(
                                                                      onPrimary:
                                                                          Colors
                                                                              .white,
                                                                      primary:
                                                                          HexColor(
                                                                              "BC0000"),
                                                                      minimumSize:
                                                                          Size(
                                                                              88,
                                                                              36),
                                                                      padding: EdgeInsets.symmetric(
                                                                          horizontal:
                                                                              16),
                                                                      shape:
                                                                          const RoundedRectangleBorder(
                                                                        borderRadius:
                                                                            BorderRadius.all(Radius.circular(5)),
                                                                      ),
                                                                    ),
                                                                    onPressed:
                                                                        () async {
                                                                      var dio =
                                                                          Dio();
                                                                      dio.options
                                                                              .baseUrl =
                                                                          appUrl;

                                                                      var token =
                                                                          await getToken();
                                                                      showLoader(
                                                                          context);
                                                                      DateTime
                                                                          date =
                                                                          DateTime
                                                                              .now();
                                                                      var loc = await geo.Geolocator.getCurrentPosition(
                                                                          desiredAccuracy: geo
                                                                              .LocationAccuracy
                                                                              .low);

                                                                      socket.emit(
                                                                          'OnDriverLocationUpdate',
                                                                          {
                                                                            'user_socket_id':
                                                                                "sg2o64ZSG25RSKCLAAQ6",
                                                                            "request_name":
                                                                                'request_from_user',
                                                                            "driver_socket_id":
                                                                                socket.id,
                                                                            "name":
                                                                                _driver.name,
                                                                            "image":
                                                                                _driver.userimage,
                                                                            'driver_location':
                                                                                [
                                                                              loc.latitude,
                                                                              loc.longitude
                                                                            ]
                                                                          });

                                                                      dissmissLoader(
                                                                          context);
                                                                      setState(
                                                                          () {
                                                                        isNewVehicle =
                                                                            false;
                                                                      });
                                                                    },
                                                                    child: Text(
                                                                        "Cancel")),
                                                          )
                                                        : ButtonBar(
                                                            alignment:
                                                                MainAxisAlignment
                                                                    .center,
                                                            children: [
                                                              ElevatedButton(
                                                                  style: ElevatedButton
                                                                      .styleFrom(
                                                                    onPrimary:
                                                                        Colors
                                                                            .white,
                                                                    primary:
                                                                        HexColor(
                                                                            "BC0000"),
                                                                    minimumSize:
                                                                        Size(88,
                                                                            36),
                                                                    padding: EdgeInsets.symmetric(
                                                                        horizontal:
                                                                            16),
                                                                    shape:
                                                                        const RoundedRectangleBorder(
                                                                      borderRadius:
                                                                          BorderRadius.all(
                                                                              Radius.circular(5)),
                                                                    ),
                                                                  ),
                                                                  onPressed:
                                                                      () {
                                                                    setState(
                                                                        () {
                                                                      isNewVehicle =
                                                                          false;
                                                                    });
                                                                  },
                                                                  child: Text(
                                                                      "Reject")),
                                                              SizedBox(
                                                                width: 30,
                                                              ),
                                                              ElevatedButton(
                                                                  style: ElevatedButton
                                                                      .styleFrom(
                                                                    onPrimary:
                                                                        Colors
                                                                            .black87,
                                                                    primary:
                                                                        HexColor(
                                                                            "8B9EB0"),
                                                                    minimumSize:
                                                                        Size(88,
                                                                            36),
                                                                    padding: EdgeInsets.symmetric(
                                                                        horizontal:
                                                                            16),
                                                                    shape:
                                                                        const RoundedRectangleBorder(
                                                                      borderRadius:
                                                                          BorderRadius.all(
                                                                              Radius.circular(5)),
                                                                    ),
                                                                  ),
                                                                  onPressed:
                                                                      () async {
                                                                    var dio =
                                                                        Dio();
                                                                    dio.options
                                                                            .baseUrl =
                                                                        appUrl;

                                                                    var token =
                                                                        await getToken();
                                                                    showLoader(
                                                                        context);
                                                                    DateTime
                                                                        date =
                                                                        DateTime
                                                                            .now();
                                                                    var loc = await geo
                                                                            .Geolocator
                                                                        .getCurrentPosition(
                                                                            desiredAccuracy:
                                                                                geo.LocationAccuracy.low);

                                                                    socket.emit(
                                                                        'OnDriverLocationUpdate',
                                                                        {
                                                                          'user_socket_id':
                                                                              "sg2o64ZSG25RSKCLAAQ6",
                                                                          "request_name":
                                                                              'request_from_user',
                                                                          "driver_socket_id":
                                                                              socket.id,
                                                                          "name":
                                                                              _driver.name,
                                                                          "image":
                                                                              _driver.userimage,
                                                                          'driver_location':
                                                                              [
                                                                            loc.latitude,
                                                                            loc.longitude
                                                                          ]
                                                                        });

                                                                    dissmissLoader(
                                                                        context);
                                                                    setState(
                                                                        () {
                                                                      isNewVehicle =
                                                                          false;
                                                                    });
                                                                  },
                                                                  child: Text(
                                                                      "Accept"))
                                                            ],
                                                          ),
                                                  ),
                                                )
                                              ],
                                            ),
                                          ),
                                        ))
                                    : Container(),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ))),
              ),
              Visibility(
                visible: isNewBooking,
                child: Positioned(
                    bottom: 0,
                    left: 0,
                    right: 0,
                    child: SafeArea(
                        child: AnimatedOpacity(
                      opacity: 1,
                      duration: Duration(milliseconds: 200),
                      child: Container(
                        child: Column(
                          children: <Widget>[
                            GestureDetector(
                              child: Visibility(
                                visible: true,
                                child: newUserData != null
                                    ? Container(
                                        width: true ? sizeScreen.width - 5 : 0,
//                                  margin:EdgeInsets.only(left:20),
                                        decoration: BoxDecoration(
                                          color: Theme.of(context).primaryColor,
                                          boxShadow: [
                                            BoxShadow(
                                              color:
                                                  Colors.grey.withOpacity(0.4),
                                              spreadRadius: 2,
                                              blurRadius: 8,
                                              offset: Offset(0, 5),
                                            )
                                          ],
                                          borderRadius: BorderRadius.only(
                                            topLeft: Radius.circular(5.0),
                                            topRight: Radius.circular(5.0),
                                          ),
                                        ),
                                        child: Center(
                                          child: SingleChildScrollView(
                                            physics:
                                                NeverScrollableScrollPhysics(),
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: <Widget>[
                                                Container(
                                                  alignment:
                                                      Alignment.topCenter,
                                                ),
                                                Container(
                                                    alignment:
                                                        Alignment.topCenter,
                                                    margin: EdgeInsets.all(20),
                                                    child: Row(
                                                      children: [
                                                        Column(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .start,
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .start,
                                                          children: [
                                                            Image.network(
                                                              _driver != null
                                                                  ? _driver
                                                                      .userimage
                                                                  : "",
                                                              width: 60,
                                                              height: 60,
                                                            ),
                                                            SizedBox(
                                                              height: 10,
                                                            ),
                                                            Text(
                                                              newUserData[
                                                                  "username"],
                                                              style: GoogleFonts.poppins(
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold,
                                                                  fontSize: 15,
                                                                  color: Colors
                                                                      .white),
                                                            ),
                                                            SizedBox(
                                                              height: 3,
                                                            ),
                                                            SmoothStarRating(
                                                                starCount: 5,
                                                                isReadOnly:
                                                                    true,
                                                                color: HexColor(
                                                                    "#0A66C2"),
                                                                rating: 3.5)
                                                          ],
                                                        ),
                                                        Column(
                                                          mainAxisSize:
                                                              MainAxisSize.min,
                                                          children: [
                                                            Row(
                                                              children: [
                                                                Text(
                                                                  "₹" +
                                                                      double.parse(newUserData["booking_details"]["amount"]
                                                                              .toString())
                                                                          .toStringAsFixed(
                                                                              2),
                                                                  style: GoogleFonts.poppins(
                                                                      fontSize:
                                                                          23,
                                                                      color: Colors
                                                                          .white),
                                                                ),
                                                                SizedBox(
                                                                  width: 20,
                                                                ),
                                                                Text(
                                                                  "4.5km",
                                                                  style: GoogleFonts.poppins(
                                                                      fontSize:
                                                                          23,
                                                                      color: Colors
                                                                          .white),
                                                                )
                                                              ],
                                                            ),
                                                            Container(
                                                              margin: EdgeInsets
                                                                  .symmetric(
                                                                      vertical:
                                                                          0,
                                                                      horizontal:
                                                                          20),
                                                              child: Row(
                                                                children: [
                                                                  CircleAvatar(
                                                                      backgroundColor:
                                                                          Theme.of(context)
                                                                              .accentColor,
                                                                      child: Icon(
                                                                          Icons
                                                                              .location_on)),
                                                                  Container(
                                                                      width:
                                                                          100,
                                                                      child: Text(
                                                                          newUserData["booking_details"]
                                                                              [
                                                                              "source"],
                                                                          style: GoogleFonts.poppins(
                                                                              fontWeight: FontWeight.normal,
                                                                              fontSize: 10,
                                                                              color: Colors.white)))
                                                                ],
                                                              ),
                                                            ),
                                                            Container(
                                                              margin: EdgeInsets
                                                                  .symmetric(
                                                                      vertical:
                                                                          0,
                                                                      horizontal:
                                                                          20),
                                                              child: Row(
                                                                children: [
                                                                  CircleAvatar(
                                                                      backgroundColor:
                                                                          Theme.of(context)
                                                                              .primaryColor,
                                                                      child:
                                                                          Icon(
                                                                        Icons
                                                                            .location_on,
                                                                        color: HexColor(
                                                                            "#0A66C2"),
                                                                      )),
                                                                  Container(
                                                                      width:
                                                                          100,
                                                                      child: Text(
                                                                          newUserData["booking_details"]
                                                                              [
                                                                              "destination"],
                                                                          style: GoogleFonts.poppins(
                                                                              fontWeight: FontWeight.normal,
                                                                              fontSize: 10,
                                                                              color: Colors.white)))
                                                                ],
                                                              ),
                                                            )
                                                          ],
                                                        )
                                                      ],
                                                    )),
                                                Center(
                                                  child: Container(
                                                    margin: EdgeInsets.all(20),
                                                    alignment: Alignment.center,
                                                    child: ButtonBar(
                                                      alignment:
                                                          MainAxisAlignment
                                                              .center,
                                                      children: [
                                                        ElevatedButton(
                                                            style:
                                                                ElevatedButton
                                                                    .styleFrom(
                                                              onPrimary:
                                                                  Colors.white,
                                                              primary: HexColor(
                                                                  "BC0000"),
                                                              minimumSize:
                                                                  Size(88, 36),
                                                              padding: EdgeInsets
                                                                  .symmetric(
                                                                      horizontal:
                                                                          16),
                                                              shape:
                                                                  const RoundedRectangleBorder(
                                                                borderRadius: BorderRadius
                                                                    .all(Radius
                                                                        .circular(
                                                                            5)),
                                                              ),
                                                            ),
                                                            onPressed: () {
                                                              setState(() {
                                                                isNewBooking =
                                                                    false;
                                                              });
                                                            },
                                                            child:
                                                                Text("Reject")),
                                                        SizedBox(
                                                          width: 30,
                                                        ),
                                                        ElevatedButton(
                                                            style:
                                                                ElevatedButton
                                                                    .styleFrom(
                                                              onPrimary: Colors
                                                                  .black87,
                                                              primary: HexColor(
                                                                  "8B9EB0"),
                                                              minimumSize:
                                                                  Size(88, 36),
                                                              padding: EdgeInsets
                                                                  .symmetric(
                                                                      horizontal:
                                                                          16),
                                                              shape:
                                                                  const RoundedRectangleBorder(
                                                                borderRadius: BorderRadius
                                                                    .all(Radius
                                                                        .circular(
                                                                            5)),
                                                              ),
                                                            ),
                                                            onPressed:
                                                                () async {
                                                              // Varibles.SenderName=newUserData["username"];
                                                              // Varibles.ReciveID=newUserData["user_id"];
                                                              //showLoader(context);
                                                              var dio = Dio();
                                                              dio.options
                                                                      .baseUrl =
                                                                  appUrl;

                                                              var token =
                                                                  await getToken();
                                                              DateTime date =
                                                                  DateTime
                                                                      .now();
                                                              print("booking_id:" +
                                                                  newUserData[
                                                                      'booking_id']);
                                                              print(
                                                                  "driver_id:" +
                                                                      _driver
                                                                          .sId);
                                                              var response =
                                                                  await dio
                                                                      .post(
                                                                '/booking-accept',
                                                                data: {
                                                                  "booking_id":
                                                                      newUserData[
                                                                          'booking_id'],
                                                                  "driver_id":
                                                                      _driver
                                                                          .sId
                                                                },
                                                                options:
                                                                    Options(
                                                                  headers: {
                                                                    "Authorization":
                                                                        token
                                                                    // set content-length
                                                                  },
                                                                ),
                                                              );
                                                              print(response);

                                                              socket.emit(
                                                                  'OnBookingAccept',
                                                                  {
                                                                    'booking_id':
                                                                        newUserData[
                                                                            'booking_id'],
                                                                    'username':
                                                                        _driver
                                                                            .name,
                                                                    "photo": _driver
                                                                        .userimage,
                                                                    'booking_details':
                                                                        newUserData[
                                                                            'booking_details']
                                                                  });
                                                              setState(() {
                                                                isNewBooking =
                                                                    false;
                                                              });
                                                              getRunningRideData();
                                                              dissmissLoader(
                                                                  context);
                                                            },
                                                            child:
                                                                Text("Accept"))
                                                      ],
                                                    ),
                                                  ),
                                                )
                                              ],
                                            ),
                                          ),
                                        ))
                                    : Container(),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ))),
              ),
              Positioned(
                  bottom: 0,
                  left: 0,
                  right: 0,
                  child: SafeArea(
                      child: AnimatedOpacity(
                    opacity: 1,
                    duration: Duration(milliseconds: 200),
                    child: Container(
                      child: Column(
                        children: <Widget>[
                          GestureDetector(
                            child: Visibility(
                              visible: true,
                              child: rideData != null
                                  ? rideData['data']['booking']['amount'] !=
                                          null
                                      ? Container(
                                          width:
                                              true ? sizeScreen.width - 5 : 0,
//                                  margin:EdgeInsets.only(left:20),
                                          decoration: BoxDecoration(
                                            color:
                                                Theme.of(context).primaryColor,
                                            boxShadow: [
                                              BoxShadow(
                                                color: Colors.grey
                                                    .withOpacity(0.4),
                                                spreadRadius: 2,
                                                blurRadius: 8,
                                                offset: Offset(0, 5),
                                              )
                                            ],
                                            borderRadius: BorderRadius.only(
                                              topLeft: Radius.circular(5.0),
                                              topRight: Radius.circular(5.0),
                                            ),
                                          ),
                                          child: Center(
                                            child: SingleChildScrollView(
                                              physics:
                                                  NeverScrollableScrollPhysics(),
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: <Widget>[
                                                  Container(
                                                    alignment:
                                                        Alignment.topCenter,
                                                  ),
                                                  Container(
                                                      alignment:
                                                          Alignment.topCenter,
                                                      margin:
                                                          EdgeInsets.all(20),
                                                      child: Row(
                                                        children: [
                                                          Column(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .start,
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .start,
                                                            children: [
                                                              Image.network(
                                                                _driver != null
                                                                    ? _driver
                                                                        .userimage
                                                                    : "",
                                                                width: 60,
                                                                height: 60,
                                                              ),
                                                              SizedBox(
                                                                height: 10,
                                                              ),
                                                              Text(
                                                                rideData["data"]
                                                                            [
                                                                            'booking']
                                                                        [
                                                                        "amount"]
                                                                    .toString(),
                                                                style: GoogleFonts.poppins(
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold,
                                                                    fontSize:
                                                                        15,
                                                                    color: Colors
                                                                        .white),
                                                              ),
                                                              SizedBox(
                                                                height: 3,
                                                              ),
                                                              SmoothStarRating(
                                                                  starCount: 5,
                                                                  isReadOnly:
                                                                      true,
                                                                  color: HexColor(
                                                                      "#0A66C2"),
                                                                  rating: 3.5),
                                                              ButtonBar(
                                                                children: [
                                                                  CircleAvatar(
                                                                    backgroundColor:
                                                                        HexColor(
                                                                            "8B9EB0"),
                                                                    child: IconButton(
                                                                        onPressed:
                                                                            () {},
                                                                        icon: Icon(
                                                                            Icons.call)),
                                                                  ),
                                                                  CircleAvatar(
                                                                    backgroundColor:
                                                                        HexColor(
                                                                            "8B9EB0"),
                                                                    child: IconButton(
                                                                        onPressed: () {
                                                                          Varibles.ReciverName =
                                                                              rideData['data']['user']['username'];
                                                                          Varibles.ReciveID =
                                                                              rideData["data"]['booking']["user_id"];

                                                                          Navigator.push(
                                                                              context,
                                                                              MaterialPageRoute(builder: (context) => ChatPage()));
                                                                        },
                                                                        icon: Icon(Icons.chat)),
                                                                  )
                                                                ],
                                                              )
                                                            ],
                                                          ),
                                                          Column(
                                                            mainAxisSize:
                                                                MainAxisSize
                                                                    .min,
                                                            children: [
                                                              Row(
                                                                children: [
                                                                  Text(
                                                                    "₹" +
                                                                        double.parse(rideData["data"]['booking']["amount"].toString())
                                                                            .toStringAsFixed(2),
                                                                    style: GoogleFonts.poppins(
                                                                        fontSize:
                                                                            23,
                                                                        color: Colors
                                                                            .white),
                                                                  ),
                                                                  SizedBox(
                                                                    width: 20,
                                                                  ),
                                                                  Text(
                                                                    "4.5km",
                                                                    style: GoogleFonts.poppins(
                                                                        fontSize:
                                                                            23,
                                                                        color: Colors
                                                                            .white),
                                                                  )
                                                                ],
                                                              ),
                                                              Container(
                                                                margin: EdgeInsets
                                                                    .symmetric(
                                                                        vertical:
                                                                            0,
                                                                        horizontal:
                                                                            20),
                                                                child: Row(
                                                                  children: [
                                                                    CircleAvatar(
                                                                        backgroundColor:
                                                                            Theme.of(context)
                                                                                .accentColor,
                                                                        child: Icon(
                                                                            Icons.location_on)),
                                                                    Container(
                                                                        width:
                                                                            100,
                                                                        child: Text(
                                                                            rideData["data"]['booking'][
                                                                                "source"],
                                                                            style: GoogleFonts.poppins(
                                                                                fontWeight: FontWeight.normal,
                                                                                fontSize: 10,
                                                                                color: Colors.white)))
                                                                  ],
                                                                ),
                                                              ),
                                                              Container(
                                                                margin: EdgeInsets
                                                                    .symmetric(
                                                                        vertical:
                                                                            0,
                                                                        horizontal:
                                                                            20),
                                                                child: Row(
                                                                  children: [
                                                                    CircleAvatar(
                                                                        backgroundColor:
                                                                            Theme.of(context)
                                                                                .primaryColor,
                                                                        child:
                                                                            Icon(
                                                                          Icons
                                                                              .location_on,
                                                                          color:
                                                                              HexColor("#0A66C2"),
                                                                        )),
                                                                    Container(
                                                                        width:
                                                                            100,
                                                                        child: Text(
                                                                            rideData["data"]['booking'][
                                                                                "destination"],
                                                                            style: GoogleFonts.poppins(
                                                                                fontWeight: FontWeight.normal,
                                                                                fontSize: 10,
                                                                                color: Colors.white)))
                                                                  ],
                                                                ),
                                                              )
                                                            ],
                                                          )
                                                        ],
                                                      )),
                                                  Center(
                                                    child: Container(
                                                      margin:
                                                          EdgeInsets.all(20),
                                                      alignment:
                                                          Alignment.center,
                                                      child: ButtonBar(
                                                        alignment:
                                                            MainAxisAlignment
                                                                .center,
                                                        children: [
                                                          ElevatedButton(
                                                              style:
                                                                  ElevatedButton
                                                                      .styleFrom(
                                                                onPrimary:
                                                                    Colors
                                                                        .white,
                                                                primary: HexColor(
                                                                    "BC0000"),
                                                                minimumSize:
                                                                    Size(
                                                                        88, 36),
                                                                padding: EdgeInsets
                                                                    .symmetric(
                                                                        horizontal:
                                                                            16),
                                                                shape:
                                                                    const RoundedRectangleBorder(
                                                                  borderRadius:
                                                                      BorderRadius.all(
                                                                          Radius.circular(
                                                                              5)),
                                                                ),
                                                              ),
                                                              onPressed:
                                                                  () async {
                                                                var dio = Dio();
                                                                dio.options
                                                                        .baseUrl =
                                                                    appUrl;

                                                                var token =
                                                                    await getToken();

                                                                DateTime date =
                                                                    DateTime
                                                                        .now();
                                                                print("book_id:" +
                                                                    rideData['data']
                                                                            [
                                                                            'booking']
                                                                        [
                                                                        '_id']);
                                                                print("driver_id:" +
                                                                    _driver
                                                                        .sId);
                                                                var response =
                                                                    await dio
                                                                        .post(
                                                                  '/cancel-a-ride',
                                                                  data: {
                                                                    "booking_id":
                                                                        rideData['data']['booking']
                                                                            [
                                                                            '_id'],
                                                                    "user_id":
                                                                        _driver
                                                                            .sId,
                                                                    "cancel_by":
                                                                        "driver",
                                                                    "cancel_reason":
                                                                        ""
                                                                  },
                                                                  options:
                                                                      Options(
                                                                    headers: {
                                                                      "Authorization":
                                                                          token
                                                                      // set content-length
                                                                    },
                                                                  ),
                                                                );
                                                                print(response);
                                                                getRunningRideData();

                                                                dissmissLoader(
                                                                    context);
                                                              },
                                                              child: Text(
                                                                  "Cancel")),
                                                          rideData['data']['booking']
                                                                      [
                                                                      'is_arrvied'] ==
                                                                  false
                                                              ? ElevatedButton(
                                                                  style: ElevatedButton
                                                                      .styleFrom(
                                                                    onPrimary:
                                                                        Colors
                                                                            .black,
                                                                    primary:
                                                                        HexColor(
                                                                            "DADADA"),
                                                                    minimumSize:
                                                                        Size(88,
                                                                            36),
                                                                    padding: EdgeInsets.symmetric(
                                                                        horizontal:
                                                                            16),
                                                                    shape:
                                                                        const RoundedRectangleBorder(
                                                                      borderRadius:
                                                                          BorderRadius.all(
                                                                              Radius.circular(5)),
                                                                    ),
                                                                  ),
                                                                  onPressed:
                                                                      () async {
                                                                    var dio =
                                                                        Dio();
                                                                    dio.options
                                                                            .baseUrl =
                                                                        appUrl;

                                                                    var token =
                                                                        await getToken();
                                                                    DateTime
                                                                        date =
                                                                        DateTime
                                                                            .now();
                                                                    var response =
                                                                        await dio
                                                                            .post(
                                                                      '/arrvied-at-start-point',
                                                                      data: {
                                                                        "booking_id":
                                                                            rideData['data']['booking']['_id'],
                                                                        "driver_id":
                                                                            _driver.sId
                                                                      },
                                                                      options:
                                                                          Options(
                                                                        headers: {
                                                                          "Authorization":
                                                                              token
                                                                          // set content-length
                                                                        },
                                                                      ),
                                                                    );
                                                                    print(
                                                                        response);
                                                                    getRunningRideData();
                                                                    socket.emit(
                                                                        'OnDriverLocationUpdate',
                                                                        {
                                                                          'user_socket_id':
                                                                              rideData['data']['user']['socket_id'],
                                                                          "ride_status":
                                                                              'start',
                                                                          'driver_location':
                                                                              [
                                                                            28.483737,
                                                                            77.053071
                                                                          ]
                                                                        });

                                                                    dissmissLoader(
                                                                        context);
                                                                  },
                                                                  child: Text(
                                                                      "Arrived pickup location"))
                                                              : rideData['data']
                                                                              ['booking']
                                                                          [
                                                                          'is_start'] ==
                                                                      false
                                                                  ? ElevatedButton(
                                                                      style: ElevatedButton
                                                                          .styleFrom(
                                                                        onPrimary:
                                                                            Colors.black,
                                                                        primary:
                                                                            HexColor("DADADA"),
                                                                        minimumSize: Size(
                                                                            88,
                                                                            36),
                                                                        padding:
                                                                            EdgeInsets.symmetric(horizontal: 16),
                                                                        shape:
                                                                            const RoundedRectangleBorder(
                                                                          borderRadius:
                                                                              BorderRadius.all(Radius.circular(5)),
                                                                        ),
                                                                      ),
                                                                      onPressed:
                                                                          () async {
                                                                        var dio =
                                                                            Dio();
                                                                        dio.options.baseUrl =
                                                                            appUrl;

                                                                        var token =
                                                                            await getToken();
                                                                        DateTime
                                                                            date =
                                                                            DateTime.now();
                                                                        var response =
                                                                            await dio.post(
                                                                          '/booking-start-stop',
                                                                          data: {
                                                                            "booking_id":
                                                                                rideData['data']['booking']['_id'],
                                                                            "type":
                                                                                "start",
                                                                            "driver_id":
                                                                                _driver.sId
                                                                          },
                                                                          options:
                                                                              Options(
                                                                            headers: {
                                                                              "Authorization": token
                                                                              // set content-length
                                                                            },
                                                                          ),
                                                                        );
                                                                        socket.emit(
                                                                            'OnDriverLocationUpdate',
                                                                            {
                                                                              'user_socket_id': rideData['data']['user']['socket_id'],
                                                                              "ride_status": 'start',
                                                                              'driver_location': [
                                                                                28.483737,
                                                                                77.053071
                                                                              ]
                                                                            });
                                                                        print(
                                                                            response);

                                                                        getRunningRideData();

                                                                        dissmissLoader(
                                                                            context);
                                                                      },
                                                                      child: Text(
                                                                          "Start Trip"))
                                                                  : ElevatedButton(
                                                                      style: ElevatedButton
                                                                          .styleFrom(
                                                                        onPrimary:
                                                                            Colors.black,
                                                                        primary:
                                                                            HexColor("DADADA"),
                                                                        minimumSize: Size(
                                                                            88,
                                                                            36),
                                                                        padding:
                                                                            EdgeInsets.symmetric(horizontal: 16),
                                                                        shape:
                                                                            const RoundedRectangleBorder(
                                                                          borderRadius:
                                                                              BorderRadius.all(Radius.circular(5)),
                                                                        ),
                                                                      ),
                                                                      onPressed:
                                                                          () async {
                                                                        var dio =
                                                                            Dio();
                                                                        dio.options.baseUrl =
                                                                            appUrl;

                                                                        var token =
                                                                            await getToken();
                                                                        DateTime
                                                                            date =
                                                                            DateTime.now();
                                                                        var response =
                                                                            await dio.post(
                                                                          '/booking-start-stop',
                                                                          data: {
                                                                            "booking_id":
                                                                                rideData['data']['booking']['_id'],
                                                                            "type":
                                                                                "stop",
                                                                            "driver_id":
                                                                                _driver.sId
                                                                          },
                                                                          options:
                                                                              Options(
                                                                            headers: {
                                                                              "Authorization": token
                                                                              // set content-length
                                                                            },
                                                                          ),
                                                                        );
                                                                        print(
                                                                            response);

                                                                        socket.emit(
                                                                            'OnDriverLocationUpdate',
                                                                            {
                                                                              'user_socket_id': rideData['data']['user']['socket_id'],
                                                                              "ride_status": 'stop',
                                                                              'driver_location': [
                                                                                28.483737,
                                                                                77.053071
                                                                              ]
                                                                            });

                                                                        dissmissLoader(
                                                                            context);
                                                                        getRunningRideData();
                                                                      },
                                                                      child: Text(
                                                                          "End Trip")),
                                                        ],
                                                      ),
                                                    ),
                                                  )
                                                ],
                                              ),
                                            ),
                                          ))
                                      : Container()
                                  : Container(),
                            ),
                          ),
                        ],
                      ),
                    ),
                  )))
            ],
          ),
        ),
      ),
    );
  }

  Future<void> getOnline() async {
    bool flag = await getOnlineStatus();
    if (flag == null) flag = false;
    print("location flag:" + flag.toString());
    setState(() {
      offlineDriver = !flag;
    });
  }

  Future<void> onData(LocationDto event) async {
    print('fdfdf');

    var dio = Dio();
    dio.options.baseUrl = appUrl;
    String token = await getToken();
    var response = await dio.post('/save-location',
        data: {
          "user_id": _driver.sId,
          "location": [event.latitude, event.longitude],
        },
        options: Options(
          headers: {
            "Authorization": token // set content-length
          },
        ));
    print('fdfdf$response');
  }

/*
  Future<void> onDataDinesh() async {
    print('fdfdf');
    print(_driver.sId);

    var dio = Dio();
    dio.options.baseUrl = appUrl;
    String token = await getToken();
    print('===============Token');
    print(token);

    var response = await dio.post('/save-location',
        data: {
          "user_id": _driver.sId,
          "location": [23.0499881, 72.5009649],
        },
        options: Options(
          headers: {
            "Authorization": token // set content-length
          },
        ));
    print('fdfdf$response');
  }
*/

  Future<void> GetID() async {
    print('fdfdf');
    print(_driver.sId);

    Varibles.SendID = _driver.sId;
    Varibles.SenderName = _driver.username;
  }

  void startLocation() async {
    // Subscribe if it hasnt been done already
    if (locationSubscription != null) {
      locationSubscription.cancel();
    }
    locationSubscription = locationStream.listen(onData);
    await LocationManager().start();
    setState(() {});
  }

  void stopLocation() async {
    setState(() {});
    locationSubscription.cancel();
    await LocationManager().stop();
  }

  void connectToServer() {
    print('lklkl===============================');
    print(_driver.sId);

    try {
      // Configure socket transports must be sepecified
      socket = io('http://api.cabandcargo.com/socket_chat', <String, dynamic>{
        'transports': ['websocket'],
        'query': {"id": _driver.sId},
        'autoConnect': true,
      });

      // Connect to websocket
      socket.connect();
      socket.onConnect(
          (data) => {print("connectedDIDIDI:" + socket.connected.toString())});

      socket.on('getBookingvent',
          (data) => {print('lklkl===========$data'), onNewBooking(data)});

      socket.on('BookingAcceptResponse',
          (data) => {print("Call1111111113:"), onHideBooking(data)});
      socket.on('OnDriverLocationSend',
          (data) => {print("Call1111111114:"), vendorAccecpt(data)});
      socket.on('RecivedRequestAcceptTransportor', (data) {
        print(">>>>>>>>>>>" + data.toString());
        vendorAccecptRequest(data);
      });
      // Handle socket events

    } catch (e) {
      print(e.toString());
    }
  }

  onNewBooking(param0) {
    print("onNewBooking:" + param0.toString());

    setState(() {
      //  print("connectedDIDIDI:" + param[0]);

      isNewBooking = true;
      newUserData = param0;
    });
    print("booking_event:" + param0.toString());
  }

  onHideBooking(data) {
    setState(() {
      isNewBooking = false;
    });
  }

  vendorAccecpt(data) async {
    print("accepted_data");
    hadVendorAccepted = true;
    vehicleAcceptByVendor = data;

    if (isNewVehicle == false) {
      setState(() {
        isNewVehicle = true;
      });
    }

    var loc = await geo.Geolocator.getCurrentPosition(
        desiredAccuracy: geo.LocationAccuracy.low);

    final dcoordinates = new Coordinates(loc.latitude, loc.longitude);
    var daddresses =
        await Geocoder.local.findAddressesFromCoordinates(dcoordinates);

    final coordinates = new Coordinates(
        vehicleAcceptByVendor['driver_location'][0],
        vehicleAcceptByVendor['driver_location'][1]);
    var addresses =
        await Geocoder.local.findAddressesFromCoordinates(coordinates);
    var first = addresses.first;
    sourceAddress = daddresses.first.addressLine;
    destinationAddress = first.addressLine;

    createPolyMap(
      loc.latitude,
      loc.longitude,
      vehicleAcceptByVendor['driver_location'][0],
      vehicleAcceptByVendor['driver_location'][1],
    );
    setState(() {});
  }

  vendorAccecptRequest(data) async {
    print("accepted_data");
    hadVendorAccepted = true;
    vehicleAcceptByVendor = data;

    if (isNewVehicle == false) {
      setState(() {
        isNewVehicle = true;
      });
    }

    var loc = await geo.Geolocator.getCurrentPosition(
        desiredAccuracy: geo.LocationAccuracy.low);

    final dcoordinates = new Coordinates(loc.latitude, loc.longitude);
    var daddresses =
        await Geocoder.local.findAddressesFromCoordinates(dcoordinates);

    final coordinates = new Coordinates(
        vehicleAcceptByVendor['TransporterId']['location'][0],
        vehicleAcceptByVendor['TransporterId']['location'][1]);
    var addresses =
        await Geocoder.local.findAddressesFromCoordinates(coordinates);
    var first = addresses.first;
    sourceAddress = daddresses.first.addressLine;
    destinationAddress = first.addressLine;

    createPolyMap(
        loc.latitude,
        loc.longitude,
        vehicleAcceptByVendor['TransporterId']['location'][0],
        vehicleAcceptByVendor['TransporterId']['location'][1]);
    setState(() {});
  }

  Future<void> createPolyMap(double slat, slon, dlat, dlon) async {
    Marker startMarker = Marker(
      markerId: MarkerId("source"),
      position: LatLng(dlat, dlon),
      infoWindow: InfoWindow(
        title: "source",
        snippet: "source",
      ),
      icon: BitmapDescriptor.defaultMarker,
    );
    Marker destinationMarker = Marker(
      markerId: MarkerId("source"),
      position: LatLng(slat, slon),
      infoWindow: InfoWindow(
        title: "source",
        snippet: "source",
      ),
      icon: await BitmapDescriptor.fromAssetImage(
          ImageConfiguration(size: Size(64, 64)),
          'assets/images/car_location.png'),
    );

    markers.add(startMarker);
    markers.add(destinationMarker);
    double startLatitude = slat;
    double startLongitude = slon;
    double destinationLatitude = dlat;
    double destinationLongitude = dlon;
    double miny = (startLatitude <= destinationLatitude)
        ? startLatitude
        : destinationLatitude;
    double minx = (startLongitude <= destinationLongitude)
        ? startLongitude
        : destinationLongitude;
    double maxy = (startLatitude <= destinationLatitude)
        ? destinationLatitude
        : startLatitude;
    double maxx = (startLongitude <= destinationLongitude)
        ? destinationLongitude
        : startLongitude;

    double southWestLatitude = miny;
    double southWestLongitude = minx;

    double northEastLatitude = maxy;
    double northEastLongitude = maxx;

// Accommodate the two locations within the
// camera view of the map
    mapController.animateCamera(
      CameraUpdate.newLatLngBounds(
        LatLngBounds(
          northeast: LatLng(northEastLatitude, northEastLongitude),
          southwest: LatLng(southWestLatitude, southWestLongitude),
        ),
        100.0,
      ),
    );
    await _createPolylines(startLatitude, startLongitude, destinationLatitude,
        destinationLongitude);
  }
}

class DrawerListTile extends StatelessWidget {
  String _title;
  String _icon;
  Function _function;

  DrawerListTile(this._title, this._icon, this._function);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => _function.call(),
      child: Container(
        margin: EdgeInsets.all(10),
        child: Row(
          children: [
            Neumorphic(
                style: NeumorphicStyle(color: HexColor("#E3EDF7")),
                child: Container(
                    padding: EdgeInsets.all(10),
                    child: SvgPicture.asset(
                      _icon,
                      height: 25,
                      width: 25,
                    ))),
            SizedBox(
              width: 20,
            ),
            Text(_title,
                style: GoogleFonts.poppins(
                    fontSize: 13, color: HexColor("#8B9EB0")))
          ],
        ),
      ),
    );
  }
}
