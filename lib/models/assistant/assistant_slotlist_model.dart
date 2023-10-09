// To parse this JSON data, do
//
//     final slotListModel = slotListModelFromJson(jsonString);

import 'dart:convert';

SlotListModel slotListModelFromJson(String str) => SlotListModel.fromJson(json.decode(str));

String slotListModelToJson(SlotListModel data) => json.encode(data.toJson());

class SlotListModel {
  SlotListModel({
    required this.status,
    required this.message,
    required this.data,
  });

  bool status;
  String message;
  List<SlotDatum> data;

  factory SlotListModel.fromJson(Map<String, dynamic> json) => SlotListModel(
    status: json["status"],
    message: json["message"],
    data: List<SlotDatum>.from(json["data"].map((x) => SlotDatum.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "message": message,
    "data": List<dynamic>.from(data.map((x) => x.toJson())),
  };
}

class SlotDatum {
  SlotDatum({
    required this.id,
    required this.startTime,
    required this.endTime,
    required this.createdBy,
  });

  String id;
  String startTime;
  String endTime;
  String createdBy;

  factory SlotDatum.fromJson(Map<String, dynamic> json) => SlotDatum(
    id: json["id"],
    startTime: json["start_time"],
    endTime: json["end_time"],
    createdBy: json["created_by"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "start_time": startTime,
    "end_time": endTime,
    "created_by": createdBy,
  };
}
