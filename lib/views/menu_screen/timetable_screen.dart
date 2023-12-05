import 'package:colegia_atenea/models/Parent/Parentlogin.dart';
import 'package:colegia_atenea/models/Student/Studentlogin.dart';
import 'package:colegia_atenea/models/timetablelist.dart';
import 'package:colegia_atenea/services/api_class.dart';
import 'package:colegia_atenea/services/session_management.dart';
import 'package:colegia_atenea/utils/app_colors.dart';
import 'package:colegia_atenea/utils/app_images.dart';
import 'package:colegia_atenea/utils/text_style.dart';
import 'package:colegia_atenea/widgets/custom_loader.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

class TimeTableScreen extends StatefulWidget {
  final String? cid;

  const TimeTableScreen(
    this.cid, {super.key}
  );

  @override
  State<TimeTableScreen> createState() => TimeTable();
}

class TimeTable extends State<TimeTableScreen> {
  List<String> dayList = ["mo".tr, "tu".tr, "we".tr, "th".tr, "fr".tr];
  int isSelects = 0;
  List<SessionList> listOfSessionList = [];
  List<Datum?> listOfSessionData = [];
  List<Datum?> tempList = [];
  TextEditingController search = TextEditingController();
  String fName = "";
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    setState(() {
      isLoading = true;
    });
    getSessionList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
            titleSpacing: 0,
            elevation: 0,
            backgroundColor: AppColors.primary,
            title: Text(
              "timetable".tr,
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
                              child: TextField(
                                controller: search,
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
                                    hintStyle: TextStyle(
                                        fontFamily: "Outfit",
                                        fontWeight: FontWeight.w400,
                                        fontSize: 16,
                                        color: AppColors.secondary.withOpacity(0.5)),
                                    border: InputBorder.none),
                                cursorColor: AppColors.primary,
                                style: CustomStyle.textValue,
                                keyboardType: TextInputType.text,
                                textInputAction: TextInputAction.next,
                                onChanged: onSearchTextChanged,
                              ),
                            ),
                          ),
                        ],
                      ),
                    )),
                const Padding(
                  padding: EdgeInsets.all(00),
                  child: Text(
                    "",
                  ),
                ),
                Expanded(
                    flex: 1,
                    child: Container(
                        margin: const EdgeInsets.only(
                          left: 30,
                          right: 15,
                        ),
                        child: ScrollConfiguration(
                          behavior: const ScrollBehavior().copyWith(overscroll: false),
                          child: ListView.separated(
                            scrollDirection: Axis.horizontal,
                            physics: const BouncingScrollPhysics(),
                            itemCount: dayList.length,
                            itemBuilder: (context, position) {
                              return GestureDetector(
                                onTap: () {
                                  setState(() {
                                    tempList = listOfSessionList[position].data!;
                                    listOfSessionData = tempList ;
                                    isSelects = position;
                                  });
                                  // callAPI();
                                },
                                child: Container(
                                  width: 50,
                                  decoration: BoxDecoration(
                                      borderRadius: const BorderRadius.all(
                                          Radius.circular(10)),
                                      color: isSelects == position
                                          ? AppColors.primary
                                          : AppColors.primary.withOpacity(0.05)),
                                  child: Center(
                                    child: Text(
                                      dayList[position],
                                      style: CustomStyle.txtvalue4.copyWith(
                                        color: isSelects == position
                                            ? AppColors.white
                                            : AppColors.primary,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            },
                            separatorBuilder: (context, position) {
                              return const SizedBox(
                                width: 10,
                              );
                            },
                          ),
                        ))),
                Expanded(
                    flex: 9,
                    child: isLoading
                        ? const SizedBox.shrink()
                        : tempList.isEmpty
                            ? Center(
                                child: Text(
                                  'noStudentFound'.tr,
                                  style: const TextStyle(
                                      fontFamily: "Outift",
                                      fontSize: 16,
                                      fontWeight: FontWeight.w400,
                                      color: AppColors.secondary),
                                ),
                              )
                            : Padding(padding: const EdgeInsets.all(15).copyWith(bottom: 10),child: ScrollConfiguration(
                      behavior: const ScrollBehavior().copyWith(overscroll: false),
                      child: ListView.separated(
                          itemBuilder: (context, index) {
                            Datum data = tempList[index]!;
                            return Container(
                              width: MediaQuery.of(context).size.width,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  color: AppColors.primary.withOpacity(0.05)
                              ),
                              constraints: const BoxConstraints(
                                  minHeight: 50
                              ),
                              padding: const EdgeInsets.only(left: 10,top: 10),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Text("${data.begintime}-${data.endtime}",style: const TextStyle(
                                      fontFamily: "Outfit",
                                      fontWeight: FontWeight.w600,
                                      fontSize: 20,
                                      color: AppColors.primary
                                  ),),
                                  const SizedBox(height: 10,),
                                  Text(data.subName!.join("\n"),
                                    style: const TextStyle(
                                        fontFamily: "Outfit",
                                        fontSize: 14,
                                        fontWeight: FontWeight.w400,
                                        color: AppColors.secondary
                                    ),),
                                  const SizedBox(height: 10,)
                                ],
                              ),
                            );
                          },
                          separatorBuilder: (context,index){
                            return const SizedBox(height: 10,);
                          },
                          itemCount: tempList.length),
                    ),))
              ],
            ),
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

  void getSessionList() async {
    ApiClass httpService = ApiClass();
    SessionManagement sessionManagement = SessionManagement();
    int? role = await sessionManagement.getRole("Role");
    if (role == 0) {
      Studentlogin login = await sessionManagement.getModel('Student');
      String? token = login.basicAuthToken;
      dynamic response = await httpService.getTimeTable(token, widget.cid!,login.userdata.cookie ?? "");
      if (response['status']) {
        Timetablelist time = Timetablelist.fromJson(response);
        int day = getDay();
        setState(() {
          listOfSessionList = time.sessionList!;
          isSelects = day - 1;
          tempList = time.sessionList![isSelects].data!;
          isLoading = false;
        });
      } else {
        setState(() {
          isLoading = false;
        });
      }
    } else {
      Parentlogin parent = await sessionManagement.getModelParent('Parent');
      String token = parent.basicAuthToken;
      dynamic response = await httpService.getTimeTable(token, widget.cid!,parent.userdata.cookie ?? "");
      if (response['status']) {
        Timetablelist time = Timetablelist.fromJson(response);
        int day = getDay();
        setState(() {
          listOfSessionList = time.sessionList!;
          isSelects = day - 1;
          listOfSessionData = listOfSessionList[isSelects].data!;
          tempList = listOfSessionData;
          isLoading = false;
        });
      } else {
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  int getDay() {
    DateTime date = DateTime.now();
    if (date.weekday == 6 || date.weekday == 7 || date.weekday == 1) {
      return 1;
    } else {
      return date.weekday;
    }
  }

  onSearchTextChanged(String text) async {
    if (text.isEmpty) {
      setState(() {
        tempList = listOfSessionData;
      });
      return;
    }

    List<Datum> searchData = [];
    for (var userDetail in listOfSessionData) {
      String subNameString = userDetail!.subName!.join("\n");
      // bool checkExist = userDetail!.subName!.where((element) {
      //   return element!.isCaseInsensitiveContains(text);
      // }).isNotEmpty;
      subNameString.replaceAll("\n", " ");
      if(subNameString.contains(text)){
        searchData.add(userDetail);
      }
    }
    setState(() {
      tempList = searchData;
    });
  }
}
