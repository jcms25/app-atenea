// To parse this JSON data, do
//
//     final studentList = studentListFromJson(jsonString);

import 'dart:convert';

StudentListModel studentListFromJson(String str) => StudentListModel.fromJson(json.decode(str));

String studentListToJson(StudentListModel data) => json.encode(data.toJson());

class StudentListModel {
  StudentListModel({
    required this.status,
    required this.message,
    required this.data,
  });

  bool status;
  String message;
  List<StudentDataDatum> data;

  factory StudentListModel.fromJson(Map<String, dynamic> json) => StudentListModel(
    status: json["status"],
    message: json["message"],
    data: List<StudentDataDatum>.from(json["data"].map((x) => StudentDataDatum.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "message": message,
    "data": List<dynamic>.from(data.map((x) => x.toJson())),
  };
}

class StudentDataDatum {
  StudentDataDatum({
    required this.wpUsrId,
    required this.studentName,
  });

  String wpUsrId;
  String studentName;

  factory StudentDataDatum.fromJson(Map<String, dynamic> json) => StudentDataDatum(
    wpUsrId: json["wp_usr_id"],
    studentName: json["student_name"],
  );

  Map<String, dynamic> toJson() => {
    "wp_usr_id": wpUsrId,
    "student_name": studentName,
  };
}
