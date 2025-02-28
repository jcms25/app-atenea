// import 'dart:convert';
//
// Dashboard dashboardFromJson(String str) => Dashboard.fromJson(json.decode(str));
//
// String dashboardToJson(Dashboard data) => json.encode(data.toJson());
//
// class Dashboard {
//   Dashboard({
//     required this.status,
//     required this.message,
//     required this.count,
//     required this.examList,
//     required this.eventList,
//   });
//
//   bool status;
//   String message;
//   Count count;
//   List<ExamItem> examList;
//   EventList eventList;
//
//   factory Dashboard.fromJson(Map<String, dynamic> json) => Dashboard(
//         status: json["status"],
//         message: json["Message"],
//         count: Count.fromJson(json["count"]),
//         examList: json["examlist"] == null
//             ? []
//             : List<ExamItem>.from(
//                 json["examlist"].map((x) => ExamItem.fromJson(x))),
//         eventList: EventList.fromJson(json["event_list"]),
//       );
//
//   Map<String, dynamic> toJson() => {
//         "status": status,
//         "Message": message,
//         "count": count.toJson(),
//         "examlist": List<dynamic>.from(examList.map((x) => x.toJson())),
//         "event_list": eventList.toJson(),
//       };
// }
//
// class Count {
//   Count({
//     required this.studentCount,
//     required this.teacherCount,
//     required this.parentCount,
//     required this.classCount,
//   });
//
//   String studentCount;
//   String teacherCount;
//   String parentCount;
//   String classCount;
//
//   factory Count.fromJson(Map<String, dynamic> json) => Count(
//         studentCount: json["student_count"],
//         teacherCount: json["teacher_count"],
//         parentCount: json["parent_count"],
//         classCount: json["class_count"],
//       );
//
//   Map<String, dynamic> toJson() => {
//         "student_count": studentCount,
//         "teacher_count": teacherCount,
//         "parent_count": parentCount,
//         "class_count": classCount,
//       };
// }
//
// class EventList {
//   EventList({
//     required this.exams,
//     required this.events,
//     required this.holiday,
//   });
//
//   List<EventItem> exams;
//   List<EventItem> events;
//   List<EventItem> holiday;
//
//   factory EventList.fromJson(Map<String, dynamic> json) => EventList(
//         exams: json["Exams"] == null
//             ? []
//             : List<EventItem>.from(
//                 json["Exams"].map((x) => EventItem.fromJson(x)).toList()),
//         events: json["Events"] == null
//             ? []
//             : List<EventItem>.from(
//                 json["Events"].map((x) => EventItem.fromJson(x)).toList()),
//         holiday: json["Holiday"] == null
//             ? []
//             : List<EventItem>.from(
//                 json["Holiday"].map((x) => EventItem.fromJson(x)).toList()),
//       );
//
//   Map<String, dynamic> toJson() => {
//         "Exams": List<dynamic>.from(exams.map((x) => x.toJson())),
//         "Events": List<dynamic>.from(events.map((x) => x.toJson())),
//         "Holiday": List<dynamic>.from(holiday.map((x) => x.toJson())),
//       };
// }
//
// class EventItem {
//   EventItem({
//     required this.startDate,
//     required this.list,
//   });
//
//   DateTime startDate;
//   List<EventItemDetail> list;
//
//   factory EventItem.fromJson(Map<String, dynamic> json) => EventItem(
//         startDate: DateTime.parse(json["StartDate"]),
//         list: json["list"] != null
//             ? List<EventItemDetail>.from(
//                 json["list"].map((x) => EventItemDetail.fromJson(x))).toList()
//             : [],
//       );
//
//   Map<String, dynamic> toJson() => {
//         "StartDate":
//             "${startDate.year.toString().padLeft(4, '0')}-${startDate.month.toString().padLeft(2, '0')}-${startDate.day.toString().padLeft(2, '0')}",
//         "list": List<dynamic>.from(list.map((x) => x.toJson())),
//       };
// }
//
// class EventItemDetail {
//   EventItemDetail({
//     required this.startDate,
//     required this.endDate,
//     required this.title,
//   });
//
//   String? startDate;
//   String? endDate;
//   String title;
//
//   factory EventItemDetail.fromJson(Map<String, dynamic> json) =>
//       EventItemDetail(
//         startDate: json["StartDate"],
//         endDate: json["EndDate"],
//         title: json["Title"],
//       );
//
//   Map<String, dynamic> toJson() => {
//         "StartDate": startDate,
//         "EndDate": endDate,
//         "Title": title,
//       };
// }
//
// class ExamItem {
//   ExamItem({
//     required this.date,
//     required this.name,
//     required this.className,
//     required this.subjects,
//   });
//
//   String date;
//   String name;
//   String className;
//   List<String> subjects;
//
//   factory ExamItem.fromJson(Map<String, dynamic> json) => ExamItem(
//         date: json["date"],
//         name: json["name"],
//         className: json["class_name"],
//         subjects: List<String>.from(json["subjects"].map((x) => x)),
//       );
//
//   Map<String, dynamic> toJson() => {
//         "date": date,
//         "name": name,
//         "class_name": className,
//         "subjects": List<dynamic>.from(subjects.map((x) => x)),
//       };
// }


