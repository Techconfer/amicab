class DriverShowVehicleRequestModel {
  bool status;
  List<Data> data;
  String msg;

  DriverShowVehicleRequestModel({this.status, this.data, this.msg});

  DriverShowVehicleRequestModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    if (json['data'] != null) {
      data = <Data>[];
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
  String status;
  String assginedTime;
  String completeTime;
  String sId;
  DriverId driverId;
  VehcileId vehcileId;
  DriverId transporterId;
  String requestId;
  String createdAt;
  int iV;

  Data(
      {this.status,
        this.assginedTime,
        this.completeTime,
        this.sId,
        this.driverId,
        this.vehcileId,
        this.transporterId,
        this.requestId,
        this.createdAt,
        this.iV});

  Data.fromJson(Map<String, dynamic> json) {
    status = json['Status'];
    assginedTime = json['assginedTime'];
    completeTime = json['CompleteTime'];
    sId = json['_id'];
    driverId = json['DriverId'] != null
         ?new DriverId.fromJson(json['DriverId'])
        : null;
    vehcileId = json['VehcileId'] != null
         ?new VehcileId.fromJson(json['VehcileId'])
        : null;
    transporterId = json['TransporterId'] != null
         ?new DriverId.fromJson(json['TransporterId'])
        : null;
    requestId = json['RequestId'];
    createdAt = json['createdAt'];
    iV = json['__v'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['Status'] = this.status;
    data['assginedTime'] = this.assginedTime;
    data['CompleteTime'] = this.completeTime;
    data['_id'] = this.sId;
    if (this.driverId != null) {
      data['DriverId'] = this.driverId.toJson();
    }
    if (this.vehcileId != null) {
      data['VehcileId'] = this.vehcileId.toJson();
    }
    if (this.transporterId != null) {
      data['TransporterId'] = this.transporterId.toJson();
    }
    data['RequestId'] = this.requestId;
    data['createdAt'] = this.createdAt;
    data['__v'] = this.iV;
    return data;
  }
}

class DriverId {
  String name;
  String username;
  bool isVehcile;
  String licenceNumber;
  String userCountry;
  int rating;
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
  String firebaseId;
  String facebookId;
  String googleId;
  String sId;
  String email;
  String mobile;
  List<double> location;
  String type;
  String createdAt;
  int iV;

  DriverId(
      {this.name,
        this.username,
        this.isVehcile,
        this.licenceNumber,
        this.userCountry,
        this.rating,
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
        this.firebaseId,
        this.facebookId,
        this.googleId,
        this.sId,
        this.email,
        this.mobile,
        this.location,
        this.type,
        this.createdAt,
        this.iV});

  DriverId.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    username = json['username'];
    isVehcile = json['is_vehcile'];
    licenceNumber = json['licence_number'];
    userCountry = json['user_country'];
    rating = json['rating'];
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
    firebaseId = json['firebase_id'];
    facebookId = json['facebook_id'];
    googleId = json['google_id'];
    sId = json['_id'];
    email = json['email'];
    mobile = json['mobile'];
    location = json['location'].cast<double>();
    type = json['type'];
    createdAt = json['createdAt'];
    iV = json['__v'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    data['username'] = this.username;
    data['is_vehcile'] = this.isVehcile;
    data['licence_number'] = this.licenceNumber;
    data['user_country'] = this.userCountry;
    data['rating'] = this.rating;
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
    data['firebase_id'] = this.firebaseId;
    data['facebook_id'] = this.facebookId;
    data['google_id'] = this.googleId;
    data['_id'] = this.sId;
    data['email'] = this.email;
    data['mobile'] = this.mobile;
    data['location'] = this.location;
    data['type'] = this.type;
    data['createdAt'] = this.createdAt;
    data['__v'] = this.iV;
    return data;
  }
}

class VehcileId {
  String vehicleType;
  String brandName;
  String model;
  int year;
  bool ownVehicle;
  String plateNumber;
  int rating;
  String facebookId;
  String googleId;
  List<String> vehicleImage;
  List<String> driverDocument;
  int rent;
  bool isAvailable;
  String sId;
  String driverId;
  String createdAt;
  int iV;

  VehcileId(
      {this.vehicleType,
        this.brandName,
        this.model,
        this.year,
        this.ownVehicle,
        this.plateNumber,
        this.rating,
        this.facebookId,
        this.googleId,
        this.vehicleImage,
        this.driverDocument,
        this.rent,
        this.isAvailable,
        this.sId,
        this.driverId,
        this.createdAt,
        this.iV});

  VehcileId.fromJson(Map<String, dynamic> json) {
    vehicleType = json['vehicle_type'];
    brandName = json['brand_name'];
    model = json['model'];
    year = json['year'];
    ownVehicle = json['own_vehicle'];
    plateNumber = json['plate_number'];
    rating = json['rating'];
    facebookId = json['facebook_id'];
    googleId = json['google_id'];
    vehicleImage = json['vehicle_image'].cast<String>();
    driverDocument = json['driver_document'].cast<String>();
    rent = json['rent'];
    isAvailable = json['isAvailable'];
    sId = json['_id'];
    driverId = json['driver_id'];
    createdAt = json['createdAt'];
    iV = json['__v'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['vehicle_type'] = this.vehicleType;
    data['brand_name'] = this.brandName;
    data['model'] = this.model;
    data['year'] = this.year;
    data['own_vehicle'] = this.ownVehicle;
    data['plate_number'] = this.plateNumber;
    data['rating'] = this.rating;
    data['facebook_id'] = this.facebookId;
    data['google_id'] = this.googleId;
    data['vehicle_image'] = this.vehicleImage;
    data['driver_document'] = this.driverDocument;
    data['rent'] = this.rent;
    data['isAvailable'] = this.isAvailable;
    data['_id'] = this.sId;
    data['driver_id'] = this.driverId;
    data['createdAt'] = this.createdAt;
    data['__v'] = this.iV;
    return data;
  }
}