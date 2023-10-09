class Singleteacher {
  bool? status;
  String? message;
  List<Data>? data;

  Singleteacher({this.status, this.message, this.data});

  Singleteacher.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['Message'];
    if (json['data'] != null) {
      data = <Data>[];
      json['data'].forEach((v) {
        data!.add(new Data.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['Message'] = this.message;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Data {
  String? tid;
  String? wpUsrId;
  String? firstName;
  String? middleName;
  String? lastName;
  String? zipcode;
  String? country;
  String? city;
  String? address;
  String? empcode;
  String? dob;
  String? doj;
  String? dol;
  String? phone;
  String? qualification;
  String? gender;
  String? bloodgrp;
  String? position;
  String? whours;
  String? familyCareHour;
  String? iD;
  String? userLogin;
  String? userPass;
  String? userNicename;
  String? userEmail;
  String? userUrl;
  String? userRegistered;
  String? userActivationKey;
  String? userStatus;
  String? displayName;
  String? image;

  Data(
      {this.tid,
        this.wpUsrId,
        this.firstName,
        this.middleName,
        this.lastName,
        this.zipcode,
        this.country,
        this.city,
        this.address,
        this.empcode,
        this.dob,
        this.doj,
        this.dol,
        this.phone,
        this.qualification,
        this.gender,
        this.bloodgrp,
        this.position,
        this.whours,
        this.familyCareHour,
        this.iD,
        this.userLogin,
        this.userPass,
        this.userNicename,
        this.userEmail,
        this.userUrl,
        this.userRegistered,
        this.userActivationKey,
        this.userStatus,
        this.displayName,
        this.image});

  Data.fromJson(Map<String, dynamic> json) {
    tid = json['tid'];
    wpUsrId = json['wp_usr_id'];
    firstName = json['first_name'];
    middleName = json['middle_name'];
    lastName = json['last_name'];
    zipcode = json['zipcode'];
    country = json['country'];
    city = json['city'];
    address = json['address'];
    empcode = json['empcode'];
    dob = json['dob'];
    doj = json['doj'];
    dol = json['dol'];
    phone = json['phone'];
    qualification = json['qualification'];
    gender = json['gender'];
    bloodgrp = json['bloodgrp'];
    position = json['position'];
    whours = json['whours'];
    familyCareHour = json['family_care_hour'];
    iD = json['ID'];
    userLogin = json['user_login'];
    userPass = json['user_pass'];
    userNicename = json['user_nicename'];
    userEmail = json['user_email'];
    userUrl = json['user_url'];
    userRegistered = json['user_registered'];
    userActivationKey = json['user_activation_key'];
    userStatus = json['user_status'];
    displayName = json['display_name'];
    image = json['image'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['tid'] = this.tid;
    data['wp_usr_id'] = this.wpUsrId;
    data['first_name'] = this.firstName;
    data['middle_name'] = this.middleName;
    data['last_name'] = this.lastName;
    data['zipcode'] = this.zipcode;
    data['country'] = this.country;
    data['city'] = this.city;
    data['address'] = this.address;
    data['empcode'] = this.empcode;
    data['dob'] = this.dob;
    data['doj'] = this.doj;
    data['dol'] = this.dol;
    data['phone'] = this.phone;
    data['qualification'] = this.qualification;
    data['gender'] = this.gender;
    data['bloodgrp'] = this.bloodgrp;
    data['position'] = this.position;
    data['whours'] = this.whours;
    data['family_care_hour'] = this.familyCareHour;
    data['ID'] = this.iD;
    data['user_login'] = this.userLogin;
    data['user_pass'] = this.userPass;
    data['user_nicename'] = this.userNicename;
    data['user_email'] = this.userEmail;
    data['user_url'] = this.userUrl;
    data['user_registered'] = this.userRegistered;
    data['user_activation_key'] = this.userActivationKey;
    data['user_status'] = this.userStatus;
    data['display_name'] = this.displayName;
    data['image'] = this.image;
    return data;
  }
}