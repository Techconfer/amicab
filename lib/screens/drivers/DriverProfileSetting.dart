import 'package:aim_cab/screens/drivers/DriverDashBoard.dart';
import 'package:aim_cab/screens/user/api/api_service.dart';

import 'package:aim_cab/screens/user/model/DriverRegisterModal.dart';
import 'package:aim_cab/utils/util.dart';
import 'package:dio/dio.dart';
import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
class DriverProfileSetting extends StatefulWidget {
  @override
  _DriverProfileSettingState createState() => _DriverProfileSettingState();
}

class _DriverProfileSettingState extends State<DriverProfileSetting> {
  bool isEdit=false;
  bool isMale=true;

  final DateFormat formatter = DateFormat('dd-MMMM-yyyy');
  TextEditingController usernameEdit=TextEditingController();
  TextEditingController passwordEdit=TextEditingController();
  TextEditingController mobileEdit=TextEditingController();
  TextEditingController nameEdit=TextEditingController();
  TextEditingController genderEdit=TextEditingController();
  TextEditingController dobEdit=TextEditingController();
  TextEditingController emailEdit=TextEditingController();
  DateTime _selectedDate;
  Driverdata _user;
  final _formKey = GlobalKey<FormState>();
  @override
  void initState() {

    getDriver().then((value) => {

      if(value!=null)
        {
          setState(() {
            _selectedDate=DateTime.parse(value.dob);

          }),
          _user=value,
          _selectedDate=DateTime.parse(value.dob),
          usernameEdit.text=value.username,
          isMale=value.gender=="Male"?true:false,
          emailEdit.text=value.email,
          mobileEdit.text=value.mobile,
          nameEdit.text=value.name



        }
    });

    super.initState();
  }
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
                      ,TextButton(
                          onPressed: (){
                            setState(() {
                              isEdit=!isEdit;
                              if(isEdit){
                                showSuccess(context, "Now you can edit");
                              }
                            });

                          },
                          child: Text("Edit",style: GoogleFonts.poppins(fontSize: 13,fontWeight: FontWeight.normal,color:HexColor(textColor)),))
                    ],

                  ),
                ),
                Container(
                  margin: EdgeInsets.symmetric(horizontal: 10),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Neumorphic(
                          child: Container(
                            margin: EdgeInsets.all(10),
                            child: TextFormField(

                              enabled: isEdit,
                              controller:nameEdit,


                                validator: (value) {
                                  Pattern pattern =
                                      r'^[a-z A-Z,.\-]+$';
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

                                  labelText: "Enter Full Name"
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height:10),
                        Neumorphic(
                          child: Container(
                            margin: EdgeInsets.all(10),
                            child: TextFormField(

                              enabled: false,


                              controller:emailEdit,
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
                        SizedBox(height:10),
                        Neumorphic(
                          child: Container(
                            margin: EdgeInsets.all(10),
                            child: TextFormField(
                              enabled: false,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter some text';
                                }
                                return null;
                              },
                              controller:usernameEdit,



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
                              enabled: isEdit,
                              validator:MultiValidator([
                                MinLengthValidator(10, errorText: 'Please enter valid mobile '),
                                MaxLengthValidator(10, errorText: 'Please enter valid mobile ')
                              ]),
                              controller:mobileEdit,

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
                        Column(children: [
                          Container(
                              alignment: Alignment.topLeft,
                              margin: EdgeInsets.only(left: 10),
                              child: Text("Gender",style: GoogleFonts.poppins(color:HexColor(textColor),fontSize: 15),)),
                          RadioListTile(

                              title: Text("Male",style: GoogleFonts.poppins(color:HexColor(textColor),fontSize: 12)),
                              value: true, groupValue:isMale,
                              onChanged:(val){
                                if(isEdit) {
                                  setState(() {
                                    isMale = true;
                                  });
                                }

                              }),
                          RadioListTile(


                              title: Text("Female",style: GoogleFonts.poppins(color:HexColor(textColor),fontSize: 12),),
                              value: false, groupValue:isMale, onChanged: (val){
                            if(isEdit) {
                              setState(() {
                                isMale = false;
                              });
                            }


                          })
                        ],),
                        SizedBox(height:10),
                        GestureDetector(
                          onTap: () async {
                            if(isEdit) {
                              final DateTime picked = await showDatePicker(
                                context: context,
                                initialDate: DateTime.parse(_user.dob),
                                firstDate: DateTime(1900),
                                lastDate: DateTime.now(),

                              );
                              var dateVal=  DateTime.now();
                              if (picked != null ) {
                                if( dateVal.year-picked.year>=18) {
                                  setState(() {
                                    _selectedDate = picked;
                                  });
                                }
                                else
                                {
                                  showError(context,"Please select date of birth for 18+");
                                }
                              }
                            }
                          },
                          child: Neumorphic(
                            child: Container(height: 50,width: double.infinity,
                              alignment: Alignment.centerLeft,
                              margin: EdgeInsets.all(10),
                              child: Text(

                                _selectedDate==null ?  "Enter dob":formatter.format( _selectedDate),
                                style: TextStyle(fontSize: 15,color:HexColor(textColor) ),
                              ),
                            ),
                          ),
                        ),


                      ],
                    ),
                  ),
                ),




                SizedBox(height:30),

                Container(



                  child: Container(
                    margin: EdgeInsets.symmetric(horizontal: 30),
                    child: NeumorphicButton(


                        child: Container(
                            padding: EdgeInsets.all(5),

                            width: sizeScreen.width,
                            child: Center(child: Text("UPDATE",style: GoogleFonts.poppins(color: HexColor("#8B9EB0"),fontSize: 15),))),
                        onPressed: () async {
                          if(_selectedDate!=null) {
                            Response response;
                            if (_formKey.currentState.validate()) {
                              showLoader(context);
                              final DateFormat formatter = DateFormat(
                                  'yyyy-MM-dd');
                              var dio = Dio();
                              dio.options.baseUrl = "http://api.cabandcargo.com//v1.0/";
                              String token=await getToken();
                              var formData = FormData.fromMap( {
                                "name": nameEdit.value.text.toLowerCase(),
                                "username": usernameEdit.value.text.toLowerCase(),
                                "email": emailEdit.value.text.toLowerCase(),
                                "mobile": mobileEdit.value.text.toLowerCase(),
                                "gender": isMale ? "Male" : "Female",
                                "dob": formatter.format(_selectedDate),
                                "token":token
                              },
                              );
                              response = await dio.post('/add-edit-driver-details', data: formData,
                                  options: Options(
                                    headers: {
                                      "Authorization" :token// set content-length
                                    },
                                  ));
                              dissmissLoader(context);
                              if (response!=null) {
                                DriverRegisterModal userRegistration = DriverRegisterModal
                                    .fromJson(response.data);
                                if (userRegistration.status) {
                                  _user.name =
                                      nameEdit.value.text.toLowerCase();
                                  _user.username =
                                      usernameEdit.value.text.toLowerCase();
                                  _user.email =
                                      emailEdit.value.text.toLowerCase();
                                  _user.mobile =
                                      mobileEdit.value.text.toLowerCase();
                                  _user.gender = isMale ? "Male" : "Female";
                                  _user.dob = formatter.format(_selectedDate);
                              //    setDriverWithoutToken(_user.toJson());
                                  Navigator.pushAndRemoveUntil(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => DriverDashBoard()), (
                                      Route<dynamic> route) => false);
                                }
                                else {
                                  showError(context,
                                      userRegistration.msg != null
                                          ? userRegistration.msg
                                          : "error in updating");
                                }
                              }
                            }
                          }
                          else {
                            showError(context, "please select valid date");
                          }
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
