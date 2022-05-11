class RazorPayWallet {
  bool status;
  Data data;
  String msg;

  RazorPayWallet({this.status, this.data, this.msg});

  RazorPayWallet.fromJson(Map<String, dynamic> json) {
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
  String systemOrderId;
  RazorPayOrder razorPayOrder;

  Data({this.systemOrderId, this.razorPayOrder});

  Data.fromJson(Map<String, dynamic> json) {
    systemOrderId = json['SystemOrderId'];
    razorPayOrder = json['RazorPayOrder'] != null
        ? new RazorPayOrder.fromJson(json['RazorPayOrder'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['SystemOrderId'] = this.systemOrderId;
    if (this.razorPayOrder != null) {
      data['RazorPayOrder'] = this.razorPayOrder.toJson();
    }
    return data;
  }
}

class RazorPayOrder {
  String id;
  String entity;
  int amount;
  int amountPaid;
  int amountDue;
  String currency;
  String receipt;
  Null offerId;
  String status;
  int attempts;
  List<Null> notes;
  int createdAt;

  RazorPayOrder(
      {this.id,
        this.entity,
        this.amount,
        this.amountPaid,
        this.amountDue,
        this.currency,
        this.receipt,
        this.offerId,
        this.status,
        this.attempts,
        this.notes,
        this.createdAt});

  RazorPayOrder.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    entity = json['entity'];
    amount = json['amount'];
    amountPaid = json['amount_paid'];
    amountDue = json['amount_due'];
    currency = json['currency'];
    receipt = json['receipt'];
    offerId = json['offer_id'];
    status = json['status'];
    attempts = json['attempts'];
    createdAt = json['created_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['entity'] = this.entity;
    data['amount'] = this.amount;
    data['amount_paid'] = this.amountPaid;
    data['amount_due'] = this.amountDue;
    data['currency'] = this.currency;
    data['receipt'] = this.receipt;
    data['offer_id'] = this.offerId;
    data['status'] = this.status;
    data['attempts'] = this.attempts;
    if (this.notes != null) {

    }
    data['created_at'] = this.createdAt;
    return data;
  }
}