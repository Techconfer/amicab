
import 'dart:convert';

import 'package:aim_cab/screens/common/PaymentHistory.dart';
import 'package:aim_cab/screens/common/Varibles.dart';
import 'package:aim_cab/screens/user/model/DriverRegisterModal.dart';
import 'package:aim_cab/screens/user/model/RazorPayWallet.dart';
import 'package:aim_cab/utils/util.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'DriverAccountDetails.dart';

class DriverPayment extends StatefulWidget {
  @override
  _DriverPaymentState createState() => _DriverPaymentState();
}

class _DriverPaymentState extends State<DriverPayment> {
  Razorpay _razorpay;
  Dio dio;
  RazorPayWallet walletData;
  String EnterdAmountwallte = '';
  Driverdata _driver;

  @override
  void initState() {
    getDriver().then((value) =>
        setState(() {
          _driver = value;
          getwalltedeatisl();
        }),

    );
    // TODO: implement initState
    dio = Dio();
    dio.options.baseUrl = appUrl;
    _razorpay = new Razorpay();

    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);

    super.initState();
  }

  Future<dynamic> getwalltedeatisl()  async {
    var dio = Dio();
    var token=await getToken();


    print("user_id_ride:"+_driver.sId);
    String urlis=_driver.sId;

    var response = await dio.get('http://api.cabandcargo.com/v1.0/user-data/'+urlis,
      options: Options(
        headers: {
          "Authorization" :token// set content-length
        },
      ),

    );
    List userwalltedata = jsonDecode(response.toString())['data'];
    // print("res_wallete_data:"+userwalltedata.toString());

    setState(() {
      for(var i = 0; i < userwalltedata.length; i++){
        Varibles.DRIVER_WALLET_BALLANCE=userwalltedata[i]['wallet_amount'].toString();
      }
    });



  }


  Future<dynamic> sendrequestuserpaymnet() async {
    var dio = Dio();

    var token = await getToken();
    print("user_id_ride:" + _driver.sId);
    print("user_id_ride:" + token);

    var resp = await dio.post(
      'http://api.cabandcargo.com/v1.0/add-money-to-user-wallet',
      data: {
        "user_id": _driver.sId,
        "booking_id": _driver.sId,
        "payment_type": 'wallet',
        "amount": EnterdAmountwallte,
      },
      options: Options(
        headers: {
          "Authorization": token,
          'Content-Type': 'application/json',
        },
      ),
    );

    Varibles.id = jsonDecode(json.encode(resp.data))['data']['RazorPayOrder']
    ['id']
        .toString();
    Varibles.amount = jsonDecode(json.encode(resp.data))['data']
    ['RazorPayOrder']['amount']
        .toString();
    Varibles.SystemOrderId =
        jsonDecode(json.encode(resp.data))['data']['SystemOrderId'].toString();
    print("user_id_ride:" + Varibles.id);
    print("user_id_ride:" + Varibles.amount);
    print("user_id_ride:" + Varibles.SystemOrderId);

    openCheckout();
  }

  Future<dynamic> Paymentsendonserver(String paymentid) async {
    var dio = Dio();
    var token = await getToken();

    var resp = await dio.post(
      'http://api.cabandcargo.com/v1.0/add-money-to-user-wallet-success',
      data: {
        "SystemOrderId": Varibles.SystemOrderId,
        "OrderId": Varibles.id,
        "PaymentId": paymentid,
        "amount": Varibles.amount
      },
      options: Options(
        headers: {
          "Authorization": token,
          'Content-Type': 'application/json',
        },
      ),
    );

    setState(() {
      Fluttertoast.showToast(msg: 'Success', toastLength: Toast.LENGTH_SHORT);
      //print("responce:"+resp.data.toString());
      Route route = MaterialPageRoute(builder: (context) => DriverPayment());
      Navigator.pushReplacement(context, route);
    });
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

                  child: Stack(



                    children: [Align(
                      alignment: Alignment.topLeft,
                      child: Container(

                          child: Neumorphic(

                              child: IconButton(icon:Icon(Icons.arrow_back_ios,color:Theme.of(context).accentColor,size: 25,),
                                onPressed: (){
                                  Navigator.pop(context);
                                },
                              ))),
                    ),

                      Align(
                          alignment: Alignment.center,
                          child: Center(child: Text("Payments",style: GoogleFonts.poppins(fontSize: 25,fontWeight: FontWeight.bold,color:Theme.of(context).accentColor),)))

                    ],

                  ),
                ),
                InkWell(
                  onTap: (){
                    showWalletModal();
                  },
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 20,vertical: 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [

                        Row(
                          children: [
                            Neumorphic(
                                style: NeumorphicStyle(
                                    color: HexColor("#E3EDF7")
                                ),
                                child:Container(
                                    padding: EdgeInsets.all(10),
                                    child: SvgPicture.asset("assets/images/wallet_icon.svg"))

                            ),
                            SizedBox(width: 20,),
                            Text("Wallet",style: GoogleFonts.poppins(fontSize: 15,fontWeight: FontWeight.normal,color:HexColor(textColor)),),
                          ],
                        ),
                        Container(

                            child:Chip(
                              label: Text("${ Varibles.DRIVER_WALLET_BALLANCE} INR",style: GoogleFonts.poppins(color: Theme.of(context).accentColor,fontWeight: FontWeight.bold),),
                            ))
                      ],),
                  ),
                ),
                InkWell(
                  onTap: (){
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) =>PaymentHistory(sId: _driver.sId)),
                    );
                  },
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 20,vertical: 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [

                        Row(
                          children: [
                            Neumorphic(
                                style: NeumorphicStyle(
                                    color: HexColor("#E3EDF7")
                                ),
                                child:Container(
                                    padding: EdgeInsets.all(10),
                                    child: SvgPicture.asset("assets/images/payment_history_icon.svg"))

                            ),
                            SizedBox(width: 20,),
                            Text("Payment History",style: GoogleFonts.poppins(fontSize: 15,fontWeight: FontWeight.normal,color:HexColor(textColor)),),
                          ],
                        ),

                      ],),
                  ),
                ),
                InkWell(
                  onTap: (){
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) =>DriverAccountDetails()),
                    );
                  },
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 20,vertical: 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [

                        Row(
                          children: [
                            Neumorphic(
                                style: NeumorphicStyle(
                                    color: HexColor("#E3EDF7")
                                ),
                                child:Container(
                                    padding: EdgeInsets.all(10),
                                    child: SvgPicture.asset("assets/images/account_detail_icon.svg"))

                            ),
                            SizedBox(width: 20,),
                            Text("Account details",style: GoogleFonts.poppins(fontSize: 15,fontWeight: FontWeight.normal,color:HexColor(textColor)),),
                          ],
                        ),

                      ],),
                  ),
                ),
                InkWell(
                  onTap: (){
                    showWalletModal();
                  },
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 20,vertical: 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [

                        Row(
                          children: [
                            Neumorphic(
                                style: NeumorphicStyle(
                                    color: HexColor("#E3EDF7")
                                ),
                                child:Container(
                                    padding: EdgeInsets.all(10),
                                    child: SvgPicture.asset("assets/images/withdraw_icon.svg"))

                            ),
                            SizedBox(width: 20,),
                            Text("Withdraw Money",style: GoogleFonts.poppins(fontSize: 15,fontWeight: FontWeight.normal,color:HexColor(textColor)),),
                          ],
                        ),

                      ],),
                  ),
                ),






              ],
            ),
          ),
        ),
      ),
    );

  }
  void showWalletModal(){
    TextEditingController amount_text = TextEditingController();
    amount_text.text=100.toString();

    showModalBottomSheet<void>(
      isScrollControlled: true,
      context: context,

      backgroundColor: Colors.transparent,
      builder: (BuildContext context) {
        return Container(
          decoration: new BoxDecoration(
              color: HexColor("D6E3F3"),

              borderRadius: new BorderRadius.only(
                  topLeft: const Radius.circular(50.0),
                  topRight: const Radius.circular(50.0))),

          child: Container(
            margin: EdgeInsets.only(top: 20,bottom: 5,right: 10,left: 10),
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
                          Neumorphic(
                              style: NeumorphicStyle(
                                  color: HexColor("#E3EDF7")
                              ),
                              child:Container(
                                  padding: EdgeInsets.all(10),
                                  child: SvgPicture.asset("assets/images/withdraw_icon.svg"))

                          ),
                          SizedBox(width: 20,),
                          Text("Withdraw Money",style: GoogleFonts.poppins(fontSize: 15,fontWeight: FontWeight.bold,color:Theme.of(context).accentColor),),
                        ],
                      ),


                    ],),
                ),
                Container(
                  margin: EdgeInsets.only(left: 20,top:10,right: 20,bottom: 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [

                      Text("Available Money",style: GoogleFonts.poppins(fontSize: 16,fontWeight: FontWeight.normal,color:Theme.of(context).primaryColor),),
                      Text("${Varibles.DRIVER_WALLET_BALLANCE} INR",style: GoogleFonts.poppins(fontSize: 16,fontWeight: FontWeight.bold,color:Theme.of(context).primaryColor),),
                    ],
                  ),

                ),

                Container(
                  alignment: Alignment.topLeft,
                  margin: EdgeInsets.only(left: 20,top:20,right: 20,bottom: 10),
                  child: Text("Transfering Account",style: GoogleFonts.poppins(fontSize: 16,fontWeight: FontWeight.bold,color:Theme.of(context).primaryColor),),
                ),
                Container(
                  alignment: Alignment.topLeft,
                  margin: EdgeInsets.only(left: 15,top:20,right: 20,bottom: 10),
                  child: TextButton(
onPressed: (){
  showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor:Colors.transparent ,
          content: Container(
            decoration: new BoxDecoration(
                color: HexColor("D6E3F3"),

                borderRadius: new BorderRadius.only(
                    topLeft: const Radius.circular(25.0),
                    topRight: const Radius.circular(25.0),
                bottomLeft:const Radius.circular(25.0),
                bottomRight: const Radius.circular(25.0)
                )),

            padding: EdgeInsets.all(20),

            height: 100,
            width: double.maxFinite,
            child: Center(
              child: ListView(
                  children: <Widget>[
               GestureDetector(
                 onTap: (){
                   Navigator.pop(context);
                 },
                 child: Container(
                   alignment: Alignment.center,
         child:      Column(
           children: [

                 Text("Bank account",style: GoogleFonts.poppins(fontSize: 15,fontWeight: FontWeight.bold,color:Theme.of(context).primaryColor),),
                 Divider(),
           ],
         ),
                 ),
               ),
                    GestureDetector(
                      onTap: (){
                        Navigator.pop(context);
                      },
                      child: Container(
                        alignment: Alignment.center,
                        child:      Column(
                          children: [

                            Text("MoMo MTM Money",style: GoogleFonts.poppins(fontSize: 15,fontWeight: FontWeight.bold,color:Theme.of(context).primaryColor),),
                            Divider(),
                          ],
                        ),
                      ),
                    )
                  ]
              ),
            ),
          ),
        );
      }
  );
},
                    child: Row(
                      children: [
                        Text("Bank account",style: GoogleFonts.poppins(fontSize: 14,fontWeight: FontWeight.normal,color:Theme.of(context).primaryColor),),
                        Icon(Icons.arrow_downward,color: Theme.of(context).primaryColor,)
                      ],
                    ),

                  ),
                ),
                Container(
                  alignment: Alignment.topLeft,
                  margin: EdgeInsets.only(left: 20,top:20,right: 20,bottom: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("Amount",style: GoogleFonts.poppins(fontSize: 15,fontWeight: FontWeight.bold,color:Theme.of(context).primaryColor),),
                      Neumorphic(
style: NeumorphicStyle(
   color: HexColor("#E3EDF7")
),

                        child: Container(
                          width: 100,
                          height: 50,
                          margin: EdgeInsets.all(10),
                          child: TextFormField(
                            // initialValue:"240",
                            controller: amount_text,

                            textAlign: TextAlign.center,
                            style: GoogleFonts.poppins(fontSize: 16,fontWeight: FontWeight.bold,color:Theme.of(context).primaryColor),


                            decoration: InputDecoration(

                                border: InputBorder.none,

                                focusedBorder: InputBorder.none,
                                enabledBorder: InputBorder.none,
                                errorBorder: InputBorder.none,

                            ),
                          ),
                        ),
                      ),
                    ],
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
                          child: Center(child: Text("ADD MONEY",style: GoogleFonts.poppins(color: HexColor("#8B9EB0"),fontSize: 18,fontWeight: FontWeight.bold),))),
                      onPressed: (){

                        EnterdAmountwallte = amount_text.text;
                        if (EnterdAmountwallte == '') {
                          Fluttertoast.showToast(
                              msg: "Enter Amount",
                              toastLength: Toast.LENGTH_SHORT);
                        } else {
                          if (EnterdAmountwallte == '0') {
                            Fluttertoast.showToast(
                                msg: "Amount is not valid",
                                toastLength: Toast.LENGTH_SHORT);
                          } else {
                            sendrequestuserpaymnet();
                          }
                        }


                      }),
                ),
              ],
            ),
          ),
        );
      },
    );

  }


  @override
  void dispose() {
    super.dispose();
    _razorpay.clear();
  }

  void openCheckout() async {
    var options = {
      "key": "rzp_test_bQ8qHHVJhXo87n",
      "amount": Varibles.amount, // Convert Paisa to Rupees
      "name": "AIM CAB",
      "description": Varibles.id,
      "timeout": "180",
      "theme.color": "#1B4670",
      "currency": "INR",
      "prefill": {"contact": "", "email": ""},
      "external": {
        "wallets": ["paytm"]
      }
    };

    try {
      _razorpay.open(options);
    } catch (e) {
      debugPrint('Error: e');
    }
  }

  Future<void> _handlePaymentSuccess(PaymentSuccessResponse response) async {
    //Fluttertoast.showToast(msg: response.paymentId.toString(), toastLength: Toast.LENGTH_SHORT);

    Paymentsendonserver('pay_HVkDuQGMF8aIGm');
  }

  void _handlePaymentError(PaymentFailureResponse response) {
    // Fluttertoast.showToast(
    //     msg: "ERROR: " + response.code.toString() + " - " + response.message,
    //     toastLength: Toast.LENGTH_SHORT);
    // print("error"+response.message);
  }

  void _handleExternalWallet(ExternalWalletResponse response) {
    Fluttertoast.showToast(
        msg: "EXTERNAL_WALLET: " + response.walletName,
        toastLength: Toast.LENGTH_SHORT);
  }
}