import 'dart:convert';

Dashboard dashboardFromJson(String str) => Dashboard.fromJson(json.decode(str));

String dashboardToJson(Dashboard data) => json.encode(data.toJson());

class Dashboard {
  Dashboard({
    required this.status,
    required this.message,
    required this.count,
    required this.examList,
    required this.eventList,
  });

  bool status;
  String message;
  Count count;
  List<ExamItem> examList;
  EventList eventList;

  factory Dashboard.fromJson(Map<String, dynamic> json) => Dashboard(
    status: json["status"],
    message: json["Message"],
    count: Count.fromJson(json["count"]),
    examList: json["examlist"] == null
        ? []
        : List<ExamItem>.from(
        json["examlist"].map((x) => ExamItem.fromJson(x))),
    eventList: EventList.fromJson(json["event_list"]),
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "Message": message,
    "count": count.toJson(),
    "examlist": List<dynamic>.from(examList.map((x) => x.toJson())),
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
    studentCount: json["student_count"].toString(),
    teacherCount: json["teacher_count"].toString(),
    parentCount: json["parent_count"].toString(),
    classCount: json["class_count"].toString(),
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

  List<EventItem> exams;
  List<EventItem> events;
  List<EventItem> holiday;

  factory EventList.fromJson(Map<String, dynamic> json) => EventList(
    exams: json["Exams"] is List
        ? List<EventItem>.from(
        json["Exams"].map((x) => EventItem.fromJson(x)))
        : [],
    events: json["Events"] is List
        ? List<EventItem>.from(
        json["Events"].map((x) => EventItem.fromJson(x)))
        : [],
    holiday: json["Holiday"] is List
        ? List<EventItem>.from(
        json["Holiday"].map((x) => EventItem.fromJson(x)))
        : [],
  );

  Map<String, dynamic> toJson() => {
    "Exams": List<dynamic>.from(exams.map((x) => x.toJson())),
    "Events": List<dynamic>.from(events.map((x) => x.toJson())),
    "Holiday": List<dynamic>.from(holiday.map((x) => x.toJson())),
  };
}

class EventItem {
  EventItem({
    required this.startDate,
    required this.list,
  });

  DateTime startDate;
  List<EventItemDetail> list;

  factory EventItem.fromJson(Map<String, dynamic> json) => EventItem(
    startDate: json["StartDate"] != null
        ? DateTime.tryParse(json["StartDate"]) ?? DateTime.now()
        : DateTime.now(),
    list: json["list"] is List
        ? List<EventItemDetail>.from(
        json["list"].map((x) => EventItemDetail.fromJson(x)))
        : [],
  );

  Map<String, dynamic> toJson() => {
    "StartDate":
    "${startDate.year.toString().padLeft(4, '0')}-${startDate.month.toString().padLeft(2, '0')}-${startDate.day.toString().padLeft(2, '0')}",
    "list": List<dynamic>.from(list.map((x) => x.toJson())),
  };
}

class EventItemDetail {
  EventItemDetail({
    required this.startDate,
    required this.endDate,
    required this.title,
  });

  String? startDate;
  String? endDate;
  String title;

  factory EventItemDetail.fromJson(Map<String, dynamic> json) =>
      EventItemDetail(
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

class ExamItem {
  ExamItem({
    required this.date,
    required this.name,
    required this.className,
    required this.subjects,
  });

  String date;
  String name;
  String className;
  List<String> subjects;

  factory ExamItem.fromJson(Map<String, dynamic> json) => ExamItem(
    date: json["date"],
    name: json["name"],
    className: json["class_name"],
    subjects: json["subjects"] is List
        ? List<String>.from(json["subjects"].map((x) => x.toString()))
        : [],
  );

  Map<String, dynamic> toJson() => {
    "date": date,
    "name": name,
    "class_name": className,
    "subjects": List<dynamic>.from(subjects.map((x) => x)),
  };
}
