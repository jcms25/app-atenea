// To parse this JSON data, do
//
//     final assistantDashboard = assistantDashboardFromJson(jsonString);

import 'dart:convert';

AssistantDashboardModel assistantDashboardFromJson(String str) => AssistantDashboardModel.fromJson(json.decode(str));

String assistantDashboardToJson(AssistantDashboardModel data) => json.encode(data.toJson());

class AssistantDashboardModel {
  AssistantDashboardModel({
    required this.status,
    required this.message,
    required this.count,
  });

  bool status;
  String message;
  Count count;

  factory AssistantDashboardModel.fromJson(Map<String, dynamic> json) => AssistantDashboardModel(
    status: json["status"],
    message: json["Message"],
    count: Count.fromJson(json["count"]),
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "Message": message,
    "count": count.toJson(),
  };
}

class Count {
  Count({
    required this.classCount,
    required this.reportCount,
    required this.commonMessageCount,
  });

  String classCount;
  String reportCount;
  String commonMessageCount;

  factory Count.fromJson(Map<String, dynamic> json) => Count(
    classCount: json["class_count"],
    reportCount: json["report_count"],
    commonMessageCount: json["common_messageCount"],
  );

  Map<String, dynamic> toJson() => {
    "class_count": classCount,
    "report_count": reportCount,
    "common_messageCount": commonMessageCount,
  };
}
