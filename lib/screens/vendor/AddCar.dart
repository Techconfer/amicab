import 'dart:convert';

import 'package:aim_cab/utils/util.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;



class AddCar extends StatefulWidget {
  @override
  _UserCreatePasswordState createState() => _UserCreatePasswordState();
}

class _UserCreatePasswordState extends State<AddCar> {

  final _formKey = GlobalKey<FormState>();
  TextEditingController Vehicle_type_Controller=TextEditingController();
  TextEditingController Band_name_Controller=TextEditingController();
  TextEditingController Model_Controller=TextEditingController();
  TextEditingController Year_Controller=TextEditingController();
  TextEditingController Plat_no_Controller=TextEditingController();
  TextEditingController Rent_Controller=TextEditingController();
  bool isOwnVehicle=false;
  bool isLoading=false;
  PickedFile vehicleImagePath=null;
  PickedFile DriverDocumentPath=null;

void callSubmitApi() async {
  setState(() {
    isLoading=true;
  });
  //for multipartrequest
  var token=await getToken();
  var request = http.MultipartRequest('POST', Uri.parse('http://aim.inawebtech.com/v1.0/add-cars'));

  //for token
  request.headers.addAll({
    "Authorization" :token
  });

  //for image and videos and files

  request.files.add(await http.MultipartFile.fromPath("vehicle_image", "${vehicleImagePath.path}"));
  request.files.add(await http.MultipartFile.fromPath("driver_document", "${DriverDocumentPath.path}"));
  request.fields['vehicle_type'] = Vehicle_type_Controller.text.toString();
  request.fields['own_vehicle'] = isOwnVehicle.toString();
  request.fields['brand_name'] =Band_name_Controller.text.toString();
  request.fields['model'] = Model_Controller.text.toString();
  request.fields['year'] = Year_Controller.text.toString();
  request.fields['plate_number'] =Plat_no_Controller.text.toString();
  request.fields['rent'] =Rent_Controller.text.toString();

  //for completeing the request
  var response =await request.send();

  //for getting and decoding the response into json format
  var responsed = await http.Response.fromStream(response);
  final responseData = json.decode(responsed.body);

  if (response.statusCode==200) {
    isLoading=false;
  setState(() {
    isLoading=false;
  });
    Fluttertoast.showToast(msg: responseData["msg"]);
  print("SUCCESS");
  print(responseData);
  }
  else {
    isLoading=false;
    Fluttertoast.showToast(msg: "Something Went Wrong");

  }
}

