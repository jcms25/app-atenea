class TeacherClassListModel {
  bool? status;
  String? message;
  List<TeacherClassItem>? data;

  TeacherClassListModel({this.status, this.message, this.data});

  TeacherClassListModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['Message'];
    if (json['data'] != null) {
      data = <TeacherClassItem>[];
      json['data'].forEach((v) {
        data!.add(TeacherClassItem.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = status;
    data['Message'] = message;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class TeacherClassItem {
  String? cid;
  String? cNumb;
  String? cName;
  String? teacherId;
  String? cCapacity;
  String? cLoc;
  String? cSdate;
  String? cEdate;
  String? cFeeType;
  String? showAssistant;

  TeacherClassItem(
      {this.cid,
        this.cNumb,
        this.cName,
        this.teacherId,
        this.cCapacity,
        this.cLoc,
        this.cSdate,
        this.cEdate,
        this.cFeeType,
        this.showAssistant});

  TeacherClassItem.fromJson(Map<String, dynamic> json) {
    cid = json['cid'];
    cNumb = json['c_numb'];
    cName = json['c_name'];
    teacherId = json['teacher_id'];
    cCapacity = json['c_capacity'];
    cLoc = json['c_loc'];
    cSdate = json['c_sdate'];
    cEdate = json['c_edate'];
    cFeeType = json['c_fee_type'];
    showAssistant = json['show_assistant'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['cid'] = cid;
    data['c_numb'] = cNumb;
    data['c_name'] = cName;
    data['teacher_id'] = teacherId;
    data['c_capacity'] = cCapacity;
    data['c_loc'] = cLoc;
    data['c_sdate'] = cSdate;
    data['c_edate'] = cEdate;
    data['c_fee_type'] = cFeeType;
    data['show_assistant'] = showAssistant;
    return data;
  }
}
