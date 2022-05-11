import 'package:aim_cab/utils/util.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:google_fonts/google_fonts.dart';

class DriverFilter extends StatefulWidget {
  @override
  _DriverFilterState createState() => _DriverFilterState();
}

class _DriverFilterState extends State<DriverFilter> {
  double sliderValue=0;
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
                margin: EdgeInsets.only(top: 10,left: 15,right: 15,bottom: 50),

                 child: Stack(



              children: [Align(
              alignment: Alignment.topLeft,
                child: Container(

                    child: Neumorphic(

                        child: IconButton(icon:Icon(Icons.arrow_back_ios,color:Theme.of(context).accentColor,size: 25,),
                          onPressed: (){
                            Navigator.pop(context);
                          },
                        ))),
              ),

              Align(
                  alignment: Alignment.center,
                  child: Center(child: Text("Filter",style: GoogleFonts.poppins(fontSize: 25,fontWeight: FontWeight.bold,color:Theme.of(context).accentColor),)))

            ],

          ),
              ),
              SingleChildScrollView(child: Container(
                margin: EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  children: [
                    Container(
                      alignment: Alignment.topRight,
                      margin: EdgeInsets.symmetric(vertical: 20,horizontal: 10),
                      child: IconButton(
                        icon: Icon(Icons.filter_alt_rounded,color: Theme.of(context).primaryColor,size: 40,),
                        onPressed:(){

                        },
                      ),


                    ),
                    Container(
                      margin: EdgeInsets.symmetric(vertical: 10),
                      child: Neumorphic(
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
                                prefixIcon:Icon( Icons.date_range),

                                labelText: "Enter Date"
                            ),
                          ),
                        ),
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.symmetric(vertical: 10),
                      child: Neumorphic(
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
                                prefixIcon:Icon( Icons.timer),

                                labelText: "Enter Time"
                            ),
                          ),
                        ),
                      ),
                    ),

                    Container(

                      width: double.infinity,
                      margin: EdgeInsets.symmetric(vertical: 10),
                      child: Column(

                        children: [
                          Container(
                              margin: EdgeInsets.symmetric(vertical: 5),
                              alignment: Alignment.topLeft,
                              child: Text("Pending",style: GoogleFonts.poppins(fontSize: 13,fontWeight: FontWeight.bold,color:HexColor(textColor)))),
                          Container(
                            width: double.infinity,
                            child: Neumorphic(
                              child: Container(
                                margin: EdgeInsets.all(10),
                                child: DropdownButton<String>(
                                  value: "Pending",


                                  elevation: 16,
                                  style: GoogleFonts.poppins(fontSize: 13,fontWeight: FontWeight.bold,color:HexColor(textColor)),
                                  underline: Container(
                                    height: 0,
                                    color: Colors.deepPurpleAccent,
                                  ),
                                  onChanged: (String newValue) {
                                    setState(() {

                                    });
                                  },
                                  items: <String>['Pending', 'Completed', 'Cancelled']
                                      .map<DropdownMenuItem<String>>((String value) {
                                    return DropdownMenuItem<String>(
                                      value: value,
                                      child: Text(value,style: GoogleFonts.poppins(fontSize: 13,fontWeight: FontWeight.bold,color:HexColor(textColor)),),
                                    );
                                  }).toList(),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.all(20),
                      child: NeumorphicButton(


                          child: Container(
                              padding: EdgeInsets.all(10),

                              child: Center(child: Text("DONE",style: GoogleFonts.poppins(color: HexColor("#8B9EB0"),fontSize: 18),))),
                          onPressed: (){

                          }),
                    ),
                  ],
                ),
              ),)








            ],
          ),
        ),
      ),
    );
  }
}