class TeacherlistModel {
  TeacherlistModel({
    this.status,
    this.message,
    this.teacherlist,});

  TeacherlistModel.fromJson(dynamic json) {
    status = json['status'];
    message = json['Message'];
    if (json['teacherlist'] != null) {
      teacherlist = [];
      json['teacherlist'].forEach((v) {
        teacherlist?.add(Teacherlist.fromJson(v));
      });
    }
  }
  bool? status;
  String? message;
  List<Teacherlist>? teacherlist;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['status'] = status;
    map['Message'] = message;
    if (teacherlist != null) {
      map['teacherlist'] = teacherlist?.map((v) => v.toJson()).toList();
    }
    return map;
  }

}

class Teacherlist {
  Teacherlist({
    this.tid,
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
    this.id,
    this.userLogin,
    this.userPass,
    this.userNicename,
    this.userEmail,
    this.userUrl,
    this.userRegistered,
    this.userActivationKey,
    this.userStatus,
    this.displayName,
    this.incharge,
    this.subjectName,
    this.image,});

  Teacherlist.fromJson(dynamic json) {
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
    id = json['ID'];
    userLogin = json['user_login'];
    userPass = json['user_pass'];
    userNicename = json['user_nicename'];
    userEmail = json['user_email'];
    userUrl = json['user_url'];
    userRegistered = json['user_registered'];
    userActivationKey = json['user_activation_key'];
    userStatus = json['user_status'];
    displayName = json['display_name'];
    if (json['incharge'] != null) {
      incharge = [];
      json['incharge'].forEach((v) {
        incharge?.add(v);
      });
    }
    subjectName = json['subject_name'] != null ? json['subject_name'].cast<String>() : [];
    image = json['image'];
  }
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
  String? id;
  String? userLogin;
  String? userPass;
  String? userNicename;
  String? userEmail;
  String? userUrl;
  String? userRegistered;
  String? userActivationKey;
  String? userStatus;
  String? displayName;
  List<String>? incharge;
  List<String>? subjectName;
  String? image;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['tid'] = tid;
    map['wp_usr_id'] = wpUsrId;
    map['first_name'] = firstName;
    map['middle_name'] = middleName;
    map['last_name'] = lastName;
    map['zipcode'] = zipcode;
    map['country'] = country;
    map['city'] = city;
    map['address'] = address;
    map['empcode'] = empcode;
    map['dob'] = dob;
    map['doj'] = doj;
    map['dol'] = dol;
    map['phone'] = phone;
    map['qualification'] = qualification;
    map['gender'] = gender;
    map['bloodgrp'] = bloodgrp;
    map['position'] = position;
    map['whours'] = whours;
    map['ID'] = id;
    map['user_login'] = userLogin;
    map['user_pass'] = userPass;
    map['user_nicename'] = userNicename;
    map['user_email'] = userEmail;
    map['user_url'] = userUrl;
    map['user_registered'] = userRegistered;
    map['user_activation_key'] = userActivationKey;
    map['user_status'] = userStatus;
    map['display_name'] = displayName;
    if (incharge != null) {
      map['incharge'] = incharge?.map((v) => v).toList();
    }
    map['subject_name'] = subjectName;
    map['image'] = image;
    return map;
  }

}