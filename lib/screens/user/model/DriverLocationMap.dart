class LocationMapData {
  bool status;
  List<Data> data;
  String msg;

  LocationMapData({this.status, this.data, this.msg});

  LocationMapData.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    if (json['data'] != null) {
      data = new List<Data>();
      json['data'].forEach((v) {
        data.add(new Data.fromJson(v));
      });
    }
    msg = json['msg'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    if (this.data != null) {
      data['data'] = this.data.map((v) => v.toJson()).toList();
    }
    data['msg'] = this.msg;
    return data;
  }
}

class Data {
  String name;
  String username;
  String licenceNumber;
  String password;
  String gender;
  String dob;
  String otp;
  bool isotpVerified;
  bool isDriverOnline;
  bool isLive;
  bool isRide;
  int walletAmount;
  String userimage;
  String socketId;
  String facebookId;
  String googleId;
  String sId;
  String email;
  List<double> location;
  String type;
  String createdAt;
  int iV;

  Data(
      {this.name,
        this.username,
        this.licenceNumber,
        this.password,
        this.gender,
        this.dob,
        this.otp,
        this.isotpVerified,
        this.isDriverOnline,
        this.isLive,
        this.isRide,
        this.walletAmount,
        this.userimage,
        this.socketId,
        this.facebookId,
        this.googleId,
        this.sId,
        this.email,
        this.location,
        this.type,
        this.createdAt,
        this.iV});

  Data.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    username = json['username'];
    licenceNumber = json['licence_number'];
    password = json['password'];
    gender = json['gender'];
    dob = json['dob'];
    otp = json['otp'];
    isotpVerified = json['isotp_verified'];
    isDriverOnline = json['is_driver_online'];
    isLive = json['is_live'];
    isRide = json['is_ride'];
    walletAmount = json['wallet_amount'];
    userimage = json['userimage'];
    socketId = json['socket_id'];
    facebookId = json['facebook_id'];
    googleId = json['google_id'];
    sId = json['_id'];
    email = json['email'];
    location = json['location'].cast<double>();
    type = json['type'];
    createdAt = json['createdAt'];
    iV = json['__v'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    data['username'] = this.username;
    data['licence_number'] = this.licenceNumber;
    data['password'] = this.password;
    data['gender'] = this.gender;
    data['dob'] = this.dob;
    data['otp'] = this.otp;
    data['isotp_verified'] = this.isotpVerified;
    data['is_driver_online'] = this.isDriverOnline;
    data['is_live'] = this.isLive;
    data['is_ride'] = this.isRide;
    data['wallet_amount'] = this.walletAmount;
    data['userimage'] = this.userimage;
    data['socket_id'] = this.socketId;
    data['facebook_id'] = this.facebookId;
    data['google_id'] = this.googleId;
    data['_id'] = this.sId;
    data['email'] = this.email;
    data['location'] = this.location;
    data['type'] = this.type;
    data['createdAt'] = this.createdAt;
    data['__v'] = this.iV;
    return data;
  }
}