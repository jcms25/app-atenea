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
  String? iD;
  String? userEmail;
  String? parentWpUsrId;
  String? stuWpUsrId;
  String? pFname;
  String? pLname;
  String? pPhone;
  String? sPAddress;
  String? studentName;
  String? parentImage;

  ParentItem(
      {this.iD,
        this.userEmail,
        this.parentWpUsrId,
        this.stuWpUsrId,
        this.pFname,
        this.pLname,
        this.pPhone,
        this.sPAddress,
        this.studentName,
        this.parentImage});

  ParentItem.fromJson(Map<String, dynamic> json) {
    iD = json['ID'];
    userEmail = json['user_email'];
    parentWpUsrId = json['parent_wp_usr_id'];
    stuWpUsrId = json['stu_wp_usr_id'];
    pFname = json['p_fname'];
    pLname = json['p_lname'];
    pPhone = json['p_phone'];
    sPAddress = json['s_paddress'];
    studentName = json['student_name'];
    parentImage = json['parent_image'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['ID'] = iD;
    data['user_email'] = userEmail;
    data['parent_wp_usr_id'] = parentWpUsrId;
    data['stu_wp_usr_id'] = stuWpUsrId;
    data['p_fname'] = pFname;
    data['p_lname'] = pLname;
    data['p_phone'] = pPhone;
    data['s_paddress'] = sPAddress;
    data['student_name'] = studentName;
    data['parent_image'] = parentImage;
    return data;
  }
}
