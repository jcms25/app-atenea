class Exam {
  bool? status;
  String? message;
  List<ExamItem>? data;

  Exam({this.status, this.message, this.data});

  Exam.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['Message'];
    if (json['Data'] != null) {
      data = <ExamItem>[];
      json['Data'].forEach((v) {
        data!.add(ExamItem.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = status;
    data['Message'] = message;
    data['Data'] = this.data!.map((v) => v.toJson()).toList();
    return data;
  }
}

class ExamItem {
  String? eid;
  String? classid;
  String? subjectId;
  String? eName;
  String? eSDate;
  String? eEDate;
  String? entryDate;
  String? time;
  String? comments;
  String? createdBy;
  String? updatedBy;
  String? wpUsrId;
  String? cName;
  String? subId;
  String? sid;
  String? subName;
  String? professorName;

  ExamItem(
      {this.eid,
        this.classid,
        this.subjectId,
        this.eName,
        this.eSDate,
        this.eEDate,
        this.entryDate,
        this.time,
        this.comments,
        this.createdBy,
        this.updatedBy,
        this.wpUsrId,
        this.cName,
        this.subId,
        this.sid,
        this.subName,
        this.professorName});

  ExamItem.fromJson(Map<String, dynamic> json) {
    eid = json['eid'] ?? "";
    classid = json['classid'] ?? "";
    subjectId = json['subject_id'] ?? "";
    eName = json['e_name'] ?? "";
    eSDate = json['e_s_date'] ??"";
    eEDate = json['e_e_date'] ?? "";
    entryDate = json['entry_date'] ?? "";
    time = json['time'] ?? "";
    comments = json['comments'] ?? "";
    createdBy = json['created_by'] ?? "";
    updatedBy = json['updated_by'] ?? "";
    wpUsrId = json['wp_usr_id'] ?? "";
    cName = json['c_name'] ?? "";
    subId = json['sub_id'] ?? "";
    sid = json['sid'] ?? "";
    subName = json['sub_name'] ?? "";
    professorName = json['professor_name'] ?? "";
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['eid'] = eid;
    data['classid'] = classid;
    data['subject_id'] = subjectId;
    data['e_name'] = eName;
    data['e_s_date'] = eSDate;
    data['e_e_date'] = eEDate;
    data['entry_date'] = entryDate;
    data['time'] = time;
    data['comments'] = comments;
    data['created_by'] = createdBy;
    data['updated_by'] = updatedBy;
    data['wp_usr_id'] = wpUsrId;
    data['c_name'] = cName;
    data['sub_id'] = subId;
    data['sid'] = sid;
    data['sub_name'] = subName;
    data['professor_name'] = professorName;
    return data;
  }
}
