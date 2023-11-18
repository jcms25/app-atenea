import 'package:colegia_atenea/models/Parent/Parentlogin.dart';
import 'package:colegia_atenea/models/Student/Studentlogin.dart';
import 'package:colegia_atenea/models/teacherlist.dart';
import 'package:colegia_atenea/views/details_screen/teacher_details_screen.dart';
import 'package:colegia_atenea/services/api_class.dart';
import 'package:colegia_atenea/services/session_management.dart';
import 'package:colegia_atenea/utils/app_colors.dart';
import 'package:colegia_atenea/utils/app_images.dart';
import 'package:colegia_atenea/utils/text_style.dart';
import 'package:colegia_atenea/widgets/custom_loader.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

class TeacherScreen extends StatefulWidget {
  final String cid;
  final String wpId;

  const TeacherScreen(this.cid, this.wpId, {super.key});

  @override
  State<TeacherScreen> createState() => _TeacherScreenChild();
}

class _TeacherScreenChild extends State<TeacherScreen> {
  List<Teacherlist> list = [];
  List<Teacherlist> tempList = [];
  bool isLoading = true;
  String imagepath =
      "http://colegioatenea.embedinfosoft.com/wp-content/plugins/scl-rest-api/img/default_avtar.jpg";
  TextEditingController search = TextEditingController();

  @override
  void initState() {
    super.initState();
    getTeacherList();
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
              "teachers".tr,
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
            SizedBox(
                width: MediaQuery.of(context).size.width,
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
                                        contentPadding:
                                            const EdgeInsets.all(10),
                                        border: InputBorder.none),
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
                    Expanded(
                      child: isLoading ? const SizedBox.shrink() : tempList.isEmpty ? Center(
                        child: Text(
                          'noStudentFound'.tr,
                          style: const TextStyle(
                              fontFamily: "Outfit",
                              fontWeight: FontWeight.w400,
                              color: AppColors.secondary,
                              fontSize: 16),
                        ),
                      ) :
                      Padding(padding: const EdgeInsets.symmetric(vertical: 10),child: ScrollConfiguration(
                        behavior: const ScrollBehavior().copyWith(overscroll: false),
                        child: ListView.separated(itemBuilder: (context,index){
                          return GestureDetector(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => TeacherDetails(
                                          tempList[index].wpUsrId ?? "",
                                          tempList[index]
                                              .subjectName!
                                              .join("\n"),
                                          tempList[index].incharge!.join(" "))));
                            },
                            child: Container(
                              margin: const EdgeInsets.only(
                                  left: 20, right: 20, top: 10),
                              child: Padding(
                                padding: const EdgeInsets.only(top: 5),
                                child: Container(
                                  // height: 120,
                                  decoration: BoxDecoration(
                                      color: AppColors.primary
                                          .withOpacity(0.05),
                                      borderRadius:
                                      const BorderRadius.all(
                                          Radius.circular(15))),
                                  child: Row(
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: [
                                      // Container(
                                      //   margin:
                                      //   const EdgeInsets.all(10),
                                      //   height: 80,
                                      //   width: 80,
                                      //   decoration: const BoxDecoration(
                                      //       color: AppColors.primary,
                                      //       borderRadius:
                                      //       BorderRadius.all(
                                      //           Radius.circular(
                                      //               80))),
                                      //   child: ClipRRect(
                                      //     child: list.isEmpty ? Image.asset(AppImages.people) : list[position].image == null ? Image.asset(AppImages.people) : list[position].image!.isEmpty? Image.asset(AppImages.people):Image.network(list[position].image!),
                                      //   ),
                                      // ),
                                      const SizedBox(width: 10,),
                                      CircleAvatar(
                                        radius: 30,
                                        backgroundImage: NetworkImage(
                                            tempList[index].image!
                                        ),
                                        backgroundColor: AppColors.primary,
                                      ),
                                      const SizedBox(
                                        width: 20,
                                      ),
                                      Expanded(
                                        child: Column(
                                          mainAxisAlignment:
                                          MainAxisAlignment.center,
                                          crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                          children: [
                                            Padding(
                                              padding:
                                              const EdgeInsets.only(
                                                  top: 10),
                                              child: Text(
                                                "${tempList[index]
                                                    .firstName!}\t${tempList[index].lastName}",
                                                style: CustomStyle
                                                    .calendarTextStyle
                                                    .copyWith(
                                                    color: AppColors
                                                        .secondary),
                                              ),
                                            ),
                                            Padding(
                                              padding:
                                              const EdgeInsets.only(
                                                  top: 5, bottom: 10),
                                              child: Text(
                                                tempList[index]
                                                    .subjectName!
                                                    .join("\n"),
                                                style: CustomStyle.hello
                                                    .copyWith(
                                                    color: AppColors
                                                        .secondary),
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
                          );
                        }, separatorBuilder: (context,index){
                          return const SizedBox(height: 5,);
                        }, itemCount: tempList.length),
                      ),)
                    ),
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

  void getTeacherList() async {
    ApiClass httpService = ApiClass();
    SessionManagement sessionManagement = SessionManagement();
    int? role = await sessionManagement.getRole("Role");
    if (role == 0) {
      Studentlogin login = await sessionManagement.getModel('Student');
      String token = login.basicAuthToken;
      dynamic country =
          await httpService.getTeacher(token, widget.wpId, widget.cid);
      if (country['status']) {
        TeacherlistModel teacher = TeacherlistModel.fromJson(country);
        setState(() {
          list = teacher.teacherlist!;
          tempList = teacher.teacherlist!;
          isLoading = false;
        });
      }
      else {
        setState(() {
          isLoading = false;
        });
      }
    } else {
      Parentlogin parent = await sessionManagement.getModelParent('Parent');
      String ptoken = parent.basicAuthToken;
      dynamic country =
          await httpService.getTeacher(ptoken, widget.wpId, widget.cid);
      if (country['status']) {
        TeacherlistModel teacher = TeacherlistModel.fromJson(country);
          setState(() {
            list = teacher.teacherlist!;
          tempList = teacher.teacherlist!;
          isLoading = false;
        });
      } else {
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  onSearchTextChanged(String text) async {
    if (text.isEmpty) {
      setState(() {
        tempList = list;
      });
      return;
    }

    List<Teacherlist> searchData = [];
    for (var userDetail in list) {
      if (userDetail.firstName!.isCaseInsensitiveContains(text) ||
          userDetail.lastName!.isCaseInsensitiveContains(text)){
        searchData.add(userDetail);
      }
    }
    setState(() {
      tempList = searchData;
    });
  }
}
