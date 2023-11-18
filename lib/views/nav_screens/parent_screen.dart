import 'package:colegia_atenea/models/Parent/Parentlogin.dart';
import 'package:colegia_atenea/models/Student/Studentlogin.dart';
import 'package:colegia_atenea/services/session_management.dart';
import 'package:colegia_atenea/utils/app_colors.dart';
import 'package:colegia_atenea/utils/app_images.dart';
import 'package:colegia_atenea/utils/text_style.dart';
import 'package:colegia_atenea/widgets/custom_loader.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

class ParentScreen extends StatefulWidget {
  const ParentScreen({super.key});

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _ParentScreenChild();
  }

}

class _ParentScreenChild extends State<ParentScreen> {
  List<ParentDatum> list = [];
  List<StudentDatum> listOfStudent = [];
  var role = 2;

  bool isLoading = true;
  String title = "";

  @override
  void initState() {
    super.initState();
    isLoading = true;
    setdata();
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
          title: Text(title, style: CustomStyle.appBarTitle),
          actions: <Widget>[
            Padding(
              padding: const EdgeInsets.only(right: 20.0),
              child: GestureDetector(
                onTap: () {},
                child: SvgPicture.asset(
                  AppImages.bell,
                  height: 26,
                  width: 26,
                ),
              ),
            ),
          ],
        ),
        body: Stack(
          children: [
            Container(
                padding: const EdgeInsets.only(left: 15, right: 15, top: 15),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                        flex: 9,
                        child: ListView.builder(
                            physics: const BouncingScrollPhysics(),
                            itemCount: role == 2
                                ? 5
                                : role == 1
                                    ? listOfStudent.length
                                    : list.length,
                            itemBuilder: (context, position) {

                              return Container(
                                margin: const EdgeInsets.only(top: 20),
                                padding:
                                    const EdgeInsets.only(bottom: 20, top: 10),
                                decoration: BoxDecoration(
                                  border: Border.all(
                                    color:
                                        AppColors.secondary.withOpacity(0.06),
                                    width: 2,
                                  ),
                                  borderRadius: const BorderRadius.all(
                                      Radius.circular(5)),
                                ),

                                //height: 280,
                                width: double.infinity,
                                child: Column(
                                  children: [
                                    CircleAvatar(
                                      radius: 35.0,
                                      backgroundImage: NetworkImage(
                                          role == 2
                                              ? "http://colegioatenea.embedinfosoft.com/wp-content/plugins/scl-rest-api/img/default_avtar.jpg"
                                              : role == 1
                                              ? listOfStudent[position]
                                              .stuImage!
                                              : list[position]
                                              .parentImage!
                                      ),
                                      backgroundColor: AppColors.primary,
                                    ),
                                    const SizedBox(
                                      height: 20,
                                    ),
                                    Text(
                                      role == 2
                                          ? "Name"
                                          : role == 1
                                              ? (listOfStudent[position].sFname)!
                                              : list[position].pFname!,
                                      style: CustomStyle.appBarTitle.copyWith(
                                        color: AppColors.secondary,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                    const SizedBox(
                                      height: 15,
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(
                                          left: 15, right: 15),
                                      child: Column(
                                        children: [
                                          const SizedBox(
                                            height: 15,
                                          ),
                                          Row(
                                            children: [
                                              Expanded(
                                                child: Text(
                                                  "email".tr,
                                                  style: CustomStyle.hello
                                                      .copyWith(
                                                          color: AppColors
                                                              .secondary
                                                              .withOpacity(
                                                                  0.6)),
                                                ),
                                              ),
                                              Text(
                                                role == 2
                                                    ? "Name"
                                                    : role == 1
                                                        ? (listOfStudent[
                                                                position]
                                                            .stuEmail)!
                                                        : list[position]
                                                            .parentEmail!,
                                                style: CustomStyle.hello
                                                    .copyWith(
                                                        color: AppColors
                                                            .secondary),
                                              )
                                            ],
                                          ),
                                          const SizedBox(
                                            height: 10,
                                          ),
                                          CustomStyle.dottedLine,
                                          const SizedBox(
                                            height: 15,
                                          ),
                                          Row(
                                            children: [
                                              Expanded(
                                                child: Text(
                                                  role == 1
                                                      ? "singalClass".tr
                                                      : "education".tr,
                                                  style: CustomStyle.hello
                                                      .copyWith(
                                                          color: AppColors
                                                              .secondary
                                                              .withOpacity(
                                                                  0.6)),
                                                ),
                                              ),
                                              Text(
                                                role == 2
                                                    ? "Name"
                                                    : role == 1
                                                        ? (listOfStudent[
                                                                position]
                                                            .className)!
                                                        : list[position].pEdu!,
                                                style: CustomStyle.hello
                                                    .copyWith(
                                                        color: AppColors
                                                            .secondary),
                                              )
                                            ],
                                          ),
                                          const SizedBox(
                                            height: 10,
                                          ),
                                          CustomStyle.dottedLine,
                                          const SizedBox(
                                            height: 15,
                                          ),
                                          Row(
                                            children: [
                                              Expanded(
                                                child: Text(
                                                  role == 1
                                                      ? "dob".tr
                                                      : "profession".tr,
                                                  style: CustomStyle.hello
                                                      .copyWith(
                                                          color: AppColors
                                                              .secondary
                                                              .withOpacity(
                                                                  0.6)),
                                                ),
                                              ),
                                              Text(
                                                role == 2
                                                    ? "-"
                                                    : role == 1
                                                        ? listOfStudent[position].sDob!
                                                        : list[position]
                                                            .pProfession!,
                                                style: CustomStyle.hello
                                                    .copyWith(
                                                        color: AppColors
                                                            .secondary),
                                              )
                                            ],
                                          ),
                                          const SizedBox(
                                            height: 10,
                                          ),
                                          CustomStyle.dottedLine,
                                          const SizedBox(
                                            height: 15,
                                          ),
                                          Row(
                                            children: [
                                              Expanded(
                                                child: Text(
                                                  role == 1 ? "" : "mobile".tr,
                                                  style: CustomStyle.hello
                                                      .copyWith(
                                                          color: AppColors
                                                              .secondary
                                                              .withOpacity(
                                                                  0.6)),
                                                ),
                                              ),
                                              Text(
                                                role == 2
                                                    ? "Name"
                                                    : role == 1
                                                        ? ""
                                                        : list[position].pPhone!,
                                                style: CustomStyle.hello
                                                    .copyWith(
                                                        color: AppColors
                                                            .secondary),
                                              )
                                            ],
                                          ),
                                          const SizedBox(
                                            height: 10,
                                          ),
                                          CustomStyle.dottedLine,
                                        ],
                                      ),
                                    )
                                  ],
                                ),
                              );
                            }))
                  ],
                )),
            Visibility(
                visible: isLoading,
                child: Container(
                  color: Colors.black.withOpacity(0.5),
                  height: MediaQuery.of(context).size.height,
                  width: MediaQuery.of(context).size.width,
                  child: const Center(
                    child: LoadingLayout(),
                  ),
                ))
          ],
        ));
  }

  void setdata() async {
    SessionManagement sessionManagment = SessionManagement();
    int? Role = await sessionManagment.getRole("Role");
    if (Role == 0) {
      Studentlogin login = await sessionManagment.getModel('Student');
      setState(() {
        role = 0;
        list = login.userdata.parentData!;
        title = "parents".tr;
        isLoading = false;
      });
    } else {
      Parentlogin Parent = await sessionManagment.getModelParent('Parent');
      setState(() {
        role = 1;
        listOfStudent = Parent.userdata.studentData!;
        title = "student".tr;
        isLoading = false;
      });
    }
  }
}
