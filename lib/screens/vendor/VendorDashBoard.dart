import 'dart:async';

import 'package:aim_cab/screens/common/SplashScreen.dart';
import 'package:aim_cab/screens/user/api/api_service.dart';
import 'package:aim_cab/screens/user/model/DriverRegisterModal.dart';
import 'package:aim_cab/screens/user/screens/userTerms.dart';
import 'package:aim_cab/screens/vendor/VendorAccount.dart';
import 'package:aim_cab/screens/vendor/widgets/drwaerlist.dart';
import 'package:aim_cab/utils/Constant.dart';
import 'package:aim_cab/utils/util.dart';
import 'package:carp_background_location/carp_background_location.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:geocoder2/geocoder2.dart';
import 'package:geolocator/geolocator.dart' as geo;
import 'package:google_fonts/google_fonts.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:smooth_star_rating/smooth_star_rating.dart';
import 'package:socket_io_client/socket_io_client.dart';

import 'CarList.dart';

class VendorDashBoard extends StatefulWidget {
  @override
  _VendorDashBoardState createState() => _VendorDashBoardState();
}

class _VendorDashBoardState extends State<VendorDashBoard> {
  String _mapStyle = "";
  Driverdata _transporter;

  // List of coordinates to join
  List<LatLng> polylineCoordinates = [];
  bool offlineDriver = false;
  dynamic newRequestData;
  Socket socket;
  bool isTripStart = false;
  bool isNewRequest = false;
  Set<Marker> markers = {};
  String sourceAddress = "source";
  String destinationAddress = "destination";

// Map storing polylines created by connecting two points
  Map<PolylineId, Polyline> polylines = {};
  PolylinePoints polylinePoints;
  GoogleMapController mapController;
  Stream<LocationDto> locationStream;
  StreamSubscription<LocationDto> locationSubscription;

