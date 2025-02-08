class TeacherScheduleModel {
  bool? status;
  String? message;
  List<String>? time;
  List<TeacherScheduleItem>? sessionList;

  TeacherScheduleModel(
      {this.status, this.message, this.time, this.sessionList});

  TeacherScheduleModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['Message'];
    time = json['Time'].cast<String>();
    if (json['SessionList'] != null) {
      sessionList = <TeacherScheduleItem>[];
      json['SessionList'].forEach((v) {
        sessionList!.add(TeacherScheduleItem.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = status;
    data['Message'] = message;
    data['Time'] = time;
    if (sessionList != null) {
      data['SessionList'] = sessionList!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class TeacherScheduleItem {
  String? day;
  List<TeacherScheduleItemData>? data;

  TeacherScheduleItem({this.day, this.data});

  TeacherScheduleItem.fromJson(Map<String, dynamic> json) {
    day = json['day'];
    if (json['data'] != null) {
      data = <TeacherScheduleItemData>[];
      json['data'].forEach((v) {
        data!.add(TeacherScheduleItemData.fromJson(v));
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

class TeacherScheduleItemData {
  String? teacherId;
  String? hour;
  String? subName;

  TeacherScheduleItemData({this.teacherId, this.hour, this.subName});

  TeacherScheduleItemData.fromJson(Map<String, dynamic> json) {
    teacherId = json['teacher_id'];
    hour = json['hour'];
    subName = json['sub_name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['teacher_id'] = teacherId;
    data['hour'] = hour;
    data['sub_name'] = subName;
    return data;
  }
}
