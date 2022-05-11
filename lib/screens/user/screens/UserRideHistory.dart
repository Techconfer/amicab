import 'package:aim_cab/screens/user/model/RideHistory.dart';
import 'package:aim_cab/utils/util.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

class UserRideHistory extends StatefulWidget {
  _UserRideHistoryState createState() => _UserRideHistoryState();
}

class _UserRideHistoryState extends State<UserRideHistory> {
  @override
  Widget build(BuildContext context) {
    Size sizeScreen = MediaQuery.of(context).size;
    return Scaffold(
      body: Container(
        height: sizeScreen.height,

        child: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              children: [
                Container(
                  margin:
                      EdgeInsets.only(top: 10, left: 15, right: 15, bottom: 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        child: Neumorphic(
                          child: IconButton(
                            icon: Icon(
                              Icons.arrow_back_ios,
                              color: Theme.of(context).colorScheme.secondary,
                              size: 25,
                            ),
                            onPressed: () {
                              Navigator.pop(context);
                            },
                          ),
                        ),
                      ),
                      Expanded(
                          child: Center(
                              child: Text(
                        "Ride history",
                        style: GoogleFonts.poppins(
                            fontSize: 25,
                            fontWeight: FontWeight.bold,
                            color: Theme.of(context).accentColor),
                      )))
                    ],
                  ),
                ),
                FutureBuilder<List<Data>>(
                    future: getRideHistory(),
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        return ListView.builder(
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: snapshot.data.length,
                            scrollDirection: Axis.vertical,
                            shrinkWrap: true,
                            itemBuilder: (BuildContext context, int index) {
                              return Container(
                                margin: EdgeInsets.symmetric(
                                    vertical: 10, horizontal: 10),
                                child: Card(
                                    elevation: 15,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(15.0),
                                    ),
                                    child: Container(
                                        margin: EdgeInsets.all(20),
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                                DateFormat(
                                                        "d MMMM yyyy, hh:mm ")
                                                    .format(DateTime.parse(
                                                        snapshot.data[index]
                                                            .rideDetail.tripDate
                                                            .toString())),
                                                style: GoogleFonts.poppins(
                                                    color: Colors.black54,
                                                    fontSize: 15)),
                                            Divider(),
                                            Container(
                                              child: Row(
                                                children: [
                                                  Text("11:24",
                                                      style:
                                                          GoogleFonts.poppins(
                                                              color: Colors
                                                                  .black12,
                                                              fontSize: 15)),
                                                  SizedBox(
                                                    width: 20,
                                                  ),
                                                  Container(
                                                      width: 200,
                                                      child: Text(
                                                          snapshot.data[index]
                                                              .rideDetail.source
                                                              .toString(),
                                                          style: GoogleFonts
                                                              .poppins(
                                                                  color: Colors
                                                                      .black54,
                                                                  fontSize:
                                                                      15)))
                                                ],
                                              ),
                                            ),
                                            Container(
                                              child: Column(
                                                children: [
                                                  Icon(
                                                    Icons.circle,
                                                    color: Colors.blue,
                                                    size: 10,
                                                  ),
                                                  Container(
                                                      height: 50,
                                                      child: VerticalDivider()),
                                                  Icon(
                                                    Icons.keyboard_arrow_down,
                                                    color: Theme.of(context)
                                                        .primaryColor,
                                                    size: 20,
                                                  )
                                                ],
                                              ),
                                            ),
                                            Container(
                                              child: Row(
                                                children: [
                                                  Text("11:24",
                                                      style:
                                                          GoogleFonts.poppins(
                                                              color: Colors
                                                                  .black12,
                                                              fontSize: 15)),
                                                  SizedBox(
                                                    width: 20,
                                                  ),
                                                  Container(
                                                      width: 200,
                                                      child: Text(
                                                          snapshot
                                                              .data[index]
                                                              .rideDetail
                                                              .destination
                                                              .toString(),
                                                          style: GoogleFonts
                                                              .poppins(
                                                                  color: Colors
                                                                      .black54,
                                                                  fontSize:
                                                                      15)))
                                                ],
                                              ),
                                            )
                                          ],
                                        ))),
                              );
                            });
                      } else if (snapshot.connectionState ==
                          ConnectionState.waiting) {
                        return Center(child: CircularProgressIndicator());
                      } else {
                        return Container(
                          child: Center(child: Text(snapshot.error.toString())),
                        );
                      }
                    }),
              ],
            ),
          ),
        ),

        // Column(
        //   crossAxisAlignment: CrossAxisAlignment.center,
        //   children: [
        //
        //     Container(
        //       margin: EdgeInsets.only(top: 10,left: 15,right: 15,bottom: 20),
        //
        //       child: Row(
        //         mainAxisAlignment: MainAxisAlignment.center,
        //
        //
        //         children: [Container(
        //
        //             child: Neumorphic(
        //
        //                 child: IconButton(icon:Icon(Icons.arrow_back_ios,color:Theme.of(context).accentColor,size: 25,),
        //                   onPressed: (){
        //                     Navigator.pop(context);
        //                   },
        //                 ))),
        //
        //           Expanded(child: Center(child: Text("Ride history",style: GoogleFonts.poppins(fontSize: 25,fontWeight: FontWeight.bold,color:Theme.of(context).accentColor),)))
        //
        //         ],
        //
        //       ),
        //     ),
        //     Container(
        //       margin: EdgeInsets.symmetric(vertical: 10,horizontal: 10),
        //       child: Card(
        //         elevation: 15,
        //           shape: RoundedRectangleBorder(
        //             borderRadius: BorderRadius.circular(15.0),
        //           ),
        //         child:Container(
        //             margin: EdgeInsets.all( 20),
        //           child:Column(
        //             mainAxisAlignment: MainAxisAlignment.start,
        //             crossAxisAlignment: CrossAxisAlignment.start,
        //             children: [
        //               Text("8 June 2019, 18:39",style:GoogleFonts.poppins(color: Colors.black54,fontSize: 15)),
        //               Divider(),
        //               Container(
        //
        //                 child: Row(children: [Text("11:24",style:GoogleFonts.poppins(color: Colors.black12,fontSize: 15)),
        //                   SizedBox(width: 20,),
        //                 Container(
        //                     width: 200,
        //                     child: Text("1, Thrale Street, London, SE19HW, UK",style:GoogleFonts.poppins(color: Colors.black54,fontSize: 15)))
        //                   ],),
        //               ),
        //               Container(
        //
        //                 child: Column(
        //                   children: [
        //                     Icon(Icons.circle,color: Colors.blue,size: 10,),
        //                     Container(
        //                         height: 50,
        //                         child: VerticalDivider()),
        //                     Icon(Icons.keyboard_arrow_down,color: Theme.of(context).primaryColor,size: 20,)
        //                   ],
        //                 ),),
        //               Container(
        //
        //                 child: Row(children: [Text("11:24",style:GoogleFonts.poppins(color: Colors.black12,fontSize: 15)),
        //                   SizedBox(width: 20,),
        //                   Container(
        //                       width: 200,
        //                       child: Text("1, Thrale Street, London, SE19HW, UK",style:GoogleFonts.poppins(color: Colors.black54,fontSize: 15)))
        //                 ],),
        //               )
        //             ],
        //           )
        //         )
        //       ),
        //
        //     ),
        //     Container(
        //       margin: EdgeInsets.symmetric(vertical: 10,horizontal: 10),
        //       child: Card(
        //           elevation: 15,
        //           shape: RoundedRectangleBorder(
        //             borderRadius: BorderRadius.circular(15.0),
        //           ),
        //           child:Container(
        //               margin: EdgeInsets.all( 20),
        //               child:Column(
        //                 mainAxisAlignment: MainAxisAlignment.start,
        //                 crossAxisAlignment: CrossAxisAlignment.start,
        //                 children: [
        //                   Text("8 June 2019, 18:39",style:GoogleFonts.poppins(color: Colors.black54,fontSize: 15)),
        //                   Divider(),
        //                   Container(
        //
        //                     child: Row(children: [Text("11:24",style:GoogleFonts.poppins(color: Colors.black12,fontSize: 15)),
        //                       SizedBox(width: 20,),
        //                       Container(
        //                           width: 200,
        //                           child: Text("1, Thrale Street, London, SE19HW, UK",style:GoogleFonts.poppins(color: Colors.black54,fontSize: 15)))
        //                     ],),
        //                   ),
        //                   Container(
        //
        //                     child: Column(
        //                       children: [
        //                         Icon(Icons.circle,color: Colors.blue,size: 10,),
        //                         Container(
        //                             height: 50,
        //                             child: VerticalDivider()),
        //                         Icon(Icons.keyboard_arrow_down,color: Theme.of(context).primaryColor,size: 20,)
        //                       ],
        //                     ),),
        //                   Container(
        //
        //                     child: Row(children: [Text("11:24",style:GoogleFonts.poppins(color: Colors.black12,fontSize: 15)),
        //                       SizedBox(width: 20,),
        //                       Container(
        //                           width: 200,
        //                           child: Text("1, Thrale Street, London, SE19HW, UK",style:GoogleFonts.poppins(color: Colors.black54,fontSize: 15)))
        //                     ],),
        //                   )
        //                 ],
        //               )
        //           )
        //       ),
        //
        //     )
        //
        //
        //
        //
        //
        //
        //
        //
        //   ],
        // ),
      ),
    );
  }

  Future<List<Data>> getRideHistory() async {
    var dio = Dio();
    dio.options.baseUrl = appUrl;
    var user = await getUser();
    var token = await getToken();
    print("user_id_ride:" + user.sId);
    var response = await dio.get(
      '/view-user-rides/${user.sId}?offset=0',
      options: Options(
        headers: {
          "Authorization": token // set content-length
        },
      ),
    );
    print("res_history_data:" + response.data.toString());
    var value = RideHistory.fromJson(response.data);
    return value.data;
  }
}
