import 'package:cached_network_image/cached_network_image.dart';
import 'package:colegia_atenea/controllers/student_parent_teacher_controller.dart';
import 'package:colegia_atenea/models/teacher_list_model.dart';
import 'package:colegia_atenea/utils/app_colors.dart';
import 'package:colegia_atenea/utils/app_textstyle.dart';
import 'package:colegia_atenea/views/custom_widgets/custom_app_bar_widget.dart';
import 'package:colegia_atenea/views/custom_widgets/custom_loader.dart';
import 'package:colegia_atenea/views/custom_widgets/teacher_class_list_dropdown.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

import '../../../utils/app_images.dart';
import '../send_message_screen.dart';
import 'class_menu_details_screen/teacher_details_screen.dart';

class TeacherListScreen extends StatefulWidget {

  const TeacherListScreen({super.key,});

  @override
  State<TeacherListScreen> createState() => _TeacherScreenChild();
}

class _TeacherScreenChild extends State<TeacherListScreen> {
  StudentParentTeacherController? studentParentTeacherController;
  Map<String, dynamic>? arguments;


  @override
  void initState() {
    super.initState();
    arguments = Get.arguments;
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      studentParentTeacherController =
          Provider.of<StudentParentTeacherController>(context, listen: false);


      if (arguments?['role'] == RoleType.teacher) {
       if(studentParentTeacherController?.listOfClassAssignToTeacher.isNotEmpty ?? false){
         studentParentTeacherController?.setCurrentSelectedClass(
             teacherClass: studentParentTeacherController
                 ?.listOfClassAssignToTeacher[0]);
         studentParentTeacherController?.getListOfTeachers(studentId: null,
             classId: studentParentTeacherController?.currentSelectedClass
                 ?.cid ?? "",
             roleType: arguments?['role']);
       }
      } else {
        studentParentTeacherController?.getListOfTeachers(
            studentId: arguments?['wpUserId'],
            classId: arguments?['classId'],
            roleType: arguments?['role']);
      }

    });
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
        canPop: true,
        onPopInvokedWithResult: (ctx, result) {
          studentParentTeacherController?.setListOfTeachers(listOfTeachers: []);
        },
        child: Scaffold(
            resizeToAvoidBottomInset: false,
            appBar: CustomAppBarWidget(
                onLeadingIconClicked: () {
                  studentParentTeacherController
                      ?.setListOfTeachers(listOfTeachers: []);
                  Get.back();
                },
                title: Text(
                  arguments?['role'] != RoleType.teacher ? "${"teachers"
                      .tr} de ${arguments?['className']}" : "teachers".tr,
                  style: AppTextStyle.getOutfit500(
                      textSize: 20, textColor: AppColors.white),
                ),
                actionIcons: [
                  Visibility(
                      visible: arguments?['role'] == RoleType.teacher,
                      child: Expanded(child:TeacherClassListDropdown(fromWhichScreen: 3)))
                ],

            ),
            body: Stack(
              children: [
                SizedBox(
                    width: MediaQuery
                        .of(context)
                        .size
                        .width,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                            height: 90,
                            decoration: const BoxDecoration(
                                borderRadius: BorderRadius.only(
                                    bottomLeft: Radius.circular(20),
                                    bottomRight: Radius.circular(20)),
                                color: AppColors.primary),
                            child: Padding(
                              padding:
                              const EdgeInsets.only(left: 15, right: 15),
                              child: Row(
                                children: [
                                  Expanded(
                                    child: Container(
                                      height: 50,
                                      decoration: BoxDecoration(
                                        color: AppColors.white,
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      child: Consumer<
                                          StudentParentTeacherController>(
                                        builder: (context,
                                            studentParentTeacherController,
                                            child) {
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
                                                    // textColor: AppColors
                                                    //     .secondary
                                                    //     .withOpacity(0.5)
                                                  textColor: AppColors.secondary.withValues(alpha: 0.5)
                                                ),
                                                contentPadding:
                                                const EdgeInsets.all(10),
                                                border: InputBorder.none),
                                            style: AppTextStyle.getOutfit400(
                                                textSize: 18,
                                                textColor: AppColors.secondary),
                                            keyboardType: TextInputType.text,
                                            textInputAction:
                                            TextInputAction.next,
                                            onChanged:
                                            studentParentTeacherController
                                                .searchInTeacherList,
                                          );
                                        },
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            )),
                        Expanded(
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 10, horizontal: 10),
                              child: ScrollConfiguration(
                                behavior: const ScrollBehavior()
                                    .copyWith(overscroll: false),
                                child: Consumer<StudentParentTeacherController>(
                                  builder: (context,
                                      studentParentTeacherController,
                                      child) {
                                    return studentParentTeacherController
                                        .listOfTeachers.isEmpty
                                        ? Center(
                                      child: Text(
                                        'no hay resultados',
                                        style: AppTextStyle.getOutfit400(
                                            textSize: 16,
                                            textColor: AppColors.secondary),
                                      ),
                                    )
                                        : ListView.separated(
                                        itemBuilder: (context, index) {
                                          TeacherItem teacherItem =
                                          studentParentTeacherController
                                              .tempListOfTeachers[index];
                                          return TeacherItemWidget(
                                            teacherItem: teacherItem, roleType: arguments?['role'],
                                          );
                                        },
                                        separatorBuilder: (context, index) {
                                          return const SizedBox(
                                            height: 15,
                                          );
                                        },
                                        itemCount:
                                        studentParentTeacherController
                                            .tempListOfTeachers.length);
                                  },
                                ),
                              ),
                            ))
                      ],
                    )),
                Consumer<StudentParentTeacherController>(
                    builder: (context, studentParentTeacherController, child) {
                      return Visibility(
                          visible: studentParentTeacherController.isLoading,
                          child: const LoadingLayout());
                    })
              ],
            )));
  }
}

