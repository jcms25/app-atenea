// Modelo para el endpoint /teacher/students-with-parents.
//
// Devuelve la estructura jerárquica que usa la pantalla nueva
// de envío de mensajes a padres (perfil profesor):
//   - una lista de alumnos
//   - cada alumno con sus padres anidados
//
// Si un padre lo es de dos hermanos de la misma clase, aparece
// en cada hermano (es la duplicación deliberada que la vista
// jerárquica necesita).

class StudentsWithParentsModel {
  bool? status;
  String? message;
  List<StudentWithParents>? data;

  StudentsWithParentsModel({this.status, this.message, this.data});

  StudentsWithParentsModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['Message'];
    if (json['Data'] != null) {
      data = <StudentWithParents>[];
      json['Data'].forEach((v) {
        data!.add(StudentWithParents.fromJson(v));
      });
    }
  }
}

class StudentWithParents {
  String? studentId;
  String? sFname;
  String? sMname;
  String? sLname;
  List<ParentOfStudent>? parents;

  StudentWithParents({
    this.studentId,
    this.sFname,
    this.sMname,
    this.sLname,
    this.parents,
  });

  StudentWithParents.fromJson(Map<String, dynamic> json) {
    studentId = json['student_id']?.toString();
    sFname = json['s_fname']?.toString();
    sMname = json['s_mname']?.toString();
    sLname = json['s_lname']?.toString();
    if (json['parents'] != null) {
      parents = <ParentOfStudent>[];
      json['parents'].forEach((v) {
        parents!.add(ParentOfStudent.fromJson(v));
      });
    }
  }
}

class ParentOfStudent {
  String? parentWpUsrId;
  String? pFname;
  String? pLname;

  ParentOfStudent({
    this.parentWpUsrId,
    this.pFname,
    this.pLname,
  });

  ParentOfStudent.fromJson(Map<String, dynamic> json) {
    parentWpUsrId = json['parent_wp_usr_id']?.toString();
    pFname = json['p_fname']?.toString();
    pLname = json['p_lname']?.toString();
  }
}