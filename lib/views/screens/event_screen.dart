import 'package:colegia_atenea/controllers/student_parent_teacher_controller.dart';
import 'package:colegia_atenea/models/events_list.dart';
import 'package:colegia_atenea/utils/app_colors.dart';
import 'package:colegia_atenea/utils/app_textstyle.dart';
import 'package:colegia_atenea/views/custom_widgets/custom_loader.dart';
import 'package:colegia_atenea/views/screens/teacher_screens/teacher_add_edit_events_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:table_calendar/table_calendar.dart';

class EventScreen extends StatefulWidget {
  const EventScreen({super.key});

  @override
  State<StatefulWidget> createState() {
    return _EventScreenChildState();
  }
}

class _EventScreenChildState extends State<EventScreen> {
  StudentParentTeacherController? studentParentTeacherController;

  @override
  void initState() {
    super.initState();
    initializeDateFormatting(Get.locale!.languageCode, null);
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      studentParentTeacherController =
          Provider.of<StudentParentTeacherController>(context, listen: false);
      studentParentTeacherController?.getEvents();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          ScrollConfiguration(
            behavior: const ScrollBehavior().copyWith(overscroll: false),
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(15),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "eventsCalendar".tr,
                      style: AppTextStyle.getOutfit600(textSize: 20, textColor: AppColors.secondary),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Container(
                      decoration: const BoxDecoration(
                          color: AppColors.orange,
                          borderRadius: BorderRadius.all(Radius.circular(15))),
                      child: Consumer<StudentParentTeacherController>(
                        builder:
                            (context, studentParentTeacherController, child) {
                          return TableCalendar(
                            firstDay: DateTime(1990),
                            focusedDay: studentParentTeacherController
                                .eventScreenFocusDay,
                            lastDay: DateTime(2050),
                            calendarFormat: CalendarFormat.month,
                            onFormatChanged: null,
                            startingDayOfWeek: StartingDayOfWeek.monday,
                            daysOfWeekVisible: true,
                            currentDay: DateTime.now(),
                            //day changed
                            onDaySelected:
                                (DateTime selectDay, DateTime focusDay) {
                              DateFormat dateFormat = DateFormat("yyyy-MM-dd");
                              studentParentTeacherController
                                  .setEventScreenSelectedDay(
                                      dateTime: selectDay);
                              studentParentTeacherController
                                  .setEventScreenFocusDay(dateTime: focusDay);
                              studentParentTeacherController.setTodayEvent(
                                  eventList: studentParentTeacherController
                                          .mapOfEventsDateWise
                                          .containsKey(DateTime.parse(
                                              dateFormat.format(focusDay)))
                                      ? studentParentTeacherController
                                                  .mapOfEventsDateWise[
                                              DateTime.parse(dateFormat
                                                  .format(focusDay))] ??
                                          []
                                      : []);
                            },
                            locale: Get.locale!.languageCode,
                            selectedDayPredicate: (DateTime date) {
                              return isSameDay(
                                  studentParentTeacherController
                                      .eventScreenSelectedDay,
                                  date);
                            },
                            eventLoader:
                                studentParentTeacherController.getEventsForDay,
                            headerStyle: HeaderStyle(
                              formatButtonVisible: false,
                              //false : invisible format button
                              titleCentered: true,
                              //Centered month and year
                              titleTextStyle: AppTextStyle.getOutfit500(
                                  textSize: 16, textColor: AppColors.secondary),
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
                                  // borderRadius: BorderRadius.all(
                                  //     Radius.circular(10)),
                                  color: AppColors.primary),
                              selectedTextStyle: AppTextStyle.getOutfit500(textSize: 16, textColor: AppColors.white),
                              todayDecoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  // borderRadius: BorderRadius.all(
                                  //     Radius.circular(10)),
                                  color: AppColors.primary.withOpacity(0.5)),
                              todayTextStyle:
                                  const TextStyle(color: AppColors.white),
                              markerDecoration: const BoxDecoration(
                                shape: BoxShape.circle,
                                color: AppColors.secondary,
                                // borderRadius: BorderRadius.circular(
                                //     8.0)
                              ),
                              markersMaxCount: 3,
                              outsideDaysVisible: true,
                            ),
                            onDayLongPressed:
                                (DateTime selectDay, DateTime focusDay) {},
                          );
                        },
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Consumer<StudentParentTeacherController>(
                      builder:
                          (context, studentParentTeacherController, child) {
                        return Column(
                          children: [
                            ...studentParentTeacherController.todayEvent
                                .map((e) {
                              Color color = e.color != null
                                  ? e.color!.isEmpty
                                      ? AppColors.primary
                                      : hexToColor(e.color ?? "")
                                  : AppColors.primary;
                              return EventWidget(eventListItemDetail: e, color: color);
                            })
                          ],
                        );
                      },
                    )
                  ],
                ),
              ),
            ),
          ),
          Consumer<StudentParentTeacherController>(
            builder: (context, studentParentTeacherController, child) {
              return Visibility(
                  visible: studentParentTeacherController.isLoading,
                  child: const LoadingLayout());
            },
          ),
        ],
      ),
      floatingActionButton: Consumer<StudentParentTeacherController>(
        builder: (context, studentParentTeacherController, child) {
          return Visibility(
              visible: studentParentTeacherController.currentLoggedInUserRole ==
                  RoleType.teacher,
              child: FloatingActionButton(
                  elevation: 0,
                  child: Center(
                    child: Icon(
                      Icons.add,
                      color: AppColors.white,
                    ),
                  ),
                  onPressed: () {
                    // Get.to(() => TeacherAddEditEvents(),
                    //     arguments: {"reason": "add-event"});
                    Get.to(() => TeacherAddEditEvents(),arguments: {
                      "reason" : "add-event"
                    });
                     }
                  ));
        },
      ),
    );
  }

  Color hexToColor(String code) {
    return Color(int.parse(code.substring(1, 7), radix: 16) + 0xFF000000);
  }

}


