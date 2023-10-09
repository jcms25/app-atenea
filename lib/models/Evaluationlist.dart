// To parse this JSON data, do
//
//     final evaluation = evaluationFromJson(jsonString);

import 'dart:convert';

Evaluation evaluationFromJson(String str) => Evaluation.fromJson(json.decode(str));

String evaluationToJson(Evaluation data) => json.encode(data.toJson());

class Evaluation {
  Evaluation({
    required this.status,
    required this.message,
    required this.data,
  });

  bool status;
  String message;
  List<Datum> data;

  factory Evaluation.fromJson(Map<String, dynamic> json) => Evaluation(
    status: json["status"],
    message: json["Message"],
    data: List<Datum>.from(json["Data"].map((x) => Datum.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "Message": message,
    "Data": List<dynamic>.from(data.map((x) => x.toJson())),
  };
}

class Datum {
  Datum({
    required this.subject,
    required this.marks,
    required this.observation,
  });

  String subject;
  Marks marks;
  Observation observation;

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
    subject: json["subject"],
    marks: Marks.fromJson(json["marks"]),
    observation: Observation.fromJson(json["observation"]),
  );

  Map<String, dynamic> toJson() => {
    "subject": subject,
    "marks": marks.toJson(),
    "observation": observation.toJson(),
  };
}

class Marks {
  Marks({
    required this.evaluation4,
    required this.evaluation3,
    required this.evaluation2,
    required this.evaluation1,
  });

  String evaluation4;
  String evaluation3;
  String evaluation2;
  String evaluation1;

  factory Marks.fromJson(Map<String, dynamic> json) => Marks(
    evaluation4: json["evaluation 4"],
    evaluation3: json["evaluation 3"],
    evaluation2: json["evaluation 2"],
    evaluation1: json["evaluation 1"],
  );

  Map<String, dynamic> toJson() => {
    "evaluation 4": evaluation4,
    "evaluation 3": evaluation3,
    "evaluation 2": evaluation2,
    "evaluation 1": evaluation1,
  };
}

class Observation {
  Observation({
    required this.observation4,
    required this.observation3,
    required this.observation2,
    required this.observation1,
  });

  String observation4;
  String observation3;
  String observation2;
  String observation1;

  factory Observation.fromJson(Map<String, dynamic> json) => Observation(
    observation4: json["observation 4"],
    observation3: json["observation 3"],
    observation2: json["observation 2"],
    observation1: json["observation 1"],
  );

  Map<String, dynamic> toJson() => {
    "observation 4": observation4,
    "observation 3": observation3,
    "observation 2": observation2,
    "observation 1": observation1,
  };
}
