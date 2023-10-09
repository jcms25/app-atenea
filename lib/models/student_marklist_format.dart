// To parse this JSON data, do
//
//     final markList = markListFromJson(jsonString);

import 'dart:convert';

import 'package:intl/intl.dart';

MarkList markListFromJson(String str) => MarkList.fromJson(json.decode(str));

String markListToJson(MarkList data) => json.encode(data.toJson());

class MarkList {
  MarkList({
    required this.status,
    required this.message,
    required this.markslist,
  });

  bool status;
  String message;
  List<Markslist> markslist;

  factory MarkList.fromJson(Map<String, dynamic> json) => MarkList(
    status: json["status"],
    message: json["Message"],
    markslist: List<Markslist>.from(json["markslist"].map((x) => Markslist.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "Message": message,
    "markslist": List<dynamic>.from(markslist.map((x) => x.toJson())),
  };
}

class Markslist {
  Markslist({
    required this.examNm,
    required this.subjectName,
    required this.mark,
    required this.status,
    required this.sDate,
    required this.eDate,
    required this.remarks,
  });

  String? examNm;
  String? subjectName;
  String? mark;
  String? status;
  String? sDate;
  String? eDate;
  String? remarks;

  factory Markslist.fromJson(Map<String, dynamic> json) => Markslist(
    examNm: json["exam_nm"] ?? "",
    subjectName: json["subject_name"] ?? "",
    mark: json["mark"] ?? "",
    status: json["status"] ?? "",
    sDate: json["s_date"] == null ? "-" : DateFormat("dd-MM-yyyy").format(DateTime.parse(json["s_date"])),
    eDate: json["e_date"] == null ? "-" : DateFormat("dd-MM-yyyy").format(DateTime.parse(json["e_date"])),
    remarks: json["remarks"] ?? "",
  );

  Map<String, dynamic> toJson() => {
    "exam_nm": examNm,
    "subject_name": subjectName,
    "mark": mark,
    "status": status,
    "s_date": sDate,
    "e_date": eDate,
    "remarks": remarks,
  };
}
