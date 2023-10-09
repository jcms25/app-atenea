// To parse this JSON data, do
//
//     final events = eventsFromJson(jsonString);

import 'dart:convert';

Events eventsFromJson(String str) => Events.fromJson(json.decode(str));

String eventsToJson(Events data) => json.encode(data.toJson());

class Events {
  bool status;
  String message;
  List<EventModel> data;

  Events({
    required this.status,
    required this.message,
    required this.data,
  });

  factory Events.fromJson(Map<String, dynamic> json) => Events(
    status: json["status"],
    message: json["Message"],
    data: List<EventModel>.from(json["data"].map((x) => EventModel.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "Message": message,
    "data": List<dynamic>.from(data.map((x) => x.toJson())),
  };
}

class EventModel {
  DateTime startDate;
  List<ListElement> list;

  EventModel({
    required this.startDate,
    required this.list,
  });

  factory EventModel.fromJson(Map<String, dynamic> json) => EventModel(
    startDate: DateTime.parse(json["StartDate"]),
    list: List<ListElement>.from(json["list"].map((x) => ListElement.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "StartDate": "${startDate.year.toString().padLeft(4, '0')}-${startDate.month.toString().padLeft(2, '0')}-${startDate.day.toString().padLeft(2, '0')}",
    "list": List<dynamic>.from(list.map((x) => x.toJson())),
  };
}

class ListElement {
  DateTime startDate;
  DateTime endDate;
  String title;
  String color;

  ListElement({
    required this.startDate,
    required this.endDate,
    required this.title,
    required this.color,
  });

  factory ListElement.fromJson(Map<String, dynamic> json) => ListElement(
    startDate: DateTime.parse(json["StartDate"]),
    endDate: DateTime.parse(json["EndDate"]),
    title: json["Title"],
    color: json["Color"],
  );

  Map<String, dynamic> toJson() => {
    "StartDate": startDate.toIso8601String(),
    "EndDate": endDate.toIso8601String(),
    "Title": title,
    "Color": color,
  };
}
