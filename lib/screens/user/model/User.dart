class User {
  String userimage;
  String sId;
  String name;
  String username;
  String email;
  String password;
  String mobile;
  String gender;
  String dob;

  User(
      {this.userimage,
        this.sId,
        this.name,
        this.username,
        this.email,
        this.password,
        this.mobile,
        this.gender,
        this.dob});

  User.fromJson(Map<String, dynamic> json) {
    userimage = json['userimage'];
    sId = json['_id'];
    name = json['name'];
    username = json['username'];
    email = json['email'];
    password = json['password'];
    mobile = json['mobile'];
    gender = json['gender'];
    dob = json['dob'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['userimage'] = this.userimage;
    data['_id'] = this.sId;
    data['name'] = this.name;
    data['username'] = this.username;
    data['email'] = this.email;
    data['password'] = this.password;
    data['mobile'] = this.mobile;
    data['gender'] = this.gender;
    data['dob'] = this.dob;
    return data;
  }
}