// To parse this JSON data, do
//
//     final singleMessageDetailModel = singleMessageDetailModelFromJson(jsonString);

import 'dart:convert';

SingleMessageDetailModel singleMessageDetailModelFromJson(String str) => SingleMessageDetailModel.fromJson(json.decode(str));

String singleMessageDetailModelToJson(SingleMessageDetailModel data) => json.encode(data.toJson());

class SingleMessageDetailModel {
  bool status;
  String message;
  Data data;

  SingleMessageDetailModel({
    required this.status,
    required this.message,
    required this.data,
  });

  factory SingleMessageDetailModel.fromJson(Map<String, dynamic> json) => SingleMessageDetailModel(
    status: json["status"],
    message: json["Message"],
    data: Data.fromJson(json["data"]),
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "Message": message,
    "data": data.toJson(),
  };
}

class Data {
  String mid;
  String sId;
  String rId;
  String subject;
  String msg;
  String replayId;
  String mainMId;
  String delStat;
  String sRead;
  String rRead;
  DateTime mDate;
  String attachments;
  String name;
  String image;
  List<dynamic> subMessage;

  Data({
    required this.mid,
    required this.sId,
    required this.rId,
    required this.subject,
    required this.msg,
    required this.replayId,
    required this.mainMId,
    required this.delStat,
    required this.sRead,
    required this.rRead,
    required this.mDate,
    required this.attachments,
    required this.name,
    required this.image,
    required this.subMessage,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    mid: json["mid"],
    sId: json["s_id"],
    rId: json["r_id"],
    subject: json["subject"],
    msg: json["msg"],
    replayId: json["replay_id"],
    mainMId: json["main_m_id"],
    delStat: json["del_stat"],
    sRead: json["s_read"],
    rRead: json["r_read"],
    mDate: DateTime.parse(json["m_date"]),
    attachments: json["attachments"],
    name: json["name"],
    image: json["image"],
    subMessage: List<dynamic>.from(json["sub_message"].map((x) => x)),
  );

  Map<String, dynamic> toJson() => {
    "mid": mid,
    "s_id": sId,
    "r_id": rId,
    "subject": subject,
    "msg": msg,
    "replay_id": replayId,
    "main_m_id": mainMId,
    "del_stat": delStat,
    "s_read": sRead,
    "r_read": rRead,
    "m_date": mDate.toIso8601String(),
    "attachments": attachments,
    "name": name,
    "image": image,
    "sub_message": List<dynamic>.from(subMessage.map((x) => x)),
  };
}
