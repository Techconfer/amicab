import 'package:aim_cab/utils/util.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:google_fonts/google_fonts.dart';

class UserDocument extends StatefulWidget {
  @override
  _UserDocumentState createState() => _UserDocumentState();
}

class _UserDocumentState extends State<UserDocument> {
  @override
  Widget build(BuildContext context) {
    Size sizeScreen = MediaQuery.of(context).size;
    return Scaffold(


      body: Container(


        child: SafeArea(
          child: Stack(
            children: [
              SingleChildScrollView(
                child: Container(

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

                    Text("Documents",style: GoogleFonts.poppins(fontSize: 25,fontWeight: FontWeight.bold,color:Theme.of(context).accentColor),)
                    ,Text("Edit",style: GoogleFonts.poppins(fontSize: 13,fontWeight: FontWeight.normal,color:HexColor(textColor)),)
                  ],

              ),

                      ),
                      Container(
                          alignment: Alignment.topLeft,
                          margin: EdgeInsets.symmetric(horizontal: 15,vertical: 10),
                          child: Text("Personal Documents",style: GoogleFonts.poppins(fontSize: 15,fontWeight: FontWeight.normal,color:HexColor(textColor)),)),
                      Container(
                        child: Neumorphic(
                          margin: EdgeInsets.symmetric(horizontal: 20,vertical: 10),
                          child: Container(
                            padding: EdgeInsets.all(20),

                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [

                                Text("1.jpg",style: GoogleFonts.poppins(fontSize: 15,fontWeight: FontWeight.normal,color:HexColor(textColor)),),

                              ],),
                          ),
                        ),
                      ),
                      Container(
                        child: Neumorphic(
                          margin: EdgeInsets.symmetric(horizontal: 20,vertical: 10),
                          child: Container(
                            padding: EdgeInsets.all(20),

                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text("2.jpg",style: GoogleFonts.poppins(fontSize: 15,fontWeight: FontWeight.normal,color:HexColor(textColor)),),
                              ],),
                          ),
                        ),
                      ),








                    ],
                  ),
                ),
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: Container(
                  alignment: Alignment.bottomCenter,
                  margin: EdgeInsets.only(left: 20,right: 20,bottom: 20),
                  child: NeumorphicButton(


                      child: Container(


                          width: sizeScreen.width,
                          height: 40,
                          child: Center(child: Text("UPDATE",style: GoogleFonts.poppins(color: HexColor("#8B9EB0"),fontSize: 18),))),
                      onPressed: (){
                        Navigator.pop(context);
                      }),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}