// To parse this JSON data, do
//
//     final messageListModel = messageListModelFromJson(jsonString);

import 'dart:convert';

MessageListModel messageListModelFromJson(String str) => MessageListModel.fromJson(json.decode(str));

String messageListModelToJson(MessageListModel data) => json.encode(data.toJson());

class MessageListModel {
  bool status;
  String message;
  List<MessageData> sendList;
  List<MessageData> receiveList;

  MessageListModel({
    required this.status,
    required this.message,
    required this.sendList,
    required this.receiveList,
  });

  factory MessageListModel.fromJson(Map<String, dynamic> json) => MessageListModel(
    status: json["status"],
    message: json["message"],
    sendList: List<MessageData>.from(json["sendList"].map((x) => MessageData.fromJson(x))),
    receiveList: List<MessageData>.from(json["receiveList"].map((x) => MessageData.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "message": message,
    "sendList": List<dynamic>.from(sendList.map((x) => x)),
    "receiveList": List<dynamic>.from(receiveList.map((x) => x.toJson())),
  };
}

class MessageData {
  String id;
  String slotId;
  String sId;
  String rId;
  String subject;
  String msg;
  String replayId;
  String mainMId;
  String delStat;
  dynamic sRead;
  dynamic rRead;
  DateTime mDate;
  String attachments;
  String studentId;
  String senderName;
  String recieverName;
  String parentName;
  String studentName;

  MessageData({
    required this.id,
    required this.slotId,
    required this.sId,
    required this.rId,
    required this.subject,
    required this.msg,
    required this.replayId,
    required this.mainMId,
    required this.delStat,
    this.sRead,
    this.rRead,
    required this.mDate,
    required this.attachments,
    required this.studentId,
    required this.senderName,
    required this.recieverName,
    required this.parentName,
    required this.studentName,
  });

  factory MessageData.fromJson(Map<String, dynamic> json) => MessageData(
    id: json["id"],
    slotId: json["slot_id"],
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
    studentId: json["student_id"],
    senderName: json["sender_name"],
    recieverName: json["reciever_name"],
    parentName: json["parent_name"],
    studentName: json["student_name"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "slot_id": slotId,
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
    "student_id": studentId,
    "sender_name": senderName,
    "reciever_name": recieverName,
    "parent_name": parentName,
    "student_name": studentName,
  };
}
