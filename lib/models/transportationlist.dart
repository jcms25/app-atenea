// To parse this JSON data, do
//
//     final transportation = transportationFromJson(jsonString);

import 'dart:convert';

Transportation transportationFromJson(String str) => Transportation.fromJson(json.decode(str));

String transportationToJson(Transportation data) => json.encode(data.toJson());

class Transportation {
  Transportation({
    required this.status,
    required  this.message,
    required this.data,
  });

  bool status;
  String message;
  List<Datum> data;

  factory Transportation.fromJson(Map<String, dynamic> json) => Transportation(
    status: json["status"],
    message: json["Message"],
    data: List<Datum>.from(json["data"].map((x) => Datum.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "Message": message,
    "data": List<dynamic>.from(data.map((x) => x.toJson())),
  };
}

class Datum {
  Datum({
    required this.id,
    required  this.busNo,
    required this.busName,
    required this.driverName,
    required this.busRoute,
    required this.routeFees,
    required  this.phoneNo,
    required  this.students,
  });

  String id;
  String busNo;
  String busName;
  String driverName;
  String busRoute;
  String routeFees;
  String phoneNo;
  List<String> students;

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
    id: json["id"],
    busNo: json["bus_no"],
    busName: json["bus_name"],
    driverName: json["driver_name"],
    busRoute: json["bus_route"],
    routeFees: json["route_fees"],
    phoneNo: json["phone_no"],
    students: List<String>.from(json["students"].map((x) => x)),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "bus_no": busNo,
    "bus_name": busName,
    "driver_name": driverName,
    "bus_route": busRoute,
    "route_fees": routeFees,
    "phone_no": phoneNo,
    "students": List<dynamic>.from(students.map((x) => x)),
  };
}
