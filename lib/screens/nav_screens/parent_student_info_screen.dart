import 'package:colegia_atenea/services/session_management.dart';
import 'package:colegia_atenea/widgets/custom_loader.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../models/Parent/Parentlogin.dart';
import '../../models/Student/Studentlogin.dart';
import '../../utils/app_colors.dart';
import '../../utils/app_images.dart';
import '../../utils/text_style.dart';

class ParentStudentInfo extends StatefulWidget {
  const ParentStudentInfo({super.key});

  @override
  State<StatefulWidget> createState() {
    return _ParentStudentInfoChild();
  }
}

class _ParentStudentInfoChild extends State<ParentStudentInfo> {
  String titleOfScreen = "";
  int roleOfUser = 2; //default 2. 1 for parent and 0 for student.
  //2 means we didn't get data from store data.

  List<ParentDatum> parentData = []; //this will store parent data.
  List<StudentDatum> studentData = []; //this will store student data.

  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    setState(() {
      isLoading = true;
    });
    setData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        titleSpacing: 0,
        elevation: 0,
        backgroundColor: AppColors.primary,
        leading: Padding(
            padding: const EdgeInsets.all(10),
            child: GestureDetector(
              onTap: () {
                Scaffold.of(context).openDrawer();
              },
              child: SvgPicture.asset(
                AppImages.humBurg,
              ),
            )),
        title: Text(titleOfScreen, style: CustomStyle.appBarTitle),
        // actions: <Widget>[
        //   Padding(
        //     padding: const EdgeInsets.only(right: 20.0),
        //     child: GestureDetector(
        //       onTap: () {},
        //       child: SvgPicture.asset(
        //         AppImages.bell,
        //         height: 26,
        //         width: 26,
        //       ),
        //     ),
        //   ),
        // ],
      ),
      body: Stack(
        children: [
          roleOfUser == 2 ? Center(
            child: Text("No Data Available",style: CustomStyle.textValue,),
          ) : Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            padding: const EdgeInsets.all(10),
            child: ScrollConfiguration(
              behavior: const ScrollBehavior().copyWith(overscroll: false),
              child: ListView.separated(
                itemCount:
                roleOfUser == 1 ? studentData.length : parentData.length,
                itemBuilder: (context, index) {
                  return Container(
                    width: MediaQuery.of(context).size.width,
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: AppColors.secondary.withOpacity(0.06),
                        width: 2,
                      ),
                      borderRadius: const BorderRadius.all(Radius.circular(5)),
                    ),
                    child: Column(
                      children: [
                        CircleAvatar(
                          radius: 35.0,
                          backgroundImage: NetworkImage(roleOfUser == 1
                              ? studentData[index].stuImage!
                              : parentData[index].parentImage!),
                          backgroundColor: AppColors.primary,
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        Text(
                          roleOfUser == 1
                              ? studentData[index].sFname!
                              : parentData[index].pFname!,
                          style: CustomStyle.appBarTitle.copyWith(
                            color: AppColors.secondary,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                        CustomRow(
                          "email".tr,
                          roleOfUser == 1
                              ? studentData[index].stuEmail!
                              : parentData[index].parentEmail!,),
                        roleOfUser == 1 ? CustomRow(
                            "singalClass".tr,studentData[index].className!) : CustomRow("eTitle".tr, parentData[index].pEdu ?? "-"),
                        roleOfUser == 1 ? CustomRow(
                            "dob".tr,DateFormat("dd-MM-yyyy").format(DateTime.parse(studentData[index].sDob!))): CustomRow("parentpro".tr, parentData[index].pProfession!),
                        Visibility(visible: roleOfUser == 0,child: CustomRow(
                            "mobile".tr,
                            roleOfUser == 0 ? parentData[index].pPhone! : ""
                        ),)
                      ],
                    ),
                  );
                }, separatorBuilder: (BuildContext context, int index) { return const SizedBox(height: 20,); },),
            ),
          ),
          Visibility(visible: roleOfUser == 2,child:Container(width: MediaQuery.of(context).size.width,height: MediaQuery.of(context).size.height,color: Colors.black54,child:  const LoadingLayout(),),)
        ],
      )
    );
  }

  void setData() async {
    SessionManagement sessionManagement = SessionManagement();
    int? userRole = await sessionManagement.getRole("Role");
    if (userRole == 0) {
      Studentlogin studentLoginData =
          await sessionManagement.getModel('Student');
      setState(() {
        roleOfUser = 0;
        parentData = studentLoginData.userdata.parentData!;
        titleOfScreen = "pTitle".tr;
        isLoading = false;
      });
    } else {
      Parentlogin parentLoginData =
          await sessionManagement.getModelParent('Parent');
      setState(() {
        roleOfUser = 1;
        studentData = parentLoginData.userdata.studentData!;
        titleOfScreen = "student".tr;
        isLoading = false;
      });
    }
  }
}

class CustomRow extends StatelessWidget {
  final String label;
  final String value;

  const CustomRow(this.label, this.value, {super.key});

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 10,),
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              label,
              style: CustomStyle.hello
                  .copyWith(color: AppColors.secondary.withOpacity(0.6)),
            ),
            const Spacer(),
            Text(
              value,
              style: CustomStyle.hello.copyWith(color: AppColors.secondary),
            ),
          ],
        ),
        const SizedBox(
          height: 10,
        ),
        CustomStyle.dottedLine,
      ],
    );
  }
}
