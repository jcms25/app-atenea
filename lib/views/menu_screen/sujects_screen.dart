import 'package:colegia_atenea/models/Parent/Parentlogin.dart';
import 'package:colegia_atenea/models/Student/Studentlogin.dart';
import 'package:colegia_atenea/models/subjectlist.dart';
import 'package:colegia_atenea/views/details_screen/subject_detail_screen.dart';
import 'package:colegia_atenea/services/api_class.dart';
import 'package:colegia_atenea/services/session_management.dart';
import 'package:colegia_atenea/utils/app_colors.dart';
import 'package:colegia_atenea/utils/app_images.dart';
import 'package:colegia_atenea/widgets/custom_loader.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

class SubjectScreen extends StatefulWidget {
  final String cid;
  final String wpId;

  const SubjectScreen(this.cid, this.wpId, {super.key});

  @override
  State<SubjectScreen> createState() => _SubjectScreenChild();
}

class _SubjectScreenChild extends State<SubjectScreen> {
  List<Subjectlist> list = [];
  List<Subjectlist> tempList = [];
  TextEditingController search = TextEditingController();
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    callAPI();
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
              "subjects".tr,
              style: const TextStyle(
                  fontWeight: FontWeight.w500,
                  fontSize: 20,
                  fontFamily: 'Outfit'),
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
                                      // hintStyle: txtHintStyle,
                                      border: InputBorder.none),
                                  //  style: txtValueStyle,
                                  cursorColor: AppColors.primary,
                                  keyboardType: TextInputType.emailAddress,
                                  textInputAction: TextInputAction.next,
                                  onChanged: onSearchTextChanged,
                                ),
                              ),
                            ),
                          ],
                        ),
                      )),
                  Expanded(
                      flex: 9,
                      child: isLoading
                          ? const SizedBox.shrink()
                          : tempList.isEmpty
                              ? Center(
                                  child: Text(
                                    'noStudentFound'.tr,
                                    style: const TextStyle(
                                        fontFamily: "Outfit",
                                        fontWeight: FontWeight.w400,
                                        color: AppColors.secondary,
                                        fontSize: 16),
                                  ),
                                )
                              : Padding(padding: const EdgeInsets.all(10),child: ScrollConfiguration(
                        behavior: const ScrollBehavior().copyWith(overscroll: false),
                        child: ListView.separated(
                            itemBuilder: (context, index) {
                              return GestureDetector(
                                onTap: (){
                                  Navigator.push(context, MaterialPageRoute(builder: (context)=>subjectdetailscreen(tempList[index].id,tempList[index].group)));
                                },
                                child: Container(
                                  width: MediaQuery.of(context).size.width,
                                  constraints:
                                  const BoxConstraints(minHeight: 50),
                                  padding: const EdgeInsets.only(left: 10,top: 10,bottom: 10),
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                      color: AppColors.primary.withOpacity(0.05)
                                  ),
                                  child: Row(
                                    children: [
                                      Container(
                                        width:80,
                                        height: 80,
                                        padding: const EdgeInsets.all(10),
                                        decoration: BoxDecoration(
                                          color: AppColors.primary,
                                          borderRadius: BorderRadius.circular(5),
                                        ),
                                        child: SvgPicture.asset(AppImages.whiteBookIcon,fit: BoxFit.fill,),
                                      ),
                                      const SizedBox(width: 10,),
                                      Expanded(child: Text(
                                        tempList[index].subName ?? "-",
                                        style: const TextStyle(
                                            fontFamily: "Outfit",
                                            fontWeight: FontWeight.w400,
                                            fontSize: 20,
                                            color: AppColors.secondary
                                        ),
                                      ))
                                    ],
                                  ),
                                ),
                              );
                            },
                            separatorBuilder: (context, index) {
                              return const SizedBox(
                                height: 10,
                              );
                            },
                            itemCount: tempList.length),
                      ),
                      )),
                ]),
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

  void callAPI() async {
    ApiClass httpService = ApiClass();
    SessionManagement sessionManagement = SessionManagement();
    int? role = await sessionManagement.getRole("Role");
    if (role == 0) {
      Studentlogin login = await sessionManagement.getModel('Student');
      // String? id = login.userdata.classId;
      // String sid = login.userdata.wpUsrId!;
      String token = login.basicAuthToken;

      dynamic country =
          await httpService.getSubject(token, widget.wpId, widget.cid,login.userdata.cookie ?? "");
      if (country['status']) {
        SubjectList subject = SubjectList.fromJson(country);
        setState(() {
          list = subject.subjectlist;
          tempList = list;
          isLoading = false;
        });
      } else {
        setState(() {
          isLoading = false;
        });
      }
    } else {
      Parentlogin parent = await sessionManagement.getModelParent('Parent');
      String ptoken = parent.basicAuthToken;
      dynamic country =
          await httpService.getSubject(ptoken, widget.wpId, widget.cid,parent.userdata.cookie ?? "");
      if (country['status']) {
        SubjectList subject = SubjectList.fromJson(country);
        setState(() {
          list = subject.subjectlist;
          tempList = list;
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

    List<Subjectlist> searchData = [];
    for (var userDetail in list) {
      if (userDetail.subName?.isCaseInsensitiveContains(text) ?? false) {
        searchData.add(userDetail);
      }
    }

    setState(() {
      tempList = searchData;
    });
  }
}
