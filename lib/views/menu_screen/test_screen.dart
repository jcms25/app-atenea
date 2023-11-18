import 'package:auto_size_text/auto_size_text.dart';
import 'package:colegia_atenea/models/Parent/Parentlogin.dart';
import 'package:colegia_atenea/models/Student/Studentlogin.dart';
import 'package:colegia_atenea/models/examslists.dart';
import 'package:colegia_atenea/views/details_screen/test_detail_screen.dart';
import 'package:colegia_atenea/services/api_class.dart';
import 'package:colegia_atenea/services/session_management.dart';
import 'package:colegia_atenea/utils/app_colors.dart';
import 'package:colegia_atenea/utils/app_images.dart';
import 'package:colegia_atenea/utils/text_style.dart';
import 'package:colegia_atenea/widgets/custom_loader.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class TestScreen extends StatefulWidget {
  final String cid;
  final String wpId;

  const TestScreen(this.cid, this.wpId, {super.key});

  @override
  State<TestScreen> createState() => Tests();
}

class Tests extends State<TestScreen> {
  // // List<Exams> listExam = [];
  // List<Datum> year = [];
  // List<DatumDatum> month = [];
  // List<Datum> searchlist = [];
  // List<String> yearSelected = [];
  TextEditingController search = TextEditingController();
  bool isLoading = true;

  List<ExamItem> tempExamList = [];
  List<ExamItem> examList = [];

  @override
  void initState() {
    super.initState();
    getAllExamList();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    tempExamList.clear();
    examList.clear();
    search.dispose();
  }

