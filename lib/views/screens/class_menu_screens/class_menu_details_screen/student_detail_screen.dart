import 'package:auto_size_text/auto_size_text.dart';
import 'package:colegia_atenea/models/Parent/Parentlogin.dart';
import 'package:colegia_atenea/models/Student/Studentlogin.dart';
import 'package:colegia_atenea/models/Studentdetaillist.dart';
import 'package:colegia_atenea/models/login_model.dart';
import 'package:colegia_atenea/services/api_class.dart';
import 'package:colegia_atenea/services/app_shared_preferences.dart';
import 'package:colegia_atenea/services/session_management.dart';
import 'package:colegia_atenea/utils/app_colors.dart';
import 'package:colegia_atenea/utils/app_images.dart';
import 'package:colegia_atenea/utils/text_style.dart';
import 'package:colegia_atenea/views/custom_widgets/custom_loader.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';


class StudentDetails extends StatefulWidget {
  final String sid;
  final String pValue;

  const StudentDetails({super.key,required this.sid,required this.pValue});

  @override
  State<StudentDetails> createState() => _StudentDetailsChild();
}

class _StudentDetailsChild extends State<StudentDetails> {
  Studentdetaillist? studentDetails;
  List<ParentsDatum> listOfParent = [];
  String name = "";
  String lastName = "";
  String bloodGroup = "";
  String dob = "";
  String address = "";
  String city = "";
  String pinCode = "";
  String countryName = "";
  String datOfJoining = "";
  String cid = "";
  String rollNo = "";
  String imagePath = "";
  String pName = "";
  String email = "";
  String phone = "";
  String gender = "";
  String profession = "";
  bool isLoading = true;
  bool isAddressVisible = false;

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
            title: Text("studentdetail".tr,style: CustomStyle.appBarTitle,),
            leading: Container(
              margin: const EdgeInsets.all(10),
              child: GestureDetector(
                onTap: () {
                  Navigator.pop(context);
                },
                child: SvgPicture.asset(
                  AppImages.arrow,
                  colorFilter: const ColorFilter.mode(AppColors.orange, BlendMode.srcIn),),
              ),
            )),
        body: Stack(
          children: [
            Container(
              color: AppColors.primary,
              child: SafeArea(
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
                      child: Stack(
                        alignment: Alignment.topCenter,
                        children: [
                          Container(
                            margin:
                            const EdgeInsets.only(top: 100, bottom: 20),
                            decoration: const BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.only(
                                    topRight: Radius.circular(30),
                                    topLeft: Radius.circular(30))),
                            child: Column(
                              //crossAxisAlignment: CrossAxisAlignment.start,
                              // mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Column(
                                  crossAxisAlignment:
                                  CrossAxisAlignment.start,
                                  children: [
                                    Container(
                                      padding:
                                      const EdgeInsets.only(top: 70),
                                      margin: const EdgeInsets.only(
                                          left: 20, right: 20, top: 10),
                                      child: Column(
                                        crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                bottom: 20),
                                            child: Column(
                                              crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                              children: [
                                                Container(
                                                    width:MediaQuery.of(context).size.width,
                                                    margin:const EdgeInsets.symmetric(horizontal: 60),
                                                    child:Center(
                                                      // child:  AutoSizeText(
                                                      //   textAlign: TextAlign.center,
                                                      //   maxLines:5,
                                                      //   "$name\n$lastName",
                                                      //   style: CustomStyle.login,
                                                      //   minFontSize: 20,
                                                      //
                                                      // ),
                                                      child: Text(
                                                        "$name\n$lastName",
                                                        style: CustomStyle.login.copyWith(fontSize: 22),
                                                        textAlign: TextAlign.center,
                                                      ),
                                                    )
                                                ),
                                                Container(
                                                  margin: const EdgeInsets.only(
                                                      top: 20),
                                                  child: Column(
                                                    mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .start,
                                                    crossAxisAlignment:
                                                    CrossAxisAlignment
                                                        .start,
                                                    children: [
                                                      Padding(
                                                        padding:
                                                        const EdgeInsets.only(
                                                            top: 15),
                                                        child: Text(
                                                          "dob".tr,style: CustomStyle.textValue.copyWith(color: AppColors.secondary.withOpacity(0.75)),
                                                        ),
                                                      ),
                                                      Padding(
                                                          padding:
                                                          const EdgeInsets.only(
                                                              top: 10),
                                                          child: Container(
                                                              width: 350,
                                                              height: 60,
                                                              decoration: BoxDecoration(
                                                                  borderRadius:
                                                                  BorderRadius.circular(
                                                                      12),
                                                                  color: AppColors
                                                                      .secondary
                                                                      .withOpacity(
                                                                      0.06)),
                                                              child: Padding(
                                                                padding:
                                                                const EdgeInsets
                                                                    .all(
                                                                    15),
                                                                child: Text(
                                                                  dob,
                                                                  textAlign:
                                                                  TextAlign
                                                                      .left,
                                                                  style: CustomStyle.textHintValue.copyWith(color: AppColors.secondary),
                                                                ),
                                                              ))),
                                                      Padding(
                                                        padding:
                                                        const EdgeInsets.only(
                                                            top: 20),
                                                        child: Text(
                                                          "address".tr,style: CustomStyle.textValue.copyWith(
                                                            fontWeight: FontWeight.w600,
                                                            color: AppColors.secondary),
                                                        ),
                                                      ),
                                                      Visibility(
                                                        visible: isAddressVisible,
                                                        child: Column(
                                                          crossAxisAlignment: CrossAxisAlignment.start,
                                                            children : [
                                                              Padding(
                                                                padding:
                                                                const EdgeInsets.only(
                                                                    top: 20),
                                                                child: Text(
                                                                  "streetaddress".tr,style: CustomStyle.textValue,

                                                                ),
                                                              ),
                                                              Padding(
                                                                  padding:
                                                                  const EdgeInsets.only(
                                                                      top: 10),
                                                                  child: Container(
                                                                      width: 350,
                                                                      height: 100,
                                                                      decoration: BoxDecoration(
                                                                          borderRadius:
                                                                          BorderRadius.circular(
                                                                              12),
                                                                          color: AppColors
                                                                              .secondary
                                                                              .withOpacity(
                                                                              0.06)),
                                                                      child: Padding(
                                                                        padding:
                                                                        const EdgeInsets
                                                                            .all(
                                                                            15),
                                                                        child: Text(
                                                                          address,
                                                                          textAlign:
                                                                          TextAlign
                                                                              .left,
                                                                          style: CustomStyle.textHintValue.copyWith(color: AppColors.secondary,),

                                                                        ),
                                                                      )))
                                                            ]
                                                        ),
                                                      ),
                                                      Padding(
                                                        padding:
                                                        const EdgeInsets.only(
                                                            top: 15),
                                                        child: Row(
                                                          children: [
                                                            Expanded(
                                                              child: Row(
                                                                children: [
                                                                  Expanded(
                                                                      child:
                                                                      Text(
                                                                        "city".tr,style: CustomStyle.textValue.copyWith(color: AppColors.secondary.withOpacity(0.75)),
                                                                      )),
                                                                  const SizedBox(
                                                                    width: 30,
                                                                  ),
                                                                  Expanded(
                                                                      child:
                                                                      Text(
                                                                        "pincode".tr,style: CustomStyle.textValue.copyWith(color: AppColors.secondary.withOpacity(0.75)),
                                                                      ))
                                                                ],
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                      Padding(
                                                        padding:
                                                        const EdgeInsets.only(
                                                            top: 10),
                                                        child: Row(
                                                          children: [
                                                            Expanded(
                                                              child: Row(
                                                                children: [
                                                                  Expanded(
                                                                      child: Container(
                                                                          height: 60,
                                                                          decoration: BoxDecoration(borderRadius: BorderRadius.circular(12), color: AppColors.secondary.withOpacity(0.06)),
                                                                          child: Padding(
                                                                            padding: const EdgeInsets.all(15),
                                                                            child: Text(
                                                                              city,
                                                                              textAlign: TextAlign.left,
                                                                              style: CustomStyle.textHintValue.copyWith(color: AppColors.secondary,),

                                                                            ),
                                                                          ))),
                                                                  const SizedBox(
                                                                    width: 20,
                                                                  ),
                                                                  Expanded(
                                                                      child: Container(
                                                                          height: 60,
                                                                          decoration: BoxDecoration(borderRadius: BorderRadius.circular(12), color: AppColors.secondary.withOpacity(0.06)),
                                                                          child: Padding(
                                                                            padding: const EdgeInsets.all(15),
                                                                            child: Text(
                                                                              pinCode,
                                                                              textAlign: TextAlign.left,
                                                                              style: CustomStyle.textHintValue.copyWith(color: AppColors.secondary,),

                                                                            ),
                                                                          ))),
                                                                ],
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                      Padding(
                                                        padding:
                                                        const EdgeInsets.only(
                                                            top: 15),
                                                        child: Text(
                                                          "country".tr,style: CustomStyle.textValue.copyWith(color: AppColors.secondary.withOpacity(0.75)),

                                                        ),
                                                      ),
                                                      Padding(
                                                          padding:
                                                          const EdgeInsets.only(
                                                              top: 10),
                                                          child: Container(
                                                              width: 350,
                                                              height: 60,
                                                              decoration: BoxDecoration(
                                                                  borderRadius:
                                                                  BorderRadius.circular(
                                                                      12),
                                                                  color: AppColors
                                                                      .secondary
                                                                      .withOpacity(
                                                                      0.06)),
                                                              child: Padding(
                                                                padding:
                                                                const EdgeInsets
                                                                    .all(
                                                                    15),
                                                                child: Text(
                                                                  countryName,
                                                                  textAlign:
                                                                  TextAlign
                                                                      .left,
                                                                  style: CustomStyle.textHintValue.copyWith(color: AppColors.secondary,),
                                                                ),
                                                              ))),
                                                      Padding(
                                                        padding:
                                                        const EdgeInsets.only(
                                                            top: 15),
                                                        child: Text(
                                                          "Email",style: CustomStyle.textValue.copyWith(color: AppColors.secondary.withOpacity(0.75)),

                                                        ),
                                                      ),
                                                      Padding(
                                                          padding:
                                                          const EdgeInsets.only(
                                                              top: 10),
                                                          child: Container(
                                                              width: 350,
                                                              height: 60,
                                                              decoration: BoxDecoration(
                                                                  borderRadius:
                                                                  BorderRadius.circular(
                                                                      12),
                                                                  color: AppColors
                                                                      .secondary
                                                                      .withOpacity(
                                                                      0.06)),
                                                              child: Padding(
                                                                padding:
                                                                const EdgeInsets
                                                                    .all(
                                                                    15),
                                                                child: Text(
                                                                  email,
                                                                  textAlign:
                                                                  TextAlign
                                                                      .left,
                                                                  style: CustomStyle.textHintValue.copyWith(color: AppColors.secondary,),
                                                                ),
                                                              ))),
                                                      Padding(
                                                          padding:
                                                          const EdgeInsets.only(
                                                              top: 20),
                                                          child: Text(
                                                            "schooldetail".tr,style: CustomStyle.textValue.copyWith(color: AppColors.secondary,fontWeight: FontWeight.w600),

                                                          )),
                                                      Padding(
                                                        padding:
                                                        const EdgeInsets.only(
                                                            top: 15),
                                                        child: Text(
                                                          "doj".tr,style: CustomStyle.textValue.copyWith(color: AppColors.secondary.withOpacity(0.75)),

                                                        ),
                                                      ),
                                                      Padding(
                                                          padding:
                                                          const EdgeInsets.only(
                                                              top: 10),
                                                          child: Container(
                                                              width: 350,
                                                              height: 60,
                                                              decoration: BoxDecoration(
                                                                  borderRadius:
                                                                  BorderRadius.circular(
                                                                      12),
                                                                  color: AppColors
                                                                      .secondary
                                                                      .withOpacity(
                                                                      0.06)),
                                                              child: Padding(
                                                                padding:
                                                                const EdgeInsets
                                                                    .all(
                                                                    15),
                                                                child: Text(
                                                                  datOfJoining,
                                                                  textAlign:
                                                                  TextAlign
                                                                      .left,
                                                                  style: CustomStyle.textHintValue.copyWith(color: AppColors.secondary,),

                                                                ),
                                                              ))),
                                                      Padding(
                                                        padding:
                                                        const EdgeInsets.only(
                                                            top: 15),
                                                        child: Row(
                                                          children: [
                                                            Expanded(
                                                              child: Row(
                                                                children: [
                                                                  Expanded(
                                                                      child:
                                                                      Text(
                                                                        "class".tr,style: CustomStyle.textValue.copyWith(color: AppColors.secondary.withOpacity(0.75)),

                                                                      )),
                                                                  const SizedBox(
                                                                    width: 30,
                                                                  ),
                                                                  Expanded(
                                                                      child:
                                                                      Text(
                                                                        "rollno".tr,style: CustomStyle.textValue.copyWith(color: AppColors.secondary.withOpacity(0.75)),

                                                                      ))
                                                                ],
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                      Padding(
                                                        padding:
                                                        const EdgeInsets.only(
                                                            top: 10),
                                                        child: Row(
                                                          children: [
                                                            Expanded(
                                                              child: Row(
                                                                children: [
                                                                  Expanded(
                                                                      child: Container(
                                                                          height: 60,
                                                                          decoration: BoxDecoration(borderRadius: BorderRadius.circular(12), color: AppColors.secondary.withOpacity(0.06)),
                                                                          child: Padding(
                                                                            padding: const EdgeInsets.all(15),
                                                                            child: Text(
                                                                              cid,
                                                                              textAlign: TextAlign.left,
                                                                              style: CustomStyle.textHintValue.copyWith(color: AppColors.secondary,),


                                                                            ),
                                                                          ))),
                                                                  const SizedBox(
                                                                    width: 20,
                                                                  ),
                                                                  Expanded(
                                                                      child: Container(
                                                                          height: 60,
                                                                          decoration: BoxDecoration(borderRadius: BorderRadius.circular(12), color: AppColors.secondary.withOpacity(0.06)),
                                                                          child: Padding(
                                                                            padding: const EdgeInsets.all(15),
                                                                            child: Text(
                                                                              rollNo,
                                                                              textAlign: TextAlign.left,
                                                                              style: CustomStyle.textHintValue.copyWith(color: AppColors.secondary,),

                                                                            ),
                                                                          ))),
                                                                ],
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                )
                                              ],
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                    Visibility(
                                        visible: widget.sid==widget.pValue,
                                        child: Container(
                                          margin: const EdgeInsets.all(0),
                                          child: ListView.builder(
                                              physics:
                                              const NeverScrollableScrollPhysics(),
                                              shrinkWrap: true,
                                              itemCount: listOfParent.length,
                                              itemBuilder:
                                                  (context, position) {
                                                return Container(
                                                    padding: const EdgeInsets.only(
                                                        left: 20, right: 20),
                                                    child: Column(
                                                        crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                        children: [
                                                          const SizedBox(height: 15,),
                                                          Text(
                                                            listOfParent[position].pGender=="Male"?"parentsdetail".tr:"parentsdetail2".tr,style: CustomStyle.textValue.copyWith(color: AppColors.secondary,fontWeight: FontWeight.w600),
                                                          ),
                                                          const SizedBox(height: 10,),
                                                          Text(
                                                            listOfParent[position].pGender=="Male"?"pname".tr:"pname2".tr,style: CustomStyle.textValue.copyWith(color: AppColors.secondary.withOpacity(0.75)),
                                                          ),
                                                          const SizedBox(height: 10,),
                                                          Container(
                                                              width:
                                                              350,
                                                              height:
                                                              60,
                                                              decoration: BoxDecoration(
                                                                  borderRadius: BorderRadius.circular(
                                                                      12),
                                                                  color: AppColors.secondary.withOpacity(
                                                                      0.06)),
                                                              child:
                                                              Padding(
                                                                padding:
                                                                const EdgeInsets.all(15),
                                                                child:
                                                                Text(
                                                                  "${listOfParent[position].pFname}\t${listOfParent[position].pLname}",
                                                                  textAlign:
                                                                  TextAlign.left,
                                                                  style: CustomStyle.textHintValue.copyWith(color: AppColors.secondary,),
                                                                ),
                                                              )),
                                                          const SizedBox(height: 15,),
                                                          Text(
                                                            listOfParent[position].pGender=="Male"?"pemail".tr:"pemail".tr,style: CustomStyle.textValue.copyWith(color: AppColors.secondary.withOpacity(0.75)),
                                                          ),
                                                          const SizedBox(height: 10,),
                                                          Container(
                                                              width:
                                                              350,
                                                              height:
                                                              60,
                                                              decoration: BoxDecoration(
                                                                  borderRadius: BorderRadius.circular(
                                                                      12),
                                                                  color: AppColors.secondary.withOpacity(
                                                                      0.06)),
                                                              child:
                                                              Padding(
                                                                padding:
                                                                const EdgeInsets.all(15),
                                                                child:
                                                                Text(
                                                                  listOfParent[position].parentEmail ?? "-",
                                                                  textAlign:
                                                                  TextAlign.left,
                                                                  style: CustomStyle.textHintValue.copyWith(color: AppColors.secondary,),
                                                                ),
                                                              )),
                                                          const SizedBox(height: 15,),
                                                          Text(
                                                            "mobile".tr,style: CustomStyle.textValue.copyWith(color: AppColors.secondary.withOpacity(0.75)),
                                                          ),
                                                          const SizedBox(height: 10,),
                                                          Container(
                                                              width:
                                                              350,
                                                              height:
                                                              60,
                                                              decoration: BoxDecoration(
                                                                  borderRadius: BorderRadius.circular(
                                                                      12),
                                                                  color: AppColors.secondary.withOpacity(
                                                                      0.06)),
                                                              child:
                                                              Padding(
                                                                padding:
                                                                const EdgeInsets.all(15),
                                                                child:
                                                                Text(
                                                                  listOfParent[position].pPhone ?? "-",
                                                                  textAlign:
                                                                  TextAlign.left,
                                                                  style: CustomStyle.textHintValue.copyWith(color: AppColors.secondary,),
                                                                ),
                                                              )),
                                                          const SizedBox(height: 15,),
                                                          Row(
                                                            children: [
                                                              Expanded(
                                                                child: Row(
                                                                  children: [
                                                                    Expanded(
                                                                        child:
                                                                        Text(
                                                                          listOfParent[position].pGender=="Male"?"parentpro".tr:"parentpro".tr,style: CustomStyle.textValue.copyWith(color: AppColors.secondary.withOpacity(0.75)),
                                                                        ))
                                                                  ],
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                          const SizedBox(height: 15,),
                                                          Row(
                                                            children: [
                                                              Expanded(
                                                                child: Row(
                                                                  children: [
                                                                    Expanded(
                                                                        child: Container(
                                                                            height: 60,
                                                                            decoration: BoxDecoration(borderRadius: BorderRadius.circular(12), color: AppColors.secondary.withOpacity(0.06)),
                                                                            child:  Padding(
                                                                              padding: const EdgeInsets.all(15),
                                                                              child: Text(
                                                                                listOfParent[position].pProfession ?? "-",
                                                                                textAlign: TextAlign.left,
                                                                                style: CustomStyle.textHintValue.copyWith(color: AppColors.secondary,),
                                                                              ),
                                                                            ))),
                                                                  ],
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                          const SizedBox(height: 15,)
                                                        ]));
                                              }),
                                        )),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          Container(
                            margin: const EdgeInsets.only(top: 20),
                            height: 140,
                            width: 140,
                            decoration: BoxDecoration(
                              color: AppColors.white,
                              border: Border.all(
                                  color: AppColors.primary,
                                  width: 3.0,
                                  style: BorderStyle.solid),
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(160)),
                              boxShadow: [
                                BoxShadow(
                                  color: AppColors.primary.withOpacity(0.5),
                                  spreadRadius: 0,
                                  blurRadius: 25,
                                  offset: const Offset(
                                      0, 0), // changes position of shadow
                                ),
                              ],
                            ),
                            child: imagePath.isEmpty ? Center(child:  SvgPicture.asset(AppImages.people,width: 100,height: 100,

                                colorFilter: const ColorFilter.mode(AppColors.orange, BlendMode.srcIn),
                            ),) : CircleAvatar(
                              radius: 16.0,
                              // child: ClipRRect(
                              //   child: Image.network(
                              //     imagepath.isEmpty
                              //         ? "http://colegioatenea.embedinfosoft.com/wp-content/plugins/scl-rest-api/img/default_avtar.jpg"
                              //         : imagepath,
                              //     height: 180,
                              //     width: 180,
                              //     fit: BoxFit.fitHeight,
                              //   ),
                              //   borderRadius: BorderRadius.circular(180.0),
                              // ),
                              backgroundImage: NetworkImage(imagePath),
                              backgroundColor: AppColors.primary,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Visibility(
                visible: isLoading,
                child:  Container(
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


    LoginModel? loginModel = AppSharedPreferences.getUserData();
      String userRole = AppSharedPreferences.getUserLoggedInRole() ?? "";
      String  token= loginModel?.basicAuthToken ?? "";
      dynamic country = await ApiClass().getStudentDetail(token,widget.sid,loginModel?.userdata?.cookies ?? "");
      if(country['status']){
        try{
          Studentdetaillist student=Studentdetaillist.fromJson(country);

          setState(() {
            studentDetails = student;
            listOfParent=studentDetails!.studentDetails.parentData;
            name=studentDetails!.studentDetails.sFname ?? "";
            lastName = studentDetails!.studentDetails.sLname ?? "";
            bloodGroup=studentDetails!.studentDetails.sBloodgrp ?? "";
            dob= studentDetails!.studentDetails.sDob == null ? "-" : DateFormat("dd/MM/yyyy").format(studentDetails!.studentDetails.sDob!);
            address=studentDetails!.studentDetails.sAddress ?? "";
            city=studentDetails!.studentDetails.sCity ?? "";
            pinCode=studentDetails!.studentDetails.sZipcode ?? "";
            countryName=studentDetails!.studentDetails.sCountry ?? "";
            cid=studentDetails!.studentDetails.className ?? "";
            rollNo=studentDetails!.studentDetails.sRollno ?? "";
            email = studentDetails!.studentDetails.stuEmail ?? "";

            if(userRole == "student"){

              isAddressVisible = loginModel?.userdata?.wpUsrId == widget.sid ? true : false;

            }else{
                    for (var element in loginModel?.userdata?.studentData ?? []) {
                      if(element.wpUsrId == widget.sid){
                        isAddressVisible = true;
                        break;
                      }
                    }
            }
            // Doj= DateFormat("dd/MM/yyyy").format(list!.studentDetails.sDoj!);
            datOfJoining = studentDetails!.studentDetails.sDoj == null ? "-" : DateFormat("dd/MM/yyyy").format(studentDetails!.studentDetails.sDoj!);
            imagePath=studentDetails!.studentDetails.stuImage ?? "";
            isLoading=false;

          });
        }catch(exception){
          Fluttertoast.showToast(msg: "$exception");
          setState(() {
            isLoading = false;
          });
        }
      }
      else{
        setState(() {
          isLoading = false;
        });
      }


    // ApiClass httpService = ApiClass();
    // SessionManagement sessionManagement = SessionManagement();
    // int? role= await sessionManagement.getRole("Role");
    // if(role==0){
    //   Studentlogin login = await sessionManagement.getModel('Student');
    //   String  token=login.basicAuthToken;
    //   dynamic country = await httpService.getStudentDetail(token,widget.sid,login.userdata.cookie ?? "");
    //   if(country['status']){
    //     try{
    //       Studentdetaillist student=Studentdetaillist.fromJson(country);
    //
    //       setState(() {
    //         studentDetails = student;
    //         listOfParent=studentDetails!.studentDetails.parentData;
    //         name=studentDetails!.studentDetails.sFname ?? "";
    //         lastName = studentDetails!.studentDetails.sLname ?? "";
    //         bloodGroup=studentDetails!.studentDetails.sBloodgrp ?? "";
    //         dob= studentDetails!.studentDetails.sDob == null ? "-" : DateFormat("dd/MM/yyyy").format(studentDetails!.studentDetails.sDob!);
    //         address=studentDetails!.studentDetails.sAddress ?? "";
    //         city=studentDetails!.studentDetails.sCity ?? "";
    //         pinCode=studentDetails!.studentDetails.sZipcode ?? "";
    //         countryName=studentDetails!.studentDetails.sCountry ?? "";
    //         cid=studentDetails!.studentDetails.className ?? "";
    //         rollNo=studentDetails!.studentDetails.sRollno ?? "";
    //         email = studentDetails!.studentDetails.stuEmail ?? "";
    //         isAddressVisible = login.userdata.wpUsrId == widget.sid ? true : false;
    //         // Doj= DateFormat("dd/MM/yyyy").format(list!.studentDetails.sDoj!);
    //         datOfJoining = studentDetails!.studentDetails.sDoj == null ? "-" : DateFormat("dd/MM/yyyy").format(studentDetails!.studentDetails.sDoj!);
    //         imagePath=studentDetails!.studentDetails.stuImage ?? "";
    //         isLoading=false;
    //
    //       });
    //     }catch(exception){
    //       Fluttertoast.showToast(msg: "$exception");
    //       setState(() {
    //         isLoading = false;
    //       });
    //     }
    //   }
    //   else{
    //     setState(() {
    //       isLoading = false;
    //     });
    //   }
    //
    // }
    //
    // else{
    //   Parentlogin parent= await sessionManagement.getModelParent('Parent');
    //   String ptoken=parent.basicAuthToken;
    //   dynamic country = await httpService.getStudentDetail(ptoken, widget.sid,parent.userdata.cookie ?? "");
    //   if(country['status']){
    //     Studentdetaillist student=Studentdetaillist.fromJson(country);
    //     setState(() {
    //       studentDetails = student;
    //       listOfParent=studentDetails!.studentDetails.parentData;
    //       name=studentDetails!.studentDetails.sFname ?? "";
    //       lastName = studentDetails!.studentDetails.sLname ?? "";
    //       bloodGroup=studentDetails!.studentDetails.sBloodgrp ?? "";
    //       dob= studentDetails!.studentDetails.sDob == null ?"-":DateFormat("dd/MM/yyyy").format(studentDetails!.studentDetails.sDob!);
    //       address=studentDetails!.studentDetails.sAddress ?? "";
    //       city=studentDetails!.studentDetails.sCity ?? "";
    //       pinCode=studentDetails!.studentDetails.sZipcode ?? "";
    //       countryName=studentDetails!.studentDetails.sCountry ?? "";
    //       cid=studentDetails!.studentDetails.className ?? "";
    //       rollNo=studentDetails!.studentDetails.sRollno ?? "";
    //       email = studentDetails!.studentDetails.stuEmail ?? "";
    //       datOfJoining= studentDetails!.studentDetails.sDoj == null ? "-" : DateFormat("dd/MM/yyyy").format(studentDetails!.studentDetails.sDoj!);
    //       imagePath=studentDetails!.studentDetails.stuImage ?? "";
    //       for (var element in parent.userdata.studentData!) {
    //         if(element.wpUsrId == widget.sid){
    //           isAddressVisible = true;
    //           break;
    //         }
    //       }
    //       isLoading=false;
    //
    //     });
    //   }else{
    //     setState(() {
    //       isLoading=false;
    //     });
    //   }
    // }

  }

}
