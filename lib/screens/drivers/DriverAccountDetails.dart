import 'package:aim_cab/utils/util.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';

import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';

class DriverAccountDetails extends StatefulWidget {
  @override
  _DriverAccountDetailsState createState() => _DriverAccountDetailsState();
}

class _DriverAccountDetailsState extends State<DriverAccountDetails> {
  bool _isBankDetail=false;
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

                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [Container(

                        child: Neumorphic(

                            child: IconButton(icon:Icon(Icons.arrow_back_ios,color:Theme.of(context).accentColor,size: 25,),
                              onPressed: (){
                                Navigator.pop(context);
                              },
                            ))),

                      Text("Account Details",style: GoogleFonts.poppins(fontSize: 25,fontWeight: FontWeight.bold,color:Theme.of(context).accentColor),)
                      ,Text("Edit",style: GoogleFonts.poppins(fontSize: 13,fontWeight: FontWeight.normal,color:HexColor(textColor)),)
                    ],

                  ),

                ),
                Container(
                  margin: EdgeInsets.only(top: 10,left: 15,right: 15,bottom: 50),
                  child: Row(
                    children: [

                       Image.asset('assets/images/mtn.png',height: 50,width: 100,),
                      Text("MTN Mobile Money",style: GoogleFonts.poppins(fontSize: 13,fontWeight: FontWeight.bold,color:HexColor(textColor)),)
                    ],
                  ),
                ),
                SizedBox(height:10),
                Form(
                  child: Container(
                    margin: EdgeInsets.symmetric(vertical: 10,horizontal: 20),
                    child: Column(
                      children: [

                        Neumorphic(
                          child: Container(
                            margin: EdgeInsets.all(10),
                            child: TextFormField(

                              keyboardType: TextInputType.name,

                              decoration: InputDecoration(
                                  isDense: true,
                                  border: InputBorder.none,
                                  focusedBorder: InputBorder.none,
                                  enabledBorder: InputBorder.none,
                                  errorBorder: InputBorder.none,

                                  labelText: "Enter Mobile"
                              ),
                            ),
                          ),
                        ),

                        Container(
                          alignment: Alignment.topLeft,
                          margin: EdgeInsets.only(top:20,right: 20,bottom: 10),
                          child: TextButton(
                            onPressed: (){
                              setState(() {
                                _isBankDetail=!_isBankDetail;
                              });

                            },
                            child: Row(
                              children: [
                                Text("Bank account info",style: GoogleFonts.poppins(fontSize: 14,fontWeight: FontWeight.normal,color:Theme.of(context).primaryColor),),
                                Icon(_isBankDetail?Icons.arrow_upward:Icons.arrow_downward,color: HexColor(textColor),)
                              ],
                            ),

                          ),
                        ),

                        Visibility(
                            visible: _isBankDetail,
                            child: Column(

                          children: [
                            Neumorphic(
                              child: Container(
                                margin: EdgeInsets.all(10),
                                child: TextFormField(

                                  keyboardType: TextInputType.name,

                                  decoration: InputDecoration(
                                      isDense: true,
                                      border: InputBorder.none,
                                      focusedBorder: InputBorder.none,
                                      enabledBorder: InputBorder.none,
                                      errorBorder: InputBorder.none,

                                      labelText: "Enter Bank Name"
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(height:10),
                            Neumorphic(
                              child: Container(
                                margin: EdgeInsets.all(10),
                                child: TextFormField(

                                  keyboardType: TextInputType.name,

                                  decoration: InputDecoration(
                                      isDense: true,
                                      border: InputBorder.none,
                                      focusedBorder: InputBorder.none,
                                      enabledBorder: InputBorder.none,
                                      errorBorder: InputBorder.none,

                                      labelText: "Enter Account Number"
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(height:10),
                            Neumorphic(
                              child: Container(
                                margin: EdgeInsets.all(10),
                                child: TextFormField(

                                  keyboardType: TextInputType.name,

                                  decoration: InputDecoration(
                                      isDense: true,
                                      border: InputBorder.none,
                                      focusedBorder: InputBorder.none,
                                      enabledBorder: InputBorder.none,
                                      errorBorder: InputBorder.none,

                                      labelText: "Enter MICR"
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(height:10),
                            Neumorphic(
                              child: Container(
                                margin: EdgeInsets.all(10),
                                child: TextFormField(

                                  keyboardType: TextInputType.name,

                                  decoration: InputDecoration(
                                      isDense: true,
                                      border: InputBorder.none,
                                      focusedBorder: InputBorder.none,
                                      enabledBorder: InputBorder.none,
                                      errorBorder: InputBorder.none,

                                      labelText: "Enter IFSC"
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(height:10),
                          ],
                        )),
                        SizedBox(height:10),
                        Container(



                          child: Container(
                            margin: EdgeInsets.all(20),
                            child: NeumorphicButton(


                                child: Container(
                                    padding: EdgeInsets.all(10),
                                    
                                    child: Center(child: Text("DONE",style: GoogleFonts.poppins(color: HexColor("#8B9EB0"),fontSize: 18),))),
                                onPressed: (){

                                }),
                          ),

                        ),
                      ],
                    ),
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