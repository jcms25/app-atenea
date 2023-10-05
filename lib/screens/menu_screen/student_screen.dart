import 'package:colegia_atenea/models/Parent/Parentlogin.dart';
import 'package:colegia_atenea/models/Student/Studentlogin.dart';
import 'package:colegia_atenea/models/Studentlist.dart';
import 'package:colegia_atenea/screens/details_screen/student_detail_screen.dart';
import 'package:colegia_atenea/services/api_class.dart';
import 'package:colegia_atenea/services/session_mangement.dart';
import 'package:colegia_atenea/utils/app_colors.dart';
import 'package:colegia_atenea/utils/app_images.dart';
import 'package:colegia_atenea/utils/text_style.dart';
import 'package:colegia_atenea/widgets/custom_loader.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';

class studentscreen extends StatefulWidget {
  var cid;
  var wpid;

  studentscreen(this.cid, this.wpid);

  @override
  State<studentscreen> createState() => Students();
}

class Students extends State<studentscreen> {
  List<Studentlist> list_student = [];
  List<Studentlist> tempSearchList = [];
  TextEditingController search = TextEditingController();
  bool isLoading = true;
  String imagepath =
      "http://colegioatenea.embedinfosoft.com/wp-content/plugins/scl-rest-api/img/default_avtar.jpg";

  String exception = "";
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
              "student".tr,
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
                  AppImages.Arrow,
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
                child:  Container(
                  // height: 50,
                  margin: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: AppColors.white,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: TextField(
                    controller: search,
                    autofocus: false,
                    decoration: InputDecoration(
                        prefixIcon: IconButton(
                          icon: const Icon(
                            Icons.search,
                            color: AppColors.searchicon,
                          ),
                          onPressed: () {},
                        ),
                        hintText: 'searchInList'.tr,
                        hintStyle: TextStyle(
                          fontFamily: "Outfit",
                          fontWeight: FontWeight.w400,
                          fontSize: 16,
                          color: AppColors.secondary.withOpacity(0.5)
                        ),
                        // hintStyle: txtHintStyle,
                        // contentPadding: const EdgeInsets.all(10),
                        border: InputBorder.none),
                        cursorHeight: 25,
                        cursorColor: AppColors.primary,
                    //style: txtValueStyle,
                    keyboardType: TextInputType.text,
                    textInputAction: TextInputAction.next,
                    onChanged: onSearchTextChanged,
                  ),
                )),
            Text(exception),
            Expanded(
                child: isLoading ? const SizedBox.shrink() : tempSearchList.isNotEmpty
                    ? ListView.builder(
                    physics: const BouncingScrollPhysics(),
                    itemCount: tempSearchList.length,
                    itemBuilder: (context, position) {
                      Studentlist student = tempSearchList[position];
                      return GestureDetector(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => studentsdetails(
                                      student.wpUsrId,
                                      widget.wpid)));
                        },
                        child: Container(
                          margin: const EdgeInsets.only(
                              left: 20, right: 20, top: 10),
                          child: Padding(
                            padding: const EdgeInsets.only(top: 5),
                            child: Container(
                              // height: 120,
                              padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                  color: AppColors.primary
                                      .withOpacity(0.05),
                                  borderRadius: const BorderRadius.all(
                                      Radius.circular(15))),
                              child: Row(
                                children: [
                                  CircleAvatar(
                                    radius: 40,
                                    backgroundImage:  NetworkImage(student.stuImage!),
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
                                        Text(
                                          student.sFname ?? "",
                                          style: CustomStyle.calaender
                                              .copyWith(
                                              color: AppColors
                                                  .secondary),
                                        ),
                                        const SizedBox(height: 5,),
                                        Row(
                                          children: [
                                            SvgPicture.asset(
                                              AppImages.people,
                                              color:
                                              AppColors.primary,
                                            ),
                                            const SizedBox(
                                              width: 10,
                                            ),
                                            Expanded(child: Text(
                                              student.sLname ?? "",
                                              style: CustomStyle
                                                  .txtvalue1
                                                  .copyWith(
                                                  color: AppColors
                                                      .secondary),
                                            ))
                                          ],
                                        ),
                                        const SizedBox(height: 5,),
                                        Row(
                                          children: [
                                            SvgPicture.asset(
                                              AppImages.Person,
                                              height: 16,
                                              color:
                                              AppColors.primary,
                                            ),
                                            const SizedBox(
                                              width: 10,
                                            ),
                                            Text(
                                              student.sRollno ?? "",
                                              style: CustomStyle
                                                  .txtvalue1
                                                  .copyWith(
                                                  color: AppColors
                                                      .secondary),
                                            ),

                                          ],
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
                    })
                    : Center(child: Text('noStudentFound'.tr,style: CustomStyle.txtvalue,),)),
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

  void callAPI() async {
    Apiclass httpService = Apiclass();
    SessionManagement sessionManagement = SessionManagement();
    int? role = await sessionManagement.getRole("Role");
    if (role == 0) {
      Studentlogin login = await sessionManagement.getModel('Student');
      String? token = login.basicAuthToken;
      String cid = login.userdata.classId!;
      dynamic response = await httpService.getStudent(token, widget.cid);
      if (response['status']) {
        try{
          StudentList student = StudentList.fromJson(response);
          setState(() {
            list_student = student.studentlist;
            tempSearchList = list_student;
            isLoading = false;
          });
        }catch(excep,stacktrace){
          setState(() {
            isLoading = false;
          });
        }
      }else{
        setState(() {
          isLoading = false;
        });
      }
    } else {
      Parentlogin parent = await sessionManagement.getModelParent('Parent');
      String ptoken = parent.basicAuthToken;
      dynamic response = await httpService.getStudent(ptoken, widget.cid);
      if (response['status']) {
        StudentList student = StudentList.fromJson(response);
        setState(() {
          list_student = student.studentlist;
          tempSearchList = list_student;
          isLoading = false;
        });
      }else{
        Fluttertoast.showToast(msg: "$response");
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  onSearchTextChanged(String text) async {
    if (text.isEmpty) {
      setState(() {
        tempSearchList = list_student;
      });
      return;
    }

    List<Studentlist> searchData = [];
    for (var userDetail in list_student) {
      if (userDetail.sFname!.isCaseInsensitiveContains(text) ||
          userDetail.sRollno!.isCaseInsensitiveContains(text) ||
          userDetail.sLname!.isCaseInsensitiveContains(text)) {
        searchData.add(userDetail);
      }
    }

    setState(() {
      tempSearchList = searchData;
    });
  }
}
