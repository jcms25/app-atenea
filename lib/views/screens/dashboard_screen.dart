import 'package:auto_size_text/auto_size_text.dart';
import 'package:colegia_atenea/controllers/student_parent_teacher_controller.dart';
import 'package:colegia_atenea/models/dashboard_model.dart';
import 'package:colegia_atenea/models/login_model.dart';
import 'package:colegia_atenea/services/app_shared_preferences.dart';
import 'package:colegia_atenea/utils/app_colors.dart';
import 'package:colegia_atenea/utils/app_images.dart';
import 'package:colegia_atenea/utils/app_textstyle.dart';
import 'package:colegia_atenea/views/custom_widgets/bottom_sheets_widgets/show_events_bottom_sheets.dart';
import 'package:colegia_atenea/views/custom_widgets/custom_loader.dart';
import 'package:colegia_atenea/views/screens/class_menu_screens/exam_list_screen.dart';
import 'package:colegia_atenea/views/screens/edit_profile_screen.dart';
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
  StudentParentTeacherController? studentParentTeacherController;

  @override
  void initState() {
    super.initState();
    // for setting local language to calendar
    initializeDateFormatting(Get.locale!.countryCode, null);
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      studentParentTeacherController =
          Provider.of<StudentParentTeacherController>(context, listen: false);
      studentParentTeacherController?.getDashboardData(showLoader: true);
      // if(studentParentTeacherController?.dashboard == null){
      //   studentParentTeacherController?.getDashboardData(showLoader: true);
      // }
    });
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
                            Userdata? userdata =
                                studentParentTeacherController.userdata;
                            String? userRole =
                                AppSharedPreferences.getUserLoggedInRole();
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

                            return GestureDetector(
                              onTap: () {
                                Get.to(() => EditProfileScreen(
                                      userdata: studentParentTeacherController
                                          .userdata,
                                      roleType: studentParentTeacherController
                                          .currentLoggedInUserRole, assistantData: null,
                                    ));
                              },
                              child: Container(
                                  // height: 100,
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
                                                // ? Image.asset(
                                                //     AppImages.person,
                                                //     fit: BoxFit.cover,
                                                //     height: 65,
                                                //     width: 65,
                                                //   )
                                                ? SvgPicture.asset(
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
                                  )),
                            );
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
                                // color: AppColors.dashBack.withOpacity(0.06)
                              color: AppColors.dashBack.withValues(alpha: 0.06)
                            ),
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
                              Consumer<StudentParentTeacherController>(
                                builder: (context, ctrl, child) {
                                  if (ctrl.currentLoggedInUserRole != RoleType.teacher) return const SizedBox.shrink();
                                  return Padding(
                                    padding: const EdgeInsets.only(top: 8, bottom: 4),
                                    child: Row(
                                      children: [
                                        Container(width: 12, height: 12, decoration: const BoxDecoration(shape: BoxShape.circle, color: AppColors.red)),
                                        const SizedBox(width: 6),
                                        Text("Mis exámenes", style: AppTextStyle.getOutfit400(textSize: 13, textColor: AppColors.secondary)),
                                        const SizedBox(width: 16),
                                        Container(width: 12, height: 12, decoration: const BoxDecoration(shape: BoxShape.circle, color: AppColors.darkPurple)),
                                        const SizedBox(width: 6),
                                        Text("Otros Exámenes de mi alumnado", style: AppTextStyle.getOutfit400(textSize: 13, textColor: AppColors.secondary)),
                                      ],
                                    ),
                                  );
                                },
                              ),
                              const SizedBox(
                                height: 15,
                              ),                              
                              Container(
                                decoration: const BoxDecoration(
                                    color: AppColors.orange,
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(15))),
                                child: Consumer<StudentParentTeacherController>(
                                  builder: (context,
                                      studentParentTeacherController, child) {
                                    return TableCalendar(
                                      firstDay: DateTime(1990),
                                      focusedDay: studentParentTeacherController
                                          .dashboardCalendarFocusDay,
                                      lastDay: DateTime(2050),
                                      calendarFormat: CalendarFormat.month,
                                      onFormatChanged: null,
                                      startingDayOfWeek:
                                          StartingDayOfWeek.monday,
                                      daysOfWeekVisible: true,
                                      currentDay: DateTime.now(),
                                      //day changed
                                      onDaySelected: (DateTime selectDay,
                                          DateTime focusDay) {
                                        DateFormat dateFormat =
                                            DateFormat("yyyy-MM-dd");
                                        studentParentTeacherController
                                            .setDashboardCalendarSelectedDay(
                                                selectedDay: selectDay);
                                        studentParentTeacherController
                                            .setDashboardCalendarFocusDay(
                                                focusDay: focusDay);
                                        showModalBottomSheet(
                                            context: context,
                                            builder: (context) {
                                              return ShowEventsBottomSheets(
                                                eventList: studentParentTeacherController
                                                            .dashboardEventMap[
                                                        DateTime.parse(
                                                            dateFormat.format(
                                                                selectDay))] ??
                                                    [],
                                                color: AppColors.red,
                                              );
                                            });
                                      },
                                      locale: Get.locale!.languageCode,
                                      selectedDayPredicate: (DateTime date) {
                                        return isSameDay(
                                            studentParentTeacherController
                                                .dashboardCalendarSelectedDay,
                                            date);
                                      },
                                      eventLoader:
                                          studentParentTeacherController
                                              .getDashboardEvents,
                                      headerStyle: HeaderStyle(
                                        formatButtonVisible: false,
                                        //false : invisible format button
                                        titleCentered: true,
                                        //Centered month and year
                                        titleTextStyle:
                                            AppTextStyle.getOutfit500(
                                                textSize: 16,
                                                textColor: AppColors.secondary),
                                        leftChevronVisible: true,
                                        //showing left arrow
                                        rightChevronVisible: true,
                                        //showing right arrow
                                        headerPadding: EdgeInsets.symmetric(
                                            horizontal: 5, vertical: 20),
                                      ),
                                      calendarStyle: CalendarStyle(
                                        selectedDecoration: const BoxDecoration(
                                            shape: BoxShape.circle,
                                            color: AppColors.primary),
                                        selectedTextStyle:
                                            AppTextStyle.getOutfit500(
                                                textSize: 16,
                                                textColor: AppColors.white),
                                        todayDecoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                          color: AppColors.primary.withValues(alpha: 0.5)
                                        ),
                                        todayTextStyle: const TextStyle(
                                            color: AppColors.white),
                                        markersMaxCount: 0,
                                        outsideDaysVisible: true,
                                      ),
                                      calendarBuilders: CalendarBuilders(
                                        markerBuilder: (context, date, events) {
                                          if (events.isEmpty) return null;
                                          final typedEvents = events.cast<EventItemDetail>();
                                          return Row(
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            children: typedEvents.map((e) {
                                              final isOwn = e.isOwn ?? true;
                                              return Container(
                                                width: 7,
                                                height: 7,
                                                margin: const EdgeInsets.symmetric(horizontal: 1),
                                                decoration: BoxDecoration(
                                                  shape: BoxShape.circle,
                                                  color: isOwn ? AppColors.red : AppColors.darkPurple,
                                                ),
                                              );
                                            }).toList(),
                                          );
                                        },
                                      ),
                                      onDayLongPressed: (DateTime selectDay,
                                          DateTime focusDay) {},
                                    );
                                  },
                                ),
                              ),
                              Consumer<StudentParentTeacherController>(
                                builder: (context,
                                    studentParentTeacherController, child) {
                                  return Visibility(
                                      visible: studentParentTeacherController
                                              .currentLoggedInUserRole !=
                                          RoleType.teacher,
                                      child: Container(
                                        margin: const EdgeInsets.only(
                                            top: 20, bottom: 10),
                                        child: Row(
                                          children: [
                                            Expanded(
                                              child: Text("exam".tr,
                                                  style:
                                                      AppTextStyle.getOutfit600(
                                                          textSize: 20,
                                                          textColor: AppColors
                                                              .secondary)),
                                            ),
                                            Consumer<StudentParentTeacherController>(
                                              builder: (context,studentParentTeacherController,child){
                                                return GestureDetector(
                                                  onTap: () {



                                                    Userdata? userdata = studentParentTeacherController.userdata;

                                                    if(studentParentTeacherController.currentLoggedInUserRole == RoleType.student){

                                                      Get.to(() => ExamListScreen(), arguments: {
                                                        "role": RoleType.student,
                                                        "wpUserId": userdata?.wpUsrId,
                                                        "classId": userdata?.classId,
                                                        "className": userdata?.className,
                                                        "studentName": "${userdata?.firstName} ${userdata?.lastName}"
                                                      });

                                                    }else{
                                                      Get.bottomSheet(
                                                        Container(
                                                          decoration: BoxDecoration(
                                                            borderRadius: BorderRadius.only(
                                                              topLeft: Radius.circular(20),
                                                              topRight: Radius.circular(20)
                                                            ),
                                                            color: AppColors.white
                                                          ),
                                                          padding: const EdgeInsets.all(10),
                                                          child: Wrap(
                                                            children: userdata?.studentData?.map((e){
                                                              return GestureDetector(
                                                                onTap: (){
                                                                  Get.to(() => ExamListScreen(), arguments: {
                                                                    "role": RoleType.student,
                                                                    "wpUserId": e.wpUsrId,
                                                                    "classId": e.classId,
                                                                    "className": e.className,
                                                                    "studentName": "${e.sFname} ${e.sLname}"
                                                                  }
                                                                  );
                                                                },
                                                                child: Container(
                                                                  width: MediaQuery.sizeOf(context).width,
                                                                  margin: EdgeInsets.only(bottom: 10),
                                                                  decoration: BoxDecoration(
                                                                      color: AppColors.white,
                                                                      border: Border.all(
                                                                          color: AppColors.primary,
                                                                          width: 1
                                                                      ),

                                                                      borderRadius:BorderRadius.circular(10)
                                                                  ),
                                                                  padding: const EdgeInsets.all(10),
                                                                  child: Row(
                                                                    crossAxisAlignment: CrossAxisAlignment.center,
                                                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                    children: [
                                                                      Expanded(child: Text("${e.sFname}\t${e.sLname}\t(${e.className})")),
                                                                      IconButton(onPressed: (){}, icon: Icon(Icons.arrow_forward))
                                                                    ],
                                                                  ),
                                                                ),
                                                              );
                                                            }).toList() ?? [],
                                                          ),
                                                        )
                                                      );
                                                    }

                                                  },
                                                  child: Row(
                                                    children: [
                                                      Text("viewall".tr,
                                                          style: AppTextStyle
                                                              .getOutfit400(
                                                              textSize: 16,
                                                              textColor:
                                                              AppColors
                                                                  .primary)),
                                                      const SizedBox(width: 2),
                                                      SvgPicture.asset(
                                                          AppImages.loginArrow,
                                                          colorFilter:
                                                          const ColorFilter
                                                              .mode(
                                                              AppColors
                                                                  .primary,
                                                              BlendMode
                                                                  .srcIn)),
                                                    ],
                                                  ),
                                                );
                                              },
                                            )
                                          ],
                                        ),
                                      ));
                                },
                              ),
                              Consumer<StudentParentTeacherController>(
                                builder: (context,
                                    studentParentTeacherController, child) {
                                  List<ExamItem> examList =
                                      studentParentTeacherController
                                              .dashboard?.examList ??
                                          [];
                                  return Visibility(
                                      visible: studentParentTeacherController
                                              .currentLoggedInUserRole !=
                                          RoleType.teacher,
                                      child: examList.isEmpty
                                          ? Center(
                                              child: Text(
                                                "No hay calendario de exámenes.",
                                                style:
                                                    AppTextStyle.getOutfit400(
                                                        textSize: 16,
                                                        textColor: AppColors
                                                            .secondary),
                                              ),
                                            )
                                          : ScrollConfiguration(
                                              behavior: const ScrollBehavior()
                                                  .copyWith(overscroll: false),
                                              child: ListView.builder(
                                                  itemCount: examList.length < 2
                                                      ? 1
                                                      : 2,
                                                  shrinkWrap: true,
                                                  itemBuilder:
                                                      (context, index) {
                                                    return Container(
                                                        margin: const EdgeInsets
                                                            .only(top: 10),
                                                        decoration: BoxDecoration(
                                                            // color: AppColors
                                                            //     .primary
                                                            //     .withOpacity(
                                                            //         0.05),
                                                            color: AppColors.primary.withValues(alpha: 0.05),
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        20)),
                                                        child: Column(
                                                            children: [
                                                              Container(
                                                                width: MediaQuery.of(
                                                                        context)
                                                                    .size
                                                                    .width,
                                                                height: 50,
                                                                padding:
                                                                    const EdgeInsets
                                                                        .all(
                                                                        10),
                                                                decoration:
                                                                    const BoxDecoration(
                                                                  color: AppColors
                                                                      .primary,
                                                                  borderRadius: BorderRadius.only(
                                                                      topLeft: Radius
                                                                          .circular(
                                                                              20),
                                                                      topRight:
                                                                          Radius.circular(
                                                                              20)),
                                                                ),
                                                                child: Text(
                                                                    textAlign:
                                                                        TextAlign
                                                                            .start,
                                                                    examList[
                                                                            index]
                                                                        .className,
                                                                    style: AppTextStyle.getOutfit500(
                                                                        textSize:
                                                                            20,
                                                                        textColor:
                                                                            AppColors.white)),
                                                              ),
                                                              Align(
                                                                alignment: Alignment
                                                                    .centerLeft,
                                                                child: Padding(
                                                                    padding:
                                                                        const EdgeInsets
                                                                            .all(
                                                                            15),
                                                                    child:
                                                                        Column(
                                                                      crossAxisAlignment:
                                                                          CrossAxisAlignment
                                                                              .start,
                                                                      children: [
                                                                        AutoSizeText(
                                                                          examList[index]
                                                                              .name,
                                                                          maxLines:
                                                                              3,
                                                                          style: AppTextStyle.getOutfit600(
                                                                              textSize: 18,
                                                                              textColor: AppColors.secondary),
                                                                        ),
                                                                        Padding(
                                                                            padding:
                                                                                const EdgeInsets.only(top: 10),
                                                                            child: Text(examList[index].date, style: AppTextStyle.getOutfit400(textSize: 16, textColor: AppColors.secondary)))
                                                                      ],
                                                                    )),
                                                              )
                                                            ]));
                                                  })));
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