  @override
  void initState() {
    LocationManager().interval = 50;
    LocationManager().distanceFilter = 0;
    LocationManager().notificationTitle = 'Vendor location background';
    LocationManager().notificationMsg = 'CAB is tracking your location';
    locationStream = LocationManager().locationStream;
    locationSubscription = locationStream.listen(onData);
    // TODO: implement initState
    rootBundle.loadString('assets/map_style.txt').then((string) {
      _mapStyle = string;
    });
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      _transporter = await getTransporter();
      connectToServer();
    });
    super.initState();
  }

  Future<void> onData(LocationDto event) async {
    var dio = Dio();
    dio.options.baseUrl = appUrl;
    String token = await getToken();
    var response = await dio.post('/save-location',
        data: {
          "user_id": _transporter.sId,
          "location": [event.latitude, event.longitude],
        },
        options: Options(
          headers: {
            "Authorization": token // set content-length
          },
        ));
    print("on Data response:$response");
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

  void stopLocation() async {
    setState(() {});
    locationSubscription.cancel();
    await LocationManager().stop();
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
      socket.on('OnDriverLocationSend', (data) => vendorUpdate(data));
      // Handle socket events

    } catch (e) {
      print(e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    GoogleMap googleMap;
    Size sizeScreen = MediaQuery.of(context).size;
    if (googleMap == null) {
      googleMap = buildGoogleMap2();
    }
    return Scaffold(
      drawer: VendorDashDrawer(transporter: _transporter),
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
                    opacity: false ? 0 : 1,
                    duration: Duration(milliseconds: 200),
                    child: Column(
                      children: [
                        Container(
                          margin: EdgeInsets.all(10),
                          child: ElevatedButton(
                            onPressed: () async {
                              ApiService api = ApiService.create();
                              showLoader(context);
                              var res = await api.changeOnlineStatus(
                                  _transporter.sId, !offlineDriver);
                              dissmissLoader(context);
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
              newRequestData != null
                  ? Visibility(
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
                                      visible: isNewRequest,
                                      child: true
                                          ? Container(
                                              width: true
                                                  ? sizeScreen.width - 5
                                                  : 0,
//                                  margin:EdgeInsets.only(left:20),
                                              decoration: BoxDecoration(
                                                color: Theme.of(context)
                                                    .primaryColor,
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
                                                  topRight:
                                                      Radius.circular(5.0),
                                                ),
                                              ),
                                              child: Center(
                                                child: SingleChildScrollView(
                                                  physics:
                                                      NeverScrollableScrollPhysics(),
                                                  child: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: <Widget>[
                                                      SizedBox(
                                                        height: 10,
                                                      ),
                                                      Center(
                                                          child: Text(
                                                              "You are assign to give the vehicle",
                                                              style: GoogleFonts.poppins(
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .normal,
                                                                  fontSize: 18,
                                                                  color: Colors
                                                                      .white))),
                                                      Container(
                                                        alignment:
                                                            Alignment.topCenter,
                                                      ),
                                                      Container(
                                                          alignment: Alignment
                                                              .topCenter,
                                                          margin:
                                                              EdgeInsets.all(
                                                                  20),
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
                                                                    newRequestData != null
                                                                        ? newRequestData[
                                                                            'image']
                                                                        : "",
                                                                    width: 60,
                                                                    height: 60,
                                                                  ),
                                                                  SizedBox(
                                                                    height: 10,
                                                                  ),
                                                                  Text(
                                                                    newRequestData[
                                                                        'name'],
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
                                                                      starCount:
                                                                          5,
                                                                      isReadOnly:
                                                                          true,
                                                                      color: HexColor(
                                                                          "#0A66C2"),
                                                                      rating:
                                                                          3.5)
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
                                                                            double.parse("22").toStringAsFixed(2),
                                                                        style: GoogleFonts.poppins(
                                                                            fontSize:
                                                                                23,
                                                                            color:
                                                                                Colors.white),
                                                                      ),
                                                                      SizedBox(
                                                                        width:
                                                                            20,
                                                                      ),
                                                                      Text(
                                                                        "4.5km",
                                                                        style: GoogleFonts.poppins(
                                                                            fontSize:
                                                                                23,
                                                                            color:
                                                                                Colors.white),
                                                                      )
                                                                    ],
                                                                  ),
                                                                  Container(
                                                                    margin: EdgeInsets.symmetric(
                                                                        vertical:
                                                                            0,
                                                                        horizontal:
                                                                            20),
                                                                    child: Row(
                                                                      children: [
                                                                        CircleAvatar(
                                                                            backgroundColor:
                                                                                Theme.of(context).accentColor,
                                                                            child: Icon(Icons.location_on)),
                                                                        Container(
                                                                            width:
                                                                                100,
                                                                            child:
                                                                                Text(sourceAddress, style: GoogleFonts.poppins(fontWeight: FontWeight.normal, fontSize: 10, color: Colors.white)))
                                                                      ],
                                                                    ),
                                                                  ),
                                                                  Container(
                                                                    margin: EdgeInsets.symmetric(
                                                                        vertical:
                                                                            0,
                                                                        horizontal:
                                                                            20),
                                                                    child: Row(
                                                                      children: [
                                                                        CircleAvatar(
                                                                            backgroundColor:
                                                                                Theme.of(context).primaryColor,
                                                                            child: Icon(
                                                                              Icons.location_on,
                                                                              color: HexColor("#0A66C2"),
                                                                            )),
                                                                        Container(
                                                                            width:
                                                                                100,
                                                                            child:
                                                                                Text(destinationAddress, style: GoogleFonts.poppins(fontWeight: FontWeight.normal, fontSize: 10, color: Colors.white)))
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
                                                              EdgeInsets.all(
                                                                  20),
                                                          alignment:
                                                              Alignment.center,
                                                          child: isTripStart
                                                              ? ElevatedButton(
                                                                  style: ElevatedButton
                                                                      .styleFrom(
                                                                    onPrimary:
                                                                        Colors
                                                                            .black,
                                                                    primary: Colors
                                                                        .white,
                                                                    minimumSize:
                                                                        Size(
                                                                            200,
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
                                                                    makeOtpView();
                                                                  },
                                                                  child: Text(
                                                                      "Trip start"))
                                                              : ButtonBar(
                                                                  alignment:
                                                                      MainAxisAlignment
                                                                          .center,
                                                                  children: [
                                                                    ElevatedButton(
                                                                        style: ElevatedButton
                                                                            .styleFrom(
                                                                          onPrimary:
                                                                              Colors.white,
                                                                          primary:
                                                                              HexColor("BC0000"),
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
                                                                            () {
                                                                          setState(
                                                                              () {
                                                                            isNewRequest =
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
                                                                              Colors.black87,
                                                                          primary:
                                                                              HexColor("8B9EB0"),
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
                                                                          showLoader(
                                                                              context);
                                                                          DateTime
                                                                              date =
                                                                              DateTime.now();
                                                                          var loc =
                                                                              await geo.Geolocator.getCurrentPosition(desiredAccuracy: geo.LocationAccuracy.low);

                                                                          socket.emit(
                                                                              'OnDriverLocationUpdate',
                                                                              {
                                                                                'user_socket_id': newRequestData['driver_socket_id'],
                                                                                'vendor_socket': socket.id,
                                                                                "request_name": 'request_from_vendor_accpet',
                                                                                "name": _transporter.name,
                                                                                "image": _transporter.userimage,
                                                                                'driver_location': [
                                                                                  loc.latitude,
                                                                                  loc.longitude
                                                                                ]
                                                                              });
                                                                          isTripStart =
                                                                              true;
                                                                          dissmissLoader(
                                                                              context);
                                                                          setState(
                                                                              () {
                                                                            isNewRequest =
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
                    )
                  : Container(),
            ],
          ),
        ),
      ),
    );
  }

  GoogleMap buildGoogleMap2() {
    return GoogleMap(
      markers: Set<Marker>.from(markers),
      myLocationEnabled: true,
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

  vendorUpdate(data) async {
    newRequestData = data;
    isNewRequest = true;
    var loc = await geo.Geolocator.getCurrentPosition(
        desiredAccuracy: geo.LocationAccuracy.low);

    final fetchGeocoder = await Geocoder2.getDataFromCoordinates(
        googleMapApiKey: kgoogleMapKey,
        latitude: loc.latitude,
        longitude: loc.longitude);
    var daddresses = fetchGeocoder.address;

    final fetchGeocoderdest = await Geocoder2.getDataFromCoordinates(
        googleMapApiKey: kgoogleMapKey,
        latitude: newRequestData['driver_location'][0],
        longitude: newRequestData['driver_location'][1]);
    var daddressesdest = fetchGeocoderdest.address;

    sourceAddress = daddresses;
    destinationAddress = daddressesdest;

    createPolyMap(newRequestData['driver_location'][0],
        newRequestData['driver_location'][1], loc.latitude, loc.longitude);
    setState(() {});
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

  void makeOtpView() {
    TextEditingController emailController = TextEditingController();
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
                                      onPressed: () {
                                        //        showPickup();
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
                                        //        showPickup();
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
}




