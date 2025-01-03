import 'dart:convert';


ParentLogin parentLoginFromJson(String str) => ParentLogin.fromJson(json.decode(str));

String parentLoginToJson(ParentLogin data) => json.encode(data.toJson());

class ParentLogin {
  ParentLogin({
   required this.status,
    required this.message,
    required this.basicAuthToken,
    required this.userdata,
  });

  bool status;
  String message;
  String basicAuthToken;
  Userdata userdata;

  factory ParentLogin.fromJson(Map<String, dynamic> json) => ParentLogin(
    status: json["status"],
    message: json["Message"],
    basicAuthToken: json["basicAuthToken"],
    userdata: Userdata.fromJson(json["userdata"]),
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "Message": message,
    "basicAuthToken": basicAuthToken,
    "userdata": userdata.toJson(),
  };
}

class Userdata {
  Userdata({
    required  this.parentWpUsrId,
    required  this.pFname,
    required this.pMname,
    required this.pLname,
    required  this.pGender,
    required this.pEdu,
    required this.pPhone,
    required this.pProfession,
    required this.pBloodgrp,
    required this.sPaddress,
    required this.sPcity,
    required this.sPcountry,
    required  this.sPzipcode,
    required this.parentImage,
    required this.parentEmail,
    required this.studentData,
    required  this.userRole,
    required this.cookie,
  });

  String? parentWpUsrId;
  String? pFname;
  String? pMname;
  String? pLname;
  String? pGender;
  String? pEdu;
  String? pPhone;
  String? pProfession;
  String? pBloodgrp;
  String? sPaddress;
  String? sPcity;
  String? sPcountry;
  String? sPzipcode;
  String? parentImage;
  String? parentEmail;
  List<StudentDatum>? studentData;
  String? userRole;
  String? cookie;

  factory Userdata.fromJson(Map<String, dynamic> json) => Userdata(
    parentWpUsrId: json["parent_wp_usr_id"],
    pFname: json["p_fname"],
    pMname: json["p_mname"],
    pLname: json["p_lname"],
    pGender: json["p_gender"],
    pEdu: json["p_edu"],
    pPhone: json["p_phone"],
    pProfession: json["p_profession"],
    pBloodgrp: json["p_bloodgrp"],
    sPaddress: json["s_paddress"],
    sPcity: json["s_pcity"],
    sPcountry: json["s_pcountry"],
    sPzipcode: json["s_pzipcode"],
    parentImage: json["parent_image"],
    parentEmail: json["parent_email"],
    studentData: List<StudentDatum>.from(json["studentData"].map((x) => StudentDatum.fromJson(x))),
    userRole: json["user_role"],
    cookie: json["cookies"]
  );

  Map<String, dynamic> toJson() => {
    "parent_wp_usr_id": parentWpUsrId,
    "p_fname": pFname,
    "p_mname": pMname,
    "p_lname": pLname,
    "p_gender": pGender,
    "p_edu": pEdu,
    "p_phone": pPhone,
    "p_profession": pProfession,
    "p_bloodgrp": pBloodgrp,
    "s_paddress": sPaddress,
    "s_pcity": sPcity,
    "s_pcountry": sPcountry,
    "s_pzipcode": sPzipcode,
    "parent_image": parentImage,
    "parent_email": parentEmail,
    "studentData": studentData == null ? [] : List<dynamic>.from(studentData!.map((x) => x.toJson())),
    "user_role": userRole,
    "cookies" : cookie
  };
}

class StudentDatum {
  StudentDatum({
    required this.wpUsrId,
    required this.classId,
    required this.sid,
    required this.sRollno,
    required this.sFname,
    required this.sMname,
    required this.sLname,
    required this.sDob,
    required this.sGender,
    required this.sAddress,
    required this.sCountry,
    required this.sZipcode,
    required this.sPhone,
    required this.sBloodgrp,
    required this.sDoj,
    required this.classDate,
    required  this.sCity,
    required  this.className,
    required this.stuEmail,
    required this.stuImage,
    required this.showAssistant,
  });

  String? wpUsrId;
  String? classId;
  String? sid;
  String? sRollno;
  String? sFname;
  String? sMname;
  String? sLname;
  String? sDob;
  String? sGender;
  String? sAddress;
  String? sCountry;
  String? sZipcode;
  String? sPhone;
  String? sBloodgrp;
  String? sDoj;
  String? classDate;
  String? showAssistant;
  String? sCity;
  String? className;
  String? stuEmail;
  String? stuImage;

  factory StudentDatum.fromJson(Map<String, dynamic> json) => StudentDatum(
    wpUsrId: json["wp_usr_id"] ?? "",
    classId: json["class_id"] ?? "",
    sid: json["sid"] ?? "",
    sRollno: json["s_rollno"] ?? "",
    sFname: json["s_fname"] ?? "",
    sMname: json["s_mname"] ?? "",
    sLname: json["s_lname"] ?? "",
    sDob: json["s_dob"] == null ? "" : json["s_dob"].toString(),
    sGender: json["s_gender"] ?? "",
    sAddress: json["s_address"] ?? "",
    sCountry: json["s_country"] ?? "",
    sZipcode: json["s_zipcode"] ?? "",
    sPhone: json["s_phone"] ?? "",
    sBloodgrp: json["s_bloodgrp"] ?? "",
    sDoj: json["s_doj"] == null ? "" : json["s_doj"].toString(),
    classDate: json["class_date"] ?? "",
    sCity: json["s_city"] ?? "",
    showAssistant: json['show_assistant'] ?? "0",
    className: json["class_name"] ?? "",
    stuEmail: json["stu_email"] ?? "",
    stuImage: json["stu_image"] ?? "",
  );

  Map<String, dynamic> toJson() => {
    "wp_usr_id": wpUsrId ,
    "class_id": classId,
    "sid": sid,
    "s_rollno": sRollno,
    "s_fname": sFname,
    "s_mname": sMname,
    "s_lname": sLname,
     // "s_dob": "${sDob!.year.toString().padLeft(4, '0')}-${sDob!.month.toString().padLeft(2, '0')}-${sDob!.day.toString().padLeft(2, '0')}",
    "s_dob" : sDob ?? "",
    "s_gender": sGender,
    "s_address": sAddress,
    "s_country": sCountry,
    "s_zipcode": sZipcode,
    "s_phone": sPhone,
    "s_bloodgrp": sBloodgrp,
    // "s_doj": sDoj == null ? DateTime.now() : "${sDoj!.year.toString().padLeft(4, '0')}-${sDoj!.month.toString().padLeft(2, '0')}-${sDoj!.day.toString().padLeft(2, '0')}",
    "s_doj" : sDoj ?? "",
    "class_date": classDate,
    "s_city": sCity,
    "show_assistant" : showAssistant,
    "class_name": className,
    "stu_email": stuEmail,
    "stu_image": stuImage,
  };
}
