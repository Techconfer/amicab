import 'dart:convert';

import 'package:aim_cab/screens/user/model/DriverRegisterModal.dart';
import 'package:aim_cab/screens/user/model/User.dart';
import 'package:carp_background_location/carp_background_location.dart';
import 'package:flutter/material.dart';
import 'package:flutter_overlay_loader/flutter_overlay_loader.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:toast/toast.dart';

class HexColor extends Color {
  static int _getColorFromHex(String hexColor) {
    hexColor = hexColor.toUpperCase().replaceAll("#", "");
    if (hexColor.length == 6) {
      hexColor = "FF" + hexColor;
    }
    return int.parse(hexColor, radix: 16);
  }

  HexColor(final String hexColor) : super(_getColorFromHex(hexColor));
}

isDriverWithCar() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  try {
    return prefs.getBool("driver_car");
  } catch (e) {
    return false;
  }
}

setUser(Map<String, dynamic> val, String token) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  prefs.setString("user_type", "user");
  prefs.setString("token", token);
  prefs.setString("user", jsonEncode(User.fromJson(val)));
}

setUserWithoutToken(Map<String, dynamic> val) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  prefs.setString("user_type", "user");

  prefs.setString("user", jsonEncode(User.fromJson(val)));
}

logoutUser() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();

  prefs.clear();

  await LocationManager().stop();
}

setDriver(Map<String, dynamic> val, String token) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  print("token:" + token);
  print("drive set:" + Driverdata.fromJson(val).toJson().toString());
  prefs.setString("user_type", "driver");
  prefs.setString("token", token);
  prefs.setString("driver", jsonEncode(Driverdata.fromJson(val)));
}

setTransporter(Map<String, dynamic> val, String token) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  print("token:" + token);
  print("drive set:" + Driverdata.fromJson(val).toJson().toString());
  prefs.setString("user_type", "transporter");
  prefs.setString("token", token);
  prefs.setString("transporter", jsonEncode(Driverdata.fromJson(val)));
}

setTransporters(Map<String, dynamic> val) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();

  print("drive set:" + Driverdata.fromJson(val).toJson().toString());
  prefs.setString("user_type", "transporter");

  prefs.setString("transporter", jsonEncode(Driverdata.fromJson(val)));
}

setvehicle(Map<String, dynamic> val) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();

  prefs.setString("vehicle", jsonEncode(VehicleData.fromJson(val)));
}

setDriverWithoutToken(Map<String, dynamic> val) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  print("drive set:" + Driverdata.fromJson(val).toJson().toString());
  prefs.setString("user_type", "driver");

  prefs.setString("driver", jsonEncode(Driverdata.fromJson(val)));
}

Future<String> getToken() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  print("token:" + prefs.getString("token"));
  return prefs.getString("token");
}

Future<Driverdata> getDriver() async {
  try {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    Map json = jsonDecode(prefs.getString('driver'));
    var user = Driverdata.fromJson(json);
    print("driver get:" + user.toJson().toString());
    return user;
  } catch (Exeception) {
    return null;
  }
}

Future<VehicleData> getVehicle() async {
  try {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    Map json = jsonDecode(prefs.getString('vehicle'));
    var user = VehicleData.fromJson(json);
    print("driver get:" + user.toJson().toString());
    return user;
  } catch (Exeception) {
    return null;
  }
}

Future<Driverdata> getTransporter() async {
  try {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    Map json = jsonDecode(prefs.getString('transporter'));
    var user = Driverdata.fromJson(json);
    return user;
  } catch (Exeception) {
    return null;
  }
}

Future<User> getUser() async {
  try {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    Map json = jsonDecode(prefs.getString('user'));
    var user = User.fromJson(json);
    return user;
  } catch (Exeception) {
    return null;
  }
}

Future<String> getUserType() async {
  try {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    return prefs.getString('user_type');
  } catch (Exeception) {
    return null;
  }
}

Future<bool> getOnlineStatus() async {
  try {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    return prefs.getBool('driver_is_online');
  } catch (Exeception) {
    return false;
  }
}

setOnlineStatus(bool isOnline) async {
  try {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    prefs.setBool('driver_is_online', isOnline);
  } catch (Exeception) {}
}

showLoader(BuildContext context) {
  Loader.show(context, progressIndicator: CircularProgressIndicator());
}

dissmissLoader(BuildContext context) {
  Loader.hide();
}

setDriverWithCar(bool val) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();

  prefs.setBool("driver_car", val);
}

void showSuccess(BuildContext context, String show) {
  Toast.show(show, context, backgroundColor: Colors.green, duration: 2);
}

void showError(BuildContext context, String show) {
  Toast.show(show, context, backgroundColor: Colors.red, duration: 2);
}

