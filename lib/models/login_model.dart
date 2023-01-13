

class LoginResponseModel {
  bool success;
  int statusCode;
  String code;
  String message;
  Data data;
  LoginResponseModel({
    this.success,
    this.statusCode,
    this.code,
    this.message,
    this.data,
  });

  LoginResponseModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    statusCode = json['statusCode'];
    code = json['code'];
    message = json['message'];
    // data = json['data'] != null ? Data.fromJson(json['data']) : null;
   data = json['data'].length > 0 ? new Data.fromJson(json['data']) : null;
  }
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['success'] = this.success;
    data['statusCode'] = this.statusCode;
    data['code'] = this.code;
    data['message'] = this.message;

    if (this.data != null) {
      data['data'] = this.data.toJson();
    }
    return data;
  }
}

class Data {
  String token;
  int id;
  String email;
  String nicename;
  String firstname;
  String lastname;
  String displayName;
  Data(
      {this.token,
      this.id,
      this.email,
      this.nicename,
      this.firstname,
      this.lastname,
      this.displayName});
  Data.fromJson(Map<String, dynamic> json) {
    token = json['token'];
    id = json['id'];
    email = json['email'];
    nicename = json['nacename'];
    firstname = json['firstname'];
    displayName = json['displayName'];
  }
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['token'] = this.token;
    data['id'] = this.id;
    data['email'] = this.email;
    data['nicename'] = this.nicename;
    data['firstname'] = this.firstname;
    data['displayName'] = this.displayName;
    return data;
  }
}
