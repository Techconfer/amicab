import 'package:aim_cab/utils/util.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:google_fonts/google_fonts.dart';
class DriverProfileSetting extends StatefulWidget {
  @override
  _DriverProfileSettingState createState() => _DriverProfileSettingState();
}

class _DriverProfileSettingState extends State<DriverProfileSetting> {
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

      Text("Profile",style: GoogleFonts.poppins(fontSize: 25,fontWeight: FontWeight.bold,color:Theme.of(context).accentColor),)
,Text("Edit",style: GoogleFonts.poppins(fontSize: 13,fontWeight: FontWeight.normal,color:HexColor(textColor)),)
    ],

  ),
),
                Container(
                  margin: EdgeInsets.symmetric(horizontal: 20),
                  child: Form(

                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Neumorphic(
                          child: Container(
                            margin: EdgeInsets.all(10),
                            child: TextFormField(



                              decoration: InputDecoration(
                                  isDense: true,
                                  border: InputBorder.none,
                                  focusedBorder: InputBorder.none,
                                  enabledBorder: InputBorder.none,
                                  errorBorder: InputBorder.none,

                                  labelText: "Enter Full Name"
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height:20),
                        Neumorphic(
                          child: Container(
                            margin: EdgeInsets.all(10),
                            child: TextFormField(


keyboardType: TextInputType.emailAddress,
                              decoration: InputDecoration(
                                  isDense: true,

                                  labelText: "Enter Email",
                                border: InputBorder.none,
                                focusedBorder: InputBorder.none,
                                enabledBorder: InputBorder.none,
                                errorBorder: InputBorder.none,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height:20),
                        Neumorphic(
                          child: Container(
                            margin: EdgeInsets.all(10),
                            child: TextFormField(



                              decoration: InputDecoration(
                                  isDense: true,
                                  border: InputBorder.none,
                                  focusedBorder: InputBorder.none,
                                  enabledBorder: InputBorder.none,
                                  errorBorder: InputBorder.none,
                                  labelText: "Enter User Name"
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
                                  labelText: "Enter Mobile"
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height:10),
                        Neumorphic(
                          child: Container(
                            margin: EdgeInsets.all(10),
                            child: TextFormField(

                              keyboardType: TextInputType.datetime,

                              decoration: InputDecoration(
                                  isDense: true,
                                  border: InputBorder.none,
                                  focusedBorder: InputBorder.none,
                                  enabledBorder: InputBorder.none,
                                  errorBorder: InputBorder.none,

                                  labelText: "Enter DOB"
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height:10),
                        Column(children: [
                          Container(
                              alignment: Alignment.topLeft,
                              margin: EdgeInsets.only(left: 10),
                              child: Text("Gender",style: GoogleFonts.poppins(color:HexColor(textColor),fontSize: 15),)),
                          RadioListTile(
                              title: Text("Male",style: GoogleFonts.poppins(color:HexColor(textColor),fontSize: 12)),
                              value: "Male", groupValue:"Male", onChanged:(val){

                          }),
                          RadioListTile(
                              title: Text("FeMale",style: GoogleFonts.poppins(color:HexColor(textColor),fontSize: 12),),
                              value: "FeMale", groupValue:"FeMale", onChanged:(val){

                          })
                        ],)


                      ],
                    ),
                  ),
                ),




                SizedBox(height:10),

                Container(



                  child: Container(
                    margin: EdgeInsets.symmetric(horizontal: 30),
                    child: NeumorphicButton(


                        child: Container(
                            padding: EdgeInsets.all(10),

                            width: sizeScreen.width,
                            child: Center(child: Text("Update",style: GoogleFonts.poppins(color: HexColor("#8B9EB0"),fontSize: 18),))),
                        onPressed: (){
                        Navigator.pop(context);
                        }),
                  ),

                ),
                SizedBox(height:20),

              ],
            ),
          ),
        ),
      ),
    );
  }
}
