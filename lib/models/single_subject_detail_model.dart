import 'dart:convert';

class Subject {
  bool? status;
  String? message;
  List<SubjectDetail>? data;
  String? books;
  String? booksName;


  Subject({this.status, this.message, this.data,this.books,this.booksName});

  Subject.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['Message'];
    if (json['data'] != null) {
      data = <SubjectDetail>[];
      json['data'].forEach((v) {
        data!.add(SubjectDetail.fromJson(v));
      });
    }
    books = json['books'] == null ? null : jsonEncode(json['books']);
    booksName = json['books_list'];

  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = status;
    data['Message'] = message;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    data['books'] = books == null ? null : jsonDecode(books ?? "{}");
    data['books_list'] = booksName;

    return data;
  }
}

class SubjectDetail {
  String? id;
  String? grupo;
  String? subCode;
  String? classId;
  String? subName;
  String? subTeachId;
  String? bookName;
  String? bookId;
  String? bookImg;
  String? subDesc;
  String? maxMark;
  String? passMark;
  String? tid;
  String? wpUsrId;
  String? firstName;
  String? middleName;
  String? lastName;
  String? zipcode;
  String? country;
  String? city;
  String? address;
  String? empcode;
  String? dob;
  String? doj;
  String? dol;
  String? phone;
  String? qualification;
  String? gender;
  String? bloodgrp;
  String? position;
  String? whours;
  String? familyCareHour;
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

  SubjectDetail(
      {this.id,
        this.grupo,
        this.subCode,
        this.classId,
        this.subName,
        this.subTeachId,
        this.bookName,
        this.bookId,
        this.bookImg,
        this.subDesc,
        this.maxMark,
        this.passMark,
        this.tid,
        this.wpUsrId,
        this.firstName,
        this.middleName,
        this.lastName,
        this.zipcode,
        this.country,
        this.city,
        this.address,
        this.empcode,
        this.dob,
        this.doj,
        this.dol,
        this.phone,
        this.qualification,
        this.gender,
        this.bloodgrp,
        this.position,
        this.whours,
        this.familyCareHour,
        this.cid,
        this.cNumb,
        this.cName,
        this.teacherId,
        this.cCapacity,
        this.cLoc,
        this.cSdate,
        this.cEdate,
        this.cFeeType,
        this.showAssistant});

  SubjectDetail.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    grupo = json['grupo'];
    subCode = json['sub_code'];
    classId = json['class_id'];
    subName = json['sub_name'];
    subTeachId = json['sub_teach_id'];
    bookName = json['book_name'];
    bookId = json['book_id'];
    bookImg = json['book_img'];
    subDesc = json['sub_desc'];
    maxMark = json['max_mark'];
    passMark = json['pass_mark'];
    tid = json['tid'];
    wpUsrId = json['wp_usr_id'];
    firstName = json['first_name'];
    middleName = json['middle_name'];
    lastName = json['last_name'];
    zipcode = json['zipcode'];
    country = json['country'];
    city = json['city'];
    address = json['address'];
    empcode = json['empcode'];
    dob = json['dob'];
    doj = json['doj'];
    dol = json['dol'];
    phone = json['phone'];
    qualification = json['qualification'];
    gender = json['gender'];
    bloodgrp = json['bloodgrp'];
    position = json['position'];
    whours = json['whours'];
    familyCareHour = json['family_care_hour'];
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
    data['id'] = id;
    data['grupo'] = grupo;
    data['sub_code'] = subCode;
    data['class_id'] = classId;
    data['sub_name'] = subName;
    data['sub_teach_id'] = subTeachId;
    data['book_name'] = bookName;
    data['book_id'] = bookId;
    data['book_img'] = bookImg;
    data['sub_desc'] = subDesc;
    data['max_mark'] = maxMark;
    data['pass_mark'] = passMark;
    data['tid'] = tid;
    data['wp_usr_id'] = wpUsrId;
    data['first_name'] = firstName;
    data['middle_name'] = middleName;
    data['last_name'] = lastName;
    data['zipcode'] = zipcode;
    data['country'] = country;
    data['city'] = city;
    data['address'] = address;
    data['empcode'] = empcode;
    data['dob'] = dob;
    data['doj'] = doj;
    data['dol'] = dol;
    data['phone'] = phone;
    data['qualification'] = qualification;
    data['gender'] = gender;
    data['bloodgrp'] = bloodgrp;
    data['position'] = position;
    data['whours'] = whours;
    data['family_care_hour'] = familyCareHour;
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
