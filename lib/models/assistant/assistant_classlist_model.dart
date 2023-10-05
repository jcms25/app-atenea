// To parse this JSON data, do
//
//     final classListModel = classListModelFromJson(jsonString);

import 'dart:convert';

ClassListModel classListModelFromJson(String str) => ClassListModel.fromJson(json.decode(str));

String classListModelToJson(ClassListModel data) => json.encode(data.toJson());

class ClassListModel {
  ClassListModel({
    required this.status,
    required this.message,
    required this.data,
  });

  bool status;
  String message;
  List<Datum>? data;

  factory ClassListModel.fromJson(Map<String, dynamic> json) => ClassListModel(
    status: json["status"],
    message: json["Message"],
    data: json["data"] == null ? [] : List<Datum>.from(json["data"].map((x) => Datum.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "Message": message,
    "data": List<dynamic>.from(data!.map((x) => x.toJson())),
  };
}

class Datum {
  Datum({
    required this.cid,
    required this.cName,
  });

  String cid;
  String cName;

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
    cid: json["cid"],
    cName: json["c_name"],
  );

  Map<String, dynamic> toJson() => {
    "cid": cid,
    "c_name": cName,
  };
}
