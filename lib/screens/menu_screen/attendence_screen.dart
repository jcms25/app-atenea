// ignore_for_file: camel_case_types, prefer_typing_uninitialized_variables, non_constant_identifier_names

import 'package:auto_size_text/auto_size_text.dart';
import 'package:colegia_atenea/models/Parent/Parentlogin.dart';
import 'package:colegia_atenea/models/Student/Studentlogin.dart';
import 'package:colegia_atenea/models/attendencelist.dart';
import 'package:colegia_atenea/services/api_class.dart';
import 'package:colegia_atenea/services/session_management.dart';
import 'package:colegia_atenea/utils/app_colors.dart';
import 'package:colegia_atenea/utils/app_images.dart';
import 'package:colegia_atenea/utils/text_style.dart';
import 'package:colegia_atenea/widgets/custom_loader.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

// ignore: must_be_immutable
class AttendanceScreen extends StatefulWidget {
  final String cid;
  final String wpId;

  const AttendanceScreen(this.cid, this.wpId, {super.key});

  @override
  State<AttendanceScreen> createState() => _AttendanceScreenChild();
}

class _AttendanceScreenChild extends State<AttendanceScreen> {
  String Name = "-";
  String Class = "-";
  String lpNumber = "-";
  String startClass = "-";
  String endClass = "-";
  String absentDay = "-";
  String presentDay = "-";
  String totalAbsentDay = "-";
  String image = "-";
  Attendencelist? list;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    getAttendanceData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            titleSpacing: 0,
            elevation: 0,
            backgroundColor: AppColors.primary,
            title: Text(
              "studatte".tr,
              style: CustomStyle.appBarTitle,
            ),
            leading: Container(
              margin: const EdgeInsets.all(10),
              child: GestureDetector(
                onTap: () {
                  Navigator.pop(context);
                },
                child: SvgPicture.asset(
                  AppImages.arrow,
                  color: AppColors.orange,
                ),
              ),
            )),
        body: Stack(
          children: [
            Visibility(visible: !isLoading,child: Container(
              color: AppColors.primary,
              child: SafeArea(
                child: Stack(
                  children: [
                    Column(
                      children: [
                        Expanded(
                          child: Container(
                            color: AppColors.primary,
                          ),
                        ),
                        Expanded(
                          child: Container(
                            color: AppColors.white,
                          ),
                        )
                      ],
                    ),
                    SingleChildScrollView(
                      physics: const BouncingScrollPhysics(),
                      child: Stack(
                        alignment: Alignment.topCenter,
                        children: [
                          Container(
                            margin: const EdgeInsets.only(top: 100, bottom: 30),
                            decoration: const BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.only(
                                    topRight: Radius.circular(30),
                                    topLeft: Radius.circular(30))),
                            child: Column(
                              //crossAxisAlignment: CrossAxisAlignment.start,
                              // mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.only(top: 100),
                                      margin: const EdgeInsets.only(
                                          left: 20, right: 20, top: 10),
                                      child: Column(
                                        crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                bottom: 70),
                                            child: Column(
                                              crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                              children: [
                                                Container(
                                                    width:
                                                    MediaQuery.of(context)
                                                        .size
                                                        .width,
                                                    margin: const EdgeInsets
                                                        .symmetric(
                                                        horizontal: 80),
                                                    child: Center(
                                                      child: AutoSizeText(
                                                        maxLines: 5,
                                                        Name,
                                                        style:
                                                        CustomStyle.login,
                                                      ),
                                                    )),
                                                Container(
                                                  margin: const EdgeInsets.only(
                                                      top: 20),
                                                  child: Column(
                                                    mainAxisAlignment:
                                                    MainAxisAlignment.start,
                                                    crossAxisAlignment:
                                                    CrossAxisAlignment
                                                        .start,
                                                    children: [
                                                      Row(
                                                        children: [
                                                          Expanded(
                                                              child: Text(
                                                                "class".tr,
                                                                style: CustomStyle
                                                                    .textValue
                                                                    .copyWith(
                                                                    color: AppColors
                                                                        .secondary
                                                                        .withOpacity(
                                                                        0.75)),
                                                              )),
                                                          const SizedBox(
                                                            width: 20,
                                                          ),
                                                          Expanded(
                                                              child: Text(
                                                                "lpn".tr,
                                                                style: CustomStyle
                                                                    .textValue
                                                                    .copyWith(
                                                                    color: AppColors
                                                                        .secondary
                                                                        .withOpacity(
                                                                        0.75)),
                                                              ))
                                                        ],
                                                      ),
                                                      const SizedBox(
                                                        height: 10,
                                                      ),
                                                      Row(
                                                        children: [
                                                          Expanded(
                                                              child: Container(
                                                                  height: 60,
                                                                  decoration: BoxDecoration(
                                                                      borderRadius:
                                                                      BorderRadius.circular(
                                                                          12),
                                                                      color: AppColors
                                                                          .secondary
                                                                          .withOpacity(
                                                                          0.06)),
                                                                  child:
                                                                  Padding(
                                                                    padding:
                                                                    const EdgeInsets.all(
                                                                        15),
                                                                    child: Text(
                                                                      Class,
                                                                      style: CustomStyle
                                                                          .textValue
                                                                          .copyWith(
                                                                          color: AppColors.secondary),
                                                                      textAlign:
                                                                      TextAlign
                                                                          .left,
                                                                    ),
                                                                  ))),
                                                          const SizedBox(
                                                            width: 20,
                                                          ),
                                                          Expanded(
                                                              child: Container(
                                                                  height: 60,
                                                                  decoration: BoxDecoration(
                                                                      borderRadius:
                                                                      BorderRadius.circular(
                                                                          12),
                                                                      color: AppColors
                                                                          .secondary
                                                                          .withOpacity(
                                                                          0.06)),
                                                                  child:
                                                                  Padding(
                                                                    padding:
                                                                    const EdgeInsets.all(
                                                                        15),
                                                                    child: Text(
                                                                      lpNumber,
                                                                      style: CustomStyle
                                                                          .textValue
                                                                          .copyWith(
                                                                          color: AppColors.secondary),
                                                                      textAlign:
                                                                      TextAlign
                                                                          .left,
                                                                    ),
                                                                  ))),
                                                        ],
                                                      ),
                                                      const SizedBox(
                                                        height: 25,
                                                      ),
                                                      Row(
                                                        children: [
                                                          Expanded(
                                                              child: Text(
                                                                "cs".tr,
                                                                style: CustomStyle
                                                                    .textValue
                                                                    .copyWith(
                                                                    color: AppColors
                                                                        .secondary
                                                                        .withOpacity(
                                                                        0.75)),
                                                              )),
                                                          const SizedBox(
                                                            width: 20,
                                                          ),
                                                          Expanded(
                                                              child: Text(
                                                                "ce".tr,
                                                                style: CustomStyle
                                                                    .textValue
                                                                    .copyWith(
                                                                    color: AppColors
                                                                        .secondary
                                                                        .withOpacity(
                                                                        0.75)),
                                                              ))
                                                        ],
                                                      ),
                                                      const SizedBox(
                                                        height: 10,
                                                      ),
                                                      Row(
                                                        children: [
                                                          Expanded(
                                                              child: Container(
                                                                  height: 60,
                                                                  decoration: BoxDecoration(
                                                                      borderRadius:
                                                                      BorderRadius.circular(
                                                                          12),
                                                                      color: AppColors
                                                                          .secondary
                                                                          .withOpacity(
                                                                          0.06)),
                                                                  child:
                                                                  Padding(
                                                                    padding:
                                                                    const EdgeInsets.all(
                                                                        15),
                                                                    child: Text(
                                                                      startClass,
                                                                      style: CustomStyle
                                                                          .textValue
                                                                          .copyWith(
                                                                          color: AppColors.secondary),
                                                                      textAlign:
                                                                      TextAlign
                                                                          .left,
                                                                    ),
                                                                  ))),
                                                          const SizedBox(
                                                            width: 20,
                                                          ),
                                                          Expanded(
                                                              child: Container(
                                                                  height: 60,
                                                                  decoration: BoxDecoration(
                                                                      borderRadius:
                                                                      BorderRadius.circular(
                                                                          12),
                                                                      color: AppColors
                                                                          .secondary
                                                                          .withOpacity(
                                                                          0.06)),
                                                                  child:
                                                                  Padding(
                                                                    padding:
                                                                    const EdgeInsets.all(
                                                                        15),
                                                                    child: Text(
                                                                      endClass,
                                                                      style: CustomStyle
                                                                          .textValue
                                                                          .copyWith(
                                                                          color: AppColors.secondary),
                                                                      textAlign:
                                                                      TextAlign
                                                                          .left,
                                                                    ),
                                                                  ))),
                                                        ],
                                                      ),
                                                      const SizedBox(
                                                        height: 25,
                                                      ),
                                                      Row(
                                                        children: [
                                                          Expanded(
                                                              child: Text(
                                                                "noad".tr,
                                                                style: CustomStyle
                                                                    .textValue
                                                                    .copyWith(
                                                                    color: AppColors
                                                                        .secondary
                                                                        .withOpacity(
                                                                        0.75)),
                                                              )),
                                                          const SizedBox(
                                                            width: 20,
                                                          ),
                                                          Expanded(
                                                              child: Text(
                                                                "nopd".tr,
                                                                style: CustomStyle
                                                                    .textValue
                                                                    .copyWith(
                                                                    color: AppColors
                                                                        .secondary
                                                                        .withOpacity(
                                                                        0.75)),
                                                              ))
                                                        ],
                                                      ),
                                                      const SizedBox(
                                                        height: 10,
                                                      ),
                                                      Row(
                                                        children: [
                                                          Expanded(
                                                              child: Container(
                                                                  height: 60,
                                                                  decoration: BoxDecoration(
                                                                      borderRadius:
                                                                      BorderRadius.circular(
                                                                          12),
                                                                      color: AppColors
                                                                          .secondary
                                                                          .withOpacity(
                                                                          0.06)),
                                                                  child:
                                                                  Padding(
                                                                    padding:
                                                                    const EdgeInsets.all(
                                                                        15),
                                                                    child: Text(
                                                                      absentDay,
                                                                      style: CustomStyle
                                                                          .textValue
                                                                          .copyWith(
                                                                          color: AppColors.secondary),
                                                                      textAlign:
                                                                      TextAlign
                                                                          .left,
                                                                    ),
                                                                  ))),
                                                          const SizedBox(
                                                            width: 20,
                                                          ),
                                                          Expanded(
                                                              child: Container(
                                                                  height: 60,
                                                                  decoration: BoxDecoration(
                                                                      borderRadius:
                                                                      BorderRadius.circular(
                                                                          12),
                                                                      color: AppColors
                                                                          .secondary
                                                                          .withOpacity(
                                                                          0.06)),
                                                                  child:
                                                                  Padding(
                                                                    padding:
                                                                    const EdgeInsets.all(
                                                                        15),
                                                                    child: Text(
                                                                      presentDay,
                                                                      style: CustomStyle
                                                                          .textValue
                                                                          .copyWith(
                                                                          color: AppColors.secondary),
                                                                      textAlign:
                                                                      TextAlign
                                                                          .left,
                                                                    ),
                                                                  ))),
                                                        ],
                                                      ),
                                                      const SizedBox(
                                                        height: 25,
                                                      ),
                                                      Text(
                                                        "noattday".tr,
                                                        style: CustomStyle
                                                            .textValue
                                                            .copyWith(
                                                            color: AppColors
                                                                .secondary
                                                                .withOpacity(
                                                                0.75)),
                                                      ),
                                                      const SizedBox(
                                                        height: 10,
                                                      ),
                                                      Container(
                                                          height: 60,
                                                          width:
                                                          double.infinity,
                                                          decoration: BoxDecoration(
                                                              borderRadius:
                                                              BorderRadius
                                                                  .circular(
                                                                  12),
                                                              color: AppColors
                                                                  .secondary
                                                                  .withOpacity(
                                                                  0.06)),
                                                          child: Padding(
                                                            padding:
                                                            const EdgeInsets
                                                                .all(15),
                                                            child: Text(
                                                              totalAbsentDay,
                                                              style: CustomStyle
                                                                  .textValue
                                                                  .copyWith(
                                                                  color: AppColors
                                                                      .secondary),
                                                              textAlign:
                                                              TextAlign
                                                                  .left,
                                                            ),
                                                          ))
                                                    ],
                                                  ),
                                                )
                                              ],
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          Container(
                            margin: const EdgeInsets.only(top: 20),
                            height: 180,
                            width: 180,
                            decoration: BoxDecoration(
                              color: AppColors.white,
                              border: Border.all(
                                  color: AppColors.primary,
                                  width: 3.0,
                                  style: BorderStyle.solid),
                              borderRadius:
                              const BorderRadius.all(Radius.circular(160)),
                              boxShadow: [
                                BoxShadow(
                                  color: AppColors.primary.withOpacity(0.5),
                                  spreadRadius: 0,
                                  blurRadius: 25,
                                  offset: const Offset(
                                      0, 0), // changes position of shadow
                                ),
                              ],
                            ),
                            child: CircleAvatar(
                              radius: 16.0,
                              backgroundColor: AppColors.primary,
                              backgroundImage: NetworkImage(image),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            ),
            Visibility(
                visible: isLoading,
                child: Container(
                  color: Colors.black.withOpacity(0.1),
                  height: MediaQuery.of(context).size.height,
                  width: MediaQuery.of(context).size.width,
                  child: const Center(
                    child: LoadingLayout(),
                  ),
                ))
          ],
        ));
  }

  void getAttendanceData() async {
    ApiClass httpService = ApiClass();
    SessionManagement sessionManagment = SessionManagement();
    int? Role = await sessionManagment.getRole("Role");
    if (Role == 0) {
      Studentlogin login = await sessionManagment.getModel('Student');
      String token = login.basicAuthToken;
      dynamic country =
          await httpService.getAttendance(token, widget.wpId, widget.cid);
      if (country['status']) {
        Attendencelist attendance = Attendencelist.fromJson(country);
        setState(() {
          list = attendance;
          Name = list!.data.fullName;
          Class = list!.data.className;
          lpNumber = list!.data.rollNo;
          startClass = list!.data.classStart;
          endClass = list!.data.classEnd;
          absentDay = list!.data.absentDays;
          presentDay = list!.data.presentDay;
          totalAbsentDay = list!.data.workingDays;
          image = list!.data.image;
          isLoading = false;
        });
      } else {
        setState(() {
          isLoading = false;
        });
      }
    } else {
      Parentlogin parent = await sessionManagment.getModelParent('Parent');
      String ptoken = parent.basicAuthToken;
      dynamic country =
          await httpService.getAttendance(ptoken, widget.wpId, widget.cid);
      if (country['status']) {
        Attendencelist attendance = Attendencelist.fromJson(country);
        setState(() {
          list = attendance;
          Name = list!.data.fullName;
          Class = list!.data.className;
          lpNumber = list!.data.rollNo;
          startClass = list!.data.classStart;
          endClass = list!.data.classEnd;
          absentDay = list!.data.absentDays;
          presentDay = list!.data.presentDay;
          totalAbsentDay = list!.data.workingDays;
          image = list!.data.image;
          isLoading = false;
        });
      } else {
        setState(() {
          isLoading = false;
        });
      }
    }
  }
}
