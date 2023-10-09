// To parse this JSON data, do
//
//     final assistantList = assistantListFromJson(jsonString);

import 'dart:convert';

AssistantList assistantListFromJson(String str) => AssistantList.fromJson(json.decode(str));

String assistantListToJson(AssistantList data) => json.encode(data.toJson());

class AssistantList {
  bool status;
  String message;
  List<AssistantData> data;

  AssistantList({
    required this.status,
    required this.message,
    required this.data,
  });

  factory AssistantList.fromJson(Map<String, dynamic> json) => AssistantList(
    status: json["status"],
    message: json["message"],
    data: List<AssistantData>.from(json["data"].map((x) => AssistantData.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "message": message,
    "data": List<dynamic>.from(data.map((x) => x.toJson())),
  };
}

class AssistantData {
  int id;
  String firstName;
  String lastName;

  AssistantData({
    required this.id,
    required this.firstName,
    required this.lastName,
  });

  factory AssistantData.fromJson(Map<String, dynamic> json) => AssistantData(
    id: json["ID"],
    firstName: json["first_name"],
    lastName: json["last_name"],
  );

  Map<String, dynamic> toJson() => {
    "ID": id,
    "first_name": firstName,
    "last_name": lastName,
  };
}
