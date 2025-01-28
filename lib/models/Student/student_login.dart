// // To parse this JSON data, do
// //
// //     final studentlogin = studentloginFromJson(jsonString);
//
// import 'dart:convert';
//
// Studentlogin studentloginFromJson(String str) => Studentlogin.fromJson(json.decode(str));
//
// String studentloginToJson(Studentlogin data) => json.encode(data.toJson());
//
// class Studentlogin {
//   Studentlogin({
//    required this.status,
//     required this.message,
//     required this.basicAuthToken,
//     required this.userdata,
//   });
//
//   bool status;
//   String message;
//   String basicAuthToken;
//   Userdatas userdata;
//
//   factory Studentlogin.fromJson(Map<String, dynamic> json) => Studentlogin(
//     status: json["status"],
//     message: json["Message"],
//     basicAuthToken: json["basicAuthToken"],
//     userdata: Userdatas.fromJson(json["userdata"]),
//   );
//
//   Map<String, dynamic> toJson() => {
//     "status": status,
//     "Message": message,
//     "basicAuthToken": basicAuthToken,
//     "userdata": userdata.toJson(),
//   };
// }
//
// class Userdatas {
//   Userdatas({
//     required  this.sid,
//     required this.wpUsrId,
//     required this.sRollno,
//     required this.sFname,
//     required this.sMname,
//     required this.sLname,
//     required this.sDob,
//     required this.sGender,
//     required this.sAddress,
//     required this.sCity,
//     required  this.sZipcode,
//     required this.sCountry,
//     required this.sPhone,
//     required this.sBloodgrp,
//     required this.sDoj,
//     required this.classId,
//     required  this.classDate,
//     required this.stuImage,
//     required this.stuEmail,
//     required this.parentData,
//     required this.userRole,
//     required this.className,
//     required this.cookie
//   });
//
//   String? sid;
//   String? wpUsrId;
//   String? sRollno;
//   String? sFname;
//   String? sMname;
//   String? sLname;
//   String? sDob;
//   String? sGender;
//   String? sAddress;
//   String? sCity;
//   String? sZipcode;
//   String? sCountry;
//   String? sPhone;
//   String? sBloodgrp;
//   String? sDoj;
//   String? classId;
//   String? classDate;
//   String? stuImage;
//   String? stuEmail;
//   List<ParentDatum>? parentData;
//   String? userRole;
//   String? className;
//   String? cookie;
//
//   factory Userdatas.fromJson(Map<String, dynamic> json) => Userdatas(
//     sid: json["sid"],
//     wpUsrId: json["wp_usr_id"],
//     sRollno: json["s_rollno"],
//     sFname: json["s_fname"],
//     sMname: json["s_mname"],
//     sLname: json["s_lname"],
//     sDob: json["s_dob"],
//     sGender: json["s_gender"],
//     sAddress: json["s_address"],
//     sCity: json["s_city"],
//     sZipcode: json["s_zipcode"],
//     sCountry: json["s_country"],
//     sPhone: json["s_phone"],
//     sBloodgrp: json["s_bloodgrp"],
//     sDoj: json["s_doj"],
//     classId: json["class_id"],
//     classDate: json["class_date"],
//     stuImage: json["stu_image"],
//     stuEmail: json["stu_email"],
//     parentData: List<ParentDatum>.from(json["parentData"].map((x) => ParentDatum.fromJson(x))),
//     userRole: json["user_role"],
//     className: json["class_name"],
//     cookie: json["cookies"]
//   );
//
//   Map<String, dynamic> toJson() => {
//     "sid": sid,
//     "wp_usr_id": wpUsrId,
//     "s_rollno": sRollno,
//     "s_fname": sFname,
//     "s_mname": sMname,
//     "s_lname": sLname,
//     "s_dob": sDob ?? "",
//     "s_gender": sGender,
//     "s_address": sAddress,
//     "s_city": sCity,
//     "s_zipcode": sZipcode,
//     "s_country": sCountry,
//     "s_phone": sPhone,
//     "s_bloodgrp": sBloodgrp,
//     "s_doj": sDoj ?? "",
//     "class_id": classId,
//     "class_date": classDate,
//     "stu_image": stuImage,
//     "stu_email": stuEmail,
//     "parentData": List<dynamic>.from(parentData!.map((x) => x.toJson())),
//     "user_role": userRole,
//     "class_name": className,
//     "cookies" : cookie
//   };
// }
//
// class ParentDatum {
//   ParentDatum({
//     required this.pid,
//     required this.stuWpUsrId,
//     required this.parentWpUsrId,
//     required  this.pFname,
//     required this.pMname,
//     required this.pLname,
//     required this.pGender,
//     required this.pEdu,
//     required this.pPhone,
//     required this.pProfession,
//     required  this.pBloodgrp,
//     required  this.sPcity,
//     required this.sPcountry,
//     required this.sPzipcode,
//     required  this.sPaddress,
//     required this.parentImage,
//     required this.parentEmail,
//   });
//
//   String? pid;
//   String? stuWpUsrId;
//   String? parentWpUsrId;
//   String? pFname;
//   String? pMname;
//   String? pLname;
//   String? pGender;
//   String? pEdu;
//   String? pPhone;
//   String? pProfession;
//   String? pBloodgrp;
//   String? sPcity;
//   String? sPcountry;
//   String? sPzipcode;
//   String? sPaddress;
//   String? parentImage;
//   String? parentEmail;
//
//   factory ParentDatum.fromJson(Map<String, dynamic> json) => ParentDatum(
//     pid: json["pid"],
//     stuWpUsrId: json["stu_wp_usr_id"],
//     parentWpUsrId: json["parent_wp_usr_id"],
//     pFname: json["p_fname"],
//     pMname: json["p_mname"],
//     pLname: json["p_lname"],
//     pGender: json["p_gender"],
//     pEdu: json["p_edu"],
//     pPhone: json["p_phone"],
//     pProfession: json["p_profession"],
//     pBloodgrp: json["p_bloodgrp"],
//     sPcity: json["s_pcity"],
//     sPcountry: json["s_pcountry"],
//     sPzipcode: json["s_pzipcode"],
//     sPaddress: json["s_paddress"],
//     parentImage: json["parent_image"],
//     parentEmail: json["parent_email"],
//   );
//
//   Map<String, dynamic> toJson() => {
//     "pid": pid,
//     "stu_wp_usr_id": stuWpUsrId,
//     "parent_wp_usr_id": parentWpUsrId,
//     "p_fname": pFname,
//     "p_mname": pMname,
//     "p_lname": pLname,
//     "p_gender": pGender,
//     "p_edu": pEdu,
//     "p_phone": pPhone,
//     "p_profession": pProfession,
//     "p_bloodgrp": pBloodgrp,
//     "s_pcity": sPcity,
//     "s_pcountry": sPcountry,
//     "s_pzipcode": sPzipcode,
//     "s_paddress": sPaddress,
//     "parent_image": parentImage,
//     "parent_email": parentEmail,
//   };
// }
