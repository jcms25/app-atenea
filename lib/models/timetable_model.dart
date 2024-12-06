class TimeTable {
  bool? status;
  String? message;
  List<String>? time;
  List<TimeTableItem>? sessionList;
  StudentInfo? stuentInfo;

  TimeTable(
      {this.status,
        this.message,
        this.time,
        this.sessionList,
        this.stuentInfo});

  TimeTable.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['Message'];
    time = json['Time'].cast<String>();
    if (json['SessionList'] != null) {
      sessionList = <TimeTableItem>[];
      json['SessionList'].forEach((v) {
        sessionList!.add(TimeTableItem.fromJson(v));
      });
    }
    stuentInfo = json['StuentInfo'] != null
        ? StudentInfo.fromJson(json['StuentInfo'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = status;
    data['Message'] = message;
    data['Time'] = time;
    if (sessionList != null) {
      data['SessionList'] = sessionList!.map((v) => v.toJson()).toList();
    }
    if (stuentInfo != null) {
      data['StuentInfo'] = stuentInfo!.toJson();
    }
    return data;
  }
}

class TimeTableItem {
  String? day;
  List<TimeTableItemData>? data;

  TimeTableItem({this.day, this.data});

  TimeTableItem.fromJson(Map<String, dynamic> json) {
    day = json['day'];
    if (json['data'] != null) {
      data = <TimeTableItemData>[];
      json['data'].forEach((v) {
        data!.add(TimeTableItemData.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['day'] = day;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class TimeTableItemData {
  String? id;
  String? classId;
  String? timeId;
  String? subjectId;
  String? sessionId;
  String? day;
  String? heading;
  String? isActive;
  String? hour;
  String? begintime;
  String? endtime;
  String? type;
  List<String>? subName;

  TimeTableItemData(
      {this.id,
        this.classId,
        this.timeId,
        this.subjectId,
        this.sessionId,
        this.day,
        this.heading,
        this.isActive,
        this.hour,
        this.begintime,
        this.endtime,
        this.type,
        this.subName});

  TimeTableItemData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    classId = json['class_id'];
    timeId = json['time_id'];
    subjectId = json['subject_id'];
    sessionId = json['session_id'];
    day = json['day'];
    heading = json['heading'];
    isActive = json['is_active'];
    hour = json['hour'];
    begintime = json['begintime'];
    endtime = json['endtime'];
    type = json['type'];
    subName = json['sub_name'].cast<String>();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['class_id'] = classId;
    data['time_id'] = timeId;
    data['subject_id'] = subjectId;
    data['session_id'] = sessionId;
    data['day'] = day;
    data['heading'] = heading;
    data['is_active'] = isActive;
    data['hour'] = hour;
    data['begintime'] = begintime;
    data['endtime'] = endtime;
    data['type'] = type;
    data['sub_name'] = subName;
    return data;
  }
}

class StudentInfo {
  String? wpUsrId;
  String? langType;

  StudentInfo({this.wpUsrId, this.langType});

  StudentInfo.fromJson(Map<String, dynamic> json) {
    wpUsrId = json['wp_usr_id'];
    langType = json['lang_type'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['wp_usr_id'] = wpUsrId;
    data['lang_type'] = langType;
    return data;
  }
}
