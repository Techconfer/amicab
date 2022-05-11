import 'package:aim_cab/utils/util.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:google_fonts/google_fonts.dart';
import '../common/UserCreatePassword.dart';

class VendorTerms extends StatefulWidget {
 final String _title;


  const VendorTerms( this._title) ;
  _VendorTermsState createState() => _VendorTermsState();
}

class _VendorTermsState extends State<VendorTerms> {
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

                      Expanded(child: Center(child: Text(widget._title,style: GoogleFonts.poppins(fontSize: 25,fontWeight: FontWeight.bold,color:Theme.of(context).accentColor),)))

                    ],

                  ),
                ),
               Container(
                 margin: EdgeInsets.all(10),
                 child: Text("This is a paragraph with more information about something important. This something has many uses and is made of 100% recycled material.This is a paragraph with more information about something important. This something has many uses and is made of 100% recycled material.This is a paragraph with more information about something important. This something has many uses and is made of 100% recycled material.This is a paragraph with more information about something important. This something has many uses and is made of 100% recycled material.This is a paragraph with more information about something important. This something has many uses and is made of 100% recycled material.",
                   textAlign: TextAlign.justify,
                   style: GoogleFonts.poppins(fontSize: 15,fontWeight: FontWeight.normal,color:HexColor(textColor)),

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