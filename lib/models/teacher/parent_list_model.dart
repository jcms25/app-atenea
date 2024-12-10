class ParentListModel {
  bool? status;
  String? message;
  List<ParentItem>? data;

  ParentListModel({this.status, this.message, this.data});

  ParentListModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['Message'];
    if (json['Data'] != null) {
      data = <ParentItem>[];
      json['Data'].forEach((v) {
        data!.add(ParentItem.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = status;
    data['Message'] = message;
    if (this.data != null) {
      data['Data'] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class ParentItem {
  String? userEmail;
  String? fullName;
  String? sFname;
  String? sLname;
  String? wpUsrId;
  String? parentWpUsrId;
  String? classId;
  String? parentImage;

  ParentItem(
      {this.userEmail,
        this.fullName,
        this.sFname,
        this.sLname,
        this.wpUsrId,
        this.parentWpUsrId,
        this.classId,
        this.parentImage
      });

  ParentItem.fromJson(Map<String, dynamic> json) {
    userEmail = json['user_email'];
    fullName = json['full_name'];
    sFname = json['s_fname'];
    sLname = json['s_lname'];
    wpUsrId = json['wp_usr_id'];
    parentWpUsrId = json['parent_wp_usr_id'];
    classId = json['class_id'];
    parentImage = json["parent_image"];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['user_email'] = userEmail;
    data['full_name'] = fullName;
    data['s_fname'] = sFname;
    data['s_lname'] = sLname;
    data['wp_usr_id'] = wpUsrId;
    data['parent_wp_usr_id'] = parentWpUsrId;
    data['class_id'] = classId;
    data["parent_image"] = parentImage;
    return data;
  }
}
