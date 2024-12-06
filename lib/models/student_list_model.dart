class StudentListModel {
  bool? status;
  String? message;
  List<StudentItem>? studentlist;

  StudentListModel({this.status, this.message, this.studentlist});

  StudentListModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['Message'];
    if (json['studentlist'] != null) {
      studentlist = <StudentItem>[];
      json['studentlist'].forEach((v) {
        studentlist!.add(StudentItem.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = status;
    data['Message'] = message;
    if (studentlist != null) {
      data['studentlist'] = studentlist!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class StudentItem {
  String? sid;
  String? wpUsrId;
  String? sRollno;
  String? sFname;
  String? sMname;
  String? sLname;
  String? sDob;
  String? sGender;
  String? sAddress;
  String? sPaddress;
  String? sCountry;
  String? sZipcode;
  String? sPhone;
  String? sBloodgrp;
  String? sDoj;
  String? classId;
  String? classDate;
  String? sCity;
  String? className;
  String? stuEmail;
  String? stuImage;

  StudentItem(
      {this.sid,
        this.wpUsrId,
        this.sRollno,
        this.sFname,
        this.sMname,
        this.sLname,
        this.sDob,
        this.sGender,
        this.sAddress,
        this.sPaddress,
        this.sCountry,
        this.sZipcode,
        this.sPhone,
        this.sBloodgrp,
        this.sDoj,
        this.classId,
        this.classDate,
        this.sCity,
        this.className,
        this.stuEmail,
        this.stuImage});

  StudentItem.fromJson(Map<String, dynamic> json) {
    sid = json['sid'];
    wpUsrId = json['wp_usr_id'];
    sRollno = json['s_rollno'];
    sFname = json['s_fname'];
    sMname = json['s_mname'];
    sLname = json['s_lname'];
    sDob = json['s_dob'];
    sGender = json['s_gender'];
    sAddress = json['s_address'];
    sPaddress = json['s_paddress'];
    sCountry = json['s_country'];
    sZipcode = json['s_zipcode'];
    sPhone = json['s_phone'];
    sBloodgrp = json['s_bloodgrp'];
    sDoj = json['s_doj'];
    classId = json['class_id'];
    classDate = json['class_date'];
    sCity = json['s_city'];
    className = json['class_name'];
    stuEmail = json['stu_email'];
    stuImage = json['stu_image'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['sid'] = sid;
    data['wp_usr_id'] = wpUsrId;
    data['s_rollno'] = sRollno;
    data['s_fname'] = sFname;
    data['s_mname'] = sMname;
    data['s_lname'] = sLname;
    data['s_dob'] = sDob;
    data['s_gender'] = sGender;
    data['s_address'] = sAddress;
    data['s_paddress'] = sPaddress;
    data['s_country'] = sCountry;
    data['s_zipcode'] = sZipcode;
    data['s_phone'] = sPhone;
    data['s_bloodgrp'] = sBloodgrp;
    data['s_doj'] = sDoj;
    data['class_id'] = classId;
    data['class_date'] = classDate;
    data['s_city'] = sCity;
    data['class_name'] = className;
    data['stu_email'] = stuEmail;
    data['stu_image'] = stuImage;
    return data;
  }
}
