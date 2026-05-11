// To parse this JSON data, do
//
//     final childDetailModel = childDetailModelFromJson(jsonString);

import 'dart:convert';

ChildListDetailModel childDetailModelFromJson(String str) => ChildListDetailModel.fromJson(json.decode(str));

String childDetailModelToJson(ChildListDetailModel data) => json.encode(data.toJson());

class ChildListDetailModel {
  ChildListDetailModel({
    required this.status,
    required this.message,
    required this.data,
  });

  bool status;
  String message;
  List<ChildListDatum> data;

  factory ChildListDetailModel.fromJson(Map<String, dynamic> json) => ChildListDetailModel(
    status: json["status"],
    message: json["message"],
    data: List<ChildListDatum>.from(json["data"].map((x) => ChildListDatum.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "message": message,
    "data": List<dynamic>.from(data.map((x) => x.toJson())),
  };
}

class ChildListDatum {
  ChildListDatum({
    required this.sid,
    required this.wpUsrId,
    required this.studentName,
    required this.sRollno,
    required this.sDob,
    required this.sGender,
    required this.sAddress,
    this.sPaddress,
    required this.sCountry,
    required this.sZipcode,
    required this.sPhone,
    required this.classId,
    required this.sCity,
    required this.className,
    required this.studEmail,
    required this.studImage,
    required this.parentData,
  });

  String sid;
  String wpUsrId;
  String studentName;
  String sRollno;
  String sDob;
  String sGender;
  String sAddress;
  String? sPaddress;
  String sCountry;
  String sZipcode;
  String sPhone;
  String classId;
  String sCity;
  String className;
  String studEmail;
  String studImage;
  List<ParentDatum> parentData;

  factory ChildListDatum.fromJson(Map<String, dynamic> json) => ChildListDatum(
    sid: json["sid"] ?? "",
    wpUsrId: json["wp_usr_id"] ?? "",
    studentName: json["student_name"] ?? "",
    sRollno: json["s_rollno"] ?? "",
    sDob: json["s_dob"] ?? "",
    sGender: json["s_gender"] ?? "",
    sAddress: json["s_address"] ?? "",
    sPaddress: json["s_paddress"],
    sCountry: json["s_country"] ?? "",
    sZipcode: json["s_zipcode"] ?? "",
    sPhone: json["s_phone"] ?? "",
    classId: json["class_id"] ?? "",
    sCity: json["s_city"] ?? "",
    className: json["class_name"] ?? "",
    studEmail: json["stud_email"] ?? "",
    studImage: json["stud_image"] ?? "",
    parentData: List<ParentDatum>.from((json["ParentData"] ?? []).map((x) => ParentDatum.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "sid": sid,
    "wp_usr_id": wpUsrId,
    "student_name": studentName,
    "s_rollno": sRollno,
    "s_dob": sDob,
    "s_gender": sGender,
    "s_address": sAddress,
    "s_paddress": sPaddress,
    "s_country": sCountry,
    "s_zipcode": sZipcode,
    "s_phone": sPhone,
    "class_id": classId,
    "s_city": sCity,
    "class_name": className,
    "stud_email": studEmail,
    "stud_image": studImage,
    "ParentData": List<dynamic>.from(parentData.map((x) => x.toJson())),
  };
}


class ParentDatum {
  ParentDatum({
    required this.parentName,
    required this.stuWpUsrId,
    required this.parentWpUsrId,
    required this.pPhone,
    required this.sPaddress,
    required this.pEmail,
    required this.parentImage,
  });

  String parentName;
  String stuWpUsrId;
  String parentWpUsrId;
  String pPhone;
  String sPaddress;
  String pEmail;
  String parentImage;

  factory ParentDatum.fromJson(Map<String, dynamic> json) => ParentDatum(
    parentName: json["parent_name"] ?? "",
    stuWpUsrId: json["stu_wp_usr_id"] ?? "",
    parentWpUsrId: json["parent_wp_usr_id"] ?? "",
    pPhone: json["p_phone"] ?? "",
    sPaddress: json["s_paddress"] ?? "",
    pEmail: json["p_email"] ?? "",
    parentImage: json["parent_image"] ?? "",
  );

  Map<String, dynamic> toJson() => {
    "parent_name": parentName,
    "stu_wp_usr_id": stuWpUsrId,
    "parent_wp_usr_id": parentWpUsrId,
    "p_phone": pPhone,
    "s_paddress": sPaddress,
    "p_email": pEmail,
    "parent_image": parentImage,
  };
}
