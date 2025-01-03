class ExamDetailsModel {
  bool? status;
  String? message;
  ExamDetailItem? data;

  ExamDetailsModel({this.status, this.message, this.data});

  ExamDetailsModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['Message'];
    data = json['Data'] != null ? ExamDetailItem.fromJson(json['Data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = status;
    data['Message'] = message;
    if (this.data != null) {
      data['Data'] = this.data!.toJson();
    }
    return data;
  }
}

class ExamDetailItem {
  String? eid;
  String? classId;
  String? subjectId;
  String? eName;
  String? eSDate;
  String? eEDate;
  String? entryDate;
  String? time;
  String? comments;
  String? createdBy;
  String? updatedBy;
  String? cName;
  List<SubDetails>? subDetails;

  ExamDetailItem(
      {this.eid,
        this.classId,
        this.subjectId,
        this.eName,
        this.eSDate,
        this.eEDate,
        this.entryDate,
        this.time,
        this.comments,
        this.createdBy,
        this.updatedBy,
        this.cName,
        this.subDetails});

  ExamDetailItem.fromJson(Map<String, dynamic> json) {
    eid = json['eid'];
    classId = json['classid'];
    subjectId = json['subject_id'];
    eName = json['e_name'];
    eSDate = json['e_s_date'];
    eEDate = json['e_e_date'];
    entryDate = json['entry_date'];
    time = json['time'];
    comments = json['comments'];
    createdBy = json['created_by'];
    updatedBy = json['updated_by'];
    cName = json['c_name'];
    if (json['subdetails'] != null) {
      subDetails = <SubDetails>[];
      json['subdetails'].forEach((v) {
        subDetails!.add(SubDetails.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['eid'] = eid;
    data['classid'] = classId;
    data['subject_id'] = subjectId;
    data['e_name'] = eName;
    data['e_s_date'] = eSDate;
    data['e_e_date'] = eEDate;
    data['entry_date'] = entryDate;
    data['time'] = time;
    data['comments'] = comments;
    data['created_by'] = createdBy;
    data['updated_by'] = updatedBy;
    data['c_name'] = cName;
    if (subDetails != null) {
      data['subdetails'] = subDetails!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class SubDetails {
  String? name;
  String? id;

  SubDetails({this.name, this.id});

  SubDetails.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    id = json['id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['name'] = name;
    data['id'] = id;
    return data;
  }
}
