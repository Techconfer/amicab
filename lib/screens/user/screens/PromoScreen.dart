import 'package:aim_cab/screens/user/model/PromocodeData.dart';
import 'package:aim_cab/utils/util.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:google_fonts/google_fonts.dart';

class PromoScreen extends StatefulWidget {

  _PromoScreenState createState() => _PromoScreenState();
}

class _PromoScreenState extends State<PromoScreen> {
  @override
  Widget build(BuildContext context) {
    Size sizeScreen = MediaQuery.of(context).size;
    return Scaffold(
      body: Container(

        child: SafeArea(

            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [

                Container(
                  margin: EdgeInsets.only(top: 10,left: 15,right: 15,bottom: 20),

                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,


                    children: [Container(

                        child: Neumorphic(

                            child: IconButton(icon:Icon(Icons.arrow_back_ios,color:Theme.of(context).accentColor,size: 25,),
                              onPressed: (){
                                Navigator.pop(context);
                              },
                            ))),

                      Expanded(child: Center(child: Text("Promo",style: GoogleFonts.poppins(fontSize: 25,fontWeight: FontWeight.bold,color:Theme.of(context).accentColor),)))

                    ],

                  ),
                ),
                FutureBuilder<List<Data>>(
                  future: getPromocode(),
                  builder: (context, snapshot) {
                    if(snapshot.hasData) {
                      return ListView.builder(
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
                                      width: sizeScreen.width,

                                      margin: EdgeInsets.all(20),
                                      child: Column(
                                        mainAxisAlignment: MainAxisAlignment
                                            .start,
                                        crossAxisAlignment: CrossAxisAlignment
                                            .start,
                                        children: [
                                          Container(

                                            child: Text(snapshot.data[index].promocode,
                                              style: GoogleFonts.poppins(
                                                  fontSize: 20,
                                                  fontWeight: FontWeight.bold,
                                                  color: Theme
                                                      .of(context)
                                                      .accentColor),),
                                          ),
                                          Container(
                                            width: sizeScreen.width - 100,
                                            child: Text(
                                              "Kate used 2 rides with 30% discount from Rakuten",
                                              style: GoogleFonts.poppins(
                                                  fontSize: 13,
                                                  fontWeight: FontWeight.normal,
                                                  color: HexColor(textColor)),),
                                          ),
                                          Container(
                                            margin: EdgeInsets.all(5),

                                            child: FlatButton(

                                              padding: EdgeInsets.symmetric(
                                                  vertical: 10, horizontal: 30),
                                              shape: RoundedRectangleBorder(
                                                borderRadius: BorderRadius
                                                    .circular(25), // <-- Radius
                                              ),

                                              color: HexColor("DADADA"),
                                              child: Text("APPLY",
                                                  style: GoogleFonts.poppins(
                                                      fontWeight: FontWeight
                                                          .bold,
                                                      fontSize: 15,
                                                      color: Theme
                                                          .of(context)
                                                          .accentColor)),
                                              onPressed: () {
                                                Navigator.pop(context,snapshot.data[index].promocode );
                                                showSuccess(context, "Promocode applied successfully");
                                                //        showPickup();
                                              },

                                            ),
                                          )
                                        ],
                                      )
                                  )
                              ),

                            );
                          }
                      );
                    }
                    else if(snapshot.connectionState==ConnectionState.waiting){
                      return CircularProgressIndicator();
                    }
                    else {
                      return Container();
                    }
                  }
                ),









              ],
            ),

        ),
      ),
    );
  }
  Future<List<Data>> getPromocode()
  async {
    var dio = Dio();
    dio.options.baseUrl = appUrl;

    var token=await      getToken();

    var   response = await dio.get('/view-all-promocodes',
      options: Options(
        headers: {
          "Authorization" :token// set content-length
        },
      ),

    );
    var value = PromocodeData
        .fromJson(response.data);
    return value.data;


  }

}