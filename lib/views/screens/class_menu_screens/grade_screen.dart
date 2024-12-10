import 'package:colegia_atenea/models/login_model.dart';
import 'package:colegia_atenea/services/api_class.dart';
import 'package:colegia_atenea/services/app_shared_preferences.dart';
import 'package:colegia_atenea/utils/app_colors.dart';
import 'package:colegia_atenea/utils/app_images.dart';
import 'package:colegia_atenea/utils/text_style.dart';
import 'package:colegia_atenea/views/custom_widgets/custom_loader.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

import '../../../models/student_marklist_format.dart';

class GradeScreen extends StatefulWidget {
  final String cid;
  final String wpId;

  const GradeScreen(this.cid, this.wpId, {super.key});

  @override
  State<GradeScreen> createState() => _GradeScreenChild();
}

class _GradeScreenChild extends State<GradeScreen> {
  TextEditingController search = TextEditingController();
  bool isLoading = true;
  List<Markslist> listMarks = [];
  List<Markslist> tempList = [];

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
              "grades".tr,
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
                  colorFilter: const ColorFilter.mode(AppColors.orange, BlendMode.srcIn)
                ),
              ),
            )),
        body: Stack(
          children: [
            Column(
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
                                maxLines: 1,
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
                                    contentPadding: const EdgeInsets.all(10),
                                    border: InputBorder.none),
                                cursorColor: AppColors.primary,
                                style: CustomStyle.textValue,
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
                    child: isLoading ? const SizedBox.shrink() : tempList.isEmpty ? Center(
                      child: Text('noStudentFound'.tr,style: const TextStyle(
                        fontFamily: "Outfit",
                        fontSize: 18,
                        fontWeight: FontWeight.w400,
                        color: AppColors.secondary
                      ),),
                    ) : Padding(padding: const EdgeInsets.symmetric(vertical: 10),child: ListView.separated(
                      physics: const BouncingScrollPhysics(),
                      itemCount: tempList.length,
                      itemBuilder: (context, position) {
                        Markslist data = tempList[position];
                        return Column(
                          children: [
                            Container(
                                margin: const EdgeInsets.symmetric(horizontal: 20),
                                padding: const EdgeInsets.all(15),
                                decoration: BoxDecoration(
                                    color: AppColors.primary
                                        .withOpacity(0.05),
                                    borderRadius:
                                    const BorderRadius.all(
                                        Radius.circular(15))),
                                child: Column(
                                  crossAxisAlignment:
                                  CrossAxisAlignment.start,
                                  children: [
                                    Container(
                                        height: 30,
                                        width: 100,
                                        decoration:
                                        const BoxDecoration(
                                            color:
                                            AppColors.primary,
                                            borderRadius:
                                            BorderRadius.all(
                                                Radius
                                                    .circular(
                                                    10))),
                                        child: Center(
                                          child: (Text(
                                            data.sDate!,
                                            style: CustomStyle
                                                .txtvalue1
                                                .copyWith(
                                                color: AppColors
                                                    .white),
                                          )),
                                        )),
                                    const SizedBox(
                                      height: 20,
                                    ),
                                    Row(
                                      children: [
                                        Expanded(
                                          child: Text("subject".tr,
                                              style: CustomStyle.hello
                                                  .copyWith(
                                                  color: AppColors
                                                      .secondary
                                                      .withOpacity(
                                                      0.5))),
                                        ),
                                        Expanded(
                                            child: Text(
                                                tempList[position]
                                                    .subjectName!,
                                                style: CustomStyle
                                                    .hello
                                                    .copyWith(
                                                    color: AppColors
                                                        .secondary,
                                                    fontWeight:
                                                    FontWeight
                                                        .w600)))
                                      ],
                                    ),
                                    const SizedBox(
                                      height: 5,
                                    ),
                                    CustomStyle.dottedLine,
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    Row(
                                      children: [
                                        Expanded(
                                          child: Text("examname".tr,
                                              style: CustomStyle.hello
                                                  .copyWith(
                                                  color: AppColors
                                                      .secondary
                                                      .withOpacity(
                                                      0.5))),
                                        ),
                                        Expanded(
                                            child: Text(
                                                tempList[
                                                position]
                                                    .examNm!,
                                                style: CustomStyle
                                                    .hello
                                                    .copyWith(
                                                    color: AppColors
                                                        .secondary,
                                                    fontWeight:
                                                    FontWeight
                                                        .w600)))
                                      ],
                                    ),
                                    const SizedBox(
                                      height: 5,
                                    ),
                                    CustomStyle.dottedLine,
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    Row(
                                      children: [
                                        Expanded(
                                          child: Text("grade".tr,
                                              style: CustomStyle.hello
                                                  .copyWith(
                                                  color: AppColors
                                                      .secondary
                                                      .withOpacity(
                                                      0.5))),
                                        ),
                                        Expanded(
                                            child: Text(
                                                tempList[
                                                position]
                                                    .mark!,
                                                style: CustomStyle
                                                    .hello
                                                    .copyWith(
                                                    color: AppColors
                                                        .secondary,
                                                    fontWeight:
                                                    FontWeight
                                                        .w600)))
                                      ],
                                    ),
                                    const SizedBox(
                                      height: 5,
                                    ),
                                    CustomStyle.dottedLine,
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    Visibility(
                                        // visible: RegExp(r'[1-9] | 10 | [a-zA-Z]*').hasMatch(tempList[position].remarks!),
                                        visible: tempList[position].remarks != null && tempList[position].remarks!.isNotEmpty,
                                        child: Column(
                                          children: [
                                            Row(
                                              children: [
                                                Expanded(
                                                  child: Text("obser".tr,
                                                      style: CustomStyle.hello
                                                          .copyWith(
                                                          color: AppColors
                                                              .secondary
                                                              .withOpacity(
                                                              0.5))),
                                                ),
                                                Expanded(
                                                    child: Text(
                                                        tempList[
                                                        position].remarks ?? "-",
                                                        style: CustomStyle
                                                            .hello
                                                            .copyWith(
                                                            color: AppColors
                                                                .secondary,
                                                            fontWeight:
                                                            FontWeight
                                                                .w600)))
                                              ],
                                            ),
                                            const SizedBox(
                                              height: 5,
                                            ),
                                            CustomStyle.dottedLine,
                                            const SizedBox(
                                              height: 10,
                                            ),
                                          ],
                                        )),

                                  ],
                                ))
                          ],
                        );
                      }, separatorBuilder: (BuildContext context, int index) { return const SizedBox(height: 10,); },),)
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

  void callAPI() async {

    try{
      LoginModel? loginModel = AppSharedPreferences.getUserData();


      dynamic response =
      await ApiClass().getMarks(loginModel?.basicAuthToken ?? "", widget.wpId, widget.cid,loginModel?.userdata?.cookies ?? "");
      if (response['status']) {
        MarkList studentMarks = MarkList.fromJson(response);
        setState(() {
          listMarks = studentMarks.markslist;
          tempList = studentMarks.markslist;
          isLoading = false;
        });
      } else {
        setState(() {
          isLoading = false;
        });
      }
    }catch(exception){
      setState(() {
        isLoading = false;
      });
    }


    // ApiClass httpService = ApiClass();
    // SessionManagement sessionManagement = SessionManagement();
    // int? role = await sessionManagement.getRole("Role");
    // if (role == 0) {
    //   Studentlogin login = await sessionManagement.getModel('Login');
    //   String? token = login.basicAuthToken;
    //   dynamic response =
    //       await httpService.getMarks(token, widget.wpId, widget.cid,login.userdata.cookie ?? "");
    //   if (response['status']) {
    //     MarkList studentMarks = MarkList.fromJson(response);
    //     setState(() {
    //       listMarks = studentMarks.markslist;
    //       tempList = studentMarks.markslist;
    //       isLoading = false;
    //     });
    //   } else {
    //     setState(() {
    //       isLoading = false;
    //     });
    //   }
    // } else {
    //   Parentlogin parent = await sessionManagement.getModelParent('Parent');
    //   String ptoken = parent.basicAuthToken;
    //   dynamic response =
    //       await httpService.getMarks(ptoken, widget.wpId, widget.cid,parent.userdata.cookie ?? "");
    //   if (response['status']) {
    //     MarkList studentMarks = MarkList.fromJson(response);
    //     setState(() {
    //       listMarks = studentMarks.markslist;
    //       tempList = studentMarks.markslist;
    //       isLoading = false;
    //     });
    //   } else {
    //     setState(() {
    //       isLoading = false;
    //     });
    //   }
    // }
  }

  onSearchTextChanged(String text) async {

    if (text.isEmpty) {
      setState(() {
        tempList = listMarks;
      });
      return;
    }

    List<Markslist> searchData = [];
    for (var userDetail in listMarks) {
      if(userDetail.subjectName!.isCaseInsensitiveContains(text) || userDetail.examNm!.isCaseInsensitiveContains(text) || userDetail.sDate!.isCaseInsensitiveContains(text)){
        searchData.add(userDetail);
      }
    }

    setState(() {
      tempList = searchData;
    });
  }
}
