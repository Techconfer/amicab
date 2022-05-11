
import 'package:aim_cab/screens/vendor/DriverFilter.dart';
import 'package:aim_cab/utils/util.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:google_fonts/google_fonts.dart';


class DriverHistory extends StatefulWidget {
  @override
  _DriverHistoryState createState() => _DriverHistoryState();
}

class _DriverHistoryState extends State<DriverHistory> {
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
                  margin: EdgeInsets.only(top: 10,left: 15,right: 15,bottom: 50),

                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,


                    children: [Container(

                        child: Neumorphic(

                            child: IconButton(icon:Icon(Icons.arrow_back_ios,color:Theme.of(context).accentColor,size: 25,),
                              onPressed: (){
                                Navigator.pop(context);
                              },
                            ))),

                      Expanded(child: Center(child: Text("Driver Detail",style: GoogleFonts.poppins(fontSize: 25,fontWeight: FontWeight.bold,color:Theme.of(context).accentColor),)))
                    ,  IconButton(icon: Icon(Icons.filter_alt_rounded,color: Theme.of(context).accentColor,), onPressed: (){
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => DriverFilter()),
                        );
                      })
                    ],

                  ),
                ),

                Container(
                  padding: EdgeInsets.all(10),
                  margin: EdgeInsets.symmetric(vertical: 10,horizontal: 10),
                  decoration: BoxDecoration(


                      borderRadius: BorderRadius.all(Radius.circular(10))
                  )

                  ,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Text("Time",style: GoogleFonts.poppins(fontSize: 13,fontWeight: FontWeight.normal,color: Theme.of(context).primaryColor),),
                      Text("Date",style: GoogleFonts.poppins(fontSize: 13,fontWeight: FontWeight.normal,color: Theme.of(context).primaryColor),),
                      Container(
                          margin: EdgeInsets.symmetric(horizontal: 20),
                          child: Text("Order ID",style: GoogleFonts.poppins(fontSize: 13,fontWeight: FontWeight.normal,color: Theme.of(context).primaryColor),)),
                      Text("Status",style: GoogleFonts.poppins(fontSize: 13,fontWeight: FontWeight.normal,color: Theme.of(context).primaryColor),),
                      Text("View",style: GoogleFonts.poppins(fontSize: 13,fontWeight: FontWeight.normal,color: Theme.of(context).primaryColor),),
                    ],
                  ),
                ),

          Container(
            padding: EdgeInsets.all(10),
            margin: EdgeInsets.symmetric(vertical: 10,horizontal: 10),
            decoration: BoxDecoration(
color: Theme.of(context).primaryColor,

              borderRadius: BorderRadius.all(Radius.circular(10))
          )

            ,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Text("7.15 PM",style: GoogleFonts.poppins(fontSize: 13,fontWeight: FontWeight.normal,color: Colors.white),),
                Text("20-10-2020",style: GoogleFonts.poppins(fontSize: 13,fontWeight: FontWeight.normal,color: Colors.white),),
                Text("15455",style: GoogleFonts.poppins(fontSize: 13,fontWeight: FontWeight.normal,color: Colors.white),),
                Text("Khuraam",style: GoogleFonts.poppins(fontSize: 13,fontWeight: FontWeight.normal,color: Colors.white),),
                Text("Pending",style: GoogleFonts.poppins(fontSize: 13,fontWeight: FontWeight.normal,color: Colors.white),),
                Text("Edit",style: GoogleFonts.poppins(fontSize: 13,fontWeight: FontWeight.normal,color: Colors.white),),
              ],
            ),
          ),
                Container(
                  padding: EdgeInsets.all(10),
                  margin: EdgeInsets.symmetric(vertical: 10,horizontal: 10),
                  decoration: BoxDecoration(
                      color: Theme.of(context).primaryColor,

                      borderRadius: BorderRadius.all(Radius.circular(10))
                  )

                  ,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Text("7.15 PM",style: GoogleFonts.poppins(fontSize: 13,fontWeight: FontWeight.normal,color: Colors.white),),
                      Text("20-10-2020",style: GoogleFonts.poppins(fontSize: 13,fontWeight: FontWeight.normal,color: Colors.white),),
                      Text("15455",style: GoogleFonts.poppins(fontSize: 13,fontWeight: FontWeight.normal,color: Colors.white),),
                      Text("Khuraam",style: GoogleFonts.poppins(fontSize: 13,fontWeight: FontWeight.normal,color: Colors.white),),
                      Text("Pending",style: GoogleFonts.poppins(fontSize: 13,fontWeight: FontWeight.normal,color: Colors.white),),
                      Text("Edit",style: GoogleFonts.poppins(fontSize: 13,fontWeight: FontWeight.normal,color: Colors.white),),
                    ],
                  ),
                ),






              ],
            ),
          ),
        ),
      ),
    );
  }
}