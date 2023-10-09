import 'package:colegia_atenea/models/Model.dart';
import 'package:colegia_atenea/screens/assistant_module/assistant_communication_list_screen.dart';
import 'package:colegia_atenea/screens/menu_screen/attendence_screen.dart';
import 'package:colegia_atenea/screens/menu_screen/evaluation_screen.dart';
import 'package:colegia_atenea/screens/menu_screen/grade_screen.dart';
import 'package:colegia_atenea/screens/menu_screen/sujects_screen.dart';
import 'package:colegia_atenea/screens/menu_screen/teacher_screen.dart';
import 'package:colegia_atenea/screens/menu_screen/timetable_screen.dart';
import 'package:colegia_atenea/screens/menu_screen/student_screen.dart';
import 'package:colegia_atenea/screens/menu_screen/test_screen.dart';
import 'package:colegia_atenea/screens/menu_screen/transportation_screen.dart';
import 'package:colegia_atenea/screens/nav_screens/message_screen.dart';
import 'package:colegia_atenea/utils/app_colors.dart';
import 'package:colegia_atenea/utils/app_images.dart';
import 'package:colegia_atenea/utils/text_style.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

import '../assistant_module/assistant_communication_report_message_list_screen.dart';
import '../menu_screen/send_message_to_assistant_screen.dart';

class ClassMenuScreen extends StatefulWidget {
  final Model model;

  const ClassMenuScreen(this.model, {super.key});

  @override
  State<ClassMenuScreen> createState() => ClassMenu();
}