  @override
  Widget build(BuildContext context) {
    Size sizeScreen = MediaQuery.of(context).size;
    return Scaffold(


      body: Stack(
        children: [
          Container(

            child: SafeArea(
              child: Stack(
                children: [
                  SingleChildScrollView(
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

                            Expanded(child: Center(child: Text("Add Car",style: GoogleFonts.poppins(fontSize: 25,fontWeight: FontWeight.bold,color:Theme.of(context).accentColor),)))

                          ],

                        ),
                      ),
                      Container(
                        margin: EdgeInsets.symmetric(horizontal: 20),
                        child: Form(
                          key: _formKey,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [

                              SizedBox(height:20),
                              Neumorphic(
                                child: Container(
                                  margin: EdgeInsets.all(10),
                                  child: TextFormField(
                                    keyboardType: TextInputType.text,
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return 'Please enter some text';
                                      }
                                      return null;
                                    },
                                    controller:Vehicle_type_Controller,
                                    decoration: InputDecoration(
                                        isDense: true,
                                        border: InputBorder.none,
                                        focusedBorder: InputBorder.none,
                                        enabledBorder: InputBorder.none,
                                        errorBorder: InputBorder.none,
                                        labelText: "Vehicle Type"
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(height:20),
                              Neumorphic(
                                child: Row(
                                  children: [
                                    Container(
                                      margin: EdgeInsets.all(10),
                                      child:   Checkbox(
                                        value: isOwnVehicle,
                                        onChanged: (value1) async{

                                          setState(() {
                                            isOwnVehicle = value1;
                                          });
                                        },
                                      ),
                                    ),
                                    Text("Your Own Vehicle")
                                  ],
                                ),
                              ),


                              SizedBox(height:20),
                              Neumorphic(
                                child: Container(
                                  margin: EdgeInsets.all(10),
                                  child: TextFormField(
                                    keyboardType: TextInputType.text,
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return 'Please enter some text';
                                      }
                                      return null;
                                    },
                                    controller:Band_name_Controller,
                                    decoration: InputDecoration(
                                        isDense: true,
                                        border: InputBorder.none,
                                        focusedBorder: InputBorder.none,
                                        enabledBorder: InputBorder.none,
                                        errorBorder: InputBorder.none,
                                        labelText: "Brand Name"
                                    ),
                                  ),
                                ),
                              ),

                              SizedBox(height:20),
                              Neumorphic(
                                child: Container(
                                  margin: EdgeInsets.all(10),
                                  child: TextFormField(
                                    keyboardType: TextInputType.text,
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return 'Please enter some text';
                                      }
                                      return null;
                                    },
                                    controller:Model_Controller,
                                    decoration: InputDecoration(
                                        isDense: true,
                                        border: InputBorder.none,
                                        focusedBorder: InputBorder.none,
                                        enabledBorder: InputBorder.none,
                                        errorBorder: InputBorder.none,
                                        labelText: "Model"
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(height:20),

                              Neumorphic(
                                child: Container(
                                  margin: EdgeInsets.all(10),
                                  child: TextFormField(
                                    keyboardType: TextInputType.text,
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return 'Please enter some text';
                                      }
                                      return null;
                                    },
                                    controller:Year_Controller,
                                    decoration: InputDecoration(
                                        isDense: true,
                                        border: InputBorder.none,
                                        focusedBorder: InputBorder.none,
                                        enabledBorder: InputBorder.none,
                                        errorBorder: InputBorder.none,
                                        labelText: "Year"
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(height:20),

                              Neumorphic(
                                child: Container(
                                  margin: EdgeInsets.all(10),
                                  child: TextFormField(
                                    keyboardType: TextInputType.text,
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return 'Please enter some text';
                                      }
                                      return null;
                                    },
                                    controller:Plat_no_Controller,
                                    decoration: InputDecoration(
                                        isDense: true,
                                        border: InputBorder.none,
                                        focusedBorder: InputBorder.none,
                                        enabledBorder: InputBorder.none,
                                        errorBorder: InputBorder.none,
                                        labelText: "Plate Number"
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(height:20),

                              Neumorphic(
                                child: Container(
                                  margin: EdgeInsets.all(10),
                                  child: TextFormField(
                                    keyboardType: TextInputType.text,
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return 'Please enter some text';
                                      }
                                      return null;
                                    },
                                    controller:Rent_Controller,
                                    decoration: InputDecoration(
                                        isDense: true,
                                        border: InputBorder.none,
                                        focusedBorder: InputBorder.none,
                                        enabledBorder: InputBorder.none,
                                        errorBorder: InputBorder.none,
                                        labelText: "Rent"
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(height:20),

                              NeumorphicButton(
                                  child: Container(
                                      margin: EdgeInsets.all(0),
                                      width: sizeScreen.width,
                                      height: 40,
                                      child: Container(child:vehicleImagePath==null? Text("Vehicle Image",style: GoogleFonts.poppins(color: HexColor("#8B9EB0"),fontSize: 16),):Container(
                                          child: Text("${vehicleImagePath.path}",style: GoogleFonts.poppins(color: HexColor("#8B9EB0"),fontSize: 16),
                                          )))),
                                  onPressed: () async {

                                    final _picker = ImagePicker();
                                    vehicleImagePath= await _picker.getImage(source: ImageSource.gallery);
                                    setState(() {

                                    });

                                  }),
                              SizedBox(height:20),

                              NeumorphicButton(
                                  child: Container(
                                      margin: EdgeInsets.all(0),
                                      width: sizeScreen.width,
                                      height: 40,
                                      child: Container(child:DriverDocumentPath==null? Text("Driver Document",style: GoogleFonts.poppins(color: HexColor("#8B9EB0"),fontSize: 16),):Container(
                                        child: Text("${DriverDocumentPath.path}",style: GoogleFonts.poppins(color: HexColor("#8B9EB0"),fontSize: 16),
                                      )))),
                                  onPressed: () async {

                                    final _picker = ImagePicker();
                                    DriverDocumentPath= await _picker.getImage(source: ImageSource.gallery);
                                    setState(() {

                                    });

                                  }),
                              SizedBox(height:20),

                              Container(
                                alignment: Alignment.bottomCenter,
                                margin: EdgeInsets.symmetric(horizontal: 30,vertical: 10),
                                child: NeumorphicButton(


                                    child: Container(


                                        width: sizeScreen.width,
                                        height: 40,
                                        child: Center(child: Text("SUBMIT",style: GoogleFonts.poppins(color: HexColor("#8B9EB0"),fontSize: 18),))),
                                    onPressed: () async {


                                      if (Vehicle_type_Controller.text.isEmpty) {
                                        Fluttertoast.showToast(
                                            msg: "Vehicle Type",
                                            toastLength: Toast.LENGTH_SHORT,
                                            gravity: ToastGravity.BOTTOM,
                                            timeInSecForIosWeb: 1,
                                            backgroundColor: Colors.red,
                                            textColor: Colors.white,
                                            fontSize: 16.0);

                                      }else if(Band_name_Controller.text.isEmpty){
                                        Fluttertoast.showToast(
                                            msg: "Brand Name",
                                            toastLength: Toast.LENGTH_SHORT,
                                            gravity: ToastGravity.BOTTOM,
                                            timeInSecForIosWeb: 1,
                                            backgroundColor: Colors.red,
                                            textColor: Colors.white,
                                            fontSize: 16.0);


                                      }
                                      else if(Model_Controller.text.isEmpty){
                                        Fluttertoast.showToast(
                                            msg: "Model",
                                            toastLength: Toast.LENGTH_SHORT,
                                            gravity: ToastGravity.BOTTOM,
                                            timeInSecForIosWeb: 1,
                                            backgroundColor: Colors.red,
                                            textColor: Colors.white,
                                            fontSize: 16.0);


                                      }
                                      else if(Year_Controller.text.isEmpty){
                                        Fluttertoast.showToast(
                                            msg: "Year",
                                            toastLength: Toast.LENGTH_SHORT,
                                            gravity: ToastGravity.BOTTOM,
                                            timeInSecForIosWeb: 1,
                                            backgroundColor: Colors.red,
                                            textColor: Colors.white,
                                            fontSize: 16.0);


                                      }
                                      else if(Plat_no_Controller.text.isEmpty){
                                        Fluttertoast.showToast(
                                            msg: "Plate Number",
                                            toastLength: Toast.LENGTH_SHORT,
                                            gravity: ToastGravity.BOTTOM,
                                            timeInSecForIosWeb: 1,
                                            backgroundColor: Colors.red,
                                            textColor: Colors.white,
                                            fontSize: 16.0);


                                      }
                                      else if(Rent_Controller.text.isEmpty){
                                        Fluttertoast.showToast(
                                            msg: "Rent",
                                            toastLength: Toast.LENGTH_SHORT,
                                            gravity: ToastGravity.BOTTOM,
                                            timeInSecForIosWeb: 1,
                                            backgroundColor: Colors.red,
                                            textColor: Colors.white,
                                            fontSize: 16.0);


                                      }else if(vehicleImagePath ==null || DriverDocumentPath==null){
                                        Fluttertoast.showToast(
                                            msg: "Select images",
                                            toastLength: Toast.LENGTH_SHORT,
                                            gravity: ToastGravity.BOTTOM,
                                            timeInSecForIosWeb: 1,
                                            backgroundColor: Colors.red,
                                            textColor: Colors.white,
                                            fontSize: 16.0);


                                      }
                                      else{
                                          callSubmitApi();

                                      }



                                    }),
                              ),


                            ],
                          ),
                        ),
                      ),












                    ],
                  ),
                ),


                ],
              ),
            ),
          ),
          Visibility(
            visible: isLoading,
              child: Container(
            height: double.infinity,
            width: double.infinity,
            color: Colors.white.withOpacity(0.8),
            child: Center(
              child: Container(
                height: 60,
                width: 60,
                child: CircularProgressIndicator()),
            ),
          ))
        ],
      ),
    );
  }
}