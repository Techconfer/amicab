import 'package:aim_cab/utils/util.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
class CardWidget extends StatelessWidget {
String image;
String name;
String mobile;
String username;
String plate;
String type;
String email;
String brandName;
String model;
String year;
String rent;
String buttonName1;
String buttonName2;
Function _function1;
Function _function2;


CardWidget(
      this.image,
      this.name,
      this.mobile,
      this.username,
      this.plate,
      this.type,
      this.email,
      this.brandName,
      this.model,
      this.year,
      this.rent,
      this.buttonName1,
      this.buttonName2,
      this._function1,
      this._function2,
    );

  @override
  Widget build(BuildContext context) {
    return Card(
        elevation: 4.0,
        child: Container(
          padding: EdgeInsets.fromLTRB(10, 0, 10, 10),
          child: Column(
            children: [
                Row(
                children: [
                 image!=""? Container(
                    height:50,
                    child: Image.network(
                        image),
                  ):Container(),
                  name!=""?Container(
                    padding: EdgeInsets.all(2),
                    alignment: Alignment.centerLeft,
                    child:Text(
                      name,
                      style: GoogleFonts.poppins(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).accentColor),
                    ),
                  ):Container(),
                ],
              ),


              mobile!=""? Container(
                padding: EdgeInsets.all(2),
                alignment: Alignment.centerLeft,
                child: Text( 'mobile: ' +mobile,
                    style: GoogleFonts.poppins(
                        fontSize: 13, color: HexColor("#8B9EB0"))),
              ):Container(),
              email!=""?Container(
                padding: EdgeInsets.all(2),
                alignment: Alignment.centerLeft,
                child: Text('email: ' +
                   email, style: GoogleFonts.poppins(
                    fontSize: 13, color: HexColor("#8B9EB0"))),
              ):Container(),

              username!=""?Container(
                padding: EdgeInsets.all(2),
                alignment: Alignment.centerLeft,
                child: Text('username: ' +
                    username, style: GoogleFonts.poppins(
                    fontSize: 13, color: HexColor("#8B9EB0"))),
              ):Container(),

              plate!=""? Container(
                padding: EdgeInsets.all(2),
                alignment: Alignment.centerLeft,
                child: Text('Plate Number: ' +
                    plate, style: GoogleFonts.poppins(
                    fontSize: 13, color: HexColor("#8B9EB0"))),
              ):Container(),
              type!=""?Container(
                padding: EdgeInsets.all(2),
                alignment: Alignment.centerLeft,
                child: Text('type: ' +
                   type, style: GoogleFonts.poppins(
                    fontSize: 13, color: HexColor("#8B9EB0"))),
              ):Container(),
              brandName!=""? Container(
                padding: EdgeInsets.all(2),
                alignment: Alignment.centerLeft,
                child: Text('Brand: ' +
                    brandName, style: GoogleFonts.poppins(
                    fontSize: 13, color: HexColor("#8B9EB0"))),
              ):Container(),
              model!=""?Container(
                padding: EdgeInsets.all(2),
                alignment: Alignment.centerLeft,
                child: Text('Model: ' +
                    model, style: GoogleFonts.poppins(
                    fontSize: 13, color: HexColor("#8B9EB0"))),
              ):Container(),
              year!=""? Container(
                padding: EdgeInsets.all(2),
                alignment: Alignment.centerLeft,
                child: Text('Year: ' +
                    year, style: GoogleFonts.poppins(
                    fontSize: 13, color: HexColor("#8B9EB0"))),
              ):Container(),
              rent!=""? Container(
                padding: EdgeInsets.all(2),
                alignment: Alignment.centerLeft,
                child: Text('Rent: ' +
                    rent, style: GoogleFonts.poppins(
                    fontSize: 13, color: HexColor("#8B9EB0"))),
              ):Container(),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  buttonName1!=""? ElevatedButton(
                      style: ElevatedButton
                          .styleFrom(
                        onPrimary:
                        Colors.white,
                        primary:
                        Theme.of(context).accentColor,
                        minimumSize:
                        Size(88,
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
                          () async {
                            _function1.call();
                      },
                      child: Text(
                          "$buttonName1")):Container(),
                  SizedBox(width: 10,),
                  buttonName2!=""?ElevatedButton(
                      style: ElevatedButton
                          .styleFrom(
                        onPrimary:
                        Colors.white,
                        primary:
                        Theme.of(context).accentColor,
                        minimumSize:
                        Size(88,
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
                          () async {
                            _function2.call();
                      },
                      child: Text(
                          "$buttonName2")):Container(),
                ],
              )
            ],
          ),
        ));
  }
}