class ClassMenu extends State<ClassMenuScreen> {
  String classname = "";

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          backgroundColor: AppColors.primary,
          elevation: 0,
          titleSpacing: 0,
          title: Padding(
            padding: const EdgeInsets.only(top: 10, bottom: 10),
            child: Text(
              widget.model.className,
              style: CustomStyle.appbartitle,
            ),
          ),
          leading: Padding(
              padding: const EdgeInsets.all(10),
              child: GestureDetector(
                onTap: () {
                  Navigator.pop(context);
                },
                child: SvgPicture.asset(
                  AppImages.Arrow,
                  color: AppColors.orange,
                ),
              )),
        ),
        body: Column(children: <Widget>[
          widget.model.showAssistant == null
              ? Expanded(
                  child: ListView(
                  physics: const BouncingScrollPhysics(),
                  children: [
                    Container(
                        margin: const EdgeInsets.all(10),
                        child: Column(
                          children: [
                            ListTile(
                                onTap: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => TimeTableScreen(
                                              widget.model.classId)));
                                },
                                title: Text(
                                  "timetable".tr,
                                  style: CustomStyle.txtvalue4,
                                ),
                                leading: const Icon(
                                  Icons.calendar_month,
                                  size: 30,
                                  color: AppColors.secondary,
                                ),
                                trailing: const Icon(
                                  Icons.arrow_forward,
                                  color: AppColors.secondary,
                                )),
                            Visibility(
                              visible: widget.model.showAssistant == "1",
                              child: ListTile(
                                onTap: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => const MessageScreen(studentOrParent: "1",)));
                                },
                                title: Text(
                                  'menu1'.tr,
                                  style: CustomStyle.txtvalue4,
                                ),
                                leading: SvgPicture.asset(AppImages.message,color: AppColors.secondary,),
                                trailing: const Icon(
                                  Icons.arrow_forward,
                                  color: AppColors.secondary,
                                )),),
                            ListTile(
                                onTap: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => teacherscreen(
                                              widget.model.classId,
                                              widget.model.wpUserid)));
                                },
                                title: Text(
                                  "teachers".tr,
                                  style: CustomStyle.txtvalue4,
                                ),
                                leading: const Icon(
                                  Icons.person_add_sharp,
                                  size: 30,
                                  color: AppColors.secondary,
                                ),
                                trailing: const Icon(
                                  Icons.arrow_forward,
                                  color: AppColors.secondary,
                                )),
                            ListTile(
                                onTap: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => studentscreen(
                                              widget.model.classId,
                                              widget.model.wpUserid)));
                                },
                                title: Text(
                                  "student".tr,
                                  style: CustomStyle.txtvalue4,
                                ),
                                leading: const Icon(
                                  Icons.person,
                                  size: 30,
                                  color: AppColors.secondary,
                                ),
                                trailing: const Icon(
                                  Icons.arrow_forward,
                                  color: AppColors.secondary,
                                )),
                            ListTile(
                                onTap: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => subjectscreen(
                                              widget.model.classId,
                                              widget.model.wpUserid)));
                                },
                                title: Text(
                                  "subjects".tr,
                                  style: CustomStyle.txtvalue4,
                                ),
                                leading: const Icon(
                                  Icons.library_books,
                                  size: 30,
                                  color: AppColors.secondary,
                                ),
                                trailing: const Icon(
                                  Icons.arrow_forward,
                                  color: AppColors.secondary,
                                )),
                            ListTile(
                                onTap: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => TestScreen(
                                              widget.model.classId,
                                              widget.model.wpUserid)));
                                },
                                title: Text(
                                  "tests".tr,
                                  style: CustomStyle.txtvalue4,
                                ),
                                leading: const Icon(
                                  Icons.textsms_sharp,
                                  size: 30,
                                  color: AppColors.secondary,
                                ),
                                trailing: const Icon(
                                  Icons.arrow_forward,
                                  color: AppColors.secondary,
                                )),
                            ListTile(
                                onTap: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => gradescreen(
                                              widget.model.classId,
                                              widget.model.wpUserid)));
                                },
                                title: Text(
                                  "grades".tr,
                                  style: CustomStyle.txtvalue4,
                                ),
                                leading: const Icon(
                                  Icons.margin,
                                  size: 30,
                                  color: AppColors.secondary,
                                ),
                                trailing: const Icon(
                                  Icons.arrow_forward,
                                  color: AppColors.secondary,
                                )),
                            ListTile(
                                onTap: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              evaluationscreen(
                                                  widget.model.classId,
                                                  widget.model.wpUserid)));
                                },
                                title: Text(
                                  "evaluation".tr,
                                  style: CustomStyle.txtvalue4,
                                ),
                                leading: const Icon(
                                  Icons.edit_calendar,
                                  size: 30,
                                  color: AppColors.secondary,
                                ),
                                trailing: const Icon(
                                  Icons.arrow_forward,
                                  color: AppColors.secondary,
                                )),

                            //attendance option hide here
                            // ListTile(
                            //     onTap: () {
                            //       Navigator.push(
                            //           context,
                            //           MaterialPageRoute(
                            //               builder: (context) =>
                            //                   attendencescreen(
                            //                       widget.model.classId,
                            //                       widget.model.wpUserid)));
                            //     },
                            //     title: Text(
                            //       "attendence".tr,
                            //       style: CustomStyle.txtvalue4,
                            //     ),
                            //     leading: const Icon(
                            //       Icons.book_online,
                            //       size: 30,
                            //       color: AppColors.secondary,
                            //     ),
                            //     trailing: const Icon(
                            //       Icons.arrow_forward,
                            //       color: AppColors.secondary,
                            //     )),
                            ListTile(
                                onTap: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              const transportationscreen()));
                                },
                                title: Text(
                                  "trans".tr,
                                  style: CustomStyle.txtvalue4,
                                ),
                                leading: const Icon(
                                  Icons.train,
                                  size: 30,
                                  color: AppColors.secondary,
                                ),
                                trailing: const Icon(
                                  Icons.arrow_forward,
                                  color: AppColors.secondary,
                                )),
                          ],
                        ))
                  ],
                ))
              : Column(
            children: [
              ListTile(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const ReportListScreen(showInParent: "1",)));
                  },
                  title: Text(
                    'menu1'.tr,
                    style: CustomStyle.txtvalue4,
                  ),
                  leading: SvgPicture.asset(AppImages.message,color: AppColors.secondary,),
                  trailing: const Icon(
                    Icons.arrow_forward,
                    color: AppColors.secondary,
                  )),
              ListTile(
                  onTap: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context)=>SendMessageToAssistant(studentId: widget.model.wpUserid,)));
                  },
                  title: Text(
                    'menu2'.tr,
                    style: CustomStyle.txtvalue4,
                  ),
                  leading: const Icon(Icons.send,color: AppColors.secondary,),
                  trailing: const Icon(
                    Icons.arrow_forward,
                    color: AppColors.secondary,
                  )),
            ],
          ),
        ]));
  }
}
