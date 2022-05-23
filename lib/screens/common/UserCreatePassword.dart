import 'package:aim_cab/utils/util.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:google_fonts/google_fonts.dart';

import 'SplashScreen.dart';

class UserCreatePassword extends StatefulWidget {
  @override
  _UserCreatePasswordState createState() => _UserCreatePasswordState();
}

class _UserCreatePasswordState extends State<UserCreatePassword> {
  bool _isOldHidden = true;
  bool _isNewHidden = true;
   bool _isConfirm = true;
  final _formKey = GlobalKey<FormState>();
  TextEditingController oldPasswordController=TextEditingController();
  TextEditingController newPasswordController=TextEditingController();
  TextEditingController confirmPasswordController=TextEditingController();


  @override
  Widget build(BuildContext context) {
    Size sizeScreen = MediaQuery.of(context).size;
    return Scaffold(


      body: Container(

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

                        Expanded(child: Center(child: Text("Change Password",style: GoogleFonts.poppins(fontSize: 25,fontWeight: FontWeight.bold,color:Theme.of(context).accentColor),)))

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
                                controller:oldPasswordController,

                                obscureText:_isOldHidden,

                                decoration: InputDecoration(
                                    suffixIcon:InkWell(
                                      onTap: (){
                                        setState(() {
                                          _isOldHidden=!_isOldHidden;
                                        });
                                      },
                                      child:_isOldHidden? Icon( Icons.visibility_off):Icon( Icons.visibility),
                                    ),
                                    isDense: true,
                                    border: InputBorder.none,
                                    focusedBorder: InputBorder.none,
                                    enabledBorder: InputBorder.none,
                                    errorBorder: InputBorder.none,
                                    labelText: "Enter Old Password"
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
                                controller:newPasswordController,

                                obscureText:_isNewHidden,

                                decoration: InputDecoration(
                                    suffixIcon:InkWell(
                                      onTap: (){
                                        setState(() {
                                          _isNewHidden=!_isNewHidden;
                                        });
                                      },
                                      child:_isNewHidden? Icon( Icons.visibility_off):Icon( Icons.visibility),
                                    ),
                                    isDense: true,
                                    border: InputBorder.none,
                                    focusedBorder: InputBorder.none,
                                    enabledBorder: InputBorder.none,
                                    errorBorder: InputBorder.none,
                                    labelText: "Enter New Password"
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
                                controller:confirmPasswordController,

                                obscureText:_isConfirm,

                                decoration: InputDecoration(
                                    suffixIcon:InkWell(
                                      onTap: (){
                                        setState(() {
                                          _isConfirm=!_isConfirm;
                                        });
                                      },
                                      child:_isConfirm? Icon( Icons.visibility_off):Icon( Icons.visibility),
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


                        ],
                      ),
                    ),
                  ),




                  SizedBox(height:10),










                ],
              ),
            ),





             Container(
                  alignment: Alignment.bottomCenter,
                  margin: EdgeInsets.symmetric(horizontal: 30,vertical: 10),
                  child: NeumorphicButton(


                      child: Container(


                          width: sizeScreen.width,
                          height: 40,
                          child: Center(child: Text("UPDATE",style: GoogleFonts.poppins(color: HexColor("#8B9EB0"),fontSize: 18),))),
                      onPressed: () async {
                        if(_formKey.currentState.validate()) {
                          if (newPasswordController.text ==
                              confirmPasswordController.text) {
                            showLoader(context);
                            var mainUser = await getUserType();
                            String userId = "";
                            if (mainUser == "transporter") {
                              var user = await getTransporter();
                              userId = user.sId;
                            }
                            else {
                              var user = await getDriver();
                              userId = user.sId;
                            }

                            var dio = Dio();
                            dio.options.baseUrl = appUrl;

                            var response = await dio.post(
                                "/change-password/${userId}",
                                data: {
                                  'current_password': oldPasswordController
                                      .text,
                                  'new_password': newPasswordController.text
                                });
                            dissmissLoader(context);
                            print("res:" + response.data.toString());
                            if (response.data['status']) {
                              showSuccess(
                                  context, "Password change successfully");
                              Navigator.pop(context);
                              await logoutUser();
                              Navigator.pushAndRemoveUntil(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => SplashScreen()), (
                                  Route<dynamic> route) => false);
                            }
                            else {
                              showError(context, response.data["msg"]);
                            }
                          }
                          else{
                            showError(context,"both password should match");
                          }
                        }

                      }),
                ),


            ],
          ),
        ),
      ),
    );
  }
}