import 'package:aim_cab/utils/util.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';

class UserTerms extends StatefulWidget {
 final String _title;


  const UserTerms( this._title) ;
  _UserTermsState createState() => _UserTermsState();
}

class _UserTermsState extends State<UserTerms> {
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
                 padding: EdgeInsets.symmetric(horizontal: 10),
                 child: Text("This is a paragraph with more information about something important. This something has many uses and is made of 100% recycled material.This is a paragraph with more information about something important. This something has many uses and is made of 100% recycled material.This is a paragraph with more information about something important. This something has many uses and is made of 100% recycled material.This is a paragraph with more information about something important. This something has many uses and is made of 100% recycled material.This is a paragraph with more information about something important. This something has many uses and is made of 100% recycled material.",

                 textAlign: TextAlign.justify,

                   style: GoogleFonts.poppins(fontSize: 15,fontWeight: FontWeight.normal,color:Colors.black),

                 ),
               ),

Visibility(
  visible: widget._title=="About",
  child:   Column(children: [
    Container(
      margin: EdgeInsets.only(left: 20),
      child: AppListTile("Rate Us","assets/images/star_icon.svg",() {
        Navigator.pop(context);
      }),
    ),

                  Container(
                    margin: EdgeInsets.only(left: 20),
                    child: AppListTile("Like Us On Facebook","assets/images/like_icon.svg",() {
                      Navigator.pop(context);
                    }),
                  )



  ,
     Center(

      child:   Column(

        children: [

          Container(

            margin: EdgeInsets.only(top: 50),

                            child:  Text("App Version",style: GoogleFonts.poppins(fontSize: 20,color: Colors.black,fontWeight: FontWeight.bold)),

                          ),

          Container(

            child:  Text("1.00",style: GoogleFonts.poppins(fontSize: 13,color: Colors.black,fontWeight: FontWeight.bold)),

          ),

        ],

      ),

    ),

  ],),
)


              ],
            ),
          ),
        ),
      ),
    );
  }
}
class AppListTile extends StatelessWidget {
  String _title;
  String _icon;
  Function _function;
 AppListTile(this._title,this._icon,this._function);

  @override
  Widget build(BuildContext context) {

    return GestureDetector(
      onTap: ()=>_function.call(),
      child: Container(
        margin: EdgeInsets.all(10),

        child: Row(

          children: [
            Neumorphic(
                style: NeumorphicStyle(
                    color: HexColor("#ffffff")
                ),
                child:Container(
                    padding: EdgeInsets.all(15),
                    child: SvgPicture.asset(_icon))

            ),
            SizedBox(width: 10,),
            Text(_title,style: GoogleFonts.poppins(fontSize: 20,color: Colors.black,fontWeight: FontWeight.bold))
          ],
        ),

      ),
    );
  }
}