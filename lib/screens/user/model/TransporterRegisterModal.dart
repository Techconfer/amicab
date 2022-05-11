class TransporterRegisterModal {
  bool status;
  Data data;
  String msg;

  TransporterRegisterModal({this.status, this.data, this.msg});

  TransporterRegisterModal.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    data = json['data'] != null ? new Data.fromJson(json['data']) : null;
    msg = json['msg'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    if (this.data != null) {
      data['data'] = this.data.toJson();
    }
    data['msg'] = this.msg;
    return data;
  }
}

class Data {
  bool isotpVerified;
  String rating;
  String profileImage;
  bool isLive;
  String sId;
  String name;
  String username;
  String password;
  String gender;
  String email;
  String dob;
  String mobileNo;
  bool ownVehicle;
  String otp;
  String vehicleType;
  String brandName;
  String model;
  int year;
  String plateNumber;
  String createdAt;
  int iV;

  Data(
      {this.isotpVerified,
        this.rating,
        this.profileImage,
        this.isLive,
        this.sId,
        this.name,
        this.username,
        this.password,
        this.gender,
        this.email,
        this.dob,
        this.mobileNo,
        this.ownVehicle,
        this.otp,
        this.vehicleType,
        this.brandName,
        this.model,
        this.year,
        this.plateNumber,
        this.createdAt,
        this.iV});

  Data.fromJson(Map<String, dynamic> json) {
    isotpVerified = json['isotp_verified'];
    rating = json['rating'];
    profileImage = json['profile_image'];
    isLive = json['is_live'];
    sId = json['_id'];
    name = json['name'];
    username = json['username'];
    password = json['password'];
    gender = json['gender'];
    email = json['email'];
    dob = json['dob'];
    mobileNo = json['mobile_no'];
    ownVehicle = json['own_vehicle'];
    otp = json['otp'];
    vehicleType = json['vehicle_type'];
    brandName = json['brand_name'];
    model = json['model'];
    year = json['year'];
    plateNumber = json['plate_number'];
    createdAt = json['createdAt'];
    iV = json['__v'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['isotp_verified'] = this.isotpVerified;
    data['rating'] = this.rating;
    data['profile_image'] = this.profileImage;
    data['is_live'] = this.isLive;
    data['_id'] = this.sId;
    data['name'] = this.name;
    data['username'] = this.username;
    data['password'] = this.password;
    data['gender'] = this.gender;
    data['email'] = this.email;
    data['dob'] = this.dob;
    data['mobile_no'] = this.mobileNo;
    data['own_vehicle'] = this.ownVehicle;
    data['otp'] = this.otp;
    data['vehicle_type'] = this.vehicleType;
    data['brand_name'] = this.brandName;
    data['model'] = this.model;
    data['year'] = this.year;
    data['plate_number'] = this.plateNumber;
    data['createdAt'] = this.createdAt;
    data['__v'] = this.iV;
    return data;
  }
}