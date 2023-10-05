// To parse this JSON data, do
//
//     final singlecircular = singlecircularFromJson(jsonString);

import 'dart:convert';

Singlecircular? singlecircularFromJson(String str) => Singlecircular.fromJson(json.decode(str));

String singlecircularToJson(Singlecircular? data) => json.encode(data!.toJson());

class Singlecircular {
  Singlecircular({
    this.status,
    this.message,
    this.data,
  });

  bool? status;
  String? message;
  Data? data;

  factory Singlecircular.fromJson(Map<String, dynamic> json) => Singlecircular(
    status: json["status"],
    message: json["Message"],
    data: Data.fromJson(json["data"]),
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "Message": message,
    "data": data!.toJson(),
  };
}

class Data {
  Data({
    this.id,
    this.title,
    this.image,
    this.date,
    this.description,
    this.excerpt,
  });

  String? id;
  String? title;
  String? image;
  String? date;
  String? description;
  String? excerpt;

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    id: json["id"] ?? "",
    title: json["title"] ?? "",
    image: json["image"] ?? "",
    date: json["date"],
    description: json["description"] ?? "",
    excerpt: json["excerpt"] ?? "",
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "title": title,
    "image": image,
    "date": date,
    "description": description,
    "excerpt": excerpt,
  };
}
