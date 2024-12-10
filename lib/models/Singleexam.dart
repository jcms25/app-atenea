class Singleexam {
  bool? status;
  String? message;
  Data? data;

  Singleexam({this.status, this.message, this.data});

  Singleexam.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['Message'];
    data = json['Data'] != null ? Data.fromJson(json['Data']) : null;
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

class Data {
  String? eid;
  String? classid;
  String? subjectId;
  String? eName;
  String? eSDate;
  String? eEDate;
  String? entryDate;
  String? time;
  String? comments;
  String? cName;
  List<Subdetails>? subdetails;

  Data(
      {this.eid,
        this.classid,
        this.subjectId,
        this.eName,
        this.eSDate,
        this.eEDate,
        this.entryDate,
        this.time,
        this.comments,
        this.cName,
        this.subdetails});

  Data.fromJson(Map<String, dynamic> json) {
    eid = json['eid'];
    classid = json['classid'];
    subjectId = json['subject_id'];
    eName = json['e_name'];
    eSDate = json['e_s_date'];
    eEDate = json['e_e_date'];
    entryDate = json['entry_date'];
    time = json['time'];
    comments = json['comments'];
    cName = json['c_name'];
    if (json['subdetails'] != null) {
      subdetails = <Subdetails>[];
      json['subdetails'].forEach((v) {
        subdetails!.add(Subdetails.fromJson(v));
      });
    }
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
    data['c_name'] = cName;
    if (subdetails != null) {
      data['subdetails'] = subdetails!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Subdetails {
  String? name;
  String? id;

  Subdetails({this.name, this.id});

  Subdetails.fromJson(Map<String, dynamic> json) {
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