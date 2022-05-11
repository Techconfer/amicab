import 'dart:async';

import 'package:aim_cab/screens/common/SplashScreen.dart';
import 'package:aim_cab/utils/util.dart';
import 'package:dio/dio.dart';
import 'package:email_validator/email_validator.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'UserCreatePassword.dart';

class UserPassword extends StatefulWidget {
  @override
  _UserPasswordState createState() => _UserPasswordState();
}

class _UserPasswordState extends State<UserPassword> {
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
                    mainAxisAlignment: MainAxisAlignment.center,


                    children: [Container(

                        child: Neumorphic(

                            child: IconButton(icon:Icon(Icons.arrow_back_ios,color:Theme.of(context).accentColor,size: 25,),
                              onPressed: (){
                                Navigator.pop(context);
                              },
                            ))),

                      Expanded(child: Center(child: Text("Password",style: GoogleFonts.poppins(fontSize: 25,fontWeight: FontWeight.bold,color:Theme.of(context).accentColor),)))

                    ],

                  ),
                ),
                Container(
                  margin: EdgeInsets.symmetric(horizontal: 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [

                      Text("Change Password",style: GoogleFonts.poppins(fontSize: 15,fontWeight: FontWeight.normal,color:HexColor(textColor)),),
                    Neumorphic(

                        child: IconButton(icon:Icon(Icons.arrow_forward_ios,color:Theme.of(context).accentColor,size: 25,),
                          onPressed: (){
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => UserCreatePassword()),
                            );
                          },
                        ))
                    ],),
                ),
                SizedBox(height: 20,),
                Container(
                  margin: EdgeInsets.symmetric(horizontal: 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [

                      Text("Forgot Password",style: GoogleFonts.poppins(fontSize: 15,fontWeight: FontWeight.normal,color:HexColor(textColor)),),

                      Neumorphic(

                          child: IconButton(icon:Icon(Icons.arrow_forward_ios,color:Theme.of(context).accentColor,size: 25,),
                            onPressed: () async {

                            var  mainUser=await getUserType();
                            if(mainUser=="user")
                              {
                                var user=await getUser();
                                showLoader(context);

                                var dio = Dio();
                                dio.options.baseUrl = appUrl;
                                var response = await dio.post("/forgot-password",
                                    data: {'email_address': user.email});

                                print("res:" + response.data.toString());


                                dissmissLoader(context);
                                forgotPassword(user.email);

                              }
                            else{
                              var user=await getDriver();
                              showLoader(context);

                              var dio = Dio();
                              dio.options.baseUrl = appUrl;
                              var response = await dio.post("/forgot-password",
                                  data: {'email_address': user.email});

                              print("res:" + response.data.toString());


                              dissmissLoader(context);
                              forgotPassword(user.email);
                            }


                            },
                          ))
                    ],),
                )







              ],
            ),
          ),
        ),
      ),
    );
  }
  void showPassword(String email){
    final _formKey = GlobalKey<FormState>();
    bool _ispasswordHidden = true;
    bool _ispasswordConformHidden = true;
    TextEditingController passwordController=TextEditingController();
    TextEditingController confirmPasswordController=TextEditingController();

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
            child: StatefulBuilder(
                builder: (context, setState) {
                  return Container(
                    margin: EdgeInsets.only(top: 20,bottom: 5,right: 10,left: 10),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          Container(
                            padding: EdgeInsets.symmetric(horizontal: 20,vertical: 10),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [

                                Row(
                                  children: [



                                    Text("New password",style: GoogleFonts.poppins(fontSize: 15,fontWeight: FontWeight.bold,color:Theme.of(context).accentColor),),
                                  ],
                                ),



                              ],),
                          ),
                          SizedBox(height: 20,),
                          Neumorphic(

                            style: NeumorphicStyle(
                              color: HexColor("D6E3F3"),
                            ),
                            child: Container(
                              margin: EdgeInsets.symmetric(vertical: 1,horizontal: 10),
                              child: TextFormField(
                                validator: (value) {
                                  if (value == null || value.isEmpty || value.length<6) {
                                    return 'Password must be greater then six digit';
                                  }
                                  return null;
                                },
                                controller:passwordController,
                                obscureText: _ispasswordHidden,

                                decoration: InputDecoration(

                                    suffixIcon:InkWell(
                                      onTap: (){
                                        setState(() {
                                          _ispasswordHidden=! _ispasswordHidden;
                                        });
                                      },
                                      child: _ispasswordHidden? Icon( Icons.visibility_off):Icon( Icons.visibility),
                                    ),
                                    isDense: true,
                                    border: InputBorder.none,
                                    focusedBorder: InputBorder.none,
                                    enabledBorder: InputBorder.none,
                                    errorBorder: InputBorder.none,
                                    labelText: "Enter Password"
                                ),
                              ),
                            ),
                          ),

                          SizedBox(height: 20,),
                          Neumorphic(

                            style: NeumorphicStyle(
                              color: HexColor("D6E3F3"),
                            ),
                            child: Container(
                              margin: EdgeInsets.symmetric(vertical: 1,horizontal: 10),
                              child: TextFormField(
                                validator: (value) {
                                  if (value == null || value.isEmpty || value.length<6) {
                                    return 'Password must be greater then six digit';
                                  }
                                  return null;
                                },
                                controller:confirmPasswordController,
                                obscureText:  _ispasswordConformHidden,

                                decoration: InputDecoration(

                                    suffixIcon:InkWell(
                                      onTap: (){
                                        setState(() {
                                          _ispasswordConformHidden=! _ispasswordConformHidden;
                                        });
                                      },
                                      child: _ispasswordConformHidden? Icon( Icons.visibility_off):Icon( Icons.visibility),
                                    ),
                                    isDense: true,
                                    border: InputBorder.none,
                                    focusedBorder: InputBorder.none,
                                    enabledBorder: InputBorder.none,
                                    errorBorder: InputBorder.none,
                                    labelText: "Confirm New Password"
                                ),
                              ),
                            ),
                          ),



                          Container(
                            margin: EdgeInsets.only(top: 20,bottom: 20),
                            child: NeumorphicButton(
                                style: NeumorphicStyle(
                                    color: HexColor("#E3EDF7")
                                ),

                                child: Container(
                                    padding: EdgeInsets.all(5),
                                    width: 200,
                                    child: Center(child: Text("CHANGE PASSWORD",style: GoogleFonts.poppins(color: HexColor("#8B9EB0"),fontSize: 18),))),
                                onPressed: () async {
                                  if(_formKey.currentState.validate()) {
                                    if (passwordController.text ==
                                        confirmPasswordController.text) {
                                      showLoader(context);

                                      var dio = Dio();
                                      dio.options.baseUrl = appUrl;
                                      var response = await dio.post("/new-password",
                                          data: {'email_address': email,
                                            'new_password': passwordController.text
                                          });

                                      print("res:" + response.data.toString());
                                      if (response.data['status']) {
                                        showSuccess(
                                            context, "Password change successfully");
                                        Navigator.pop(context);
                                        await  logoutUser();
                                        Navigator.pushAndRemoveUntil(
                                            context,
                                            MaterialPageRoute(builder: (context) => SplashScreen()),(Route<dynamic> route) => false);
                                      }
                                      else {
                                        showError(context, response.data['msg']);
                                      }
                                    }
                                    else {
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
                  );}),
          ),
        );
      },
    );

  }
  void forgotPassword(String email)
  {
    TextEditingController emailController=TextEditingController();
    TextEditingController otpText = TextEditingController();
    StreamController<ErrorAnimationType> errorController=StreamController<ErrorAnimationType>();
    bool hasError = false;
    bool isOtpVisibility=true;
    final _formKey = GlobalKey<FormState>();
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return Dialog(
              backgroundColor: Colors.transparent,
              //this right here
              child: StatefulBuilder(
                  builder: (context, setState) {
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
                              Center(child: Text("Forgot password",style: GoogleFonts.poppins(fontSize: 15,fontWeight: FontWeight.bold,color:Theme.of(context).accentColor),)),


                              Visibility(
                                visible: !isOtpVisibility,
                                child: Container(
                                  margin: EdgeInsets.symmetric(vertical: 20,horizontal: 30),
                                  child:  Text("Enter email to change password",style: GoogleFonts.poppins(fontSize: 13,color: Theme.of(context).primaryColor,fontWeight: FontWeight.normal)),),
                              ),
                              Visibility(
                                visible: isOtpVisibility,
                                child: Container(
                                  margin: EdgeInsets.symmetric(vertical: 20,horizontal: 30),
                                  child:  Text("Verification code had sent to "+email,style: GoogleFonts.poppins(fontSize: 13,color: Theme.of(context).primaryColor,fontWeight: FontWeight.normal)),),
                              ),
                              Visibility(
                                visible: !isOtpVisibility,
                                child: Neumorphic(
                                  style: NeumorphicStyle(
                                    color: HexColor("D6E3F3"),
                                  ),
                                  child: Container(
                                    margin: EdgeInsets.symmetric(horizontal: 10,vertical: 1),
                                    child: TextFormField(
                                      validator: (value) {
                                        if (! EmailValidator.validate(value)) {
                                          return 'Please enter email';
                                        }
                                        return null;
                                      },
                                      controller:emailController,
                                      keyboardType:TextInputType.emailAddress,



                                      decoration: InputDecoration(
                                          isDense: false,
                                          border: InputBorder.none,
                                          focusedBorder: InputBorder.none,
                                          enabledBorder: InputBorder.none,
                                          errorBorder: InputBorder.none,

                                          labelText: "Enter Email"
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(height: 20,),
                              Visibility(
                                visible:isOtpVisibility,
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
                                        inactiveColor: Theme.of(context).primaryColor,
                                        activeFillColor:Colors.blue.shade100
                                    ), boxShadows: [
                                    BoxShadow(
                                      offset: Offset(0, 1),
                                      color: HexColor("D6E3F3"),
                                      blurRadius: 25,
                                    )
                                  ], onChanged: (String value) {  },



                                  ),

                                ),
                              ),
                              Center(
                                child: Container(
                                  margin: EdgeInsets.only(top: 20,bottom: 20),
                                  child: NeumorphicButton(
                                      style: NeumorphicStyle(
                                          color: HexColor("#E3EDF7")
                                      ),

                                      child: Container(
                                          padding: EdgeInsets.all(2),
                                          width: 200,
                                          child: Center(child: Text(isOtpVisibility?"VERIFY OTP":"SEND mail",style: GoogleFonts.poppins(color: HexColor("#8B9EB0"),fontSize: 15),))),
                                      onPressed: () async {
                                        if(_formKey.currentState.validate())
                                        {
                                          if(!isOtpVisibility) {
                                            showLoader(context);

                                            var dio = Dio();
                                            dio.options.baseUrl = appUrl;
                                            var response = await dio.post("/forgot-password",
                                                data: {'email_address': emailController.text.toString()});

                                            print("res:" + response.data.toString());
                                            setState(() {
                                              isOtpVisibility = true;
                                            });

                                            dissmissLoader(context);
                                          }
                                          else{
                                            showLoader(context);

                                            var dio = Dio();
                                            dio.options.baseUrl = appUrl;
                                            var response = await dio.post("/verify-otp",
                                                data: {'email_address': email,
                                                  'otp':otpText.text.toString()
                                                });

                                            print("res:" + response.data.toString());
                                            if(response.data["status"])
                                            {
                                              Navigator.of(context).pop();
                                              showPassword(email);

                                            }
                                            else{
                                              errorController.add(ErrorAnimationType
                                                  .shake);
                                              showError(context, response.data["msg"]);
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
                  }
              ));
        });
  }
}