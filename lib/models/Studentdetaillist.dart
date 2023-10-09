// To parse this JSON data, do
//
//     final studentdetaillist = studentdetaillistFromJson(jsonString);

import 'dart:convert';

Studentdetaillist studentdetaillistFromJson(String str) => Studentdetaillist.fromJson(json.decode(str));

String studentdetaillistToJson(Studentdetaillist data) => json.encode(data.toJson());

class Studentdetaillist {
  Studentdetaillist({
  required  this.status,
  required  this.message,
   required this.studentDetails,
  });

  bool status;
  String message;
  StudentDetails studentDetails;

  factory Studentdetaillist.fromJson(Map<String, dynamic> json) => Studentdetaillist(
    status: json["status"],
    message: json["Message"],
    studentDetails: StudentDetails.fromJson(json["studentDetails"]),
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "Message": message,
    "studentDetails": studentDetails.toJson(),
  };
}

class StudentDetails {
  StudentDetails({
    required  this.sid,
    required  this.wpUsrId,
    required  this.sRollno,
    required  this.sFname,
    required  this.sMname,
    required  this.sLname,
    required  this.sDob,
    required  this.sGender,
    required  this.sAddress,
    required this.sCity,
    required  this.sZipcode,
    required  this.sCountry,
    required  this.sPhone,
    required  this.sBloodgrp,
    required  this.sDoj,
    required  this.classId,
    required  this.classDate,
    required  this.stuImage,
    required  this.stuEmail,
    required  this.parentData,
    required  this.className,
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
  String? sCity;
  String? sZipcode;
  String? sCountry;
  String? sPhone;
  String? sBloodgrp;
  DateTime? sDoj;
  String? classId;
  String? classDate;
  String? stuImage;
  String? stuEmail;
  List<ParentsDatum> parentData;
  String? className;

  factory StudentDetails.fromJson(Map<String, dynamic> json) => StudentDetails(
    sid: json["sid"],
    wpUsrId: json["wp_usr_id"],
    sRollno: json["s_rollno"],
    sFname: json["s_fname"],
    sMname: json["s_mname"],
    sLname: json["s_lname"],
    sDob: DateTime.parse(json["s_dob"] ?? "0000-00-00"),
    sGender: json["s_gender"],
    sAddress: json["s_address"],
    sCity: json["s_city"],
    sZipcode: json["s_zipcode"],
    sCountry: json["s_country"],
    sPhone: json["s_phone"],
    sBloodgrp: json["s_bloodgrp"],
    sDoj: DateTime.parse(json["s_doj"] ?? "0000-00-00"),
    classId: json["class_id"],
    classDate: json["class_date"],
    stuImage: json["stu_image"],
    stuEmail: json["stu_email"],
    parentData: List<ParentsDatum>.from(json["parentData"].map((x) => ParentsDatum.fromJson(x))),
    className: json["class_name"],
  );

  Map<String, dynamic> toJson() => {
    "sid": sid,
    "wp_usr_id": wpUsrId,
    "s_rollno": sRollno,
    "s_fname": sFname,
    "s_mname": sMname,
    "s_lname": sLname,
    "s_dob": sDob == null ? null : "${sDob!.year.toString().padLeft(4, '0')}-${sDob!.month.toString().padLeft(2, '0')}-${sDob!.day.toString().padLeft(2, '0')}",
    "s_gender": sGender,
    "s_address": sAddress,
    "s_city": sCity,
    "s_zipcode": sZipcode,
    "s_country": sCountry,
    "s_phone": sPhone,
    "s_bloodgrp": sBloodgrp,
    "s_doj": sDoj == null ? null : "${sDoj!.year.toString().padLeft(4, '0')}-${sDoj!.month.toString().padLeft(2, '0')}-${sDoj!.day.toString().padLeft(2, '0')}",
    "class_id": classId,
    "class_date": classDate,
    "stu_image": stuImage,
    "stu_email": stuEmail,
    "parentData": List<dynamic>.from(parentData.map((x) => x.toJson())),
    "class_name": className,
  };
}

class ParentsDatum {
  ParentsDatum({
    required  this.pid,
    required  this.stuWpUsrId,
    required this.parentWpUsrId,
    required  this.pFname,
    required  this.pMname,
    required this.pLname,
    required  this.pGender,
    required  this.pEdu,
    required  this.pPhone,
    required  this.pProfession,
    required  this.pBloodgrp,
    required this.sPcity,
    required  this.sPcountry,
    required this.sPzipcode,
    required  this.sPaddress,
    required this.parentImage,
   required this.parentEmail,
  });

  String? pid;
  String? stuWpUsrId;
  String? parentWpUsrId;
  String? pFname;
  String? pMname;
  String? pLname;
  String? pGender;
  String? pEdu;
  String? pPhone;
  String? pProfession;
  String? pBloodgrp;
  String? sPcity;
  String? sPcountry;
  String? sPzipcode;
  String? sPaddress;
  String? parentImage;
  String? parentEmail;

  factory ParentsDatum.fromJson(Map<String, dynamic> json) => ParentsDatum(
    pid: json["pid"],
    stuWpUsrId: json["stu_wp_usr_id"],
    parentWpUsrId: json["parent_wp_usr_id"],
    pFname: json["p_fname"],
    pMname: json["p_mname"],
    pLname: json["p_lname"],
    pGender: json["p_gender"],
    pEdu: json["p_edu"],
    pPhone: json["p_phone"],
    pProfession: json["p_profession"],
    pBloodgrp: json["p_bloodgrp"],
    sPcity: json["s_pcity"],
    sPcountry: json["s_pcountry"],
    sPzipcode: json["s_pzipcode"],
    sPaddress: json["s_paddress"],
    parentImage: json["parent_image"],
    parentEmail: json["parent_email"],
  );

  Map<String, dynamic> toJson() => {
    "pid": pid,
    "stu_wp_usr_id": stuWpUsrId,
    "parent_wp_usr_id": parentWpUsrId,
    "p_fname": pFname,
    "p_mname": pMname,
    "p_lname": pLname,
    "p_gender": pGender,
    "p_edu": pEdu,
    "p_phone": pPhone,
    "p_profession": pProfession,
    "p_bloodgrp": pBloodgrp,
    "s_pcity": sPcity,
    "s_pcountry": sPcountry,
    "s_pzipcode": sPzipcode,
    "s_paddress": sPaddress,
    "parent_image": parentImage,
    "parent_email": parentEmail,
  };
}
