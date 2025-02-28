class MarksList {
  bool? status;
  List<MarksItem>? data;
  String? message;

  MarksList({this.status, this.data, this.message});

  MarksList.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    if (json['data'] != null) {
      data = <MarksItem>[];
      json['data'].forEach((v) {
        data!.add(MarksItem.fromJson(v));
      });
    }
    message = json['Message'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = status;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    data['Message'] = message;
    return data;
  }
}

class MarksItem {
  String? mid;
  String? subjectId;
  String? classId;
  String? studentId;
  String? examId;
  String? mark;
  String? remarks;
  String? attendance;
  String? studentFirstName;
  String? studentLastName;
  String? studentName;
  String? studentRollNo;
  String? studentImage;

  MarksItem(
      {this.mid,
        this.subjectId,
        this.classId,
        this.studentId,
        this.examId,
        this.mark,
        this.remarks,
        this.attendance,
        this.studentFirstName,
        this.studentLastName,
        this.studentName,
        this.studentImage,
        this.studentRollNo});

  MarksItem.fromJson(Map<String, dynamic> json) {
    mid = json['mid'];
    subjectId = json['subject_id'];
    classId = json['class_id'];
    studentId = json['student_id'];
    examId = json['exam_id'];
    mark = json['mark'];
    remarks = json['remarks'];
    attendance = json['attendance'];
    studentName = json['student_name'];
    studentFirstName = json["student_firstname"];
    studentLastName = json["student_lastname"];
    studentRollNo = json['student_roll_no'];
    studentImage = json['stud_image'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['mid'] = mid;
    data['subject_id'] = subjectId;
    data['class_id'] = classId;
    data['student_id'] = studentId;
    data['exam_id'] = examId;
    data['mark'] = mark;
    data['remarks'] = remarks;
    data['attendance'] = attendance;
    data['student_name'] = studentName;
    data['student_roll_no'] = studentRollNo;
    data['stud_image'] = studentImage;
    data['student_firstname'] = studentFirstName;
    data['student_lastname'] = studentLastName;
    return data;
  }
}
