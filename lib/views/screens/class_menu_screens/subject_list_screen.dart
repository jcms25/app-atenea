import 'package:colegia_atenea/controllers/student_parent_teacher_controller.dart';
import 'package:colegia_atenea/utils/app_colors.dart';
import 'package:colegia_atenea/utils/app_images.dart';
import 'package:colegia_atenea/utils/app_textstyle.dart';
import 'package:colegia_atenea/views/custom_widgets/custom_app_bar_widget.dart';
import 'package:colegia_atenea/views/custom_widgets/teacher_class_list_dropdown.dart';
import 'package:colegia_atenea/views/screens/class_menu_screens/class_menu_details_screen/subject_detail_screen.dart';
import 'package:colegia_atenea/views/custom_widgets/custom_loader.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

import '../../../models/subject_list_model.dart';

class SubjectListScreen extends StatefulWidget {


  const SubjectListScreen(
      {super.key,});

  @override
  State<SubjectListScreen> createState() => _SubjectListScreenChild();
}

class _SubjectListScreenChild extends State<SubjectListScreen> {
  StudentParentTeacherController? studentParentTeacherController;
  Map<String,dynamic>? arguments;


  @override
  void initState() {
    super.initState();
    arguments = Get.arguments;
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      studentParentTeacherController = Provider.of<StudentParentTeacherController>(context, listen: false);

        if(arguments?['role'] == RoleType.teacher){
         if(studentParentTeacherController?.listOfClassAssignToTeacher.isNotEmpty ?? false){
           studentParentTeacherController?.setCurrentSelectedClass(teacherClass: studentParentTeacherController?.listOfClassAssignToTeacher[0]);
           studentParentTeacherController?.getListOfSubjects(
               classId: studentParentTeacherController?.currentSelectedClass?.cid ?? "", wpId: null, roleType: arguments?['role']);

         }
        }else{
          studentParentTeacherController?.getListOfSubjects(
              classId: arguments?['role'] == RoleType.teacher ? studentParentTeacherController?.currentSelectedClass?.cid ?? "" : arguments?['classId'] ?? "", wpId: arguments?['wpUserId'], roleType: arguments?['role']);

        }
       });
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
        canPop: true,
        onPopInvokedWithResult: (result, onPopInvoked) {
          studentParentTeacherController?.setListOfSubject(listOfSubject: []);
        },
        child: SafeArea(child: Scaffold(
            resizeToAvoidBottomInset: false,
            appBar: CustomAppBarWidget(
                onLeadingIconClicked: () {
                  studentParentTeacherController
                      ?.setListOfSubject(listOfSubject: []);
                  Get.back();
                },
                title: Text(
                  arguments?['role'] == RoleType.teacher ? "subjects".tr : "${"subjects".tr} de ${arguments?['studentName']}",
                  style: AppTextStyle.getOutfit500(
                      textSize: 20, textColor: AppColors.white),
                ),
                actionIcons: [
                  Visibility(
                      visible: arguments?['role'] == RoleType.teacher,
                      child: Expanded(child: TeacherClassListDropdown(fromWhichScreen: 4)))
                ],
            ),
            body: Stack(
              children: [
                Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                          height: 90,
                          width: MediaQuery.of(context).size.width,
                          decoration: const BoxDecoration(
                              borderRadius: BorderRadius.only(
                                  bottomLeft: Radius.circular(20),
                                  bottomRight: Radius.circular(20)),
                              color: AppColors.primary),
                          child: Padding(
                            padding: const EdgeInsets.only(left: 15, right: 15),
                            child: Row(
                              children: [
                                Expanded(
                                  child: Container(
                                    height: 50,
                                    decoration: BoxDecoration(
                                      color: AppColors.white,
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: Consumer<StudentParentTeacherController>(
                                      builder: (context, appController, child) {
                                        return TextField(
                                          autofocus: false,
                                          decoration: InputDecoration(
                                              prefixIcon: IconButton(
                                                icon: const Icon(
                                                  Icons.search,
                                                  color: AppColors.searchIcon,
                                                ),
                                                onPressed: () {},
                                              ),
                                              hintText: 'searchInList'.tr,
                                              hintStyle:
                                              AppTextStyle.getOutfit400(
                                                  textSize: 16,
                                                  textColor: AppColors
                                                      .secondary
                                                      .withOpacity(0.5)),
                                              border: InputBorder.none),
                                          cursorColor: AppColors.primary,
                                          keyboardType: TextInputType.text,
                                          textInputAction: TextInputAction.done,
                                          onChanged:
                                          appController.searchInSubjectList,
                                        );
                                      },
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          )),
                      Expanded(
                        child: ScrollConfiguration(
                            behavior: const ScrollBehavior()
                                .copyWith(overscroll: false),
                            child: Padding(
                              padding:
                              const EdgeInsets.symmetric(horizontal: 10).copyWith(top: 20),
                              child: Consumer<StudentParentTeacherController>(
                                builder: (context, appController, child) {
                                  return appController
                                      .tempListOfSubject.isEmpty
                                      ? Center(
                                    child: Text(
                                      'noStudentFound'.tr,
                                      style: AppTextStyle.getOutfit400(
                                          textSize: 16,
                                          textColor: AppColors.secondary),
                                    ),
                                  )
                                      : ListView.separated(
                                      itemBuilder: (context, index) {
                                        SubjectItem subject = appController
                                            .tempListOfSubject[
                                        index];
                                        return SubjectItemWidget(
                                            subjectItem: subject);
                                      },
                                      separatorBuilder: (context, index) {
                                        return const SizedBox(
                                          height: 10,
                                        );
                                      },
                                      itemCount: appController
                                          .tempListOfSubject.length);
                                },
                              ),
                            )),
                      )
                    ]),
                Consumer<StudentParentTeacherController>(
                    builder: (context, appController, child) {
                      return Visibility(
                          visible: appController.isLoading,
                          child: Container(
                            color: Colors.black.withOpacity(0.5),
                            height: MediaQuery.of(context).size.height,
                            width: MediaQuery.of(context).size.width,
                            child: const Center(
                              child: LoadingLayout(),
                            ),
                          ));
                    })
              ],
            ))));
  }
}

class SubjectItemWidget extends StatelessWidget {
  final SubjectItem subjectItem;

  const SubjectItemWidget({super.key, required this.subjectItem});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) =>
                    SubjectDetailScreen(subjectId: subjectItem.id ?? "",group: subjectItem.group ?? "")));
      },
      child: Container(
        width: MediaQuery.of(context).size.width,
        constraints: const BoxConstraints(minHeight: 25),
        padding: const EdgeInsets.only(left: 10, top: 10, bottom: 10),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: AppColors.primary.withOpacity(0.05)),
        child: Row(
          children: [
            Container(
              width: 50,
              height: 50,
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: AppColors.primary,
                borderRadius: BorderRadius.circular(5),
              ),
              child: SvgPicture.asset(
                AppImages.whiteBookIcon,
                fit: BoxFit.fill,
              ),
            ),
            const SizedBox(
              width: 10,
            ),
            Expanded(
                child: Text(
              subjectItem.subName ?? "-",
              style: AppTextStyle.getOutfit400(
                  textSize: 18, textColor: AppColors.secondary),
            ))
          ],
        ),
      ),
    );
  }
}
