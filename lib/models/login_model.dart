class LoginModel {
  bool? status;
  String? message;
  String? basicAuthToken;
  Userdata? userdata;

  LoginModel({this.status, this.message, this.basicAuthToken, this.userdata});

  LoginModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['Message'];
    basicAuthToken = json['basicAuthToken'];
    userdata = json['userdata'] != null
        ? Userdata.fromJson(json['userdata'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = status;
    data['Message'] = message;
    data['basicAuthToken'] = basicAuthToken;
    if (userdata != null) {
      data['userdata'] = userdata!.toJson();
    }
    return data;
  }
}

class Userdata {
  String? sid;
  String? wpUsrId;
  String? sRollno;
  String? sFname;
  String? sMname;
  String? sLname;
  String? sDob;
  String? sGender;
  String? sAddress;
  String? sCity;
  String? sZipcode;
  String? sCountry;
  String? sPhone;
  String? sBloodgrp;
  String? sDoj;
  String? classId;
  String? classDate;
  String? stuImage;
  String? stuEmail;
  List<ParentData>? parentData;
  String? parentWpUsrId;
  String? pFname;
  String? pMname;
  String? pLname;
  String? pGender;
  String? pEdu;
  String? pPhone;
  String? pProfession;
  String? pBloodgrp;
  String? sPaddress;
  String? sPcity;
  String? sPcountry;
  String? sPzipcode;
  String? parentImage;
  String? parentEmail;
  List<StudentData>? studentData;
  String? className;
  String? userRole;
  String? cookies;
  String? tid;
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
  String? teacherImage;
  String? teacherEmail;

  Userdata(
      {this.sid,
        this.wpUsrId,
        this.sRollno,
        this.sFname,
        this.sMname,
        this.sLname,
        this.sDob,
        this.sGender,
        this.sAddress,
        this.sCity,
        this.sZipcode,
        this.sCountry,
        this.sPhone,
        this.sBloodgrp,
        this.sDoj,
        this.classId,
        this.classDate,
        this.stuImage,
        this.stuEmail,
        this.parentData,
        this.parentWpUsrId,
        this.pFname,
        this.pMname,
        this.pLname,
        this.pGender,
        this.pEdu,
        this.pPhone,
        this.pProfession,
        this.pBloodgrp,
        this.sPaddress,
        this.sPcity,
        this.sPcountry,
        this.sPzipcode,
        this.parentImage,
        this.parentEmail,
        this.studentData,
        this.className,
        this.userRole,
        this.cookies,
        this.tid,
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
        this.teacherImage,
        this.teacherEmail,

      });

  Userdata.fromJson(Map<String, dynamic> json) {
    sid = json['sid'];
    wpUsrId = json['wp_usr_id'];
    sRollno = json['s_rollno'];
    sFname = json['s_fname'];
    sMname = json['s_mname'];
    sLname = json['s_lname'];
    sDob = json['s_dob'];
    sGender = json['s_gender'];
    sAddress = json['s_address'];
    sCity = json['s_city'];
    sZipcode = json['s_zipcode'];
    sCountry = json['s_country'];
    sPhone = json['s_phone'];
    sBloodgrp = json['s_bloodgrp'];
    sDoj = json['s_doj'];
    classId = json['class_id'];
    classDate = json['class_date'];
    stuImage = json['stu_image'];
    stuEmail = json['stu_email'];
    if (json['parentData'] != null) {
      parentData = <ParentData>[];
      json['parentData'].forEach((v) {
        parentData!.add(ParentData.fromJson(v));
      });
    }
    parentWpUsrId = json['parent_wp_usr_id'];
    pFname = json['p_fname'];
    pMname = json['p_mname'];
    pLname = json['p_lname'];
    pGender = json['p_gender'];
    pEdu = json['p_edu'];
    pPhone = json['p_phone'];
    pProfession = json['p_profession'];
    pBloodgrp = json['p_bloodgrp'];
    sPaddress = json['s_paddress'];
    sPcity = json['s_pcity'];
    sPcountry = json['s_pcountry'];
    sPzipcode = json['s_pzipcode'];
    parentImage = json['parent_image'];
    parentEmail = json['parent_email'];
    if (json['studentData'] != null) {
      studentData = <StudentData>[];
      json['studentData'].forEach((v) {
        studentData!.add(StudentData.fromJson(v));
      });
    }
    className = json['class_name'];
    userRole = json['user_role'];
    cookies = json['cookies'];

    tid = json['tid'];
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
    teacherImage = json['teacher_image'];
    teacherEmail = json['teacher_email'];
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
    data['s_city'] = sCity;
    data['s_zipcode'] = sZipcode;
    data['s_country'] = sCountry;
    data['s_phone'] = sPhone;
    data['s_bloodgrp'] = sBloodgrp;
    data['s_doj'] = sDoj;
    data['class_id'] = classId;
    data['class_date'] = classDate;
    data['stu_image'] = stuImage;
    data['stu_email'] = stuEmail;
    if (parentData != null) {
      data['parentData'] = parentData!.map((v) => v.toJson()).toList();
    }
    data['parent_wp_usr_id'] = parentWpUsrId;
    data['p_fname'] = pFname;
    data['p_mname'] = pMname;
    data['p_lname'] = pLname;
    data['p_gender'] = pGender;
    data['p_edu'] = pEdu;
    data['p_phone'] = pPhone;
    data['p_profession'] = pProfession;
    data['p_bloodgrp'] = pBloodgrp;
    data['s_paddress'] = sPaddress;
    data['s_pcity'] = sPcity;
    data['s_pcountry'] = sPcountry;
    data['s_pzipcode'] = sPzipcode;
    data['parent_image'] = parentImage;
    data['parent_email'] = parentEmail;
    if (studentData != null) {
      data['studentData'] = studentData!.map((v) => v.toJson()).toList();
    }
    data['class_name'] = className;
    data['user_role'] = userRole;
    data['cookies'] = cookies;


    data['tid'] = tid;
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
    data['teacher_image'] = teacherImage;
    data['teacher_email'] = teacherEmail;

    return data;
  }
}

class ParentData {
  String? pid;
  String? stuWpUsrId;
  String? parentWpUsrId;
  String? pFname;
  String? pMname;
  String? pLname;
  String? pGender;
  String? pEdu;
  String? pPhone;
  String? pProfession;
  String? pBloodgrp;
  String? sPcity;
  String? sPcountry;
  String? sPzipcode;
  String? sPaddress;
  String? pUser;
  String? pPw;
  String? credential;
  String? parentImage;
  String? parentEmail;

  ParentData(
      {this.pid,
        this.stuWpUsrId,
        this.parentWpUsrId,
        this.pFname,
        this.pMname,
        this.pLname,
        this.pGender,
        this.pEdu,
        this.pPhone,
        this.pProfession,
        this.pBloodgrp,
        this.sPcity,
        this.sPcountry,
        this.sPzipcode,
        this.sPaddress,
        this.pUser,
        this.pPw,
        this.credential,
        this.parentImage,
        this.parentEmail});

  ParentData.fromJson(Map<String, dynamic> json) {
    pid = json['pid'];
    stuWpUsrId = json['stu_wp_usr_id'];
    parentWpUsrId = json['parent_wp_usr_id'];
    pFname = json['p_fname'];
    pMname = json['p_mname'];
    pLname = json['p_lname'];
    pGender = json['p_gender'];
    pEdu = json['p_edu'];
    pPhone = json['p_phone'];
    pProfession = json['p_profession'];
    pBloodgrp = json['p_bloodgrp'];
    sPcity = json['s_pcity'];
    sPcountry = json['s_pcountry'];
    sPzipcode = json['s_pzipcode'];
    sPaddress = json['s_paddress'];
    pUser = json['p_user'];
    pPw = json['p_pw'];
    credential = json['Credential'];
    parentImage = json['parent_image'];
    parentEmail = json['parent_email'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['pid'] = pid;
    data['stu_wp_usr_id'] = stuWpUsrId;
    data['parent_wp_usr_id'] = parentWpUsrId;
    data['p_fname'] = pFname;
    data['p_mname'] = pMname;
    data['p_lname'] = pLname;
    data['p_gender'] = pGender;
    data['p_edu'] = pEdu;
    data['p_phone'] = pPhone;
    data['p_profession'] = pProfession;
    data['p_bloodgrp'] = pBloodgrp;
    data['s_pcity'] = sPcity;
    data['s_pcountry'] = sPcountry;
    data['s_pzipcode'] = sPzipcode;
    data['s_paddress'] = sPaddress;
    data['p_user'] = pUser;
    data['p_pw'] = pPw;
    data['Credential'] = credential;
    data['parent_image'] = parentImage;
    data['parent_email'] = parentEmail;
    return data;
  }
}

class StudentData {
  String? wpUsrId;
  String? classId;
  String? sid;
  String? sRollno;
  String? sFname;
  String? sMname;
  String? sLname;
  String? sDob;
  String? sGender;
  String? sAddress;
  String? sCountry;
  String? sZipcode;
  String? sPhone;
  String? sBloodgrp;
  String? sDoj;
  String? classDate;
  String? sCity;
  String? className;
  String? showAssistant;
  String? stuEmail;
  String? stuImage;

  StudentData(
      {this.wpUsrId,
        this.classId,
        this.sid,
        this.sRollno,
        this.sFname,
        this.sMname,
        this.sLname,
        this.sDob,
        this.sGender,
        this.sAddress,
        this.sCountry,
        this.sZipcode,
        this.sPhone,
        this.sBloodgrp,
        this.sDoj,
        this.classDate,
        this.sCity,
        this.className,
        this.showAssistant,
        this.stuEmail,
        this.stuImage});

  StudentData.fromJson(Map<String, dynamic> json) {
    wpUsrId = json['wp_usr_id'];
    classId = json['class_id'];
    sid = json['sid'];
    sRollno = json['s_rollno'];
    sFname = json['s_fname'];
    sMname = json['s_mname'];
    sLname = json['s_lname'];
    sDob = json['s_dob'];
    sGender = json['s_gender'];
    sAddress = json['s_address'];
    sCountry = json['s_country'];
    sZipcode = json['s_zipcode'];
    sPhone = json['s_phone'];
    sBloodgrp = json['s_bloodgrp'];
    sDoj = json['s_doj'];
    classDate = json['class_date'];
    sCity = json['s_city'];
    className = json['class_name'];
    showAssistant = json['show_assistant'];
    stuEmail = json['stu_email'];
    stuImage = json['stu_image'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['wp_usr_id'] = wpUsrId;
    data['class_id'] = classId;
    data['sid'] = sid;
    data['s_rollno'] = sRollno;
    data['s_fname'] = sFname;
    data['s_mname'] = sMname;
    data['s_lname'] = sLname;
    data['s_dob'] = sDob;
    data['s_gender'] = sGender;
    data['s_address'] = sAddress;
    data['s_country'] = sCountry;
    data['s_zipcode'] = sZipcode;
    data['s_phone'] = sPhone;
    data['s_bloodgrp'] = sBloodgrp;
    data['s_doj'] = sDoj;
    data['class_date'] = classDate;
    data['s_city'] = sCity;
    data['class_name'] = className;
    data['show_assistant'] = showAssistant;
    data['stu_email'] = stuEmail;
    data['stu_image'] = stuImage;
    return data;
  }
}
