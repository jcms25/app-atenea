// To parse this JSON data, do
//
//     final dashboard = dashboardFromJson(jsonString);

import 'dart:convert';

Dashboard dashboardFromJson(String str) => Dashboard.fromJson(json.decode(str));

String dashboardToJson(Dashboard data) => json.encode(data.toJson());

class Dashboard {
  Dashboard({
    required this.status,
    required this.message,
    required this.count,
    required this.examlist,
    required this.eventList,
  });

  bool status;
  String message;
  Count count;
  List<Examlist> examlist;
  EventList eventList;

  factory Dashboard.fromJson(Map<String, dynamic> json) => Dashboard(
    status: json["status"],
    message: json["Message"],
    count: Count.fromJson(json["count"]),
    examlist: json["examlist"] == null ? [] : List<Examlist>.from(json["examlist"].map((x) => Examlist.fromJson(x))),
    eventList: EventList.fromJson(json["event_list"]),
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "Message": message,
    "count": count.toJson(),
    "examlist": List<dynamic>.from(examlist.map((x) => x.toJson())),
    "event_list": eventList.toJson(),
  };
}

class Count {
  Count({
    required this.studentCount,
    required this.teacherCount,
    required this.parentCount,
    required this.classCount,
  });

  String studentCount;
  String teacherCount;
  String parentCount;
  String classCount;

  factory Count.fromJson(Map<String, dynamic> json) => Count(
    studentCount: json["student_count"],
    teacherCount: json["teacher_count"],
    parentCount: json["parent_count"],
    classCount: json["class_count"],
  );

  Map<String, dynamic> toJson() => {
    "student_count": studentCount,
    "teacher_count": teacherCount,
    "parent_count": parentCount,
    "class_count": classCount,
  };
}

class EventList {
  EventList({
    required this.exams,
    required this.events,
    required this.holiday,
  });

  List<Exam> exams;
  List<Event> events;
  List<Holyday> holiday;

  factory EventList.fromJson(Map<String, dynamic> json) => EventList(
    exams: json["Exams"] == null ? [] : List<Exam>.from(json["Exams"].map((x) => Exam.fromJson(x))),
    events: json["Events"] == null ? [] : List<Event>.from(json["Events"].map((x) => Event.fromJson(x))),
    holiday: json["Holiday"] == null ? [] : List<Holyday>.from(json["Holiday"].map((x) => Holyday.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "Exams": List<dynamic>.from(exams.map((x) => x.toJson())),
    "Events": List<dynamic>.from(events.map((x) => x.toJson())),
    "Holiday": List<dynamic>.from(holiday.map((x) => x)),
  };
}

class Event {
  Event({
    required this.startDate,
    required this.list,
  });

  DateTime startDate;
  List<ListElement> list;

  factory Event.fromJson(Map<String, dynamic> json) => Event(
    startDate: DateTime.parse(json["StartDate"]),
    list: List<ListElement>.from(json["list"].map((x) => ListElement.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "StartDate": "${startDate.year.toString().padLeft(4, '0')}-${startDate.month.toString().padLeft(2, '0')}-${startDate.day.toString().padLeft(2, '0')}",
    "list": List<dynamic>.from(list.map((x) => x.toJson())),
  };
}

class ListElement {
  ListElement({
    required this.startDate,
    required this.endDate,
    required this.title,
  });

  dynamic startDate;
  dynamic endDate;
  String title;

  factory ListElement.fromJson(Map<String, dynamic> json) => ListElement(
    startDate: json["StartDate"],
    endDate: json["EndDate"],
    title: json["Title"],
  );

  Map<String, dynamic> toJson() => {
    "StartDate": startDate,
    "EndDate": endDate,
    "Title": title,
  };
}

class Exam {
  Exam({
    required this.startDate,
    required this.list,
  });

  DateTime startDate;
  ListElement list;

  factory Exam.fromJson(Map<String, dynamic> json) => Exam(
    startDate: DateTime.parse(json["StartDate"]),
    list: ListElement.fromJson(json["list"]),
  );

  Map<String, dynamic> toJson() => {
    "StartDate": "${startDate.year.toString().padLeft(4, '0')}-${startDate.month.toString().padLeft(2, '0')}-${startDate.day.toString().padLeft(2, '0')}",
    "list": list.toJson(),
  };
}

class Examlist {
  Examlist({
    required this.date,
    required this.name,
    required this.className,
    required this.subjects,
  });

  String date;
  String name;
  String className;
  List<String> subjects;

  factory Examlist.fromJson(Map<String, dynamic> json) => Examlist(
    date: json["date"],
    name: json["name"],
    className: json["class_name"],
    subjects: List<String>.from(json["subjects"].map((x) => x)),
  );

  Map<String, dynamic> toJson() => {
    "date": date,
    "name": name,
    "class_name": className,
    "subjects": List<dynamic>.from(subjects.map((x) => x)),
  };
}

class Holyday {
  Holyday({
    required this.startDate,
    required this.list,
  });

  DateTime startDate;
  List<ListElement> list;

  factory Holyday.fromJson(Map<String, dynamic> json) => Holyday(
    startDate: DateTime.parse(json["StartDate"]),
    list: List<ListElement>.from(json["list"].map((x) => ListElement.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "StartDate": "${startDate.year.toString().padLeft(4, '0')}-${startDate.month.toString().padLeft(2, '0')}-${startDate.day.toString().padLeft(2, '0')}",
    "list": List<dynamic>.from(list.map((x) => x.toJson())),
  };
}
