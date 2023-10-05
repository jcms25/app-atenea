// To parse this JSON data, do
//
//     final circular = circularFromJson(jsonString);

import 'dart:convert';

Circular circularFromJson(String str) => Circular.fromJson(json.decode(str));

String circularToJson(Circular data) => json.encode(data.toJson());

class Circular {
  Circular({
    required this.status,
    required this.message,
    required this.data,
  });

  bool status;
  String message;
  List<Datum> data;

  factory Circular.fromJson(Map<String, dynamic> json) => Circular(
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
    required this.title,
    this.image,
    required this.date,
  });

  String id;
  String title;
  String? image;
  String date;

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
    id: json["id"],
    title: json["title"],
    image: json["image"],
    date: json["date"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "title": title,
    "image": image,
    "date": date,
  };
}