class TeacherItemWidget extends StatelessWidget {
  final TeacherItem teacherItem;
  final RoleType roleType;

  const TeacherItemWidget({super.key, required this.teacherItem, required this.roleType});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
          // color: AppColors.primary.withOpacity(0.05),
          color: AppColors.primary.withValues(alpha: 0.05),
          borderRadius: const BorderRadius.all(Radius.circular(15))),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
              child: Consumer<StudentParentTeacherController>(
                builder: (context,studentParentTeacherController,child){
                  return GestureDetector(
                    onTap: () {
                      Get.to(() =>
                          TeacherDetails(
                            wpUserId: teacherItem.wpUsrId ?? "",
                            subject: studentParentTeacherController.currentLoggedInUserRole == RoleType.teacher ? null : teacherItem.subjectName?.join("\n") ?? "",
                            inCharge: teacherItem.inCharge?.join("\n") ?? "",
                          ));
                    },
                    child: Row(
                      children: [
                        CircleAvatar(
                          radius: 30,
                          // backgroundImage: NetworkImage(
                          //   teacherItem.image!,
                          // ),
                          backgroundImage: CachedNetworkImageProvider(
                              teacherItem.image ?? "",
                          ),
                          backgroundColor: AppColors.primary,
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        Expanded(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(top: 10),
                                  child: Text(
                                    "${teacherItem.firstName!}\t${teacherItem
                                        .lastName}",
                                    style: AppTextStyle.getOutfit600(
                                        textSize: 20,
                                        textColor: AppColors.secondary),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(
                                      top: 5, bottom: 10),
                                  child: Text(
                                    teacherItem.subjectName!.join("\n"),
                                    style: AppTextStyle.getOutfit400(
                                        textSize: 16,
                                        textColor: AppColors.secondary),
                                  ),
                                ),
                              ],
                            )),
                      ],
                    ),
                  );
                },
              )),
          const SizedBox(
            width: 10,
          ),
          Visibility(
              visible: roleType == RoleType.parent,
              child: GestureDetector(
            onTap: () {
              Get.to(() =>
                  MessageSendScreen(
                    teacherId: teacherItem.wpUsrId, roleType: roleType,
                  ));
            },
            child: SvgPicture.asset(
              AppImages.message,
              colorFilter:
              const ColorFilter.mode(AppColors.greyColor, BlendMode.srcIn),
            ),
          )),
          const SizedBox(
            width: 10,
          )
        ],
      ),
    );
  }
}
