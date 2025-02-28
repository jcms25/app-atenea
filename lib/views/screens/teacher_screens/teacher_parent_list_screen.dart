import 'package:colegia_atenea/controllers/student_parent_teacher_controller.dart';
import 'package:colegia_atenea/utils/app_colors.dart';
import 'package:colegia_atenea/utils/app_textstyle.dart';
import 'package:colegia_atenea/views/custom_widgets/custom_app_bar_widget.dart';
import 'package:colegia_atenea/views/custom_widgets/teacher_class_list_dropdown.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

import '../../../models/teacher/parent_list_model.dart';
import '../../../utils/app_images.dart';
import '../../custom_widgets/custom_loader.dart';

class TeacherParentListScreen extends StatefulWidget {
  const TeacherParentListScreen({super.key});

  @override
  State<TeacherParentListScreen> createState() =>
      _TeacherParentListScreenState();
}

class _TeacherParentListScreenState extends State<TeacherParentListScreen> {

  Map<String,dynamic>? arguments;
  StudentParentTeacherController? studentParentTeacherController;


  @override
  void initState() {
    super.initState();
    arguments = Get.arguments;
    WidgetsBinding.instance.addPostFrameCallback((timeStamp){
      studentParentTeacherController = Provider.of<StudentParentTeacherController>(context,listen: false);
      if(studentParentTeacherController?.listOfClassAssignToTeacher.isNotEmpty ?? false){
        studentParentTeacherController?.setCurrentSelectedClass(teacherClass: studentParentTeacherController?.listOfClassAssignToTeacher[0]);
        studentParentTeacherController?.getListOfParents(classId: studentParentTeacherController?.currentSelectedClass?.cid ?? "");
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
        canPop: true,
        onPopInvokedWithResult: (res,ctx){
          studentParentTeacherController?.setListOfParents(listOfParents: []);
        },
        child: Scaffold(
      appBar: CustomAppBarWidget(
          onLeadingIconClicked: (){
            studentParentTeacherController?.setListOfParents(listOfParents: []);
            Get.back();
          },
          title: Text(
            'Padres',
            style:
            AppTextStyle.getOutfit600(textSize: 20, textColor: AppColors.white),
          ),
          actionIcons: [
            Expanded(child: TeacherClassListDropdown(fromWhichScreen: 2))
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
                                                    textColor: AppColors
                                                              .secondary
                                                              .withValues(alpha: 0.5)
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
                                                .searchInParentList,
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
                                        .listOfParents.isEmpty
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
                                          ParentItem parentItem =
                                          studentParentTeacherController
                                              .tempListOfParents[index];
                                          return ParentItemWidget(
                                            parentItem: parentItem,
                                          );
                                        },
                                        separatorBuilder: (context, index) {
                                          return const SizedBox(
                                            height: 15,
                                          );
                                        },
                                        itemCount:
                                        studentParentTeacherController
                                            .tempListOfParents.length);
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
            )
    ));
  }
}

class ParentItemWidget extends StatelessWidget {
  final ParentItem parentItem;

  const ParentItemWidget({super.key, required this.parentItem});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
          // color: AppColors.primary.withOpacity(0.05),
          color: AppColors.primary.withValues(alpha: 0.05),
          borderRadius: const BorderRadius.all(Radius.circular(15))),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                  child: GestureDetector(
                    onTap: () {
                      // Get.to(() =>
                      //     TeacherDetails(
                      //       id: teacherItem.wpUsrId ?? "",
                      //       subject: teacherItem.subjectName?.join("\n") ?? "",
                      //       inCharge: teacherItem.inCharge?.join("\n") ?? "",
                      //     ));
                    },
                    child: Row(
                      children: [
                        CircleAvatar(
                          radius: 30,
                          backgroundImage: NetworkImage(
                            // parentItem.image!,
                            parentItem.parentImage ?? "",
                          ),
                          backgroundColor: AppColors.primary,
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        const SizedBox(width: 10,),
                        Expanded(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "${parentItem.pFname?.isEmpty ?? false ? "-" : "${parentItem.pFname}"} ${parentItem.pLname?.isEmpty ?? false ? "-" : "${parentItem.pLname}"}",
                                  style: AppTextStyle.getOutfit600(
                                      textSize: 20,
                                      textColor: AppColors.secondary),
                                ),
                                const SizedBox(height: 5,),
                                Row(
                                  children: [
                                    SvgPicture.asset(AppImages.message,colorFilter: ColorFilter.mode(AppColors.primary, BlendMode.srcIn),width: 15,height: 15,),
                                    const SizedBox(width: 5,),
                                    Expanded(child: Text(
                                      "${parentItem.userEmail}",
                                      style: AppTextStyle.getOutfit400(
                                          textSize: 16,
                                          textColor: AppColors.secondary),
                                    ))
                                  ],
                                ),
                                const SizedBox(height: 5,),
                                Row(
                                  children: [
                                    SvgPicture.asset(AppImages.people,colorFilter: ColorFilter.mode(AppColors.primary, BlendMode.srcIn),),
                                    const SizedBox(width: 5,),
                                    Expanded(child: Text(
                                        parentItem.studentName ?? "",
                                        style: AppTextStyle.getOutfit400(
                                            textSize: 16,
                                            textColor: AppColors.secondary)
                                    ))
                                  ],
                                )
                              ],
                            )),
                      ],
                    ),
                  )),
              const SizedBox(
                width: 10,
              ),
              // Visibility(
              //     visible: roleType != RoleType.teacher,
              //     child: GestureDetector(
              //       onTap: () {
              //         Get.to(() =>
              //             MessageSendScreen(
              //               teacherId: teacherItem.wpUsrId,
              //             ));
              //       },
              //       child: SvgPicture.asset(
              //         AppImages.message,
              //         colorFilter:
              //         const ColorFilter.mode(AppColors.greyColor, BlendMode.srcIn),
              //       ),
              //     )),
              // const SizedBox(
              //   width: 10,
              // )
            ],
          ),
          const SizedBox(height: 20,),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(Icons.phone,color: AppColors.primary,),
              const SizedBox(width: 10,),
              Text( parentItem.pPhone ?? "-",style: AppTextStyle.getOutfit400(
                  textSize: 16,
                  textColor: AppColors.secondary),)
            ],
          ),
          const SizedBox(height: 5,),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(Icons.home,color: AppColors.primary,),
              const SizedBox(width: 10,),
              Expanded(child: Text(parentItem.sPAddress ?? "-",style: AppTextStyle.getOutfit400(
                  textSize: 16,
                  textColor: AppColors.secondary),))
            ],
          ),
        ],
      ),
    );
  }
}
