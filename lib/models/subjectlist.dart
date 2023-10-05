// To parse this JSON data, do
//
//     final subject = subjectFromJson(jsonString);

import 'dart:convert';

SubjectList subjectFromJson(String str) => SubjectList.fromJson(json.decode(str));

String subjectToJson(SubjectList data) => json.encode(data.toJson());

class SubjectList {
  SubjectList({
    required this.status,
    required  this.message,
    required this.subjectlist,
  });

  bool status;
  String message;
  List<Subjectlist> subjectlist;

  factory SubjectList.fromJson(Map<String, dynamic> json) => SubjectList(
    status: json["status"],
    message: json["Message"],
    subjectlist: List<Subjectlist>.from(json["subjectlist"].map((x) => Subjectlist.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "Message": message,
    "subjectlist": List<dynamic>.from(subjectlist.map((x) => x.toJson())),
  };
}

class Subjectlist {
  Subjectlist({
    required this.classId,
    required this.id,
    required  this.subCode,
    required this.subName,
    required this.subTeachId,
    required this.bookName,
    required this.subDesc,
    required  this.maxMark,
    required  this.passMark,
    required this.faculty,
    required this.group
  });

  String classId;
  String id;
  String subCode;
  String subName;
  String subTeachId;
  String bookName;
  dynamic subDesc;
  dynamic maxMark;
  dynamic passMark;
  String faculty;
  String group;

  factory Subjectlist.fromJson(Map<String, dynamic> json) => Subjectlist(
    classId: json["class_id"],
    id: json["id"],
    subCode: json["sub_code"],
    subName: json["sub_name"],
    subTeachId: json["sub_teach_id"],
    bookName: json["book_name"],
    subDesc: json["sub_desc"],
    maxMark: json["max_mark"],
    passMark: json["pass_mark"],
    faculty: json["faculty"],
    group : json["grupo"],
  );

  Map<String, dynamic> toJson() => {
    "class_id": classId,
    "id": id,
    "sub_code": subCode,
    "sub_name": subName,
    "sub_teach_id": subTeachId,
    "book_name": bookName,
    "sub_desc": subDesc,
    "max_mark": maxMark,
    "pass_mark": passMark,
    "faculty": faculty,
    "grupo" : group
  };
}
