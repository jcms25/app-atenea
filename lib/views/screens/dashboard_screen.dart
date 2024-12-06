import 'dart:async';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:colegia_atenea/controllers/student_parent_teacher_controller.dart';
import 'package:colegia_atenea/models/Failed.dart';
import 'package:colegia_atenea/models/dashboard_model.dart';
import 'package:colegia_atenea/models/login_model.dart';
import 'package:colegia_atenea/services/app_shared_preferences.dart';
import 'package:colegia_atenea/utils/app_colors.dart';
import 'package:colegia_atenea/utils/app_images.dart';
import 'package:colegia_atenea/utils/app_textstyle.dart';
import 'package:colegia_atenea/utils/text_style.dart';
import 'package:colegia_atenea/views/screens/class_menu_screens/test_screen.dart';
import 'package:colegia_atenea/views/custom_widgets/custom_loader.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:table_calendar/table_calendar.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  final DateTime _selectedDay = DateTime.now();
  final DateTime _focusedDay = DateTime.now();
  Map<DateTime, dynamic> selectedEvents = {};
  String selectDay = "";
  int listToShow = 0;
  String classname = "";
  String examName = "";
  String date = "";
  String classname1 = "";
  String examName1 = "";
  String date1 = "";

  StudentParentTeacherController? studentParentTeacherController;

  @override
  void initState() {
    super.initState();
    // for setting local language to calendar
    initializeDateFormatting(Get.locale!.countryCode, null);

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      studentParentTeacherController =
          Provider.of<StudentParentTeacherController>(context, listen: false);
      // if (studentParentTeacherController?.dashboard == null) {
      //   studentParentTeacherController?.getDashboardData(showLoader: true);
      // } else {
      //   studentParentTeacherController?.getDashboardData(showLoader: false);
      // }
      studentParentTeacherController?.getDashboardData(showLoader: false);

    });

    // setUserInfo();
    // getDashBoardData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            color: AppColors.primary,
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
                  child: Container(
                    color: AppColors.white,
                    child: Column(
                      children: [
                        Consumer<StudentParentTeacherController>(
                          builder:
                              (context, studentParentTeacherController, child) {
                            Userdata? userdata = studentParentTeacherController
                                .loginModel?.userdata;
                            String? userRole =  AppSharedPreferences.getUserLoggedInRole();
                            String? profileImage = userRole == "student"
                                ? userdata?.stuImage
                                : userRole == "parent"
                                    ? userdata?.parentImage
                                    : userdata?.teacherImage;
                            String fName = userRole == "student"
                                ? userdata?.sFname ?? ""
                                : userRole == "parent"
                                    ? userdata?.pFname ?? ""
                                    : userdata?.firstName ?? "";

                            return Container(
                                height: 100,
                                width: MediaQuery.of(context).size.width,
                                padding: const EdgeInsets.all(20),
                                decoration: const BoxDecoration(
                                    borderRadius: BorderRadius.only(
                                        bottomLeft: Radius.circular(20),
                                        bottomRight: Radius.circular(20)),
                                    color: AppColors.primary),
                                child: Row(
                                  children: [
                                    SizedBox(
                                      height: 65,
                                      width: 65,
                                      child: CircleAvatar(
                                        radius: 16.0,
                                        child: ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(65.0),
                                          child: profileImage == null ||
                                                  profileImage.isEmpty
                                              ? Image.asset(
                                                  AppImages.person,
                                                  fit: BoxFit.cover,
                                                  height: 65,
                                                  width: 65,
                                                )
                                              : Image.network(
                                                  profileImage,
                                                  fit: BoxFit.cover,
                                                  height: 65,
                                                  width: 65,
                                                ),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(
                                      width: 10,
                                    ),
                                    Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          "hello".tr,
                                          style: AppTextStyle.getOutfit300(
                                              textSize: 16,
                                              textColor: AppColors.white),
                                        ),
                                        Text(
                                          fName,
                                          style: AppTextStyle.getOutfit600(
                                              textSize: 20,
                                              textColor: AppColors.white),
                                        )
                                      ],
                                    ),
                                  ],
                                ));
                          },
                        ),
                        Container(
                            margin: const EdgeInsets.symmetric(horizontal: 20),
                            padding: const EdgeInsets.all(15),
                            height: 100,
                            decoration: BoxDecoration(
                                borderRadius: const BorderRadius.only(
                                    bottomRight: Radius.circular(15),
                                    bottomLeft: Radius.circular(15)),
                                color: AppColors.dashBack.withOpacity(0.06)),
                            child: Center(
                              child: Text("live".tr,
                                  style: AppTextStyle.getOutfit400(
                                      textSize: 18,
                                      textColor: AppColors.secondary)),
                            )),
                        const SizedBox(
                          height: 10,
                        ),
                        Consumer<StudentParentTeacherController>(
                          builder:
                              (context, studentParentTeacherController, child) {
                            return Row(
                              children: [
                                const SizedBox(
                                  width: 15,
                                ),
                                Expanded(
                                    child: DashboardWidget1(
                                        label: 'student'.tr,
                                        value: studentParentTeacherController
                                                .dashboard
                                                ?.count
                                                .studentCount ??
                                            "0",
                                        iconBackgroundColor: AppColors.blue,
                                        backgroundColor: AppColors.blueLight,
                                        icon: AppImages.cardImg)),
                                const SizedBox(
                                  width: 10,
                                ),
                                Expanded(
                                    child: DashboardWidget1(
                                        label: "parents".tr,
                                        value: studentParentTeacherController
                                                .dashboard?.count.parentCount ??
                                            "0",
                                        iconBackgroundColor: AppColors.green,
                                        backgroundColor: AppColors.greenLight,
                                        icon: AppImages.cardImg2)),
                                const SizedBox(
                                  width: 15,
                                ),
                              ],
                            );
                          },
                        ),
                        Container(
                          margin: const EdgeInsets.only(
                              top: 15, right: 15, left: 15),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "activitiescalender".tr,
                                style: AppTextStyle.getOutfit600(
                                    textSize: 20,
                                    textColor: AppColors.secondary),
                              ),
                              const SizedBox(
                                height: 15,
                              ),
                              Row(
                                children: [
                                  DashboardWidget2(
                                      label: "events".tr,
                                      color: AppColors.darkPurple,
                                      id: 1),
                                  const SizedBox(
                                    width: 5,
                                  ),
                                  DashboardWidget2(
                                      label:  "exam".tr,
                                      color: AppColors.red,
                                      id: 2),
                                  const SizedBox(
                                    width: 5,
                                  ),
                                  DashboardWidget2(
                                      label: "holiday".tr,
                                      color: AppColors.green,
                                      id: 3),
                                ],
                              ),
                              const SizedBox(height: 15,),
                              Consumer<StudentParentTeacherController>(
                                builder: (context,studentParentTeacherController,child){
                                  return Container(
                                    decoration: const BoxDecoration(
                                        color: AppColors.orange,
                                        borderRadius:
                                        BorderRadius.all(Radius.circular(15))),
                                    child: TableCalendar(
                                      firstDay: DateTime(1990),
                                      focusedDay: _focusedDay,
                                      lastDay: DateTime(2050),
                                      calendarFormat: CalendarFormat.month,
                                      onFormatChanged: null,
                                      locale: Get.locale!.languageCode,
                                      startingDayOfWeek: StartingDayOfWeek.monday,
                                      daysOfWeekVisible: true,
                                      currentDay: DateTime.now(),
                                      //day changed
                                      onDaySelected:
                                          (DateTime selectDay, DateTime focusDay) {
                                        studentParentTeacherController.setSelectedDay(selectedDay: selectDay);
                                        studentParentTeacherController.setFocusDay(focusDay: focusDay);

                                        DateFormat dateFormat =
                                        DateFormat("yyyy-MM-dd");
                                        showModalBottomSheet(
                                            isDismissible: true,
                                            isScrollControlled: false,
                                            enableDrag: false,
                                            shape: const RoundedRectangleBorder(
                                                borderRadius: BorderRadius.vertical(
                                                    top: Radius.circular(20))),
                                            builder: (BuildContext context) {
                                              // dynamic events = selectedEvents[
                                              //                 DateTime.parse(
                                              //                     dateFormat.format(
                                              //                         selectDay))]
                                              //             .runtimeType ==
                                              //         EventItemDetail
                                              //     ? [
                                              //         selectedEvents[DateTime.parse(
                                              //             dateFormat
                                              //                 .format(selectDay))]
                                              //       ]
                                              //     : selectedEvents[DateTime.parse(
                                              //         dateFormat
                                              //             .format(selectDay))];
                                              return Container();
                                              // return _bottomSheet(events);
                                            },
                                            context: context);
                                      },
                                      selectedDayPredicate: (DateTime date) {
                                        return isSameDay(_selectedDay, date);
                                      },

                                      // eventLoader: _getEventsForDay,
                                      headerStyle: HeaderStyle(
                                        formatButtonVisible: false,
                                        //false : invisible format button
                                        titleCentered: true,
                                        //Centered month and year
                                        titleTextStyle: AppTextStyle.getOutfit500(textSize: 16, textColor: AppColors.black),
                                        // titleTextStyle: TextStyle(
                                        //     fontSize: 16,
                                        //     fontFamily: "OutfitMedium",
                                        //     fontWeight: FontWeight.w500),
                                        leftChevronVisible: true,
                                        //showing left arrow
                                        rightChevronVisible: true,
                                        //showing right arrow
                                        headerPadding: const EdgeInsets.symmetric(
                                            horizontal: 5, vertical: 20),
                                      ),
                                      calendarStyle: CalendarStyle(
                                          selectedDecoration: const BoxDecoration(
                                              shape: BoxShape.circle,
                                              // borderRadius: BorderRadius.all(
                                              //     Radius.circular(10)),
                                              color: AppColors.primary),
                                          selectedTextStyle: AppTextStyle.getOutfit500(textSize: 16, textColor: AppColors.white),
                                          todayDecoration: const BoxDecoration(
                                              shape: BoxShape.circle,
                                              // borderRadius: BorderRadius.all(
                                              //     Radius.circular(10)),
                                              color: AppColors.primary),
                                          todayTextStyle: const TextStyle(
                                              color: AppColors.white),
                                          markerDecoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                            color: listToShow == 0
                                                ? AppColors.darkPurple
                                                : listToShow == 1
                                                ? AppColors.red
                                                : AppColors.green,
                                            // borderRadius: BorderRadius.circular(
                                            //     8.0)
                                          )),

                                      onDayLongPressed:
                                          (DateTime selectDay, DateTime focusDay) {
                                        DateFormat dateFormat =
                                        DateFormat("yyyy-MM-dd");
                                        showModalBottomSheet(
                                            isDismissible: true,
                                            isScrollControlled: false,
                                            enableDrag: false,
                                            shape: const RoundedRectangleBorder(
                                                borderRadius: BorderRadius.vertical(
                                                    top: Radius.circular(20))),
                                            builder: (BuildContext context) {
                                              // dynamic events = [];
                                              // dynamic events = selectedEvents[
                                              //                 DateTime.parse(
                                              //                     dateFormat.format(
                                              //                         selectDay))]
                                              //             .runtimeType ==
                                              //         EventItemDetail
                                              //     ? [
                                              //         selectedEvents[DateTime.parse(
                                              //             dateFormat
                                              //                 .format(selectDay))]
                                              //       ]
                                              //     : selectedEvents[DateTime.parse(
                                              //         dateFormat
                                              //             .format(selectDay))];
                                              // return _bottomSheet(events);
                                              return Container();
                                            },
                                            context: context);
                                      },
                                    ),
                                  );
                                },
                              ),
                              Container(
                                margin:
                                    const EdgeInsets.only(top: 20, bottom: 10),
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: Text(
                                        "exam".tr,
                                        style: CustomStyle.calendarTextStyle,
                                      ),
                                    ),
                                    GestureDetector(
                                      onTap: () {
                                        // if (userDatas != null) {
                                        //   goToExamScreen(userDatas!.classId!,
                                        //       userDatas!.wpUsrId!);
                                        // } else if (studentData != null) {
                                        //   showBottomSheet(
                                        //       context: context,
                                        //       backgroundColor: AppColors
                                        //           .primary,
                                        //       shape:
                                        //       const RoundedRectangleBorder(
                                        //           borderRadius:
                                        //           BorderRadius.only(
                                        //               topLeft: Radius
                                        //                   .circular(
                                        //                   20),
                                        //               topRight: Radius
                                        //                   .circular(
                                        //                   20))),
                                        //       builder: (context) {
                                        //         return SizedBox(
                                        //           width:
                                        //           MediaQuery.of(context)
                                        //               .size
                                        //               .width,
                                        //           height: 200,
                                        //           child: ScrollConfiguration(
                                        //             behavior:
                                        //             const ScrollBehavior()
                                        //                 .copyWith(
                                        //                 overscroll:
                                        //                 false),
                                        //             child:
                                        //             SingleChildScrollView(
                                        //               child: Column(
                                        //                 crossAxisAlignment:
                                        //                 CrossAxisAlignment
                                        //                     .start,
                                        //                 children: [
                                        //                   const SizedBox(height: 10,),
                                        //                   Padding(
                                        //                       padding:
                                        //                       const EdgeInsets
                                        //                           .only(
                                        //                           left:
                                        //                           20),
                                        //                       child: Row(
                                        //                         mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        //                         children: [
                                        //                           Text(
                                        //                             "exam".tr,
                                        //                             style: const TextStyle(
                                        //                                 fontSize:
                                        //                                 24,
                                        //                                 fontFamily:
                                        //                                 "OutfitMedium",
                                        //                                 fontWeight:
                                        //                                 FontWeight
                                        //                                     .w500,
                                        //                                 color: AppColors
                                        //                                     .white),
                                        //                           ),
                                        //                           IconButton(onPressed: (){
                                        //                             Navigator.pop(context);
                                        //                           }, icon: const Icon(Icons.close,color: AppColors.white,))
                                        //                         ],
                                        //                       )),
                                        //                   ...studentData!
                                        //                       .map((e) {
                                        //                     return GestureDetector(
                                        //                         onTap: () {
                                        //                           Navigator.pop(
                                        //                               context);
                                        //                           goToExamScreen(
                                        //                               e.classId!,
                                        //                               e.wpUsrId!);
                                        //                         },
                                        //                         child:
                                        //                         Container(
                                        //                           height: 60,
                                        //                           decoration: BoxDecoration(
                                        //                               color: AppColors
                                        //                                   .white,
                                        //                               borderRadius:
                                        //                               BorderRadius.circular(10)),
                                        //                           margin:
                                        //                           const EdgeInsets.all(
                                        //                               10),
                                        //                           padding: const EdgeInsets
                                        //                               .only(
                                        //                               left:
                                        //                               20),
                                        //                           width: MediaQuery.of(
                                        //                               context)
                                        //                               .size
                                        //                               .width,
                                        //                           child:
                                        //                           Column(
                                        //                             crossAxisAlignment:
                                        //                             CrossAxisAlignment
                                        //                                 .start,
                                        //                             mainAxisAlignment:
                                        //                             MainAxisAlignment
                                        //                                 .center,
                                        //                             children: [
                                        //                               Text(
                                        //                                 "${e.sFname}\t${e.sLname}",
                                        //                                 style: const TextStyle(
                                        //                                     fontSize: 16,
                                        //                                     fontFamily: "OutfitMedium",
                                        //                                     fontWeight: FontWeight.w500,
                                        //                                     color: AppColors.primary),
                                        //                               ),
                                        //                               Text(
                                        //                                 "${e.className}",
                                        //                                 style: const TextStyle(
                                        //                                     fontSize: 16,
                                        //                                     fontFamily: "OutfitMedium",
                                        //                                     fontWeight: FontWeight.w500,
                                        //                                     color: AppColors.primary),
                                        //                               ),
                                        //                             ],
                                        //                           ),
                                        //                         ));
                                        //                   }).toList()
                                        //                 ],
                                        //               ),
                                        //             ),
                                        //           ),
                                        //         );
                                        //       });
                                        // } else {
                                        //   setUserInfo();
                                        //   Fluttertoast.showToast(
                                        //       msg: "tryAgain".tr);
                                        // }
                                      },
                                      child: Row(
                                        children: [
                                          Text("viewall".tr,
                                              style: CustomStyle.hello.copyWith(
                                                  color: AppColors.primary)),
                                          const SizedBox(width: 2),
                                          SvgPicture.asset(AppImages.loginArrow,
                                              colorFilter:
                                                  const ColorFilter.mode(
                                                      AppColors.primary,
                                                      BlendMode.srcIn)),
                                        ],
                                      ),
                                    )
                                  ],
                                ),
                              ),
                              Consumer<StudentParentTeacherController>(
                                builder: (context,studentParentTeacherController,child){
                                  List<ExamItem> examList = studentParentTeacherController.dashboard?.examList ?? [];
                                  return examList.isEmpty
                                      ? Center(
                                    child: Text("No hay calendario de exámenes.",
                                        style: AppTextStyle.getOutfit400(textSize: 16, textColor: AppColors.secondary),
                                    ),
                                  )
                                      : ScrollConfiguration(
                                      behavior: const ScrollBehavior()
                                          .copyWith(overscroll: false),
                                      child: ListView.builder(
                                          itemCount:
                                          examList.length < 2
                                              ? 1
                                              : 2,
                                          shrinkWrap: true,
                                          itemBuilder: (context, index) {
                                            return Container(
                                                margin: const EdgeInsets.only(
                                                    top: 10),
                                                decoration: BoxDecoration(
                                                    color: AppColors.primary
                                                        .withOpacity(0.05),
                                                    borderRadius:
                                                    BorderRadius.circular(
                                                        20)),
                                                child: Column(children: [
                                                  Container(
                                                    width:
                                                    MediaQuery.of(context)
                                                        .size
                                                        .width,
                                                    height: 50,
                                                    padding:
                                                    const EdgeInsets.all(
                                                        10),
                                                    decoration:
                                                    const BoxDecoration(
                                                      color: AppColors.primary,
                                                      borderRadius:
                                                      BorderRadius.only(
                                                          topLeft: Radius
                                                              .circular(20),
                                                          topRight: Radius
                                                              .circular(
                                                              20)),
                                                    ),
                                                    child: Text(
                                                      textAlign:
                                                      TextAlign.start,
                                                      examList[
                                                      index]
                                                          .className,
                                                      style: CustomStyle
                                                          .calendarTextStyle
                                                          .copyWith(
                                                          color: AppColors
                                                              .white,
                                                          fontWeight:
                                                          FontWeight
                                                              .w500),
                                                    ),
                                                  ),
                                                  Align(
                                                    alignment:
                                                    Alignment.centerLeft,
                                                    child: Padding(
                                                        padding:
                                                        const EdgeInsets
                                                            .all(15),
                                                        child: Column(
                                                          crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                          children: [
                                                            AutoSizeText(
                                                              examList[
                                                              index]
                                                                  .name,
                                                              maxLines: 3,
                                                              style: CustomStyle.hello.copyWith(
                                                                  color: AppColors
                                                                      .secondary,
                                                                  fontWeight:
                                                                  FontWeight
                                                                      .w600,
                                                                  fontSize: 18),
                                                            ),
                                                            Padding(
                                                                padding:
                                                                const EdgeInsets
                                                                    .only(
                                                                    top:
                                                                    10),
                                                                child: Text(
                                                                    examList[
                                                                    index]
                                                                        .date,
                                                                    style: CustomStyle
                                                                        .hello
                                                                        .copyWith(
                                                                        color:
                                                                        AppColors.secondary)))
                                                          ],
                                                        )),
                                                  )
                                                ]));
                                          }));
                                },
                              )
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          Consumer<StudentParentTeacherController>(
              builder: (context, studentParentTeacherController, child) {
            return Visibility(
                visible: studentParentTeacherController.isLoading,
                child: const LoadingLayout());
          }),
        ],
      ),
    );
  }

  void getDashBoardData() async {
    // ApiClass httpService = ApiClass();
    // SessionManagement sessionManagement = SessionManagement();
    // int? role = await sessionManagement.getRole("Role");
    // if (role == 0) {
    //   // Studentlogin studentModel = await sessionManagement.getModel('Student');
    //   // String token = studentModel.basicAuthToken;
    //   dynamic dashBoardData = await httpService.getDashboard(token: token, cookieExample: studentModel.userdata.cookie ?? "", );
    //   if (dashBoardData["status"]) {
    //     Dashboard data = Dashboard.fromJson(dashBoardData);
    //     setState(() {
    //       // //token will be set
    //       // _basicAuthenticationtoken = token;
    //       //
    //       // //set role of use
    //       // _role = 0;
    //
    //       //set Events List
    //       examList = data.eventList.exams;
    //       eventList = data.eventList.events;
    //       holidayList = data.eventList.holiday;
    //
    //       //data from dashboard api will be set below
    //       examListFromDashboard = data.examlist;
    //       parentCount = data.count.parentCount;
    //       studentCount = data.count.studentCount;
    //
    //       isLoading = false;
    //     });
    //   } else {
    //     Failed failed = Failed.fromJson(dashBoardData);
    //     setState(() {
    //       isLoading = false;
    //     });
    //     showSnackBar(failed);
    //   }
    // } else {
    //   Parentlogin parentModel =
    //       await sessionManagement.getModelParent('Parent');
    //   String ptoken = parentModel.basicAuthToken;
    //   dynamic dashBoardData = await httpService.getDashboard(token: ptoken, cookieExample: parentModel.userdata.cookie ?? "");
    //   if (dashBoardData["status"]) {
    //     Dashboard data = Dashboard.fromJson(dashBoardData);
    //     setState(() {
    //       // //token will be set here
    //       // _basicAuthenticationtoken = ptoken;
    //       //
    //       // //set Role of use
    //       // _role = 1;
    //
    //       //set Events List
    //       examList = data.eventList.exams;
    //       eventList = data.eventList.events;
    //       holidayList = data.eventList.holiday;
    //
    //       //data from dashboard will set below
    //       examListFromDashboard = data.examlist;
    //       parentCount = data.count.parentCount;
    //       studentCount = data.count.studentCount;
    //       isLoading = false;
    //     });
    //   } else {
    //     setState(() {
    //       isLoading = false;
    //     });
    //   }
    // }
    //
    // setEvents(listToShow);
  }

  Future<void> setUserInfo() async {
    // SessionManagement sessionManagement = SessionManagement();
    // int? role = await sessionManagement.getRole("Role");
    // if (role == 0) {
    //   Studentlogin student = await sessionManagement.getModel('Student');
    //   setState(() {
    //     fName = student.userdata.sFname!;
    //     imagePath = student.userdata.stuImage!;
    //     userDatas = student.userdata;
    //   });
    // } else {
    //   Parentlogin parent = await sessionManagement.getModelParent('Parent');
    //   setState(() {
    //     fName = (parent.userdata.pFname)!;
    //     imagePath = (parent.userdata.parentImage)!;
    //     studentData = parent.userdata.studentData;
    //   });
    // }
  }

  // void setEvents(int listToShow) {
  //   Map<DateTime, List<ListElement>> eventMap = {};
  //   DateFormat df = DateFormat("yyyy-MM-dd");
  //   if (listToShow == 0) {
  //     for (var element in eventList) {
  //       if (eventMap[element.startDate] != null) {
  //         eventMap[DateTime.parse(df.format(element.startDate))]!
  //             .addAll(element.list);
  //       } else {
  //         eventMap[DateTime.parse(df.format(element.startDate))] = element.list;
  //       }
  //     }
  //   } else if (listToShow == 1) {
  //     for (var element in examList) {
  //       if (eventMap[element.startDate] != null) {
  //         eventMap[DateTime.parse(df.format(element.startDate))]!
  //             .addAll([element.list]);
  //       } else {
  //         eventMap[DateTime.parse(df.format(element.startDate))] = [
  //           element.list
  //         ];
  //       }
  //     }
  //   } else {
  //     for (var element in holidayList) {
  //       if (eventMap[element.startDate] != null) {
  //         eventMap[DateTime.parse(df.format(element.startDate))]!
  //             .addAll(element.list);
  //       } else {
  //         eventMap[DateTime.parse(df.format(element.startDate))] = element.list;
  //       }
  //     }
  //   }
  //
  //   setState(() {
  //     selectedEvents = eventMap;
  //     isLoading = false;
  //   });
  // }

  // List<ListElement> _getEventsForDay(DateTime date) {
  //   DateFormat dateFormat = DateFormat("yyyy-MM-dd");
  //   List<ListElement>? events =
  //       selectedEvents[DateTime.parse(dateFormat.format(date))].runtimeType ==
  //               ListElement
  //           ? [selectedEvents[DateTime.parse(dateFormat.format(date))]]
  //           : selectedEvents[DateTime.parse(dateFormat.format(date))];
  //   return events ?? [];
  // }

  // Widget _bottomSheet(List<ExamItemDetail>? selectedEvent) {
  //   return selectedEvent != null
  //       ? ScrollConfiguration(
  //           behavior: const ScrollBehavior().copyWith(overscroll: false),
  //           child: Padding(
  //             padding: const EdgeInsets.symmetric(horizontal: 20),
  //             child: ListView.separated(
  //               padding: const EdgeInsets.symmetric(
  //                 vertical: 10,
  //               ),
  //               shrinkWrap: true,
  //               itemBuilder: (context, position) {
  //                 ListElement item = selectedEvent[position];
  //                 return Container(
  //                   decoration: BoxDecoration(
  //                       color: listToShow == 0
  //                           ? AppColors.holidayIcon.withOpacity(0.05)
  //                           : listToShow == 1
  //                               ? AppColors.red.withOpacity(0.05)
  //                               : AppColors.green.withOpacity(0.05),
  //                       borderRadius: BorderRadius.circular(10)),
  //                   child: Column(
  //                     mainAxisAlignment: MainAxisAlignment.start,
  //                     crossAxisAlignment: CrossAxisAlignment.start,
  //                     children: [
  //                       Padding(
  //                         padding: const EdgeInsets.all(14),
  //                         child: Column(
  //                           mainAxisAlignment: MainAxisAlignment.start,
  //                           crossAxisAlignment: CrossAxisAlignment.start,
  //                           children: [
  //                             Text(
  //                               item.title,
  //                               style: TextStyle(
  //                                 fontFamily: 'Outfit',
  //                                 fontSize: 20,
  //                                 fontWeight: FontWeight.w700,
  //                                 color: listToShow == 0
  //                                     ? AppColors.holidayIcon
  //                                     : listToShow == 1
  //                                         ? AppColors.red
  //                                         : AppColors.green,
  //                               ),
  //                             ),
  //                             Padding(
  //                               padding: const EdgeInsets.only(top: 10),
  //                               child: Text(
  //                                 DateFormat("dd-MM-yyyy")
  //                                     .format(DateTime.parse(item.startDate)),
  //                                 style: TextStyle(
  //                                   fontSize: 18,
  //                                   fontWeight: FontWeight.w600,
  //                                   fontFamily: 'Outfit',
  //                                   color: listToShow == 0
  //                                       ? AppColors.holidayIcon
  //                                       : listToShow == 1
  //                                           ? AppColors.red
  //                                           : AppColors.green,
  //                                 ),
  //                               ),
  //                             ),
  //                             Padding(
  //                                 padding: const EdgeInsets.only(top: 5),
  //                                 child: Text(
  //                                   DateFormat("dd-MM-yyyy")
  //                                       .format(DateTime.parse(item.endDate)),
  //                                   style: TextStyle(
  //                                     fontFamily: 'Outfit',
  //                                     fontWeight: FontWeight.w400,
  //                                     fontSize: 14,
  //                                     color: listToShow == 0
  //                                         ? AppColors.holidayIcon
  //                                         : listToShow == 1
  //                                             ? AppColors.red
  //                                             : AppColors.green,
  //                                   ),
  //                                 ))
  //                           ],
  //                         ),
  //                       )
  //                     ],
  //                   ),
  //                 );
  //               },
  //               separatorBuilder: (context, position) {
  //                 return const SizedBox(
  //                   height: 15,
  //                 );
  //               },
  //               itemCount: selectedEvent.isEmpty ? 5 : selectedEvent.length,
  //             ),
  //           ))
  //       : Container(
  //           margin: const EdgeInsets.all(20), child: const Text("No Events"));
  // }

  void goToExamScreen(String classId, String studentId) {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => TestScreen(classId, studentId)));
  }
}

