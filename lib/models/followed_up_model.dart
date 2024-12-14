class FollowedUpModel {
  bool? status;
  String? message;
  List<FollowedUpItem>? data;

  FollowedUpModel({this.status, this.message, this.data});

  FollowedUpModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['Message'];
    if (json['data'] != null) {
      data = <FollowedUpItem>[];
      json['data'].forEach((v) {
        data!.add(FollowedUpItem.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = status;
    data['Message'] = message;
    if (this.data != null) {
      data['data'] = this.data?.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class FollowedUpItem {
  List<FollowedUpItemDetail>? list;

  FollowedUpItem({this.list});

  FollowedUpItem.fromJson(Map<String, dynamic> json) {
    if (json['list'] != null) {
      list = <FollowedUpItemDetail>[];
      json['list'].forEach((v) {
        list!.add( FollowedUpItemDetail.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (list != null) {
      data['list'] = list!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class FollowedUpItemDetail {
  String? date;
  String? subjectName;
  String? mark;
  String? status;
  String? remarks;
  String?  examName;

  FollowedUpItemDetail(
      {this.date,
        this.subjectName,
        this.mark,
        this.status,
        this.remarks,
        this.examName});

  FollowedUpItemDetail.fromJson(Map<String, dynamic> json) {
    date = json['date'];
    subjectName = json['subject_name'];
    mark = json['mark'];
    status = json['status'];
    remarks = json['remarks'];
    examName = json['exam_name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['date'] = date;
    data['subject_name'] = subjectName;
    data['mark'] = mark;
    data['status'] = status;
    // data['extrafield'] = extraField.map((v) => v.toJson()).toList();
      data['remarks'] = remarks;
    data['exam_name'] = examName;
    return data;
  }
}
