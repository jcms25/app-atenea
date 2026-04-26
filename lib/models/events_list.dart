import 'dart:convert';

Events eventsFromJson(String str) => Events.fromJson(json.decode(str));
String eventsToJson(Events data) => json.encode(data.toJson());

class Events {
  bool status;
  String message;
  List<EventListItem> eventsList;
  List<EventLegendItem> legend;

  Events({
    required this.status,
    required this.message,
    required this.eventsList,
    required this.legend,
  });

  factory Events.fromJson(Map<String, dynamic> json) => Events(
        status: json["status"],
        message: json["Message"],
        eventsList: json["data"] == null
            ? []
            : List<EventListItem>.from(
                json["data"].map((x) => EventListItem.fromJson(x))),
        legend: json["legend"] == null
            ? []
            : List<EventLegendItem>.from(
                json["legend"].map((x) => EventLegendItem.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "Message": message,
        "data": List<dynamic>.from(eventsList.map((x) => x.toJson())),
        "legend": List<dynamic>.from(legend.map((x) => {'color': x.color, 'label': x.label})),
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
  String? id;
  DateTime? startDate;
  DateTime? endDate;
  String? title;
  String? color;
  String? createdBy;
  String? description;

  EventListItemDetail(
      {required this.startDate,
      required this.id,
        required this.endDate,
      required this.title,
      required this.color,
      required this.description,
      required this.createdBy});

  factory EventListItemDetail.fromJson(Map<String, dynamic> json) =>
      EventListItemDetail(
          id: json['id'],
          startDate: json["StartDate"] == null
              ? null
              : DateTime.parse(json["StartDate"]),
          endDate:
              json["EndDate"] == null ? null : DateTime.parse(json["EndDate"]),
          title: json["Title"],
          color: json["Color"],
          createdBy: json['created_by'],
          description: json['description']

      );

  Map<String, dynamic> toJson() => {
        'id' : id,
        "StartDate": startDate?.toIso8601String(),
        "EndDate": endDate?.toIso8601String(),
        "Title": title,
        "Color": color,
        'created_by': createdBy,
        "description" : description
      };
}

class EventLegendItem {
  final String color;
  final String label;

  EventLegendItem({required this.color, required this.label});

  factory EventLegendItem.fromJson(Map<String, dynamic> json) =>
      EventLegendItem(
        color: json['color'] ?? '#888888',
        label: json['label'] ?? '',
      );
}