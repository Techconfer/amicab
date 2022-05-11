import 'dart:async';
import 'package:aim_cab/screens/user/screens/DashBoard.dart';
import 'package:aim_cab/screens/user/screens/UserLocationScreen.dart';
import 'package:aim_cab/screens/user/api/api_service.dart';
import 'package:aim_cab/screens/user/model/UserRegisterModal.dart';
import 'package:aim_cab/utils/util.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
// import 'package:flutter_icons/flutter_icons.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
// import 'package:flutter_overlay_loader/flutter_overlay_loader.dart';
import 'package:flutter_svg/svg.dart';
// import 'package:fluttertoast/fluttertoast.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:google_fonts/google_fonts.dart';
// import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:location/location.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
// import 'package:provider/provider.dart';

class UserRegistration extends StatefulWidget {
  @override
  _UserRegistrationState createState() => _UserRegistrationState();
}

class _UserRegistrationState extends State<UserRegistration> {
  bool _isPersonal = false;
  bool isMale = true;
  bool isAgree = false;
  final DateFormat formatter = DateFormat('dd-MMMM-yyyy');
  TextEditingController usernameEdit = TextEditingController();
  TextEditingController passwordEdit = TextEditingController();
  TextEditingController mobileEdit = TextEditingController();
  TextEditingController nameEdit = TextEditingController();
  PermissionStatus permissionGranted;
  TextEditingController genderEdit = TextEditingController();
  TextEditingController dobEdit = TextEditingController();
  TextEditingController emailEdit = TextEditingController();
  DateTime _selectedDate;
  bool _isHidden = true;
  final _formKey = GlobalKey<FormState>();

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
                          child: Image.asset("assets/images/login_logo.png")),
                      Text(
                        "SIGN UP",
                        style: GoogleFonts.poppins(
                            fontSize: 25, color: Colors.black),
                      ),
                      SizedBox(height: 10),
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
                      Neumorphic(
                        child: Container(
                          margin: EdgeInsets.all(10),
                          child: TextFormField(
                            validator: EmailValidator(
                                errorText: 'enter a valid email address'),
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
                                return 'Please enter valid password, minimum 6 characters';
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
                              labelText: "Enter Password",
                            ),
                          ),
                        ),
                      ),
                      Column(
                        children: [
                          SizedBox(height: 10),
                          Container(
                            alignment: Alignment.topLeft,
                            margin:
                                EdgeInsets.only(top: 20, right: 20, bottom: 10),
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
                                        if (!regex.hasMatch(value) ||
                                            value.length < 5)
                                          return 'Enter Valid Full name, should be more than 5 characters';
                                        else
                                          return null;
                                      },
                                      decoration: InputDecoration(
                                        isDense: true,
                                        border: InputBorder.none,
                                        focusedBorder: InputBorder.none,
                                        enabledBorder: InputBorder.none,
                                        errorBorder: InputBorder.none,
                                        labelText: "Full Name",
                                      ),
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
                                    var dateVal = DateTime.now();
                                    if (picked != null &&
                                        picked != _selectedDate) {
                                      if (dateVal.year - picked.year >= 18) {
                                        setState(() {
                                          _selectedDate = picked;
                                        });
                                      } else {
                                        showError(context,
                                            "Please select date of birth for 18+");
                                      }
                                    }
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
                                            : formatter.format(_selectedDate),
                                        style: TextStyle(
                                            fontSize: 15,
                                            color: HexColor(textColor)),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          )
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
                            isAgree = val;
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
                        if (_selectedDate != null) {
                          if (_formKey.currentState.validate()) {
                            showLoader(context);
                            final DateFormat formatter =
                                DateFormat('yyyy-MM-dd');
                            var dio = Dio();
                            dio.options.baseUrl =
                                "http://api.cabandcargo.com/v1.0/";
                            var formData = FormData.fromMap(({
                              "name": nameEdit.value.text.toLowerCase(),
                              "username": usernameEdit.value.text.toLowerCase(),
                              "password": passwordEdit.value.text,
                              "email": emailEdit.value.text.toLowerCase(),
                              "mobile": mobileEdit.value.text.toLowerCase(),
                              "gender": isMale ? "Male" : "Female",
                              "type": "user",
                              "dob": formatter.format(_selectedDate),
                              "location": "[11,11]",
                              "login_type": "normal"
                            }));
                            Response response =
                                await dio.post('/register', data: formData);
                            dissmissLoader(context);
                            if (response != null) {
                              UserRegisterModal userRegistration =
                                  UserRegisterModal.fromJson(response.data);
                              if (userRegistration.status) {
                                showOtpVerify(userRegistration.data,
                                    userRegistration.token);
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
                    }),
              ),
              SizedBox(height: 20),
              SizedBox(height: 50),
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

  void showOtpVerify(Data userData, String token) {
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
                  Container(
                    margin: EdgeInsets.symmetric(vertical: 20, horizontal: 30),
                    child: Text(
                        "Verification code had sent to " +
                            emailEdit.text.toLowerCase(),
                        style: GoogleFonts.poppins(
                            fontSize: 13,
                            color: Theme.of(context).primaryColor,
                            fontWeight: FontWeight.normal)),
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
                              setUser(userData.toJson(), token);
                              Location location = new Location();

                              bool _serviceEnabled;

                              LocationData _locationData;
                              permissionGranted =
                                  await location.hasPermission();

                              Navigator.pushAndRemoveUntil(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => permissionGranted ==
                                              PermissionStatus.granted
                                          ? DashBoard()
                                          : UserLocationScreen()),
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
}
