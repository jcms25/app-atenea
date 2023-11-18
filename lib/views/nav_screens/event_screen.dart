import 'package:colegia_atenea/models/Parent/Parentlogin.dart';
import 'package:colegia_atenea/models/Student/Studentlogin.dart';
import 'package:colegia_atenea/models/events_list.dart';
import 'package:colegia_atenea/services/api_class.dart';
import 'package:colegia_atenea/services/session_management.dart';
import 'package:colegia_atenea/utils/app_colors.dart';
import 'package:colegia_atenea/utils/app_images.dart';
import 'package:colegia_atenea/utils/text_style.dart';
import 'package:colegia_atenea/widgets/custom_loader.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:intl/intl.dart';

void main() => runApp(const EventScreen());

class EventScreen extends StatelessWidget {
  const EventScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const HomeCalendarPage();
  }
}

class HomeCalendarPage extends StatefulWidget {
  const HomeCalendarPage({super.key});

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _HomeCalendarPageState();
  }

}

class _HomeCalendarPageState extends State<HomeCalendarPage> {


  // late Future<Dashboard> futureAlbum;
  String fName = "";
  String mName = "";
  String imagePath = "";
  DateTime _focusedDay = DateTime.now();
  final CalendarFormat _format = CalendarFormat.values.first;
  DateTime _selectedDay = DateTime.now();
  bool isLoading = false;
  List<ListElement> todayEvents = [];
  Map<DateTime, List<ListElement>> mapOfEvents = {};