  @override
  void deactivate() {
    // TODO: implement deactivate
    super.deactivate();
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
            "tests".tr,
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
          ),
        ),
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
                                    hintText: 'search',
                                    hintStyle: CustomStyle.textHintValue,
                                    contentPadding: const EdgeInsets.all(10),
                                    border: InputBorder.none),
                                style: CustomStyle.textValue,
                                keyboardType: TextInputType.emailAddress,
                                textInputAction: TextInputAction.next,
                                onChanged: onSearchTextChanged,
                                cursorColor: AppColors.primary,
                              ),
                            ),
                          ),
                        ],
                      ),
                    )),
                isLoading
                    ? const SizedBox.shrink()
                    : Expanded(child: SizedBox(
                  width: MediaQuery.of(context).size.width,
                  child: ScrollConfiguration(
                    behavior: const ScrollBehavior().copyWith(overscroll: false),
                    child: ListView.builder(
                        itemCount: tempExamList.length,
                        itemBuilder: (context,index){
                          return getExamItem(tempExamList[index]);
                        }
                    ),
                  ),
                )),
                const SizedBox(
                  height: 10,
                )
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

  void getAllExamList() async {
    ApiClass httpService = ApiClass();
    SessionManagement sessionManagement = SessionManagement();
    int? role = await sessionManagement.getRole("Role");
    if (role == 0) {
      Studentlogin login = await sessionManagement.getModel('Student');
      String? token = login.basicAuthToken;
      dynamic response =
          await httpService.getExamList(token, widget.wpId, widget.cid);
     setExamList(response);
    } else {
      Parentlogin parent = await sessionManagement.getModelParent('Parent');
      String ptoken = parent.basicAuthToken;

      dynamic response =
          await httpService.getExamList(ptoken, widget.wpId, widget.cid);
      setExamList(response);
    }
  }

  setExamList(dynamic response){
    if (response['status']) {
      Exam exam = Exam.fromJson(response);
      setState(() {
        // year = exam.data;
        tempExamList = exam.data!;
        examList = exam.data!;
        isLoading = false;
      });
    }
    else {
      setState(() {
        isLoading = false;
      });
    }
  }

  getExamItem(ExamItem examItem) {
      String month = getMonthInSpan(DateTime.parse(examItem.eSDate!).month);
      return GestureDetector(
        onTap: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => TestDetails(
                      examItem.eid!,examItem.sid!,examItem.professorName!)));

        },
        child: Container(
          margin:
          const EdgeInsets
              .only(
              left: 20,
              right: 20,
              top: 10),
          child: Padding(
            padding:
            const EdgeInsets
                .all(5),
            child:
            Container(
                decoration: BoxDecoration(
                    color: AppColors.primary.withOpacity(
                        0.05),
                    borderRadius: const BorderRadius.all(Radius.circular(
                        15))),
                child:
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                            margin: const EdgeInsets.all(15),
                            height: 80,
                            width: 80,
                            decoration: const BoxDecoration(color: AppColors.primary, borderRadius: BorderRadius.all(Radius.circular(10))),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(00),
                                  child: Text(
                                    DateFormat("dd").format(DateTime.parse(examItem.eSDate!)),
                                    style: CustomStyle.id,
                                  ),
                                ),
                                AutoSizeText("${month.length >= 5
                                    ? month.substring(0, 3)
                                    : month}\t${DateFormat("yyyy").format(DateTime.parse(examItem.eSDate!))}",
                                  style: CustomStyle.txtvalue1.copyWith(color: AppColors.white),
                                ),
                              ],
                            )),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(top: 10),
                                child: Text(
                                  examItem.eName!,
                                  style: CustomStyle.calendarTextStyle,
                                ),
                              ),
                              const SizedBox(
                                height: 5,
                              ),
                              Text(
                                examItem.subName!,
                                style: CustomStyle.textValue,
                              ),
                              const SizedBox(
                                height: 5,
                              ),
                              Text(
                                examItem.time!,
                                style: CustomStyle.hello.copyWith(color: AppColors.secondary),
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                  ],
                )),
          ),
        ),
      );
  }

  String getMonthInSpan(int month){
    switch(month){
      case 1 :
        return "enero";
      case 2 :
        return "febrero";
      case 3 :
        return "marzo";
      case 4 :
        return "abril";
      case 5 :
        return "mayo";
      case 6 :
        return "junio";
      case 7 :
        return "julio";
      case 8 :
        return "agosto";
      case 9 :
        return "septiembre";
      case 10:
        return "octubre";
      case 11:
        return "noviembre";
      default:
        return "diciembre ";
    }
  }

  // Widget getListView(List<Datum> year){
  //   return Expanded(
  //       child: year.isEmpty
  //           ? Center(
  //         child: Text("asList".tr),
  //       )
  //           : ScrollConfiguration(
  //           behavior: const ScrollBehavior()
  //               .copyWith(overscroll: false),
  //           child: ListView.builder(
  //               shrinkWrap: true,
  //               itemCount: year.isEmpty ? 0 : year.length,
  //               itemBuilder: (context, position) {
  //                 List<DatumDatum> monthWiseData =
  //                 List.from(
  //                     year[position].data.reversed);
  //                 return GestureDetector(
  //                     onTap: () {},
  //                     child: ListView.builder(
  //                         physics:
  //                         const NeverScrollableScrollPhysics(),
  //                         shrinkWrap: true,
  //                         reverse: true,
  //                         itemCount: year.isEmpty
  //                             ? 0
  //                             : monthWiseData.length,
  //                         itemBuilder: (context, index) {
  //                           return Column(
  //                             crossAxisAlignment:
  //                             CrossAxisAlignment.start,
  //                             children: [
  //                               monthWiseData[index]
  //                                   .data
  //                                   .isEmpty
  //                                   ? const SizedBox
  //                                   .shrink()
  //                                   : Padding(
  //                                 padding:
  //                                 const EdgeInsets
  //                                     .only(
  //                                     left: 20,
  //                                     right: 20,
  //                                     top: 10),
  //                                 child: Text(
  //                                   year.isEmpty
  //                                       ? "January"
  //                                       : "${monthWiseData[index].month} - ${year[position].year}",
  //                                   style: CustomStyle
  //                                       .appbartitle
  //                                       .copyWith(
  //                                       color: AppColors
  //                                           .primary,
  //                                       fontWeight:
  //                                       FontWeight
  //                                           .w600),
  //                                 ),
  //                               ),
  //                               ListView.builder(
  //                                   shrinkWrap: true,
  //                                   physics:
  //                                   const NeverScrollableScrollPhysics(),
  //                                   itemCount: year.isEmpty
  //                                       ? 0
  //                                       : monthWiseData[
  //                                   index]
  //                                       .data
  //                                       .length,
  //                                   itemBuilder:
  //                                       (context, item) {
  //                                     String date = year
  //                                         .isEmpty
  //                                         ? "15"
  //                                         : monthWiseData[
  //                                     index]
  //                                         .data[item]
  //                                         .eSDate
  //                                         .substring(
  //                                         0, 2);
  //                                     return GestureDetector(
  //                                       onTap: () {
  //                                         Navigator.push(
  //                                             context,
  //                                             MaterialPageRoute(
  //                                                 builder: (context) => TestDetails(
  //                                                     monthWiseData[index]
  //                                                         .data[
  //                                                     item]
  //                                                         .eid,
  //                                                     monthWiseData[index]
  //                                                         .data[
  //                                                     item]
  //                                                         .sid,
  //                                                     monthWiseData[index]
  //                                                         .data[item]
  //                                                         .professorname)));
  //                                       },
  //                                       child: Container(
  //                                         margin:
  //                                         const EdgeInsets
  //                                             .only(
  //                                             left: 20,
  //                                             right: 20,
  //                                             top: 10),
  //                                         child: Padding(
  //                                           padding:
  //                                           const EdgeInsets
  //                                               .only(
  //                                               top:
  //                                               00),
  //                                           child:
  //                                           Container(
  //                                               decoration: BoxDecoration(
  //                                                   color: AppColors.primary.withOpacity(
  //                                                       0.05),
  //                                                   borderRadius: const BorderRadius.all(Radius.circular(
  //                                                       15))),
  //                                               child:
  //                                               Column(
  //                                                 children: [
  //                                                   Row(
  //                                                     children: [
  //                                                       Container(
  //                                                           margin: const EdgeInsets.all(15),
  //                                                           height: 80,
  //                                                           width: 80,
  //                                                           decoration: const BoxDecoration(color: AppColors.primary, borderRadius: BorderRadius.all(Radius.circular(10))),
  //                                                           child: Column(
  //                                                             mainAxisAlignment: MainAxisAlignment.center,
  //                                                             children: [
  //                                                               Padding(
  //                                                                 padding: const EdgeInsets.all(00),
  //                                                                 child: Text(
  //                                                                   date,
  //                                                                   style: CustomStyle.id,
  //                                                                 ),
  //                                                               ),
  //                                                               Padding(
  //                                                                 padding: const EdgeInsets.only(
  //                                                                   left: 10,
  //                                                                   right: 10,
  //                                                                 ),
  //                                                                 child: Text(
  //                                                                   year.isEmpty
  //                                                                       ? "Jan".toString()
  //                                                                       : monthWiseData[index].month.length > 5
  //                                                                       ? monthWiseData[index].month.substring(0, 3)
  //                                                                       : monthWiseData[index].month,
  //                                                                   style: CustomStyle.txtvalue1.copyWith(color: AppColors.white),
  //                                                                 ),
  //                                                               ),
  //                                                             ],
  //                                                           )),
  //                                                       Expanded(
  //                                                         child: Column(
  //                                                           crossAxisAlignment: CrossAxisAlignment.start,
  //                                                           children: [
  //                                                             Padding(
  //                                                               padding: const EdgeInsets.only(top: 10),
  //                                                               child: Text(
  //                                                                 year.isEmpty ? "Subject name".toString() : monthWiseData[index].data[item].subName,
  //                                                                 style: CustomStyle.calaender,
  //                                                               ),
  //                                                             ),
  //                                                             const SizedBox(
  //                                                               height: 5,
  //                                                             ),
  //                                                             Text(
  //                                                               year.isEmpty ? "Exam Name".toString() : monthWiseData[index].data[item].eName,
  //                                                               style: CustomStyle.txtvalue,
  //                                                             ),
  //                                                             const SizedBox(
  //                                                               height: 5,
  //                                                             ),
  //                                                             Text(
  //                                                               year.isEmpty ? "hour".toString() : monthWiseData[index].data[item].time,
  //                                                               style: CustomStyle.hello.copyWith(color: AppColors.secondary),
  //                                                             ),
  //                                                             const SizedBox(
  //                                                               height: 10,
  //                                                             ),
  //                                                           ],
  //                                                         ),
  //                                                       )
  //                                                     ],
  //                                                   ),
  //                                                 ],
  //                                               )),
  //                                         ),
  //                                       ),
  //                                     );
  //                                   }),
  //                             ],
  //                           );
  //                         }));
  //               })));
  // }





  // Widget getFilterData() {
  //   List<Datum> yearList = [];
  //   filterData.forEach((key, value) {
  //   });
  //   return getListView(yearList);
  // }


  void onSearchTextChanged(String value) {
    if(value.isEmpty){
      setState(() {
        tempExamList = examList;
      });
    }else{
      List<ExamItem> searchedData = [];
      for(var examDetail in examList){
          if(examDetail.eName!.isCaseInsensitiveContains(value) || examDetail.subName!.isCaseInsensitiveContains(value)){
            searchedData.add(examDetail);
          }
      }
      setState(() {
        tempExamList = searchedData;
      });
    }
  }
}
