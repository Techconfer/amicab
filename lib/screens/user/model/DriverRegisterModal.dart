class DriverRegisterModal {
  bool status;
  String token;
  Data data;
  String msg;

  DriverRegisterModal({this.status, this.token, this.data, this.msg});

  DriverRegisterModal.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    token = json['token'];
    data = json['data'] != null ? new Data.fromJson(json['data']) : null;
    msg = json['msg'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['token'] = this.token;
    if (this.data != null) {
      data['data'] = this.data.toJson();
    }
    data['msg'] = this.msg;
    return data;
  }
}

class Data {
  Driverdata driverdata;
  VehicleData vehicleData;

  Data({this.driverdata, this.vehicleData});

  Data.fromJson(Map<String, dynamic> json) {
    driverdata = json['driverdata'] != null
        ? new Driverdata.fromJson(json['driverdata'])
        : null;
    vehicleData = json['vehicle_data'] != null
        ? new VehicleData.fromJson(json['vehicle_data'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.driverdata != null) {
      data['driverdata'] = this.driverdata.toJson();
    }
    if (this.vehicleData != null) {
      data['vehicle_data'] = this.vehicleData.toJson();
    }
    return data;
  }
}

class Driverdata {
  String name;
  String username;
  String licenceNumber;
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
  String mobile;
  List<double> location;
  String type;
  String createdAt;
  int iV;
  bool is_vehcile;

  Driverdata(
      {this.name,
        this.username,
        this.licenceNumber,
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
        this.mobile,
        this.location,
        this.type,
        this.createdAt,
        this.iV,
        this.is_vehcile,
      });

  Driverdata.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    username = json['username'];
    licenceNumber = json['licence_number'];
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
    mobile = json['mobile'];

    type = json['type'];
    createdAt = json['createdAt'];
    iV = json['__v'];
    is_vehcile = json['is_vehcile'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    data['username'] = this.username;
    data['licence_number'] = this.licenceNumber;
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
    data['mobile'] = this.mobile;
    data['location'] = this.location;
    data['type'] = this.type;
    data['createdAt'] = this.createdAt;
    data['__v'] = this.iV;
    data['is_vehcile'] = this.is_vehcile;
    return data;
  }
}

class VehicleData {
  String vehicleType;
  String brandName;
  String model;
  int year;
  bool ownVehicle;
  String plateNumber;
  String licenseNumber;
  int rating;
  String facebookId;
  String googleId;
  List<Null> vehicleImage;
  List<Null> driverDocument;
  String sId;
  String driverId;
  String createdAt;
  int iV;

  VehicleData({this.vehicleType,
    this.brandName,
    this.model,
    this.year,
    this.ownVehicle,
    this.plateNumber,
    this.licenseNumber,
    this.rating,
    this.facebookId,
    this.googleId,
    this.vehicleImage,
    this.driverDocument,
    this.sId,
    this.driverId,
    this.createdAt,
    this.iV});

  VehicleData.fromJson(Map<String, dynamic> json) {
    vehicleType = json['vehicle_type'];
    brandName = json['brand_name'];
    model = json['model'];
    year = json['year'];
    ownVehicle = json['own_vehicle'];
    plateNumber = json['plate_number'];
    licenseNumber = json['license_number'];
    rating = json['rating'];
    facebookId = json['facebook_id'];
    googleId = json['google_id'];


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
    data['license_number'] = this.licenseNumber;
    data['rating'] = this.rating;
    data['facebook_id'] = this.facebookId;
    data['google_id'] = this.googleId;
    if (this.vehicleImage != null) {

    }
    if (this.driverDocument != null) {

    }
    data['_id'] = this.sId;
    data['driver_id'] = this.driverId;
    data['createdAt'] = this.createdAt;
    data['__v'] = this.iV;
    return data;
  }
}
