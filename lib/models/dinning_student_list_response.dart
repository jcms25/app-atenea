class DinningStudentListResponse {
  bool? status;
  String? message;
  List<DinningStudentItem>? data;
  DinningSettings? diningSettings;

  DinningStudentListResponse(
      {this.status, this.message, this.data, this.diningSettings});

  DinningStudentListResponse.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['Message'];
    if (json['data'] != null) {
      data = <DinningStudentItem>[];
      json['data'].forEach((v) {
        data!.add(DinningStudentItem.fromJson(v));
      });
    }
    diningSettings = json['DiningSettings'] != null
        ? DinningSettings.fromJson(json['DiningSettings'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = status;
    data['Message'] = message;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    if (diningSettings != null) {
      data['DiningSettings'] = diningSettings!.toJson();
    }
    return data;
  }
}

class DinningStudentItem {
  String? sid;
  String? wpUsrId;
  String? studentName;
  String? classId;
  String? className;
  String? atten;
  int? diningProfile;
  String? day;
  String? month;
  String? color;
  String? role;

  DinningStudentItem(
      {this.sid,
        this.wpUsrId,
        this.studentName,
        this.classId,
        this.className,
        this.atten,
        this.diningProfile,
        this.day,
        this.month,
        this.color,
        this.role});

  DinningStudentItem.fromJson(Map<String, dynamic> json) {
    sid = json['sid'];
    wpUsrId = json['wp_usr_id'];
    studentName = json['student_name'];
    classId = json['class_id'];
    className = json['class_name'];
    atten = json['atten'];
    diningProfile = json['dining_profile'];
    day = json['day'];
    month = json['month'];
    color = json['color'];
    role = json['role'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['sid'] = sid;
    data['wp_usr_id'] = wpUsrId;
    data['student_name'] = studentName;
    data['class_id'] = classId;
    data['class_name'] = className;
    data['atten'] = atten;
    data['dining_profile'] = diningProfile;
    data['day'] = day;
    data['month'] = month;
    data['color'] = color;
    data['role'] = role;
    return data;
  }
}

class DinningSettings {
  String? todaymsg;
  String? teacherMsg;
  String? closingTime;
  String? checkClosingTime;

  DinningSettings(
      {this.todaymsg,
        this.teacherMsg,
        this.closingTime,
        this.checkClosingTime});

  DinningSettings.fromJson(Map<String, dynamic> json) {
    todaymsg = json['todaymsg'];
    teacherMsg = json['teacherMsg'];
    closingTime = json['closingTime'];
    checkClosingTime = json['checkClosgingtime'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['todaymsg'] = todaymsg;
    data['teacherMsg'] = teacherMsg;
    data['closingTime'] = closingTime;
    data['checkClosgingtime'] = checkClosingTime;
    return data;
  }
}