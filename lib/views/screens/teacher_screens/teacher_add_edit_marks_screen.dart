import 'package:colegia_atenea/controllers/student_parent_teacher_controller.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';



class TeacherAddEditMarksScreen extends StatefulWidget {
  const TeacherAddEditMarksScreen({super.key});

  @override
  State<TeacherAddEditMarksScreen> createState() => _TeacherAddEditMarksScreenState();
}

class _TeacherAddEditMarksScreenState extends State<TeacherAddEditMarksScreen> {
  
  StudentParentTeacherController? studentParentTeacherController;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp){
      studentParentTeacherController = Provider.of<StudentParentTeacherController>(context,listen: false);
    });
  }
  

  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}



class MarksEditViewWidget extends StatelessWidget {
  const MarksEditViewWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}
