class RideHistory {
  bool status;
  List<Data> data;
  String msg;

  RideHistory({this.status, this.data, this.msg});

  RideHistory.fromJson(Map<String, dynamic> json) {
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
  RideDetail rideDetail;
  CarData carData;
  DriverData driverData;

  Data({this.rideDetail, this.carData, this.driverData});

  Data.fromJson(Map<String, dynamic> json) {
    rideDetail = json['ride_detail'] != null
        ? new RideDetail.fromJson(json['ride_detail'])
        : null;
    carData = json['car_data'] != null
        ? new CarData.fromJson(json['car_data'])
        : null;
    driverData = json['driver_data'] != null
        ? new DriverData.fromJson(json['driver_data'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.rideDetail != null) {
      data['ride_detail'] = this.rideDetail.toJson();
    }
    if (this.carData != null) {
      data['car_data'] = this.carData.toJson();
    }
    if (this.driverData != null) {
      data['driver_data'] = this.driverData.toJson();
    }
    return data;
  }
}

class RideDetail {
  String driverId;
  String vehicleType;
  var amount;
  bool paymentDone;
  int amountReceived;
  String paymentTime;
  String source;
  String destination;
  bool isArrvied;
  String arrviedTime;
  String distance;
  String date;
  bool isPre;
  bool isRound;
  String status;
  String cancelReason;
  String cancelBy;
  String cancelById;
  String cancelTime;
  String tripDate;
  bool isStart;
  String starttime;
  bool isEnd;
  String endtime;
  String sId;
  String userId;
  List<double> sourceLocation;
  List<double> destinationLocation;
  List<double> currentLocation;
  String payment;
  List<double> roundDropLocation;
  String createdAt;
  int iV;

  RideDetail(
      {this.driverId,
      this.vehicleType,
      this.amount,
      this.paymentDone,
      this.amountReceived,
      this.paymentTime,
      this.source,
      this.destination,
      this.isArrvied,
      this.arrviedTime,
      this.distance,
      this.date,
      this.isPre,
      this.isRound,
      this.status,
      this.cancelReason,
      this.cancelBy,
      this.cancelById,
      this.cancelTime,
      this.tripDate,
      this.isStart,
      this.starttime,
      this.isEnd,
      this.endtime,
      this.sId,
      this.userId,
      this.sourceLocation,
      this.destinationLocation,
      this.currentLocation,
      this.payment,
      this.roundDropLocation,
      this.createdAt,
      this.iV});

  RideDetail.fromJson(Map<String, dynamic> json) {
    driverId = json['driver_id'];
    vehicleType = json['vehicle_type'];
    amount = json['amount'];
    paymentDone = json['payment_done'];
    amountReceived = json['amount_received'];
    paymentTime = json['payment_time'];
    source = json['source'];
    destination = json['destination'];
    isArrvied = json['is_arrvied'];
    arrviedTime = json['arrvied_time'];
    distance = json['distance'];
    date = json['date'];
    isPre = json['is_pre'];
    isRound = json['is_round'];
    status = json['status'];
    cancelReason = json['cancel_reason'];
    cancelBy = json['cancel_by'];
    cancelById = json['cancel_by_id'];
    cancelTime = json['cancel_time'];
    tripDate = json['trip_date'];
    isStart = json['is_start'];
    starttime = json['starttime'];
    isEnd = json['is_end'];
    endtime = json['endtime'];
    sId = json['_id'];
    userId = json['user_id'];
    // sourceLocation = json['source_location'].cast<double>();
    // destinationLocation = json['destination_location'].cast<double>();
    // currentLocation = json['current_location'].cast<double>();
    payment = json['payment'];
    // roundDropLocation = json['round_drop_location'].cast<double>();
    createdAt = json['createdAt'];
    iV = json['__v'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['driver_id'] = this.driverId;
    data['vehicle_type'] = this.vehicleType;
    data['amount'] = this.amount;
    data['payment_done'] = this.paymentDone;
    data['amount_received'] = this.amountReceived;
    data['payment_time'] = this.paymentTime;
    data['source'] = this.source;
    data['destination'] = this.destination;
    data['is_arrvied'] = this.isArrvied;
    data['arrvied_time'] = this.arrviedTime;
    data['distance'] = this.distance;
    data['date'] = this.date;
    data['is_pre'] = this.isPre;
    data['is_round'] = this.isRound;
    data['status'] = this.status;
    data['cancel_reason'] = this.cancelReason;
    data['cancel_by'] = this.cancelBy;
    data['cancel_by_id'] = this.cancelById;
    data['cancel_time'] = this.cancelTime;
    data['trip_date'] = this.tripDate;
    data['is_start'] = this.isStart;
    data['starttime'] = this.starttime;
    data['is_end'] = this.isEnd;
    data['endtime'] = this.endtime;
    data['_id'] = this.sId;
    data['user_id'] = this.userId;
    data['source_location'] = this.sourceLocation;
    data['destination_location'] = this.destinationLocation;
    data['current_location'] = this.currentLocation;
    data['payment'] = this.payment;
    data['round_drop_location'] = this.roundDropLocation;
    data['createdAt'] = this.createdAt;
    data['__v'] = this.iV;
    return data;
  }
}

class CarData {
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
  String sId;
  String driverId;
  String createdAt;
  int iV;

  CarData(
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
      this.sId,
      this.driverId,
      this.createdAt,
      this.iV});

  CarData.fromJson(Map<String, dynamic> json) {
    vehicleType = json['vehicle_type'];
    brandName = json['brand_name'];
    model = json['model'];
    year = json['year'];
    ownVehicle = json['own_vehicle'];
    plateNumber = json['plate_number'];
    rating = json['rating'];
    facebookId = json['facebook_id'];
    googleId = json['google_id'];
    // vehicleImage = json['vehicle_image'];
    // driverDocument = json['driver_document'];
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
    data['_id'] = this.sId;
    data['driver_id'] = this.driverId;
    data['createdAt'] = this.createdAt;
    data['__v'] = this.iV;
    return data;
  }
}

class DriverData {
  String name;
  String username;
  String licenceNumber;
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
  Null firebaseId;
  String facebookId;
  String googleId;
  String sId;
  String email;
  String mobile;
  List<double> location;
  String type;
  String createdAt;
  int iV;

  DriverData(
      {this.name,
      this.username,
      this.licenceNumber,
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

  DriverData.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    username = json['username'];
    licenceNumber = json['licence_number'];
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
    // location = json['location'];
    type = json['type'];
    createdAt = json['createdAt'];
    iV = json['__v'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    data['username'] = this.username;
    data['licence_number'] = this.licenceNumber;
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