class EventWidget extends StatelessWidget {
  final EventListItemDetail eventListItemDetail;
  final Color color;
  const EventWidget({super.key, required this.eventListItemDetail, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
          color: color.withOpacity(0.05),
          borderRadius: BorderRadius.circular(10)),
      padding: const EdgeInsets.all(10),
      margin: const EdgeInsets.only(bottom: 10),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(child: Text(eventListItemDetail.title ?? "",
                  style: AppTextStyle.getOutfit700(
                      textSize: 20, textColor: color))),
              Consumer<StudentParentTeacherController>(
                builder: (context,studentParentTeacherController,child){
                  return Visibility(
                    visible: studentParentTeacherController.currentLoggedInUserRole == RoleType.teacher && studentParentTeacherController.userdata?.wpUsrId == eventListItemDetail.createdBy,
                      child: IconButton(icon: Icon(Icons.edit),color: color, onPressed: () {
                        Get.to(() => TeacherAddEditEvents(),
                          arguments: {
                           "reason" : "edit-event",
                           "event-data" : eventListItemDetail
                          }
                        );
                      },));
                },
              )
            ],
          ),
          const SizedBox(
            height: 10,
          ),
          RichText(text: TextSpan(
           text: "Fecha de inicio\t:\t",
           style: AppTextStyle.getOutfit600(textSize: 18, textColor: color),
           children: [
             TextSpan(
               text:DateFormat("dd-MM-yyyy HH:mm").format(eventListItemDetail.startDate ?? DateTime.now()),
               style: AppTextStyle.getOutfit600(textSize: 16, textColor: color)
             ),
           ]
         )),
          const SizedBox(
            height: 5,
          ),
          RichText(text: TextSpan(
              text: "Fecha de finalización\t:\t",
              style: AppTextStyle.getOutfit600(textSize: 18, textColor: color),
              children: [
                TextSpan(
                    text:DateFormat("dd-MM-yyyy HH:mm").format(eventListItemDetail.endDate ?? DateTime.now()),
                    style: AppTextStyle.getOutfit600(textSize: 16, textColor: color)
                ),
              ]
          )),
        ],
      ),
    );
  }
}


