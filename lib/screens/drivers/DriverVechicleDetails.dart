import 'package:aim_cab/screens/user/api/api_service.dart';

import 'package:aim_cab/screens/user/model/DriverRegisterModal.dart';
import 'package:aim_cab/utils/util.dart';
import 'package:flutter/material.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

import 'DriverDashBoard.dart';
class DriverVechicleDetails extends StatefulWidget {
  @override
  _DriverVechicleDetailsState createState() => _DriverVechicleDetailsState();
}

class _DriverVechicleDetailsState extends State<DriverVechicleDetails> {

  bool isEdit=false;
  bool isMale=true;

  final DateFormat formatter = DateFormat('dd-MMMM-yyyy');
  TextEditingController brandEdit=TextEditingController();
  TextEditingController modelEdit=TextEditingController();
  TextEditingController yearEdit=TextEditingController();
  TextEditingController plateEdit=TextEditingController();

  VehicleData _user;
  final _formKey = GlobalKey<FormState>();
  @override
  void initState() {

    getVehicle().then((value) => {

      if(value!=null)
        {

          _user=value,
          brandEdit.text=value.brandName.toUpperCase(),
          modelEdit.text=value.model.toUpperCase(),
          yearEdit.text=value.year.toString(),
          plateEdit.text=value.plateNumber.toUpperCase(),




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

                      Text("Vehicle Details",style: GoogleFonts.poppins(fontSize: 25,fontWeight: FontWeight.bold,color:Theme.of(context).accentColor),)
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
    textCapitalization: TextCapitalization.characters,
                              enabled: isEdit,
                              controller:brandEdit,

                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter Brand Name';
                                }
                                return null;
                              },

                              decoration: InputDecoration(
                                  isDense: true,
                                  border: InputBorder.none,
                                  focusedBorder: InputBorder.none,
                                  enabledBorder: InputBorder.none,
                                  errorBorder: InputBorder.none,

                                  labelText: "Enter Brand Name"
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height:10),
                        Neumorphic(
                          child: Container(
                            margin: EdgeInsets.all(10),
                            child: TextFormField(

                              enabled: isEdit,
                              controller:modelEdit,
    textCapitalization: TextCapitalization.characters,

                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter Model name';
                                }
                                return null;
                              },

                              decoration: InputDecoration(
                                  isDense: true,
                                  border: InputBorder.none,
                                  focusedBorder: InputBorder.none,
                                  enabledBorder: InputBorder.none,
                                  errorBorder: InputBorder.none,

                                  labelText: "Enter Model"
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height:10),
                        Neumorphic(
                          child: Container(
                            margin: EdgeInsets.all(10),
                            child: TextFormField(

                              enabled: isEdit,
                              controller:yearEdit,

                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter Year';
                                }
                                return null;
                              },
    keyboardType: TextInputType.number,
    maxLength: 4,

                              decoration: InputDecoration(
                                  isDense: true,
                                  border: InputBorder.none,
                                  focusedBorder: InputBorder.none,
                                  enabledBorder: InputBorder.none,
                                  errorBorder: InputBorder.none,

                                  labelText: "Enter Year"
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height:10),
                        Neumorphic(
                          child: Container(
                            margin: EdgeInsets.all(10),
                            child: TextFormField(

                              enabled: isEdit,
                              controller:plateEdit,

                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter Plate number';
                                }
                                return null;
                              },
textCapitalization: TextCapitalization.characters,
                              decoration: InputDecoration(
                                  isDense: true,
                                  border: InputBorder.none,
                                  focusedBorder: InputBorder.none,
                                  enabledBorder: InputBorder.none,
                                  errorBorder: InputBorder.none,

                                  labelText: "Enter Plate number"
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

                            if (_formKey.currentState.validate()) {
                              showLoader(context);
                              final DateFormat formatter = DateFormat(
                                  'yyyy-MM-dd');
                              ApiService service = ApiService.create();
                              final response = await service
                                  .postDriverProfileUpdate(_user.sId, {
                                "brand_name": brandEdit.value.text.toLowerCase(),
                                "model": modelEdit.value.text.toLowerCase(),
                                "year": yearEdit.value.text.toString(),
                                "plate_number": plateEdit.value.text.toLowerCase(),

                              });

                              dissmissLoader(context);
                              if (response.isSuccessful) {
                                DriverRegisterModal userRegistration = DriverRegisterModal
                                    .fromJson(response.body);
                                if (userRegistration.status) {
  _user.brandName= brandEdit.value.text.toLowerCase();
    _user.model=modelEdit.value.text.toLowerCase();
    _user.year=int.parse( yearEdit.value.text.toString());
    _user.plateNumber= plateEdit.value.text.toLowerCase();
                                  setDriverWithoutToken(_user.toJson());
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
