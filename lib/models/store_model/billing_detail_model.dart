class BillingDetailModel {
  bool? status;
  String? message;
  BillingDetail? data;
  List<ClassItem>? classlist;

  BillingDetailModel({this.status, this.message, this.data, this.classlist});

  BillingDetailModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['Message'];
    data = json['data'] != null ? BillingDetail.fromJson(json['data']) : null;
    if (json['classlist'] != null) {
      classlist = <ClassItem>[];
      json['classlist'].forEach((v) {
        classlist!.add(ClassItem.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = status;
    data['Message'] = message;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    if (classlist != null) {
      data['classlist'] = classlist!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class BillingDetail {
  String? billingFirstName;
  String? billingLastName;
  String? billingNIF;
  String? billingNIFOptional;
  String? billingAddress1;
  String? billingPostcode;
  String? billingCity;
  String? billingEmail;
  String? billingAlumnosName;
  String? billingPhoneNumber;
  String? billingState;
  dynamic billingAlumnosClassName;

  BillingDetail(
      {this.billingFirstName,
        this.billingLastName,
        this.billingNIF,
        this.billingNIFOptional,
        this.billingAddress1,
        this.billingPostcode,
        this.billingCity,
        this.billingEmail,
        this.billingAlumnosName,
        this.billingPhoneNumber,
        this.billingState,
        this.billingAlumnosClassName});

  BillingDetail.fromJson(Map<String, dynamic> json) {
    billingFirstName = json['billing_first_name'];
    billingLastName = json['billing_last_name'];
    billingNIF = json['billing_myfield3'];
    billingNIFOptional = json['billing_vat'];
    billingAddress1 = json['billing_address_1'];
    billingPostcode = json['billing_postcode'];
    billingCity = json['billing_city'];
    billingEmail = json['billing_email'];
    billingAlumnosName = json['billing_wooccm10'];
    billingPhoneNumber = json['billing_phone'];
    billingState = json['billing_state'];

    if(json['billing_wooccm12'] != null && json['billing_wooccm12'].runtimeType == List){
      billingAlumnosClassName = List<String>.from(json['billing_wooccm12'].map((e) => e));
    }else if(json['billing_wooccm12'].runtimeType == String){
      billingAlumnosClassName = json['billing_wooccm12'];
    }else{
      billingAlumnosClassName = null;
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['billing_first_name'] = billingFirstName;
    data['billing_last_name'] = billingLastName;
    data['billing_myfield3'] = billingNIF;
    data['billing_vat'] = billingNIFOptional;
    data['billing_address_1'] = billingAddress1;
    data['billing_postcode'] = billingPostcode;
    data['billing_city'] = billingCity;
    data['billing_email'] = billingEmail;
    data['billing_wooccm10'] = billingAlumnosName;
    data['billing_wooccm12'] = billingAlumnosClassName;
    data['billing_phone'] = billingPhoneNumber;
    data['billing_state'] = billingState;
    return data;
  }
}

class ClassItem {
  String? cid;
  String? cName;

  ClassItem({this.cid, this.cName});

  ClassItem.fromJson(Map<String, dynamic> json) {
    cid = json['cid'];
    cName = json['c_name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['cid'] = cid;
    data['c_name'] = cName;
    return data;
  }
}
