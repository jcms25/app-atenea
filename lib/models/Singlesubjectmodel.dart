// To parse this JSON data, do
//
//     final singlesubject = singlesubjectFromJson(jsonString);

import 'dart:convert';

Singlesubject singlesubjectFromJson(String str) => Singlesubject.fromJson(json.decode(str));

String singlesubjectToJson(Singlesubject data) => json.encode(data.toJson());

class Singlesubject {
  Singlesubject({
    required this.status,
    required this.message,
    required  this.data,
  });

  bool status;
  String message;
  List<Datum> data;

  factory Singlesubject.fromJson(Map<String, dynamic> json) => Singlesubject(
    status: json["status"],
    message: json["Message"],
    data: List<Datum>.from(json["data"].map((x) => Datum.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "Message": message,
    "data": List<dynamic>.from(data.map((x) => x.toJson())),
  };
}

class Datum {
  Datum({
    required  this.id,
    required  this.subCode,
    required this.classId,
    required this.subName,
    required this.subTeachId,
    required  this.bookName,
    required this.subDesc,
    required  this.maxMark,
    required  this.passMark,
    required  this.tid,
    required  this.wpUsrId,
    required  this.firstName,
    required  this.middleName,
    required  this.lastName,
    required  this.zipcode,
    required  this.country,
    required  this.city,
    required  this.address,
    required  this.empcode,
    required  this.dob,
    required  this.doj,
    required  this.dol,
    required this.phone,
    required  this.qualification,
    required  this.gender,
    required  this.bloodgrp,
    required  this.position,
    required this.whours,
    required  this.familyCareHour,
    required  this.cid,
    required this.cNumb,
    required  this.cName,
    required this.teacherId,
    required this.cCapacity,
    required  this.cLoc,
    required  this.cSdate,
    required  this.cEdate,
   required this.cFeeType,
  });

  String id;
  String subCode;
  String classId;
  String subName;
  String subTeachId;
  String bookName;
  dynamic subDesc;
  dynamic maxMark;
  dynamic passMark;
  String tid;
  String wpUsrId;
  String firstName;
  dynamic middleName;
  String lastName;
  String zipcode;
  String country;
  String city;
  String address;
  String empcode;
  DateTime dob;
  dynamic doj;
  dynamic dol;
  String phone;
  dynamic qualification;
  String gender;
  dynamic bloodgrp;
  dynamic position;
  dynamic whours;
  dynamic familyCareHour;
  String cid;
  String cNumb;
  String cName;
  String teacherId;
  String cCapacity;
  String cLoc;
  DateTime cSdate;
  DateTime cEdate;
  String cFeeType;

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
    id: json["id"],
    subCode: json["sub_code"],
    classId: json["class_id"],
    subName: json["sub_name"],
    subTeachId: json["sub_teach_id"],
    bookName: json["book_name"],
    subDesc: json["sub_desc"],
    maxMark: json["max_mark"],
    passMark: json["pass_mark"],
    tid: json["tid"],
    wpUsrId: json["wp_usr_id"],
    firstName: json["first_name"],
    middleName: json["middle_name"],
    lastName: json["last_name"],
    zipcode: json["zipcode"],
    country: json["country"],
    city: json["city"],
    address: json["address"],
    empcode: json["empcode"],
    dob: DateTime.parse(json["dob"]),
    doj: json["doj"],
    dol: json["dol"],
    phone: json["phone"],
    qualification: json["qualification"],
    gender: json["gender"],
    bloodgrp: json["bloodgrp"],
    position: json["position"],
    whours: json["whours"],
    familyCareHour: json["family_care_hour"],
    cid: json["cid"],
    cNumb: json["c_numb"],
    cName: json["c_name"],
    teacherId: json["teacher_id"],
    cCapacity: json["c_capacity"],
    cLoc: json["c_loc"],
    cSdate: DateTime.parse(json["c_sdate"]),
    cEdate: DateTime.parse(json["c_edate"]),
    cFeeType: json["c_fee_type"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "sub_code": subCode,
    "class_id": classId,
    "sub_name": subName,
    "sub_teach_id": subTeachId,
    "book_name": bookName,
    "sub_desc": subDesc,
    "max_mark": maxMark,
    "pass_mark": passMark,
    "tid": tid,
    "wp_usr_id": wpUsrId,
    "first_name": firstName,
    "middle_name": middleName,
    "last_name": lastName,
    "zipcode": zipcode,
    "country": country,
    "city": city,
    "address": address,
    "empcode": empcode,
    "dob": "${dob.year.toString().padLeft(4, '0')}-${dob.month.toString().padLeft(2, '0')}-${dob.day.toString().padLeft(2, '0')}",
    "doj": doj,
    "dol": dol,
    "phone": phone,
    "qualification": qualification,
    "gender": gender,
    "bloodgrp": bloodgrp,
    "position": position,
    "whours": whours,
    "family_care_hour": familyCareHour,
    "cid": cid,
    "c_numb": cNumb,
    "c_name": cName,
    "teacher_id": teacherId,
    "c_capacity": cCapacity,
    "c_loc": cLoc,
    "c_sdate": "${cSdate.year.toString().padLeft(4, '0')}-${cSdate.month.toString().padLeft(2, '0')}-${cSdate.day.toString().padLeft(2, '0')}",
    "c_edate": "${cEdate.year.toString().padLeft(4, '0')}-${cEdate.month.toString().padLeft(2, '0')}-${cEdate.day.toString().padLeft(2, '0')}",
    "c_fee_type": cFeeType,
  };
}
