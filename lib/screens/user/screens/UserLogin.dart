import 'dart:async';

import 'package:aim_cab/screens/user/api/api_service.dart';
import 'package:aim_cab/screens/user/model/UserRegisterModal.dart';
import 'package:aim_cab/screens/user/screens/UserLocationScreen.dart';
import 'package:aim_cab/utils/util.dart';
import 'package:dio/dio.dart';
import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
// import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:location/location.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
// import 'package:provider/provider.dart';

import 'DashBoard.dart';
import 'UserRegistration.dart';

class UserLogin extends StatefulWidget {
  @override
  _UserLoginState createState() => _UserLoginState();
}

class _UserLoginState extends State<UserLogin> {
  TextEditingController usernameEdit = TextEditingController();
  TextEditingController passwordEdit = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _isHidden = true;
  @override
  Widget build(BuildContext context) {
    Size sizeScreen = MediaQuery.of(context).size;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Container(
        height: sizeScreen.height,
        child: Stack(
          children: [
            SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                      margin: EdgeInsets.only(top: 100),
                      height: 100,
                      child: Image.asset("assets/images/login_logo.png")),
                  Text(
                    "LOGIN",
                    style:
                        GoogleFonts.poppins(fontSize: 25, color: Colors.black),
                  ),
                  SizedBox(height: 10),
                  Container(
                    margin: EdgeInsets.symmetric(horizontal: 20),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        children: [
                          Neumorphic(
                            child: Container(
                              margin: EdgeInsets.all(10),
                              child: TextFormField(
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Please enter some text';
                                  }
                                  return null;
                                },
                                controller: usernameEdit,
                                decoration: InputDecoration(
                                    border: InputBorder.none,
                                    focusedBorder: InputBorder.none,
                                    enabledBorder: InputBorder.none,
                                    errorBorder: InputBorder.none,
                                    isDense: true,
                                    labelText: "Enter Username"),
                              ),
                            ),
                          ),
                          SizedBox(height: 10),
                          Neumorphic(
                            child: Container(
                              margin: EdgeInsets.all(10),
                              child: TextFormField(
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Please enter some text';
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
                        ],
                      ),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.all(10),
                    alignment: Alignment.bottomRight,
                    child: TextButton(
                        child: Text("Forgot Password"),
                        onPressed: () {
                          forgotPassword();
                        }),
                  ),
                  SizedBox(height: 20),
                  Container(
                    child: NeumorphicButton(
                        child: Container(
                            padding: EdgeInsets.all(5),
                            width: 200,
                            child: Center(
                                child: Text(
                              "Login",
                              style: GoogleFonts.poppins(
                                  color: HexColor("#8B9EB0"), fontSize: 15),
                            ))),
                        onPressed: () async {
                          if (_formKey.currentState.validate()) {
                            showLoader(context);

                            ApiService service = ApiService.create();
                            final response = await service.postLogin({
                              "username": usernameEdit.value.text.toLowerCase(),
                              "password": passwordEdit.value.text,
                              "type": "user"
                            });
                            dissmissLoader(context);
                            if (response.isSuccessful) {
                              UserRegisterModal userRegistration =
                                  UserRegisterModal.fromJson(response.body);
                              if (userRegistration.status) {
                                setUser(userRegistration.data.toJson(),
                                    userRegistration.token);
                                Location location = new Location();

                                bool _serviceEnabled;

                                LocationData _locationData;
                                PermissionStatus permissionGranted =
                                    await location.hasPermission();
                                Navigator.pushAndRemoveUntil(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            permissionGranted ==
                                                    PermissionStatus.granted
                                                ? DashBoard()
                                                : UserLocationScreen()),
                                    (Route<dynamic> route) => false);
                              } else {
                                showError(
                                    context,
                                    userRegistration.msg != null
                                        ? userRegistration.msg
                                        : "please check username or password");
                              }
                            }
                          }
                        }),
                  ),
                  SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Neumorphic(
                        child: IconButton(
                            icon: Icon(
                              FontAwesome.facebook,
                              size: 25,
                              color: Colors.blue,
                            ),
                            onPressed: () {}),
                      ),
                      SizedBox(width: 20),
                      Neumorphic(
                        child: IconButton(
                            icon: Icon(
                              FontAwesome.google,
                              size: 25,
                              color: Colors.grey,
                            ),
                            onPressed: () {}),
                      )
                    ],
                  ),
                ],
              ),
            ),
            Container(
              margin: EdgeInsets.only(bottom: 5),
              alignment: Alignment.bottomCenter,
              child: TextButton(
                  child: Text(
                    "New Here?Register",
                    style: GoogleFonts.poppins(color: HexColor("#828282")),
                  ),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => UserRegistration()),
                    );
                  }),
            )
          ],
        ),
      ),
    );
  }

  void forgotPassword() {
    TextEditingController emailController = TextEditingController();
    TextEditingController otpText = TextEditingController();
    StreamController<ErrorAnimationType> errorController =
        StreamController<ErrorAnimationType>();
    bool hasError = false;
    bool isOtpVisibility = false;
    final _formKey = GlobalKey<FormState>();
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return Dialog(
              backgroundColor: Colors.transparent,
              //this right here
              child: StatefulBuilder(builder: (context, setState) {
                return Container(
                  decoration: new BoxDecoration(
                      color: HexColor("D6E3F3"),
                      borderRadius: BorderRadius.all(Radius.circular(20))),
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Center(
                              child: Text(
                            "Forgot password",
                            style: GoogleFonts.poppins(
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                                color: Theme.of(context).accentColor),
                          )),
                          Visibility(
                            visible: !isOtpVisibility,
                            child: Container(
                              margin: EdgeInsets.symmetric(
                                  vertical: 20, horizontal: 30),
                              child: Text("Enter email to change password",
                                  style: GoogleFonts.poppins(
                                      fontSize: 13,
                                      color: Theme.of(context).primaryColor,
                                      fontWeight: FontWeight.normal)),
                            ),
                          ),
                          Visibility(
                            visible: isOtpVisibility,
                            child: Container(
                              margin: EdgeInsets.symmetric(
                                  vertical: 20, horizontal: 30),
                              child: Text(
                                  "Verification code had sent to " +
                                      emailController.text.toLowerCase(),
                                  style: GoogleFonts.poppins(
                                      fontSize: 13,
                                      color: Theme.of(context).primaryColor,
                                      fontWeight: FontWeight.normal)),
                            ),
                          ),
                          Visibility(
                            visible: !isOtpVisibility,
                            child: Neumorphic(
                              style: NeumorphicStyle(
                                color: HexColor("D6E3F3"),
                              ),
                              child: Container(
                                margin: EdgeInsets.symmetric(
                                    horizontal: 10, vertical: 1),
                                child: TextFormField(
                                  validator: (value) {
                                    if (!EmailValidator.validate(value)) {
                                      return 'Please enter email';
                                    }
                                    return null;
                                  },
                                  controller: emailController,
                                  keyboardType: TextInputType.emailAddress,
                                  decoration: InputDecoration(
                                      isDense: false,
                                      border: InputBorder.none,
                                      focusedBorder: InputBorder.none,
                                      enabledBorder: InputBorder.none,
                                      errorBorder: InputBorder.none,
                                      labelText: "Enter Email"),
                                ),
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          Visibility(
                            visible: isOtpVisibility,
                            child: Container(
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
                                    inactiveColor:
                                        Theme.of(context).primaryColor,
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
                          ),
                          Center(
                            child: Container(
                              margin: EdgeInsets.only(top: 20, bottom: 20),
                              child: NeumorphicButton(
                                  style: NeumorphicStyle(
                                      color: HexColor("#E3EDF7")),
                                  child: Container(
                                      padding: EdgeInsets.all(2),
                                      width: 200,
                                      child: Center(
                                          child: Text(
                                        isOtpVisibility
                                            ? "VERIFY OTP"
                                            : "SEND mail",
                                        style: GoogleFonts.poppins(
                                            color: HexColor("#8B9EB0"),
                                            fontSize: 15),
                                      ))),
                                  onPressed: () async {
                                    if (_formKey.currentState.validate()) {
                                      if (!isOtpVisibility) {
                                        showLoader(context);

                                        var dio = Dio();
                                        dio.options.baseUrl = appUrl;
                                        var response = await dio
                                            .post("/forgot-password", data: {
                                          'email_address':
                                              emailController.text.toString()
                                        });

                                        print(
                                            "res:" + response.data.toString());
                                        setState(() {
                                          isOtpVisibility = true;
                                        });

                                        dissmissLoader(context);
                                      } else {
                                        showLoader(context);

                                        var dio = Dio();
                                        dio.options.baseUrl = appUrl;
                                        var response = await dio
                                            .post("/verify-otp", data: {
                                          'email_address':
                                              emailController.text.toString(),
                                          'otp': otpText.text.toString()
                                        });

                                        print(
                                            "res:" + response.data.toString());
                                        if (response.data["status"]) {
                                          Navigator.of(context).pop();
                                          showPassword(emailController.text);
                                        } else {
                                          errorController
                                              .add(ErrorAnimationType.shake);
                                          showError(
                                              context, response.data["msg"]);
                                        }

                                        dissmissLoader(context);
                                      }
                                    }
                                  }),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              }));
        });
  }

  void showPassword(String email) {
    final _formKey = GlobalKey<FormState>();
    bool _ispasswordHidden = true;
    bool _ispasswordConformHidden = true;
    TextEditingController passwordController = TextEditingController();
    TextEditingController confirmPasswordController = TextEditingController();

    showModalBottomSheet<void>(
      isScrollControlled: true,
      context: context,
      isDismissible: true,
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
            child: StatefulBuilder(builder: (context, setState) {
              return Container(
                margin:
                    EdgeInsets.only(top: 20, bottom: 5, right: 10, left: 10),
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Container(
                        padding:
                            EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                Text(
                                  "New password",
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
                      Neumorphic(
                        style: NeumorphicStyle(
                          color: HexColor("D6E3F3"),
                        ),
                        child: Container(
                          margin:
                              EdgeInsets.symmetric(vertical: 1, horizontal: 10),
                          child: TextFormField(
                            validator: (value) {
                              if (value == null ||
                                  value.isEmpty ||
                                  value.length < 6) {
                                return 'Password must be greater then six digit';
                              }
                              return null;
                            },
                            controller: passwordController,
                            obscureText: _ispasswordHidden,
                            decoration: InputDecoration(
                                suffixIcon: InkWell(
                                  onTap: () {
                                    setState(() {
                                      _ispasswordHidden = !_ispasswordHidden;
                                    });
                                  },
                                  child: _ispasswordHidden
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
                      SizedBox(
                        height: 20,
                      ),
                      Neumorphic(
                        style: NeumorphicStyle(
                          color: HexColor("D6E3F3"),
                        ),
                        child: Container(
                          margin:
                              EdgeInsets.symmetric(vertical: 1, horizontal: 10),
                          child: TextFormField(
                            validator: (value) {
                              if (value == null ||
                                  value.isEmpty ||
                                  value.length < 6) {
                                return 'Password must be greater then six digit';
                              }
                              return null;
                            },
                            controller: confirmPasswordController,
                            obscureText: _ispasswordConformHidden,
                            decoration: InputDecoration(
                                suffixIcon: InkWell(
                                  onTap: () {
                                    setState(() {
                                      _ispasswordConformHidden =
                                          !_ispasswordConformHidden;
                                    });
                                  },
                                  child: _ispasswordConformHidden
                                      ? Icon(Icons.visibility_off)
                                      : Icon(Icons.visibility),
                                ),
                                isDense: true,
                                border: InputBorder.none,
                                focusedBorder: InputBorder.none,
                                enabledBorder: InputBorder.none,
                                errorBorder: InputBorder.none,
                                labelText: "Confirm New Password"),
                          ),
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
                                  "CHANGE PASSWORD",
                                  style: GoogleFonts.poppins(
                                      color: HexColor("#8B9EB0"), fontSize: 18),
                                ))),
                            onPressed: () async {
                              if (_formKey.currentState.validate()) {
                                if (passwordController.text ==
                                    confirmPasswordController.text) {
                                  showLoader(context);

                                  var dio = Dio();
                                  dio.options.baseUrl = appUrl;
                                  var response = await dio.post("/new-password",
                                      data: {
                                        'email_address': email,
                                        'new_password': passwordController.text
                                      });

                                  print("res:" + response.data.toString());
                                  if (response.data['status']) {
                                    showSuccess(context,
                                        "Password change successfully");
                                    Navigator.pop(context);
                                  } else {
                                    showError(context, response.data['msg']);
                                  }
                                } else {
                                  showError(context,
                                      "Please confirm your password correct");
                                }
                                dissmissLoader(context);
                              }
                            }),
                      ),
                    ],
                  ),
                ),
              );
            }),
          ),
        );
      },
    );
  }
}
