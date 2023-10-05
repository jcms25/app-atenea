// To parse this JSON data, do
//
//     final messageDetailModel = messageDetailModelFromJson(jsonString);

import 'dart:convert';

MessageDetailModel messageDetailModelFromJson(String str) => MessageDetailModel.fromJson(json.decode(str));

String messageDetailModelToJson(MessageDetailModel data) => json.encode(data.toJson());

class MessageDetailModel {
  bool status;
  String message;
  MessageDetailData data;

  MessageDetailModel({
    required this.status,
    required this.message,
    required this.data,
  });

  factory MessageDetailModel.fromJson(Map<String, dynamic> json) => MessageDetailModel(
    status: json["status"],
    message: json["message"],
    data: MessageDetailData.fromJson(json["data"]),
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "message": message,
    "data": data.toJson(),
  };
}

class MessageDetailData {
  String? id;
  String? slotId;
  String? sId;
  String? rId;
  String? subject;
  String? msg;
  String? replayId;
  String? mainMId;
  String? delStat;
  dynamic sRead;
  dynamic rRead;
  DateTime? mDate;
  String? attachments;
  String? studentId;
  String? receiverName;
  String? senderName;
  List<ReportData> reportData;

  MessageDetailData({
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
    required this.reportData,
    required this.receiverName,
    this.senderName
  });

  factory MessageDetailData.fromJson(Map<String, dynamic> json) => MessageDetailData(
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
    receiverName: json["reciever_name"],
    reportData: List<ReportData>.from(json["reportData"].map((x) => ReportData.fromJson(x))),
    senderName: json["sender_name"]
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
    "m_date": mDate?.toIso8601String(),
    "attachments": attachments,
    "student_id": studentId,
    "reciever_name" : receiverName,
    "reportData": List<dynamic>.from(reportData.map((x) => x.toJson())),
    "sender_name" : senderName
  };
}

class ReportData {
  String? id;
  String? comId;
  dynamic subSlotId;
  String? timeId;
  String? day;
  String? subjectId;
  String? text;
  String? isActive;
  String? hour;
  String? beginTime;
  String? endTime;
  String? subName;

  ReportData({
    required this.id,
    required this.comId,
    this.subSlotId,
    required this.timeId,
    required this.day,
    required this.subjectId,
    required this.text,
    required this.isActive,
    required this.hour,
    required this.beginTime,
    required this.endTime,
    required this.subName,
  });

  factory ReportData.fromJson(Map<String, dynamic> json) => ReportData(
    id: json["id"],
    comId: json["com_id"],
    subSlotId: json["subslot_id"],
    timeId: json["time_id"],
    day: json["day"],
    subjectId: json["subject_id"],
    text: json["text"],
    isActive: json["is_active"],
    hour: json["hour"],
    beginTime: json["begintime"],
    endTime: json["endtime"],
    subName: json["sub_name"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "com_id": comId,
    "subslot_id": subSlotId,
    "time_id": timeId,
    "day": day,
    "subject_id": subjectId,
    "text": text,
    "is_active": isActive,
    "hour": hour,
    "begintime": beginTime,
    "endtime": endTime,
    "sub_name": subName,
  };
}