class DashboardWidget1 extends StatelessWidget {
  final String label;
  final String value;
  final Color iconBackgroundColor;
  final Color backgroundColor;
  final String icon;

  const DashboardWidget1(
      {super.key,
      required this.label,
      required this.value,
      required this.iconBackgroundColor,
      required this.backgroundColor,
      required this.icon});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        color: backgroundColor,
      ),
      child: Row(
        children: [
          Container(
              height: 80,
              width: 60,
              decoration: BoxDecoration(
                color: iconBackgroundColor,
                borderRadius: const BorderRadius.only(
                    topRight: Radius.circular(160),
                    bottomRight: Radius.circular(160),
                    bottomLeft: Radius.circular(50),
                    topLeft: Radius.circular(50)),
              ),
              child: Padding(
                padding: const EdgeInsets.only(
                    top: 20, right: 20, bottom: 20, left: 5),
                child: SvgPicture.asset(icon),
              )),
          const SizedBox(
            width: 5,
          ),
          Expanded(
              child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: AppTextStyle.getOutfit400(
                    textSize: 18, textColor: iconBackgroundColor),
              ),
              const SizedBox(
                height: 5,
              ),
              Text(
                value,
                style: AppTextStyle.getOutfit700(
                    textSize: 24, textColor: iconBackgroundColor),
              )
            ],
          ))
        ],
      ),
    );
  }
}

