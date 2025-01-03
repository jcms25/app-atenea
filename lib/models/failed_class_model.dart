// To parse this JSON data, do
//
//     final failed = failedFromJson(jsonString);

import 'dart:convert';

Failed failedFromJson(String str) => Failed.fromJson(json.decode(str));

String failedToJson(Failed data) => json.encode(data.toJson());

class Failed {
  Failed({
    required this.status,
    required this.message,
  });

  bool status;
  String message;

  factory Failed.fromJson(Map<String, dynamic> json) => Failed(
    status: json["status"],
    message: json["Message"],
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "Message": message,
  };
}
