import 'dart:async';
import 'dart:io';

import 'package:aim_cab/screens/drivers/DriverDashBoard.dart';
import 'package:aim_cab/screens/user/api/api_service.dart';
import 'package:aim_cab/screens/user/model/DriverRegisterModal.dart';
import 'package:aim_cab/screens/user/model/VehicleData.dart';
import 'package:aim_cab/screens/vendor/VendorDashBoard.dart';
import 'package:aim_cab/utils/util.dart';
import 'package:aim_cab/screens/user/model/Vehicle.dart' as vehicle;
import 'package:dio/dio.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:flutter_svg/svg.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

class DriverRegistration extends StatefulWidget {
  @override
  _DriverRegistrationState createState() => _DriverRegistrationState();
}

class _DriverRegistrationState extends State<DriverRegistration> {
  bool _isVehicle = false;
  bool _haveVehicle = true;
  bool _isPersonal = false;
  bool _isHidden = true;
  PickedFile carSide1File;
  PickedFile carSide2File;
  PickedFile carSide3File;
  PickedFile carSide4File;
  PickedFile docSide1File;
  PickedFile docSide2File;
  PickedFile docSide3File;
  PickedFile docSide4File;

  bool isMale = true;
  List<String> rideType = <String>[];
  String selectedRideType = "";
  bool isAgree = false;
  final DateFormat formatter = DateFormat('dd-MMMM-yyyy');
  TextEditingController usernameEdit = TextEditingController();
  TextEditingController passwordEdit = TextEditingController();
  TextEditingController mobileEdit = TextEditingController();
  TextEditingController nameEdit = TextEditingController();
  TextEditingController genderEdit = TextEditingController();
  TextEditingController dobEdit = TextEditingController();
  TextEditingController emailEdit = TextEditingController();
  TextEditingController licenceEdit = TextEditingController();
  TextEditingController typeOfVehicleEdit = TextEditingController();
  TextEditingController brandNameEdit = TextEditingController();
  TextEditingController modelEdit = TextEditingController();
  TextEditingController yearEdit = TextEditingController();
  TextEditingController platNumber = TextEditingController();
  DateTime _selectedDate;
  final _formKey = GlobalKey<FormState>();
  @override
  void initState() {
    // TODO: implement initState
    loadData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size sizeScreen = MediaQuery.of(context).size;

    return Scaffold(
      body: Container(
        margin: EdgeInsets.only(top: 50),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                margin: EdgeInsets.symmetric(horizontal: 20),
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                          height: 100,
                          child: Image.asset("assets/images/aimlogo.jpeg")),
                      Text(
                        "SIGN UP",
                        style: GoogleFonts.poppins(
                            fontSize: 25, color: Colors.black),
                      ),
                      SizedBox(height: 20),
                      Neumorphic(
                        child: Container(
                          margin: EdgeInsets.all(10),
                          child: TextFormField(
                            validator: (value) {
                              Pattern pattern =
                                  r'^[a-zA-Z0-9]([._-](?![._-])|[a-zA-Z0-9]){3,18}[a-zA-Z0-9]$';
                              RegExp regex = new RegExp(pattern);
                              if (!regex.hasMatch(value))
                                return 'Enter Valid Username,should be of more then 5 character and should not contain special character';
                              else
                                return null;
                            },
                            controller: usernameEdit,
                            decoration: InputDecoration(
                                isDense: true,
                                border: InputBorder.none,
                                focusedBorder: InputBorder.none,
                                enabledBorder: InputBorder.none,
                                errorBorder: InputBorder.none,
                                labelText: "Enter User Name"),
                          ),
                        ),
                      ),
                      SizedBox(height: 10),
                      SizedBox(height: 10),
                      Neumorphic(
                        child: Container(
                          margin: EdgeInsets.all(10),
                          child: TextFormField(
                            validator: MultiValidator([
                              EmailValidator(
                                  errorText: 'Please enter valid email '),
                              MinLengthValidator(4,
                                  errorText: 'Please enter valid email')
                            ]),
                            controller: emailEdit,
                            keyboardType: TextInputType.emailAddress,
                            decoration: InputDecoration(
                                isDense: true,
                                border: InputBorder.none,
                                focusedBorder: InputBorder.none,
                                enabledBorder: InputBorder.none,
                                errorBorder: InputBorder.none,
                                labelText: "Enter Email"),
                          ),
                        ),
                      ),
                      SizedBox(height: 10),
                      Neumorphic(
                        child: Container(
                          margin: EdgeInsets.all(10),
                          child: TextFormField(
                            validator: MultiValidator([
                              MinLengthValidator(10,
                                  errorText: 'Please enter valid mobile '),
                              MaxLengthValidator(10,
                                  errorText: 'Please enter valid mobile ')
                            ]),
                            controller: mobileEdit,
                            keyboardType: TextInputType.phone,
                            decoration: InputDecoration(
                                isDense: true,
                                border: InputBorder.none,
                                focusedBorder: InputBorder.none,
                                enabledBorder: InputBorder.none,
                                errorBorder: InputBorder.none,
                                labelText: "Enter Mobile"),
                          ),
                        ),
                      ),
                      SizedBox(height: 10),
                      Neumorphic(
                        child: Container(
                          margin: EdgeInsets.all(10),
                          child: TextFormField(
                            validator: (value) {
                              if (value == null ||
                                  value.isEmpty ||
                                  value.length < 6) {
                                return 'Please enter some text of 6 char';
                              }
                              return null;
                            },
                            controller: passwordEdit,
                            obscureText: _isHidden,
                            decoration: InputDecoration(
                                suffixIcon: InkWell(
                                  onTap: () {
                                    setState(() {
                                      _isHidden = !_isHidden;
                                    });
                                  },
                                  child: _isHidden
                                      ? Icon(Icons.visibility_off)
                                      : Icon(Icons.visibility),
                                ),
                                isDense: true,
                                border: InputBorder.none,
                                focusedBorder: InputBorder.none,
                                enabledBorder: InputBorder.none,
                                errorBorder: InputBorder.none,
                                labelText: "Enter Password"),
                          ),
                        ),
                      ),
                      SizedBox(height: 10),
                      Column(
                        children: [
                          SizedBox(height: 10),
                          Container(
                            alignment: Alignment.topLeft,
                            margin: EdgeInsets.only(top: 10, right: 20),
                            child: TextButton(
                              onPressed: () {
                                setState(() {
                                  _isVehicle = !_isVehicle;
                                });
                              },
                              child: Row(
                                children: [
                                  Text(
                                    "Vehicle Information   ",
                                    style: GoogleFonts.poppins(
                                        fontSize: 14,
                                        fontWeight: FontWeight.normal,
                                        color: Theme.of(context).primaryColor),
                                  ),
                                  Icon(
                                    _isVehicle
                                        ? Icons.arrow_upward
                                        : Icons.arrow_downward,
                                    color: HexColor(textColor),
                                  )
                                ],
                              ),
                            ),
                          ),
                          Visibility(
                              visible: _isVehicle,
                              child: Column(
                                children: [
                                  Container(
                                    margin: EdgeInsets.symmetric(
                                        vertical: 10, horizontal: 5),
                                    child: Row(
                                      children: [
                                        Text(
                                          "Do you own a vehicle?",
                                          style: GoogleFonts.poppins(
                                              color: HexColor(textColor),
                                              fontSize: 13,
                                              fontWeight: FontWeight.bold),
                                        ),
                                        Container(
                                          margin: EdgeInsets.all(5),
                                          child: NeumorphicRadio(
                                            style: NeumorphicRadioStyle(
                                              selectedColor: Theme.of(context)
                                                  .primaryColor,
                                            ),
                                            isEnabled: true,
                                            groupValue: _haveVehicle,
                                            value: true,
                                            onChanged: (val) {
                                              setState(() {
                                                _haveVehicle = true;
                                              });
                                              setDriverWithCar(true);
                                            },
                                            child: Container(
                                                margin: EdgeInsets.all(5),
                                                child: Text("Yes",
                                                    style: GoogleFonts.poppins(
                                                        color:
                                                            HexColor(textColor),
                                                        fontWeight:
                                                            FontWeight.bold))),
                                          ),
                                        ),
                                        Container(
                                          margin: EdgeInsets.all(5),
                                          child: NeumorphicRadio(
                                            style: NeumorphicRadioStyle(
                                              selectedColor: Theme.of(context)
                                                  .primaryColor,
                                            ),
                                            groupValue: _haveVehicle,
                                            value: false,
                                            onChanged: (val) {
                                              setState(() {
                                                _haveVehicle = false;
                                              });
                                              setDriverWithCar(false);
                                            },
                                            child: Container(
                                                margin: EdgeInsets.all(5),
                                                child: Text(
                                                  "No",
                                                  style: GoogleFonts.poppins(
                                                      color:
                                                          HexColor(textColor),
                                                      fontWeight:
                                                          FontWeight.bold),
                                                )),
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                  Visibility(
                                    visible: _haveVehicle,
                                    child: Container(
                                      child: Column(
                                        children: [
                                          Neumorphic(
                                            child: Container(
                                              margin: EdgeInsets.all(10),
                                              // child: TextFormField(
                                              //
                                              //   keyboardType: TextInputType.name,
                                              //   validator: (value) {
                                              //     if (value == null || value.isEmpty) {
                                              //       return 'Please type of vehicle';
                                              //     }
                                              //     return null;
                                              //   },
                                              //   controller:typeOfVehicleEdit,
                                              //
                                              //   decoration: InputDecoration(
                                              //       isDense: true,
                                              //       border: InputBorder.none,
                                              //       focusedBorder: InputBorder.none,
                                              //       enabledBorder: InputBorder.none,
                                              //       errorBorder: InputBorder.none,
                                              //
                                              //       labelText: "Enter Type of vehicle"
                                              //   ),
                                              //

                                              child: DropdownSearch<String>(
                                                mode: Mode.MENU,
                                                //showSelectedItem: true,
                                                items: rideType,
                                                // label: "Please select type of vehicle",
                                                //hint: "Please select type of vehicle",

                                                onChanged: (value) {
                                                  selectedRideType = value;
                                                },
                                              ),
                                            ),
                                          ),
                                          SizedBox(height: 10),
                                          Neumorphic(
                                            child: Container(
                                              margin: EdgeInsets.all(10),
                                              child: TextFormField(
                                                keyboardType:
                                                    TextInputType.name,
                                                validator: (value) {
                                                  if (value == null ||
                                                      value.isEmpty ||
                                                      value.length < 4) {
                                                    return 'Please enter brand name';
                                                  }
                                                  return null;
                                                },
                                                controller: brandNameEdit,
                                                decoration: InputDecoration(
                                                    isDense: true,
                                                    border: InputBorder.none,
                                                    focusedBorder:
                                                        InputBorder.none,
                                                    enabledBorder:
                                                        InputBorder.none,
                                                    errorBorder:
                                                        InputBorder.none,
                                                    labelText:
                                                        "Enter brand name"),
                                              ),
                                            ),
                                          ),
                                          SizedBox(height: 10),
                                          Neumorphic(
                                            child: Container(
                                              margin: EdgeInsets.all(10),
                                              child: TextFormField(
                                                keyboardType:
                                                    TextInputType.name,
                                                validator: (value) {
                                                  if (value == null ||
                                                      value.isEmpty ||
                                                      value.length < 3) {
                                                    return 'Please enter model';
                                                  }
                                                  return null;
                                                },
                                                controller: modelEdit,
                                                decoration: InputDecoration(
                                                    isDense: true,
                                                    border: InputBorder.none,
                                                    focusedBorder:
                                                        InputBorder.none,
                                                    enabledBorder:
                                                        InputBorder.none,
                                                    errorBorder:
                                                        InputBorder.none,
                                                    labelText: "Enter Model"),
                                              ),
                                            ),
                                          ),
                                          SizedBox(height: 10),
                                          Neumorphic(
                                            child: Container(
                                              margin: EdgeInsets.all(10),
                                              child: TextFormField(
                                                validator: (value) {
                                                  if (value == null ||
                                                      value.isEmpty) {
                                                    return 'Please enter Year';
                                                  }
                                                  return null;
                                                },
                                                controller: yearEdit,
                                                keyboardType:
                                                    TextInputType.number,
                                                maxLength: 4,
                                                decoration: InputDecoration(
                                                    isDense: true,
                                                    border: InputBorder.none,
                                                    focusedBorder:
                                                        InputBorder.none,
                                                    enabledBorder:
                                                        InputBorder.none,
                                                    errorBorder:
                                                        InputBorder.none,
                                                    labelText: "Enter Year"),
                                              ),
                                            ),
                                          ),
                                          SizedBox(height: 10),
                                          Neumorphic(
                                            child: Container(
                                              margin: EdgeInsets.all(10),
                                              child: TextFormField(
                                                maxLength: 10,
                                                validator: (value) {
                                                  if (value == null ||
                                                      value.isEmpty ||
                                                      value.length != 10) {
                                                    return 'Please enter plate number';
                                                  }
                                                  return null;
                                                },
                                                controller: platNumber,
                                                keyboardType:
                                                    TextInputType.text,
                                                textCapitalization:
                                                    TextCapitalization
                                                        .characters,
                                                decoration: InputDecoration(
                                                    isDense: true,
                                                    border: InputBorder.none,
                                                    focusedBorder:
                                                        InputBorder.none,
                                                    enabledBorder:
                                                        InputBorder.none,
                                                    errorBorder:
                                                        InputBorder.none,
                                                    labelText:
                                                        "Enter Plate number"),
                                              ),
                                            ),
                                          ),
                                          Container(
                                            alignment: Alignment.topRight,
                                            child: TextButton(
                                              onPressed: () {
                                                showVehicle();
                                              },
                                              child: Text(
                                                "Upload photos from 4 sides",
                                                style: GoogleFonts.poppins(
                                                    color: HexColor("#2F80ED"),
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 10),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              )),
                          Container(
                            alignment: Alignment.topLeft,
                            margin: EdgeInsets.only(right: 20, bottom: 10),
                            child: TextButton(
                              onPressed: () {
                                setState(() {
                                  _isPersonal = !_isPersonal;
                                });
                              },
                              child: Row(
                                children: [
                                  Text(
                                    "Personal Information",
                                    style: GoogleFonts.poppins(
                                        fontSize: 14,
                                        fontWeight: FontWeight.normal,
                                        color: Theme.of(context).primaryColor),
                                  ),
                                  Icon(
                                    _isPersonal
                                        ? Icons.arrow_upward
                                        : Icons.arrow_downward,
                                    color: HexColor(textColor),
                                  )
                                ],
                              ),
                            ),
                          ),
                          Visibility(
                            visible: _isPersonal,
                            child: Column(
                              children: [
                                Neumorphic(
                                  child: Container(
                                    margin: EdgeInsets.all(10),
                                    child: TextFormField(
                                      controller: nameEdit,
                                      validator: (value) {
                                        Pattern pattern = r'^[a-z A-Z,.\-]+$';
                                        RegExp regex = new RegExp(pattern);
                                        if (!regex.hasMatch(value))
                                          return 'Enter Valid Full name';
                                        else
                                          return null;
                                      },
                                      decoration: InputDecoration(
                                          isDense: true,
                                          border: InputBorder.none,
                                          focusedBorder: InputBorder.none,
                                          enabledBorder: InputBorder.none,
                                          errorBorder: InputBorder.none,
                                          labelText: "Full Name"),
                                    ),
                                  ),
                                ),
                                SizedBox(height: 10),
                                Container(
                                    alignment: Alignment.topLeft,
                                    margin: EdgeInsets.only(left: 10),
                                    child: Text(
                                      "Gender",
                                      style: GoogleFonts.poppins(
                                          color: HexColor(textColor),
                                          fontSize: 15),
                                    )),
                                RadioListTile(
                                    title: Text("Male",
                                        style: GoogleFonts.poppins(
                                            color: HexColor(textColor),
                                            fontSize: 12)),
                                    value: true,
                                    groupValue: isMale,
                                    onChanged: (val) {
                                      setState(() {
                                        isMale = true;
                                      });
                                    }),
                                RadioListTile(
                                    title: Text(
                                      "Female",
                                      style: GoogleFonts.poppins(
                                          color: HexColor(textColor),
                                          fontSize: 12),
                                    ),
                                    value: false,
                                    groupValue: isMale,
                                    onChanged: (val) {
                                      setState(() {
                                        isMale = false;
                                      });
                                    }),
                                SizedBox(height: 10),
                                GestureDetector(
                                  onTap: () async {
                                    final DateTime picked =
                                        await showDatePicker(
                                      context: context,
                                      initialDate: DateTime.now(),
                                      firstDate: DateTime(1900),
                                      lastDate: DateTime.now(),
                                    );
                                    if (picked != null &&
                                        picked != _selectedDate
                                       // || isAdult(picked.toString()) > 18
                                    )
                                      // print(isAdult(picked.toString()) > 18);
                                      setState(() {
                                        _selectedDate = picked;
                                      });
                                    print("selected date:$_selectedDate");
                                  },
                                  child: Neumorphic(
                                    child: Container(
                                      height: 50,
                                      width: double.infinity,
                                      alignment: Alignment.centerLeft,
                                      margin: EdgeInsets.all(10),
                                      child: Text(
                                        _selectedDate == null
                                            ? "Enter dob"
                                            : isAdult(_selectedDate
                                                            .toString()) >
                                                        18 &&
                                                    _selectedDate != null
                                                ? formatter
                                                    .format(_selectedDate)
                                                : "Minimum required Age is 18",
                                        style: TextStyle(
                                            fontSize: 15,
                                            color: HexColor(textColor)),
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(height: 10),
                                Neumorphic(
                                  child: Container(
                                    margin: EdgeInsets.all(10),
                                    child: TextFormField(
                                      controller: licenceEdit,
                                      validator: (value) {
                                        // Pattern pattern =
                                        //     r'^(([A-Z]{2}[0-9]{2})( )|([A-Z]{2}-[0-9]{2}))((19|20)[0-9][0-9])[0-9]{7}$';
                                        // RegExp regex = new RegExp(pattern);
                                        //if (!regex.hasMatch(value))
                                        if(value.isEmpty)
                                          return 'Enter Valid license ';
                                        else
                                          return null;
                                      },
                                      keyboardType: TextInputType.text,
                                      textCapitalization:
                                          TextCapitalization.characters,
                                      decoration: InputDecoration(
                                          isDense: true,
                                          border: InputBorder.none,
                                          focusedBorder: InputBorder.none,
                                          enabledBorder: InputBorder.none,
                                          errorBorder: InputBorder.none,
                                          labelText: "Licence Number"),
                                    ),
                                  ),
                                ),
                                Container(
                                    alignment: Alignment.topRight,
                                    child: TextButton(
                                        onPressed: () {
                                          showSupportDoc();
                                        },
                                        child: Text(
                                          "Upload supporting documents",
                                          style: GoogleFonts.poppins(
                                              color: HexColor("#2F80ED"),
                                              fontWeight: FontWeight.bold,
                                              fontSize: 10),
                                        )))
                              ],
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              ),
              SizedBox(height: 10),
              Container(
                alignment: Alignment.center,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    NeumorphicCheckbox(
                        padding: EdgeInsets.all(2),
                        value: isAgree,
                        onChanged: (val) {
                          setState(() {
                            isAgree = !isAgree;
                          });
                        }),
                    Container(
                        margin: EdgeInsets.all(10),
                        width: sizeScreen.width - 100,
                        child: Text(
                            "By Signing Up you are agreed to the terms and conditions"))
                  ],
                ),
              ),
              Container(
                child: NeumorphicButton(
                    child: Container(
                        padding: EdgeInsets.all(5),
                        width: 200,
                        child: Center(
                            child: Text(
                          "Sign up",
                          style: GoogleFonts.poppins(
                              color: HexColor("#8B9EB0"), fontSize: 15),
                        ))),
                    onPressed: () async {
                      FocusScope.of(context).requestFocus(FocusNode());

                      if (isAgree) {
                        if (_selectedDate!=null && isAdult(_selectedDate.toString())>18) {
                          if (_formKey.currentState.validate()  ) {
                            showLoader(context);
                            final DateFormat formatter =
                                DateFormat('yyyy-MM-dd');
                            var dio = Dio();
                            dio.options.baseUrl =
                                "http://api.cabandcargo.com//v1.0/";

                            ApiService service = ApiService.create();
                            Response response;
                            if (_haveVehicle) {
                              if (carSide1File != null &&
                                  carSide2File != null &&
                                  carSide3File != null &&
                                  carSide4File != null &&
                                  docSide1File != null &&
                                  docSide2File != null &&
                                  docSide3File != null &&
                                  docSide4File != null) {
                                if (selectedRideType != "") {
                                  var formData = FormData.fromMap({
                                    "name": nameEdit.value.text.toLowerCase(),
                                    "username":
                                        usernameEdit.value.text.toLowerCase(),
                                    "password": passwordEdit.value.text,
                                    "email": emailEdit.value.text.toLowerCase(),
                                    "mobile":
                                        mobileEdit.value.text.toLowerCase(),
                                    "gender": isMale ? "Male" : "Female",
                                    "license_number":
                                        licenceEdit.value.text.toUpperCase(),
                                    "dob": formatter.format(_selectedDate),
                                    "vehicle_type": selectedRideType,
                                    "brand_name":
                                        brandNameEdit.value.text.toLowerCase(),
                                    "model": modelEdit.value.text.toLowerCase(),
                                    "year": yearEdit.value.text.toLowerCase(),
                                    "plate_number":
                                        platNumber.value.text.toLowerCase(),
                                    "login_type": "normal",
                                    "type": "driver",
                                    "own_vehicle": true,
                                    "location": "[22,22]",
                                    "vehicle_image":
                                        await MultipartFile.fromFile(
                                            carSide1File.path),
                                    "vehicle_image":
                                        await MultipartFile.fromFile(
                                            carSide2File.path),
                                    "vehicle_image":
                                        await MultipartFile.fromFile(
                                            carSide3File.path),
                                    "vehicle_image":
                                        await MultipartFile.fromFile(
                                            carSide4File.path),
                                    "driver_document":
                                        await MultipartFile.fromFile(
                                            docSide1File.path),
                                    "driver_document":
                                        await MultipartFile.fromFile(
                                            docSide2File.path),
                                    "driver_document":
                                        await MultipartFile.fromFile(
                                            docSide3File.path),
                                    "driver_document":
                                        await MultipartFile.fromFile(
                                            docSide4File.path),
                                  });
                                  response = await dio.post('/register',
                                      data: formData);
                                } else {
                                  dissmissLoader(context);
                                  showError(context, "Please select ride type");
                                }
                              } else {
                                dissmissLoader(context);
                                showError(context,
                                    "Please upload required documents");
                              }
                            } else {
                              if (docSide1File != null &&
                                  docSide2File != null &&
                                  docSide3File != null &&
                                  docSide4File != null) {
                                var formData = FormData.fromMap({
                                  "name": nameEdit.value.text.toLowerCase(),
                                  "username":
                                      usernameEdit.value.text.toLowerCase(),
                                  "password": passwordEdit.value.text,
                                  "email": emailEdit.value.text.toLowerCase(),
                                  "licence_number":
                                      licenceEdit.value.text.toUpperCase(),
                                  "mobile": mobileEdit.value.text.toLowerCase(),
                                  "gender": isMale ? "Male" : "Female",
                                  "dob": formatter.format(_selectedDate),
                                  "login_type": "normal",
                                  "type": "driver",
                                  "own_vehicle": false,
                                  "location": "[22,22]",
                                  "driver_document":
                                      await MultipartFile.fromFile(
                                          docSide1File.path),
                                  "driver_document":
                                      await MultipartFile.fromFile(
                                          docSide2File.path),
                                  "driver_document":
                                      await MultipartFile.fromFile(
                                          docSide3File.path),
                                  "driver_document":
                                      await MultipartFile.fromFile(
                                          docSide4File.path),
                                });
                                response =
                                    await dio.post('/register', data: formData);
                                print(response);
                              } else {
                                dissmissLoader(context);
                                showError(context,
                                    "Please upload required documents");
                              }
                            }
                            print(response.data);
                            dissmissLoader(context);
                            if (response != null) {
                              DriverRegisterModal userRegistration =
                                  DriverRegisterModal.fromJson(response.data);
                              if (userRegistration.status) {
                                // showOtpVerify(
                                //     userRegistration, userRegistration.token);
                                setDriver(
                                    userRegistration.data.driverdata.toJson(), userRegistration.token);
                                setvehicle(userRegistration.data.vehicleData.toJson());
                                Navigator.pushAndRemoveUntil(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => DriverDashBoard()),
                                        (Route<dynamic> route) => false);
                              } else {
                                showError(context, userRegistration.msg);
                              }
                            }
                          }
                        } else {
                          showError(context, "please select valid date");
                        }
                      } else {
                        showError(context, "Please agree terms and condition");
                      }
                    },
                ),
              ),
              SizedBox(height: 20),
              Container(
                margin: EdgeInsets.all(10),
                alignment: Alignment.bottomCenter,
                child: TextButton(
                    child: Text(
                      "Already have an account? Login",
                      style: GoogleFonts.poppins(color: HexColor(textColor)),
                    ),
                    onPressed: () {
                      Navigator.pop(context);
                    }),
              )
            ],
          ),
        ),
      ),
    );
  }

  double isAdult(String enteredAge) {
    var birthDate = DateFormat('yyyy-mm-dd').parse(enteredAge);
    print("set state: $birthDate");
    var today = DateTime.now();

    final difference = today.difference(birthDate).inDays;
    print(difference);
    final year = difference / 365;
    print(year);
    return year;
  }

  void showOtpVerify(DriverRegisterModal userData, String token) {
    TextEditingController otpText = TextEditingController();
    StreamController<ErrorAnimationType> errorController =
        StreamController<ErrorAnimationType>();
    bool hasError = false;
    showModalBottomSheet<void>(
      isScrollControlled: true,
      context: context,
      isDismissible: false,
      backgroundColor: Colors.transparent,
      builder: (BuildContext context) {
        return Container(
          decoration: new BoxDecoration(
              color: HexColor("D6E3F3"),
              borderRadius: new BorderRadius.only(
                  topLeft: const Radius.circular(50.0),
                  topRight: const Radius.circular(50.0))),
          child: Padding(
            padding: MediaQuery.of(context).viewInsets,
            child: Container(
              margin: EdgeInsets.only(top: 20, bottom: 5, right: 10, left: 10),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Neumorphic(
                                style:
                                    NeumorphicStyle(color: HexColor("#E3EDF7")),
                                child: Container(
                                    padding: EdgeInsets.all(10),
                                    child: SvgPicture.asset(
                                        "assets/images/user_wallet.svg"))),
                            SizedBox(
                              width: 20,
                            ),
                            Text(
                              "Verify otp",
                              style: GoogleFonts.poppins(
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold,
                                  color: Theme.of(context).accentColor),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Center(
                    child: Container(
                      margin:
                          EdgeInsets.symmetric(vertical: 20, horizontal: 30),
                      child: Text(
                          "Verification code had sent to " +
                              emailEdit.text.toLowerCase(),
                          style: GoogleFonts.poppins(
                              fontSize: 13,
                              color: Theme.of(context).primaryColor,
                              fontWeight: FontWeight.normal)),
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    child: PinCodeTextField(
                      appContext: context,
                      obscureText: false,
                      keyboardType: TextInputType.number,
                      length: 6,
                      animationType: AnimationType.scale,
                      controller: otpText,
                      cursorColor: Theme.of(context).primaryColor,
                      errorAnimationController: errorController,
                      pinTheme: PinTheme(
                          shape: PinCodeFieldShape.box,
                          borderRadius: BorderRadius.circular(5),
                          fieldHeight: 50,
                          fieldWidth: 40,
                          inactiveColor: Theme.of(context).primaryColor,
                          activeFillColor: Colors.blue.shade100),
                      boxShadows: [
                        BoxShadow(
                          offset: Offset(0, 1),
                          color: HexColor("D6E3F3"),
                          blurRadius: 25,
                        )
                      ],
                      onChanged: (String value) {},
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(top: 20, bottom: 20),
                    child: NeumorphicButton(
                        style: NeumorphicStyle(color: HexColor("#E3EDF7")),
                        child: Container(
                            padding: EdgeInsets.all(5),
                            width: 200,
                            child: Center(
                                child: Text(
                              "VERIFY OTP",
                              style: GoogleFonts.poppins(
                                  color: HexColor("#8B9EB0"), fontSize: 18),
                            ))),
                        onPressed: () async {
                          ApiService service = ApiService.create();

                          if (otpText.text.length == 6) {
                            showLoader(context);
                            var res = await service.verifyOtp({
                              "otp": otpText.text.toString(),
                              "email_address": emailEdit.text.toString()
                            });
                            dissmissLoader(context);
                            if (res.body['status'] == true) {
                              setDriver(
                                  userData.data.driverdata.toJson(), token);
                              setvehicle(userData.data.vehicleData.toJson());
                              Navigator.pushAndRemoveUntil(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => DriverDashBoard()),
                                  (Route<dynamic> route) => false);
                            } else {
                              errorController.add(ErrorAnimationType.shake);
                              showError(context, res.body["msg"]);
                            }
                          } else {
                            errorController.add(ErrorAnimationType.shake);
                          }
                        }),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  void showVehicle() {
    showModalBottomSheet<void>(
      isScrollControlled: true,
      context: context,
      isDismissible: true,
      backgroundColor: Colors.transparent,
      builder: (BuildContext context) {
        return Container(
          decoration: new BoxDecoration(
              color: HexColor("FFFFFF"),
              borderRadius: new BorderRadius.only(
                  topLeft: const Radius.circular(25.0),
                  topRight: const Radius.circular(25.0))),
          child: Padding(
            padding: MediaQuery.of(context).viewInsets,
            child: StatefulBuilder(builder: (BuildContext context,
                StateSetter state /*You can rename this!*/) {
              return Container(
                margin:
                    EdgeInsets.only(top: 20, bottom: 5, right: 10, left: 10),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Container(
                      alignment: Alignment.topLeft,
                      margin: EdgeInsets.only(left: 20),
                      child: Text(
                        "Vehicle Images Upload",
                        style: GoogleFonts.poppins(
                            color: HexColor(textColor), fontSize: 15),
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(top: 20, bottom: 20),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          NeumorphicButton(
                              style:
                                  NeumorphicStyle(color: HexColor("#FFFFFF")),
                              child: Container(
                                  padding: EdgeInsets.all(5),
                                  width: 250,
                                  child: Center(
                                      child: Text(
                                    "Front View",
                                    style: GoogleFonts.poppins(
                                        color: HexColor("#8B9EB0"),
                                        fontSize: 18),
                                  ))),
                              onPressed: () async {
                                final _picker = ImagePicker();
                                carSide1File = await _picker.getImage(
                                    source: ImageSource.gallery);
                                state(() {});
                              }),
                          SizedBox(
                            width: 5,
                          ),
                          carSide1File == null
                              ? Container()
                              : Center(
                                  child: ClipRRect(
                                      borderRadius: BorderRadius.circular(8.0),
                                      child: Image.file(
                                        File(carSide1File.path),
                                        height: 50,
                                        width: 45,
                                        fit: BoxFit.fill,
                                      )))
                        ],
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(top: 20, bottom: 20),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          NeumorphicButton(
                              style:
                                  NeumorphicStyle(color: HexColor("#FFFFFF")),
                              child: Container(
                                  padding: EdgeInsets.all(5),
                                  width: 250,
                                  child: Center(
                                      child: Text(
                                    "Leaft View",
                                    style: GoogleFonts.poppins(
                                        color: HexColor("#8B9EB0"),
                                        fontSize: 18),
                                  ))),
                              onPressed: () async {
                                final _picker = ImagePicker();
                                carSide2File = await _picker.getImage(
                                    source: ImageSource.gallery);
                                state(() {});
                              }),
                          SizedBox(
                            width: 5,
                          ),
                          carSide2File == null
                              ? Container()
                              : Center(
                                  child: ClipRRect(
                                      borderRadius: BorderRadius.circular(8.0),
                                      child: Image.file(
                                        File(carSide2File.path),
                                        height: 50,
                                        width: 45,
                                        fit: BoxFit.fill,
                                      )))
                        ],
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(top: 20, bottom: 20),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          NeumorphicButton(
                              style:
                                  NeumorphicStyle(color: HexColor("#FFFFFF")),
                              child: Container(
                                  padding: EdgeInsets.all(5),
                                  width: 250,
                                  child: Center(
                                      child: Text(
                                    "Back View",
                                    style: GoogleFonts.poppins(
                                        color: HexColor("#8B9EB0"),
                                        fontSize: 18),
                                  ))),
                              onPressed: () async {
                                final _picker = ImagePicker();
                                carSide3File = await _picker.getImage(
                                    source: ImageSource.gallery);
                                state(() {});
                              }),
                          SizedBox(
                            width: 5,
                          ),
                          carSide3File == null
                              ? Container()
                              : Center(
                                  child: ClipRRect(
                                      borderRadius: BorderRadius.circular(8.0),
                                      child: Image.file(
                                        File(carSide3File.path),
                                        height: 50,
                                        width: 45,
                                        fit: BoxFit.fill,
                                      )))
                        ],
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(top: 20, bottom: 20),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          NeumorphicButton(
                              style:
                                  NeumorphicStyle(color: HexColor("#FFFFFF")),
                              child: Container(
                                  padding: EdgeInsets.all(5),
                                  width: 250,
                                  child: Center(
                                      child: Text(
                                    "Right View",
                                    style: GoogleFonts.poppins(
                                        color: HexColor("#8B9EB0"),
                                        fontSize: 18),
                                  ))),
                              onPressed: () async {
                                final _picker = ImagePicker();
                                carSide4File = await _picker.getImage(
                                    source: ImageSource.gallery);
                                state(() {});
                              }),
                          SizedBox(
                            width: 5,
                          ),
                          carSide4File == null
                              ? Container()
                              : Center(
                                  child: ClipRRect(
                                      borderRadius: BorderRadius.circular(8.0),
                                      child: Image.file(
                                        File(carSide4File.path),
                                        height: 50,
                                        width: 45,
                                        fit: BoxFit.fill,
                                      )))
                        ],
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(top: 20, bottom: 20),
                      child: TextButton(
                          child: Container(
                              padding: EdgeInsets.all(5),
                              width: 200,
                              child: Center(
                                  child: Text(
                                "Done",
                                style: GoogleFonts.poppins(
                                    color: Theme.of(context).primaryColor,
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold),
                              ))),
                          onPressed: () async {
                            Navigator.of(context).pop();
                          }),
                    ),
                  ],
                ),
              );
            }),
          ),
        );
      },
    );
  }

  void showSupportDoc() {
    showModalBottomSheet<void>(
      isScrollControlled: true,
      context: context,
      isDismissible: true,
      backgroundColor: Colors.transparent,
      builder: (BuildContext context) {
        return Container(
          decoration: new BoxDecoration(
              color: HexColor("FFFFFF"),
              borderRadius: new BorderRadius.only(
                  topLeft: const Radius.circular(25.0),
                  topRight: const Radius.circular(25.0))),
          child: Padding(
            padding: MediaQuery.of(context).viewInsets,
            child: StatefulBuilder(builder: (BuildContext context,
                StateSetter state /*You can rename this!*/) {
              return Container(
                margin:
                    EdgeInsets.only(top: 20, bottom: 5, right: 10, left: 10),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Container(
                      alignment: Alignment.topLeft,
                      margin: EdgeInsets.only(left: 20),
                      child: Text(
                        "Supporting document Upload",
                        style: GoogleFonts.poppins(
                            color: HexColor(textColor), fontSize: 15),
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(top: 20, bottom: 20),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          NeumorphicButton(
                              style:
                                  NeumorphicStyle(color: HexColor("#FFFFFF")),
                              child: Container(
                                  padding: EdgeInsets.all(5),
                                  width: 250,
                                  child: Center(
                                      child: Text(
                                    "Driver licence",
                                    style: GoogleFonts.poppins(
                                        color: HexColor("#8B9EB0"),
                                        fontSize: 18),
                                  ))),
                              onPressed: () async {
                                final _picker = ImagePicker();
                                docSide1File = await _picker.getImage(
                                    source: ImageSource.gallery);
                                state(() {});
                              }),
                          SizedBox(
                            width: 5,
                          ),
                          docSide1File == null
                              ? Container()
                              : Center(
                                  child: ClipRRect(
                                      borderRadius: BorderRadius.circular(8.0),
                                      child: Image.file(
                                        File(docSide1File.path),
                                        height: 50,
                                        width: 45,
                                        fit: BoxFit.fill,
                                      ),),),
                        ],
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(top: 20, bottom: 20),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          NeumorphicButton(
                              style:
                                  NeumorphicStyle(color: HexColor("#FFFFFF")),
                              child: Container(
                                  padding: EdgeInsets.all(5),
                                  width: 250,
                                  child: Center(
                                      child: Text(
                                    "Govt. ID proof",
                                    style: GoogleFonts.poppins(
                                        color: HexColor("#8B9EB0"),
                                        fontSize: 18),
                                  ))),
                              onPressed: () async {
                                final _picker = ImagePicker();
                                docSide2File = await _picker.getImage(
                                    source: ImageSource.gallery);
                                state(() {});
                              }),
                          SizedBox(
                            width: 5,
                          ),
                          docSide2File == null
                              ? Container()
                              : Center(
                                  child: ClipRRect(
                                      borderRadius: BorderRadius.circular(8.0),
                                      child: Image.file(
                                        File(docSide2File.path),
                                        height: 50,
                                        width: 45,
                                        fit: BoxFit.fill,
                                      ),),),
                        ],
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(top: 20, bottom: 20),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          NeumorphicButton(
                              style:
                                  NeumorphicStyle(color: HexColor("#FFFFFF")),
                              child: Container(
                                  padding: EdgeInsets.all(5),
                                  width: 250,
                                  child: Center(
                                      child: Text(
                                    "Vehicle ID proof",
                                    style: GoogleFonts.poppins(
                                        color: HexColor("#8B9EB0"),
                                        fontSize: 18),
                                  ))),
                              onPressed: () async {
                                final _picker = ImagePicker();
                                docSide3File = await _picker.getImage(
                                    source: ImageSource.gallery);
                                state(() {});
                              }),
                          SizedBox(
                            width: 5,
                          ),
                          docSide3File == null
                              ? Container()
                              : Center(
                                  child: ClipRRect(
                                      borderRadius: BorderRadius.circular(8.0),
                                      child: Image.file(
                                        File(docSide3File.path),
                                        height: 50,
                                        width: 45,
                                        fit: BoxFit.fill,
                                      ),),),
                        ],
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(top: 20, bottom: 20),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          NeumorphicButton(
                              style:
                                  NeumorphicStyle(color: HexColor("#FFFFFF")),
                              child: Container(
                                  padding: EdgeInsets.all(5),
                                  width: 250,
                                  child: Center(
                                      child: Text(
                                    "Address Proof",
                                    style: GoogleFonts.poppins(
                                        color: HexColor("#8B9EB0"),
                                        fontSize: 18),
                                  ))),
                              onPressed: () async {
                                final _picker = ImagePicker();
                                docSide4File = await _picker.getImage(
                                    source: ImageSource.gallery);
                                state(() {});
                              }),
                          SizedBox(
                            width: 5,
                          ),
                          docSide4File == null
                              ? Container()
                              : Center(
                                  child: ClipRRect(
                                      borderRadius: BorderRadius.circular(8.0),
                                      child: Image.file(
                                        File(docSide4File.path),
                                        height: 50,
                                        width: 45,
                                        fit: BoxFit.fill,
                                      ),),),
                        ],
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(top: 20, bottom: 20),
                      child: TextButton(
                          child: Container(
                              padding: EdgeInsets.all(5),
                              width: 200,
                              child: Center(
                                  child: Text(
                                "Done",
                                style: GoogleFonts.poppins(
                                    color: Theme.of(context).primaryColor,
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold),
                              ))),
                          onPressed: () async {
                            Navigator.of(context).pop();
                          }),
                    ),
                  ],
                ),
              );
            }),
          ),
        );
      },
    );
  }

  Future<void> loadData() async {
    var dio = Dio();
    dio.options.baseUrl = appUrl;
    showLoader(context);
    rideType.clear();

    var response = await dio.get('/get-vehicle');
    var vechicleType = RideData.fromJson(response.data);
    vechicleType.data.forEach((element) {
      rideType.add(element.vehicleType);
    });
    setState(() {});
    dissmissLoader(context);
  }
}