class DashboardWidget2 extends StatelessWidget {
  final String label;
  final Color color;
  final int id;

  const DashboardWidget2(
      {super.key, required this.label, required this.color, required this.id});

  @override
  Widget build(BuildContext context) {
    return Consumer<StudentParentTeacherController>(
      builder: (context, studentParentTeacherController, child) {
        int currentSelected =
            studentParentTeacherController.currentListToShowInCalendar;
        return GestureDetector(
          onTap: () {
            studentParentTeacherController.setCurrentListToShowInCalendar(
                currentListToShowInCalendar: id);
          },
          child: Container(
            padding: const EdgeInsets.all(5),
            height: 30,
            decoration: BoxDecoration(
              color: currentSelected == id
                  ? color.withOpacity(0.5)
                  : AppColors.white,
              border: Border.all(
                  color: currentSelected == id ? color : AppColors.white,
                  width: 1.0,
                  style: BorderStyle.solid),
              borderRadius: const BorderRadius.all(Radius.circular(10)),
            ),
            child: Row(
              children: [
                Container(
                  width: 15,
                  height: 15,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5), color: color),
                ),
                const SizedBox(
                  width: 5,
                ),
                Text(
                  label,
                  style: AppTextStyle.getOutfit400(
                      textSize: 16, textColor: AppColors.secondary),
                )
              ],
            ),
          ),
        );
      },
    );
  }
}
