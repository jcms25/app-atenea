// To parse this JSON data, do
//
//     final events = eventsFromJson(jsonString);

import 'dart:convert';

Events eventsFromJson(String str) => Events.fromJson(json.decode(str));

String eventsToJson(Events data) => json.encode(data.toJson());

class Events {
  bool status;
  String message;
  List<EventListItem> eventsList;

  Events({
    required this.status,
    required this.message,
    required this.eventsList,
  });

  factory Events.fromJson(Map<String, dynamic> json) => Events(
        status: json["status"],
        message: json["Message"],
        eventsList: json["data"] == null
            ? []
            : List<EventListItem>.from(
                json["data"].map((x) => EventListItem.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "Message": message,
        "data": List<dynamic>.from(eventsList.map((x) => x.toJson())),
      };
}

class EventListItem {
  DateTime? startDate;
  List<EventListItemDetail>? list;

  EventListItem({
    required this.startDate,
    required this.list,
  });

  factory EventListItem.fromJson(Map<String, dynamic> json) => EventListItem(
        startDate: json["StartDate"] == null
            ? null
            : DateTime.parse(json["StartDate"]),
        list: json["list"] == null
            ? []
            : List<EventListItemDetail>.from(
                json["list"].map((x) => EventListItemDetail.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "StartDate":
            "${startDate?.year.toString().padLeft(4, '0')}-${startDate?.month.toString().padLeft(2, '0')}-${startDate?.day.toString().padLeft(2, '0')}",
        "list": List<dynamic>.from(list?.map((x) => x.toJson()) ?? []),
      };
}

class EventListItemDetail {
  DateTime? startDate;
  DateTime? endDate;
  String? title;
  String? color;
  String? createdBy;

  EventListItemDetail(
      {required this.startDate,
      required this.endDate,
      required this.title,
      required this.color,
      required this.createdBy});

  factory EventListItemDetail.fromJson(Map<String, dynamic> json) =>
      EventListItemDetail(
          startDate: json["StartDate"] == null
              ? null
              : DateTime.parse(json["StartDate"]),
          endDate:
              json["EndDate"] == null ? null : DateTime.parse(json["EndDate"]),
          title: json["Title"],
          color: json["Color"],
          createdBy: json['created_by']);

  Map<String, dynamic> toJson() => {
        "StartDate": startDate?.toIso8601String(),
        "EndDate": endDate?.toIso8601String(),
        "Title": title,
        "Color": color,
        'created_by': createdBy
      };
}
