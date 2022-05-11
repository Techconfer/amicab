class DriverFindVehicleShowDetailsModel {
  bool status;
  List<Data> data;
  String msg;

  DriverFindVehicleShowDetailsModel({this.status, this.data, this.msg});

  DriverFindVehicleShowDetailsModel.fromJson(Map<String, dynamic> json) {
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

  Data(
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

  Data.fromJson(Map<String, dynamic> json) {
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