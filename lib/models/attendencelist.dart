// To parse this JSON data, do
//
//     final attendence = attendenceFromJson(jsonString);

import 'dart:convert';

Attendencelist attendenceFromJson(String str) => Attendencelist.fromJson(json.decode(str));

String attendenceToJson(Attendencelist data) => json.encode(data.toJson());

class Attendencelist {
  Attendencelist({
    required this.status,
    required this.message,
    required  this.data,
  });

  bool status;
  String message;
  Data data;

  factory Attendencelist.fromJson(Map<String, dynamic> json) => Attendencelist(
    status: json["status"],
    message: json["Message"],
    data: Data.fromJson(json["data"]),
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "Message": message,
    "data": data.toJson(),
  };
}

class Data {
  Data({
    required this.fullName,
    required this.className,
    required this.rollNo,
    required this.classStart,
    required this.classEnd,
    required this.absentDays,
    required  this.presentDay,
    required this.workingDays,
  required  this.image,
  });

  String fullName;
  String className;
  String rollNo;
  String classStart;
  String classEnd;
  String absentDays;
  String presentDay;
  String workingDays;
  String image;

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    fullName: json["full_name"],
    className: json["class_name"],
    rollNo: json["roll_no"],
    classStart: json["class_start"],
    classEnd: json["class_end"],
    absentDays: json["absent_days"],
    presentDay: json["present_day"],
    workingDays: json["working_days"],
    image: json["image"],
  );

  Map<String, dynamic> toJson() => {
    "full_name": fullName,
    "class_name": className,
    "roll_no": rollNo,
    "class_start": classStart,
    "class_end": classEnd,
    "absent_days": absentDays,
    "present_day": presentDay,
    "working_days": workingDays,
    "image": image,
  };
}
