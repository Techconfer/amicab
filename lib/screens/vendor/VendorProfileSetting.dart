import 'package:aim_cab/screens/user/api/api_service.dart';
import 'package:aim_cab/screens/user/model/DriverRegisterModal.dart';
import 'package:aim_cab/screens/user/model/Transporter.dart';
import 'package:aim_cab/screens/user/model/TransporterRegisterModal.dart';
import 'package:aim_cab/screens/vendor/VendorDashBoard.dart';
import 'package:aim_cab/utils/util.dart';
import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
class VendorProfileSetting extends StatefulWidget {
  @override
  _VendorProfileSettingState createState() => _VendorProfileSettingState();
}

class _VendorProfileSettingState extends State<VendorProfileSetting> {
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

    getTransporter().then((value) => {

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
                                if (value == null || value.isEmpty) {
                                  return 'Please enter full name';
                                }
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
                              validator: (value) {
                                if (! EmailValidator.validate(value)) {
                                  return 'Please enter email';
                                }
                                return null;
                              },
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
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter some text';
                                }
                                return null;
                              },
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
                              if (picked != null && picked != _selectedDate)
                                setState(() {
                                  _selectedDate = picked;
                                });
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
                            if (_formKey.currentState.validate()) {
                              showLoader(context);
                              final DateFormat formatter = DateFormat(
                                  'yyyy-MM-dd');
                              ApiService service = ApiService.create();
                              final response = await service
                                  .postTransporterProfileUpdate(_user.sId, {
                                "name": nameEdit.value.text.toLowerCase(),
                                "username": usernameEdit.value.text.toLowerCase(),
                                "email": emailEdit.value.text.toLowerCase(),
                                "mobile_no": mobileEdit.value.text.toLowerCase(),
                                "gender": isMale ? "Male" : "Female",
                                "dob": formatter.format(_selectedDate)
                              });

                              dissmissLoader(context);
                              if (response.isSuccessful) {
                                TransporterRegisterModal userRegistration =TransporterRegisterModal
                                    .fromJson(response.body);
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
                                  setTransporters(_user.toJson());
                                  Navigator.pushAndRemoveUntil(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => VendorDashBoard()), (
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