final ButtonStyle flatButtonStyle = TextButton.styleFrom(
  primary: Colors.blue,
  minimumSize: Size(88, 36),
  padding: EdgeInsets.symmetric(horizontal: 16.0),
  shape: const RoundedRectangleBorder(
    borderRadius: BorderRadius.all(Radius.circular(2.0)),
  ),
);
const appUrl = "http://api.cabandcargo.com/v1.0";
const textColor = "#8B9EB0";
const carIcon =
    '<svg width="23" height="23" viewBox="0 0 23 23" fill="none" xmlns="http://www.w3.org/2000/svg"><path d="M21.2664 9.01127L19.6533 3.93499C19.2855 2.77731 18.1786 2 16.899 2H6.10095C4.82138 2 3.71447 2.77731 3.34667 3.93499L1.73361 9.01127C0.71506 9.42917 0 10.3861 0 11.5V16.9286C0 17.678 0.643646 18.2857 1.4375 18.2857H1.43759L1.4375 19.6428C1.4375 20.3923 2.08106 21 2.875 21H4.31259C5.10644 21 5.75009 20.3923 5.75009 19.6429L5.74947 18.2857H17.25L17.2499 19.6428C17.2499 20.3923 17.8935 21 18.6874 21H20.125C20.9189 21 21.5625 20.3923 21.5625 19.6429V18.2858L21.562 18.2857H21.5625C22.3564 18.2857 23 17.678 23 16.9286V11.5C23 10.3861 22.2849 9.42916 21.2664 9.01127L21.2664 9.01127ZM6.10091 4.71429H16.899L18.1928 8.78571H4.80712L6.1009 4.71429H6.10091ZM5.74996 14.8929C4.95601 14.8929 4.31246 14.2852 4.31246 13.5357C4.31246 12.7862 4.95601 12.1786 5.74996 12.1786C6.5439 12.1786 7.18745 12.7862 7.18745 13.5357C7.18745 14.2852 6.5439 14.8929 5.74996 14.8929ZM17.25 14.8929C16.456 14.8929 15.8125 14.2852 15.8125 13.5357C15.8125 12.7862 16.456 12.1786 17.25 12.1786C18.0439 12.1786 18.6875 12.7862 18.6875 13.5357C18.6875 14.2852 18.0439 14.8929 17.25 14.8929Z" fill="#1B4670"/></svg>';
const homeIcon =
    '<svg width="22" height="20" viewBox="0 0 22 20" fill="none" xmlns="http://www.w3.org/2000/svg"><path d="M11 0L0 11V16.5C0 18.156 1.344 19.5 3 19.5H19C20.656 19.5 22 18.156 22 16.5V11L11 0Z" fill="#1B4670"/></svg>';
const supportIcon =
    '<svg width="22" height="19" viewBox="0 0 22 19" fill="none" xmlns="http://www.w3.org/2000/svg"><path d="M8 13C5.33 13 0 14.34 0 17V19H16V17C16 14.34 10.67 13 8 13ZM15.76 3.36L14.08 5.05C14.92 6.23 14.92 7.76 14.08 8.94L15.76 10.63C17.78 8.61 17.78 5.56 15.76 3.36ZM19.07 0L17.44 1.63C20.21 4.65 20.21 9.19 17.44 12.37L19.07 14C22.97 10.11 22.98 4.05 19.07 0Z" fill="#1B4670"/></svg>';
const accountIcon =
    '<svg width="21" height="21" viewBox="0 0 21 21" fill="none" xmlns="http://www.w3.org/2000/svg"><g clip-path="url(#clip0)"> <path d="M10.3505 10.1158C11.7403 10.1158 12.9437 9.61736 13.9269 8.63395C14.9102 7.6507 15.4086 6.44762 15.4086 5.05774C15.4086 3.66833 14.9102 2.4651 13.9268 1.48153C12.9433 0.498436 11.7401 0 10.3505 0C8.96066 0 7.75758 0.498436 6.77433 1.48169C5.79108 2.46494 5.29248 3.66817 5.29248 5.05774C5.29248 6.44762 5.79108 7.65086 6.77449 8.63411C7.7579 9.6172 8.96114 10.1158 10.3505 10.1158Z" fill="#1B4670"/><path d="M19.2006 16.148C19.1722 15.7388 19.1149 15.2924 19.0304 14.8211C18.9452 14.3462 18.8355 13.8972 18.7041 13.4869C18.5684 13.0628 18.3838 12.644 18.1557 12.2427C17.9189 11.8261 17.6407 11.4634 17.3286 11.1649C17.0023 10.8526 16.6027 10.6016 16.1406 10.4184C15.6801 10.2363 15.1699 10.144 14.624 10.144C14.4096 10.144 14.2023 10.232 13.8019 10.4926C13.5555 10.6533 13.2673 10.8392 12.9456 11.0447C12.6705 11.22 12.2978 11.3842 11.8375 11.5329C11.3884 11.6782 10.9324 11.7519 10.4824 11.7519C10.0323 11.7519 9.57651 11.6782 9.12694 11.5329C8.66711 11.3844 8.29445 11.2202 8.01968 11.0449C7.701 10.8413 7.41261 10.6554 7.16251 10.4925C6.76261 10.2318 6.55513 10.1438 6.34076 10.1438C5.79474 10.1438 5.28461 10.2363 4.8243 10.4186C4.36256 10.6014 3.96281 10.8525 3.63613 11.1651C3.32419 11.4637 3.04589 11.8263 2.80941 12.2427C2.58142 12.644 2.39685 13.0627 2.26099 13.4871C2.12977 13.8974 2.02002 14.3462 1.93478 14.8211C1.85035 15.2918 1.79299 15.7383 1.76463 16.1485C1.73676 16.5503 1.72266 16.9673 1.72266 17.3885C1.72266 18.4847 2.07113 19.3722 2.7583 20.0267C3.43698 20.6725 4.335 21.0002 5.42704 21.0002H15.5387C16.6307 21.0002 17.5284 20.6727 18.2073 20.0267C18.8946 19.3727 19.2431 18.4851 19.2431 17.3884C19.2429 16.9652 19.2286 16.5479 19.2006 16.148Z" fill="#1B4670"/></g> <defs> <clipPath id="clip0"> <rect width="21" height="21.0001" fill="white"/></clipPath></defs></svg>';
