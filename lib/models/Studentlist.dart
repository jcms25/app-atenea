
import 'dart:convert';

StudentList studentListFromJson(String str) => StudentList.fromJson(json.decode(str));

String studentListToJson(StudentList data) => json.encode(data.toJson());

class StudentList {
  StudentList({
    required   this.status,
    required  this.message,
    required this.studentlist,
  });

  bool status;
  String message;
  List<Studentlist> studentlist;

  factory StudentList.fromJson(Map<String, dynamic> json) => StudentList(
    status: json["status"],
    message: json["Message"],
    studentlist: List<Studentlist>.from(json["studentlist"].map((x) => Studentlist.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "Message": message,
    "studentlist": List<dynamic>.from(studentlist.map((x) => x.toJson())),
  };
}

class Studentlist {
  Studentlist({
    required  this.sid,
    required  this.wpUsrId,
    required this.sRollno,
    required  this.sFname,
    required  this.sMname,
    required  this.sLname,
    required this.sDob,
    required this.sGender,
    required this.sAddress,
    required this.sPaddress,
    required this.sCountry,
    required  this.sZipcode,
    required   this.sPhone,
    required  this.sBloodgrp,
    required  this.sDoj,
    required  this.classId,
    required  this.classDate,
    required  this.sCity,
    required this.className,
    required this.stuEmail,
    required  this.stuImage,
  });

  String sid;
  String wpUsrId;
  String? sRollno;
  String? sFname;
  String? sMname;
  String? sLname;
  DateTime? sDob;
  String? sGender;
  String? sAddress;
  String? sPaddress;
  String? sCountry;
  String? sZipcode;
  String? sPhone;
  String? sBloodgrp;
  DateTime? sDoj;
  String? classId;
  dynamic classDate;
  String? sCity;
  String? className;
  String? stuEmail;
  String? stuImage;

  factory Studentlist.fromJson(Map<String, dynamic> json) => Studentlist(
    sid: json["sid"],
    wpUsrId: json["wp_usr_id"],
    sRollno: json["s_rollno"],
    sFname: json["s_fname"],
    sMname: json["s_mname"],
    sLname: json["s_lname"],
    sDob: DateTime.parse(json["s_dob"] ?? "0000-00-00"),
    sGender: json["s_gender"],
    sAddress: json["s_address"],
    sPaddress: json["s_paddress"],
    sCountry: json["s_country"],
    sZipcode: json["s_zipcode"],
    sPhone: json["s_phone"],
    sBloodgrp: json["s_bloodgrp"],
    sDoj: DateTime.parse(json["s_doj"] ?? "0000-00-00"),
    classId: json["class_id"],
    classDate: json["class_date"],
    sCity: json["s_city"],
    className: json["class_name"],
    stuEmail: json["stu_email"],
    stuImage: json["stu_image"],
  );

  Map<String, dynamic> toJson() => {
    "sid": sid,
    "wp_usr_id": wpUsrId,
    "s_rollno": sRollno,
    "s_fname": sFname,
    "s_mname": sMname,
    "s_lname": sLname,
    "s_dob": sDob == null ? "0000-00-00" : "${sDob!.year.toString().padLeft(4, '0')}-${sDob!.month.toString().padLeft(2, '0')}-${sDob!.day.toString().padLeft(2, '0')}",
    "s_gender": sGender,
    "s_address": sAddress,
    "s_paddress": sPaddress,
    "s_country": sCountry,
    "s_zipcode": sZipcode,
    "s_phone": sPhone,
    "s_bloodgrp": sBloodgrp,
    "s_doj": sDoj == null ? "0000-00-00" : "${sDoj!.year.toString().padLeft(4, '0')}-${sDoj!.month.toString().padLeft(2, '0')}-${sDoj!.day.toString().padLeft(2, '0')}",
    "class_id": classId,
    "class_date": classDate,
    "s_city": sCity,
    "class_name": className,
    "stu_email": stuEmail,
    "stu_image": stuImage,
  };
}
