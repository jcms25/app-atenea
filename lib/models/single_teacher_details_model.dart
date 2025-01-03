class SingleTeacherModel {
  bool? status;
  String? message;
  List<SingleTeacherDetailItem>? data;

  SingleTeacherModel({this.status, this.message, this.data});

  SingleTeacherModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['Message'];
    if (json['data'] != null) {
      data = <SingleTeacherDetailItem>[];
      json['data'].forEach((v) {
        data!.add(SingleTeacherDetailItem.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = status;
    data['Message'] = message;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class SingleTeacherDetailItem {
  String? tid;
  String? wpUsrId;
  String? firstName;
  String? middleName;
  String? lastName;
  String? zipcode;
  String? country;
  String? city;
  String? address;
  String? empCode;
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
  List<String>? subjectName;

  SingleTeacherDetailItem(
      {this.tid,
        this.wpUsrId,
        this.firstName,
        this.middleName,
        this.lastName,
        this.zipcode,
        this.country,
        this.city,
        this.address,
        this.empCode,
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
        this.image,
        this.subjectName
      });

  SingleTeacherDetailItem.fromJson(Map<String, dynamic> json) {
    tid = json['tid'];
    wpUsrId = json['wp_usr_id'];
    firstName = json['first_name'];
    middleName = json['middle_name'];
    lastName = json['last_name'];
    zipcode = json['zipcode'];
    country = json['country'];
    city = json['city'];
    address = json['address'];
    empCode = json['empcode'];
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
    // subjectName = json['subject_name'];

    if (json['subject_name'] != null) {
      subjectName = <String>[];
      json['subject_name'].forEach((v) {
        subjectName!.add(v);
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['tid'] = tid;
    data['wp_usr_id'] = wpUsrId;
    data['first_name'] = firstName;
    data['middle_name'] = middleName;
    data['last_name'] = lastName;
    data['zipcode'] = zipcode;
    data['country'] = country;
    data['city'] = city;
    data['address'] = address;
    data['empcode'] = empCode;
    data['dob'] = dob;
    data['doj'] = doj;
    data['dol'] = dol;
    data['phone'] = phone;
    data['qualification'] = qualification;
    data['gender'] = gender;
    data['bloodgrp'] = bloodgrp;
    data['position'] = position;
    data['whours'] = whours;
    data['family_care_hour'] = familyCareHour;
    data['ID'] = iD;
    data['user_login'] = userLogin;
    data['user_pass'] = userPass;
    data['user_nicename'] = userNicename;
    data['user_email'] = userEmail;
    data['user_url'] = userUrl;
    data['user_registered'] = userRegistered;
    data['user_activation_key'] = userActivationKey;
    data['user_status'] = userStatus;
    data['display_name'] = displayName;
    data['image'] = image;
    data['subject_name'] = subjectName;
    return data;
  }
}