  @override
  void initState() {
    super.initState();
    initializeDateFormatting(Get.locale!.languageCode,null);
    setState(() {
      isLoading = true;
    });
    getEvents();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            titleSpacing: 0,
            elevation: 0,
            backgroundColor: AppColors.primary,
            title: Text(
              "events".tr,
              style: CustomStyle.appBarTitle,
            ),
            leading: Container(
              margin: const EdgeInsets.all(10),
              child: GestureDetector(
                onTap: () {
                  Scaffold.of(context).openDrawer();
                },
                child: SvgPicture.asset(
                  AppImages.humBurg,
                  color: AppColors.orange,
                ),
              ),
            )),
        body: Stack(
          children: [
            ScrollConfiguration(behavior: const ScrollBehavior().copyWith(overscroll: false),
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(15),
                  child: Column(
                    crossAxisAlignment:
                    CrossAxisAlignment.start,
                    children: [
                      Text(
                        "eventsCalendar".tr,
                        style: CustomStyle.calendarTextStyle,
                      ),
                      const SizedBox(height: 20,),
                      Container(
                        decoration: const BoxDecoration(
                            color: AppColors.orange,
                            borderRadius: BorderRadius.all(
                                Radius.circular(15))),
                        child: TableCalendar(
                          firstDay: DateTime(1990),
                          focusedDay: _focusedDay,
                          lastDay: DateTime(2050),
                          calendarFormat: _format,
                          onFormatChanged: null,
                          startingDayOfWeek:
                          StartingDayOfWeek.monday,
                          daysOfWeekVisible: true,
                          currentDay: DateTime.now(),
                          //day changed
                          onDaySelected: (DateTime selectDay,
                              DateTime focusDay) {
                            DateFormat dateFormat = DateFormat("yyyy-MM-dd");
                            setState(() {
                              _selectedDay = selectDay;
                              todayEvents = mapOfEvents.containsKey(DateTime.parse(dateFormat.format(focusDay))) ? mapOfEvents[DateTime.parse(dateFormat.format(focusDay))]! : [];
                              _focusedDay = focusDay;
                            });
                          },
                          locale: Get.locale!.languageCode,
                          selectedDayPredicate:
                              (DateTime date) {
                            return isSameDay(
                                _selectedDay, date);
                          },
                          eventLoader: _getEventsForDay,
                          headerStyle: const HeaderStyle(
                            formatButtonVisible: false,
                            //false : invisible format button
                            titleCentered: true,
                            //Centered month and year
                            titleTextStyle: TextStyle(
                                fontSize: 16,
                                fontFamily: "OutfitMedium",
                                fontWeight: FontWeight.w500),
                            leftChevronVisible: true,
                            //showing left arrow
                            rightChevronVisible: true,
                            //showing right arrow
                            headerPadding:
                            EdgeInsets.symmetric(
                                horizontal: 5,
                                vertical: 20),
                          ),
                          calendarStyle: CalendarStyle(
                              selectedDecoration:
                              const BoxDecoration(
                                  shape: BoxShape.circle,
                                  // borderRadius: BorderRadius.all(
                                  //     Radius.circular(10)),
                                  color:
                                  AppColors.primary),
                              selectedTextStyle: CustomStyle
                                  .txtvalue4
                                  .copyWith(
                                  color: AppColors.white),
                              todayDecoration:
                              const BoxDecoration(
                                  shape: BoxShape.circle,
                                  // borderRadius: BorderRadius.all(
                                  //     Radius.circular(10)),
                                  color:
                                  AppColors.primary),
                              todayTextStyle: const TextStyle(
                                  color: AppColors.white),
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
                              (DateTime selectDay,
                              DateTime focusDay) {},
                        ),
                      ),
                      const SizedBox(height: 20,),
                      ...todayEvents.map((e){
                        Color color = e.color.isEmpty ? AppColors.primary : hexToColor(e.color);
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
                              Text(
                                e.title,
                                style: TextStyle(
                                  fontFamily: 'Outfit',
                                  fontSize: 20,
                                  fontWeight: FontWeight.w700,
                                  color: color,
                                ),
                              ),
                              const SizedBox(height: 10,),
                              Text(
                                DateFormat("dd-MM-yyyy").format(e.startDate),
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w600,
                                  fontFamily: 'Outfit',
                                  color: color,
                                ),
                              ),
                              const SizedBox(height: 10,),
                              Text(
                                DateFormat("dd-MM-yyyy").format(e.endDate),
                                style: TextStyle(
                                  fontFamily: 'Outfit',
                                  fontWeight: FontWeight.w400,
                                  fontSize: 14,
                                  color: color,
                                ),
                              )
                            ],
                          ),
                        );
                      })
                    ],
                  ),
                ),
              ),),
            Visibility(
                visible: isLoading,
                child: Container(
                  color: Colors.black.withOpacity(0.5),
                  height: MediaQuery
                      .of(context)
                      .size
                      .height,
                  width: MediaQuery
                      .of(context)
                      .size
                      .width,
                  child: const Center(
                    child: LoadingLayout(),
                  ),
                )),
          ],
        ));
  }

  List<ListElement> _getEventsForDay(DateTime date) {
    DateFormat dateFormat = DateFormat("yyyy-MM-dd");
    List<ListElement> events = mapOfEvents.containsKey(DateTime.parse(dateFormat.format(date))) ? mapOfEvents[DateTime.parse(dateFormat.format(date))]! : [];
    return  events;
  }

  // Widget _bottomSheet(List<ListElement>? selectedEvent) {
  //   return selectedEvent != null
  //       ? ListView.separated(
  //     physics: const BouncingScrollPhysics(),
  //     padding: const EdgeInsets.symmetric(
  //       vertical: 10,
  //     ),
  //     shrinkWrap: true,
  //     itemBuilder: (context, position) {
  //       return Container(
  //         decoration: BoxDecoration(
  //             color: AppColors.primary.withOpacity(0.05),
  //             borderRadius: BorderRadius.circular(30)),
  //         margin: const EdgeInsets.only(top: 10, left: 20, right: 20),
  //         height: 110,
  //         child: Row(
  //           children: [
  //             Column(
  //               mainAxisAlignment: MainAxisAlignment.start,
  //               crossAxisAlignment: CrossAxisAlignment.start,
  //               children: [
  //                 Padding(
  //                   padding: const EdgeInsets.all(14),
  //                   child: Column(
  //                     mainAxisAlignment: MainAxisAlignment.start,
  //                     crossAxisAlignment: CrossAxisAlignment.start,
  //                     children: [
  //                       Text(
  //                         selectedEvent[position].title,
  //                         style: const TextStyle(
  //                           fontFamily: 'Outfit',
  //                           fontSize: 20,
  //                           fontWeight: FontWeight.w700,
  //                           color: AppColors.primary,
  //                         ),
  //                       ),
  //                       Padding(
  //                         padding: const EdgeInsets.only(top: 10),
  //                         child: Text(
  //                           selectedEvent[position].startDate.toString(),
  //                           style: const TextStyle(
  //                             fontSize: 18,
  //                             fontWeight: FontWeight.w600,
  //                             fontFamily: 'Outfit',
  //                             color: AppColors.primary,
  //                           ),
  //                         ),
  //                       ),
  //                       Padding(
  //                           padding: const EdgeInsets.only(top: 5),
  //                           child: Text(
  //                             selectedEvent[position].endDate.toString(),
  //                             style: const TextStyle(
  //                               fontFamily: 'Outfit',
  //                               fontWeight: FontWeight.w400,
  //                               fontSize: 14,
  //                               color: AppColors.primary,
  //                             ),
  //                           ))
  //                     ],
  //                   ),
  //                 )
  //               ],
  //             )
  //           ],
  //         ),
  //       );
  //     },
  //     separatorBuilder: (context, position) {
  //       return const SizedBox(
  //         height: 15,
  //       );
  //     },
  //     itemCount: selectedEvent.isEmpty
  //         ? selectedEvent.isEmpty
  //         ? 0
  //         : selectedEvent.length
  //         : 10,
  //   )
  //       : Container(
  //       margin: const EdgeInsets.all(20), child: const Text("No Events"));
  // }


  Color hexToColor(String code) {
    return Color(int.parse(code.substring(1, 7), radix: 16) + 0xFF000000);
  }

  void getEvents() async {
    ApiClass httpService = ApiClass();
    SessionManagement sessionManagement = SessionManagement();
    int? role = await sessionManagement.getRole("Role");
    if (role == 0) {
      Studentlogin login = await sessionManagement.getModel('Student');
      String token = login.basicAuthToken;
      dynamic response = await httpService.getEvent(token);
      if (response['status']) {
         Events events = Events.fromJson(response);
         setEvents(events.data);
      }
      else {
        setState(() {
          isLoading = false;
        });
      }
    } else {
      Parentlogin parent = await sessionManagement.getModelParent('Parent');
      String token = parent.basicAuthToken;
      dynamic response = await httpService.getEvent(token);
      if (response['status']) {
        Events events = Events.fromJson(response);
        setEvents(events.data);
      }
      else {
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  void setEvents(List<EventModel> data) {
    Map<DateTime, List<ListElement>> eventMap = {};
    DateFormat df = DateFormat("yyyy-MM-dd");
    for(var element in data){
      if (eventMap[element.startDate] != null) {
        eventMap[DateTime.parse(df.format(element.startDate))]!
            .addAll(element.list);
      } else {
        eventMap[DateTime.parse(df.format(element.startDate))] = element.list;
      }
    }


    setState(() {
      isLoading = false;
      todayEvents = eventMap.containsKey(DateTime.parse(df.format(DateTime.now()))) ? eventMap[DateTime.parse(df.format(DateTime.now()))]! : [];
      mapOfEvents = eventMap;
    });
  }




}