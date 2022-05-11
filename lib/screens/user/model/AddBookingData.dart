class AddBookingData {
  bool status;
  Data data;
  String msg;

  AddBookingData({this.status, this.data, this.msg});

  AddBookingData.fromJson(Map<String, dynamic> json) {
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
  String vehicleType;
  double amount;
  bool paymentDone;
  double amountReceived;
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
  String promoCode;
  String createdAt;
  int iV;

  Data(
      {this.vehicleType,
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
        this.promoCode,
        this.createdAt,
        this.iV});

  Data.fromJson(Map<String, dynamic> json) {
    vehicleType = json['vehicle_type'];
    amount = double.parse(json['amount'].toString());
    paymentDone = json['payment_done'];
    amountReceived = double.parse(json['amount_received'].toString());
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
    sourceLocation = json['source_location'].cast<double>();
    destinationLocation = json['destination_location'].cast<double>();
    currentLocation = json['current_location'].cast<double>();
    payment = json['payment'];
    roundDropLocation = json['round_drop_location'].cast<double>();
    promoCode = json['promo_code'];
    createdAt = json['createdAt'];
    iV = json['__v'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
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
    data['promo_code'] = this.promoCode;
    data['createdAt'] = this.createdAt;
    data['__v'] = this.iV;
    return data;
  }
}