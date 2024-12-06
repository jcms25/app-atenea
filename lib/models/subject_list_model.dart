class SubjectListModel {
  bool? status;
  String? message;
  List<SubjectItem>? subjectlist;

  SubjectListModel({this.status, this.message, this.subjectlist});

  SubjectListModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['Message'];
    if (json['subjectlist'] != null) {
      subjectlist = <SubjectItem>[];
      json['subjectlist'].forEach((v) {
        subjectlist!.add(SubjectItem.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = status;
    data['Message'] = message;
    if (subjectlist != null) {
      data['subjectlist'] = subjectlist!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class SubjectItem {
  String? classId;
  String? id;
  String? group;
  String? subCode;
  String? subName;
  String? subTeachId;
  String? bookName;
  String? bookId;
  String? bookImg;
  String? subDesc;
  String? maxMark;
  String? passMark;
  String? faculty;

  SubjectItem(
      {this.classId,
        this.id,
        this.group,
        this.subCode,
        this.subName,
        this.subTeachId,
        this.bookName,
        this.bookId,
        this.bookImg,
        this.subDesc,
        this.maxMark,
        this.passMark,
        this.faculty});

  SubjectItem.fromJson(Map<String, dynamic> json) {
    classId = json['class_id'];
    id = json['id'];
    group = json['grupo'];
    subCode = json['sub_code'];
    subName = json['sub_name'];
    subTeachId = json['sub_teach_id'];
    bookName = json['book_name'];
    bookId = json['book_id'];
    bookImg = json['book_img'];
    subDesc = json['sub_desc'];
    maxMark = json['max_mark'];
    passMark = json['pass_mark'];
    faculty = json['faculty'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['class_id'] = classId;
    data['id'] = id;
    data['grupo'] = group;
    data['sub_code'] = subCode;
    data['sub_name'] = subName;
    data['sub_teach_id'] = subTeachId;
    data['book_name'] = bookName;
    data['book_id'] = bookId;
    data['book_img'] = bookImg;
    data['sub_desc'] = subDesc;
    data['max_mark'] = maxMark;
    data['pass_mark'] = passMark;
    data['faculty'] = faculty;
    return data;
  }
}
