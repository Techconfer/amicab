class PromocodeData {
  bool status;
  List<Data> data;
  String msg;

  PromocodeData({this.status, this.data, this.msg});

  PromocodeData.fromJson(Map<String, dynamic> json) {
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
  String applyTo;
  int couponValue;
  String couponType;
  Null expiredAt;
  Null currentUsed;
  Null maxUsed;
  String promocode;
  String sId;
  String createdAt;
  int iV;

  Data(
      {this.applyTo,
        this.couponValue,
        this.couponType,
        this.expiredAt,
        this.currentUsed,
        this.maxUsed,
        this.promocode,
        this.sId,
        this.createdAt,
        this.iV});

  Data.fromJson(Map<String, dynamic> json) {
    applyTo = json['apply_to'];
    couponValue = json['coupon_value'];
    couponType = json['coupon_type'];
    expiredAt = json['expiredAt'];
    currentUsed = json['current_used'];
    maxUsed = json['max_used'];
    promocode = json['promocode'];
    sId = json['_id'];
    createdAt = json['createdAt'];
    iV = json['__v'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['apply_to'] = this.applyTo;
    data['coupon_value'] = this.couponValue;
    data['coupon_type'] = this.couponType;
    data['expiredAt'] = this.expiredAt;
    data['current_used'] = this.currentUsed;
    data['max_used'] = this.maxUsed;
    data['promocode'] = this.promocode;
    data['_id'] = this.sId;
    data['createdAt'] = this.createdAt;
    data['__v'] = this.iV;
    return data;
  }
}