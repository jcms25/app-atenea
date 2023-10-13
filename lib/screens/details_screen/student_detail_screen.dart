
import 'package:auto_size_text/auto_size_text.dart';
import 'package:colegia_atenea/models/Parent/Parentlogin.dart';
import 'package:colegia_atenea/models/Student/Studentlogin.dart';
import 'package:colegia_atenea/models/Studentdetaillist.dart';
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
import 'package:intl/intl.dart';


class studentsdetails extends StatefulWidget {
  var sid;
  String pvalu;

  studentsdetails( this.sid,this.pvalu, {super.key});

  @override
  State<studentsdetails> createState() => StudentDetail();
}

class StudentDetail extends State<studentsdetails> {
  Studentdetaillist? studentDetails;
  List<ParentsDatum> listparent = [];
  String name = "";
  String bloodGroup = "";
  String dob = "";
  String address = "";
  String city = "";
  String pinCode = "";
  String Country = "";
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
            title: Text("studentdetail".tr,style: CustomStyle.appbartitle,),
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
                                      const EdgeInsets.only(top: 100),
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
                                                      child:  AutoSizeText(
                                                        maxLines:5,
                                                        name,
                                                        style: CustomStyle.login,

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
                                                          "dob".tr,style: CustomStyle.txtvalue.copyWith(color: AppColors.secondary.withOpacity(0.75)),
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
                                                                  style: CustomStyle.txthintvalue.copyWith(color: AppColors.secondary),
                                                                ),
                                                              ))),
                                                      Padding(
                                                        padding:
                                                        const EdgeInsets.only(
                                                            top: 20),
                                                        child: Text(
                                                          "address".tr,style: CustomStyle.txtvalue.copyWith(
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
                                                                  "streetaddress".tr,style: CustomStyle.txtvalue,

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
                                                                          style: CustomStyle.txthintvalue.copyWith(color: AppColors.secondary,),

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
                                                                        "city".tr,style: CustomStyle.txtvalue.copyWith(color: AppColors.secondary.withOpacity(0.75)),
                                                                      )),
                                                                  const SizedBox(
                                                                    width: 30,
                                                                  ),
                                                                  Expanded(
                                                                      child:
                                                                      Text(
                                                                        "pincode".tr,style: CustomStyle.txtvalue.copyWith(color: AppColors.secondary.withOpacity(0.75)),
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
                                                                              style: CustomStyle.txthintvalue.copyWith(color: AppColors.secondary,),

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
                                                                              style: CustomStyle.txthintvalue.copyWith(color: AppColors.secondary,),

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
                                                          "country".tr,style: CustomStyle.txtvalue.copyWith(color: AppColors.secondary.withOpacity(0.75)),

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
                                                                  Country,
                                                                  textAlign:
                                                                  TextAlign
                                                                      .left,
                                                                  style: CustomStyle.txthintvalue.copyWith(color: AppColors.secondary,),
                                                                ),
                                                              ))),
                                                      Padding(
                                                          padding:
                                                          const EdgeInsets.only(
                                                              top: 20),
                                                          child: Text(
                                                            "schooldetail".tr,style: CustomStyle.txtvalue.copyWith(color: AppColors.secondary,fontWeight: FontWeight.w600),

                                                          )),
                                                      Padding(
                                                        padding:
                                                        const EdgeInsets.only(
                                                            top: 15),
                                                        child: Text(
                                                          "doj".tr,style: CustomStyle.txtvalue.copyWith(color: AppColors.secondary.withOpacity(0.75)),

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
                                                                  style: CustomStyle.txthintvalue.copyWith(color: AppColors.secondary,),

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
                                                                        "class".tr,style: CustomStyle.txtvalue.copyWith(color: AppColors.secondary.withOpacity(0.75)),

                                                                      )),
                                                                  const SizedBox(
                                                                    width: 30,
                                                                  ),
                                                                  Expanded(
                                                                      child:
                                                                      Text(
                                                                        "rollno".tr,style: CustomStyle.txtvalue.copyWith(color: AppColors.secondary.withOpacity(0.75)),

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
                                                                              style: CustomStyle.txthintvalue.copyWith(color: AppColors.secondary,),


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
                                                                              style: CustomStyle.txthintvalue.copyWith(color: AppColors.secondary,),

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
                                        visible: widget.sid==widget.pvalu,
                                        child: Container(
                                          margin: const EdgeInsets.all(0),
                                          child: ListView.builder(
                                              physics:
                                              const NeverScrollableScrollPhysics(),
                                              shrinkWrap: true,
                                              itemCount: listparent.length,
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
                                                            listparent[position].pGender=="Male"?"parentsdetail".tr:"parentsdetail2".tr,style: CustomStyle.txtvalue.copyWith(color: AppColors.secondary,fontWeight: FontWeight.w600),
                                                          ),
                                                          const SizedBox(height: 10,),
                                                          Text(
                                                            listparent[position].pGender=="Male"?"pname".tr:"pname2".tr,style: CustomStyle.txtvalue.copyWith(color: AppColors.secondary.withOpacity(0.75)),
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
                                                                  "${listparent[position].pFname}\t${listparent[position].pLname}",
                                                                  textAlign:
                                                                  TextAlign.left,
                                                                  style: CustomStyle.txthintvalue.copyWith(color: AppColors.secondary,),
                                                                ),
                                                              )),
                                                          const SizedBox(height: 15,),
                                                          Text(
                                                            listparent[position].pGender=="Male"?"pemail".tr:"pemail".tr,style: CustomStyle.txtvalue.copyWith(color: AppColors.secondary.withOpacity(0.75)),
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
                                                                  listparent[position].parentEmail ?? "-",
                                                                  textAlign:
                                                                  TextAlign.left,
                                                                  style: CustomStyle.txthintvalue.copyWith(color: AppColors.secondary,),
                                                                ),
                                                              )),
                                                          const SizedBox(height: 15,),
                                                          Text(
                                                            "mobile".tr,style: CustomStyle.txtvalue.copyWith(color: AppColors.secondary.withOpacity(0.75)),
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
                                                                  listparent[position].pPhone ?? "-",
                                                                  textAlign:
                                                                  TextAlign.left,
                                                                  style: CustomStyle.txthintvalue.copyWith(color: AppColors.secondary,),
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
                                                                          listparent[position].pGender=="Male"?"parentpro".tr:"parentpro".tr,style: CustomStyle.txtvalue.copyWith(color: AppColors.secondary.withOpacity(0.75)),
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
                                                                                listparent[position].pProfession ?? "-",
                                                                                textAlign: TextAlign.left,
                                                                                style: CustomStyle.txthintvalue.copyWith(color: AppColors.secondary,),
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
                            height: 180,
                            width: 180,
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
                            child: imagePath.isEmpty ? Center(child:  SvgPicture.asset(AppImages.people,width: 100,height: 100,color: AppColors.primary,),) : CircleAvatar(
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
    Apiclass httpService = Apiclass();
    SessionManagement sessionManagement = SessionManagement();
    int? role= await sessionManagement.getRole("Role");
    if(role==0){
      Studentlogin login = await sessionManagement.getModel('Student');
      String  token=login.basicAuthToken;
      dynamic country = await httpService.getStudentDetail(token,widget.sid);
      if(country['status']){
        try{
          Studentdetaillist student=Studentdetaillist.fromJson(country);

          setState(() {
            studentDetails = student;
            listparent=studentDetails!.studentDetails.parentData;
            name=studentDetails!.studentDetails.sFname ?? "";
            bloodGroup=studentDetails!.studentDetails.sBloodgrp ?? "";
            dob= studentDetails!.studentDetails.sDob == null ? "-" : DateFormat("dd/MM/yyyy").format(studentDetails!.studentDetails.sDob!);
            address=studentDetails!.studentDetails.sAddress ?? "";
            city=studentDetails!.studentDetails.sCity ?? "";
            pinCode=studentDetails!.studentDetails.sZipcode ?? "";
            Country=studentDetails!.studentDetails.sCountry ?? "";
            cid=studentDetails!.studentDetails.className ?? "";
            rollNo=studentDetails!.studentDetails.sRollno ?? "";
            isAddressVisible = login.userdata.wpUsrId == widget.sid ? true : false;
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

    }else{
      Parentlogin parent= await sessionManagement.getModelParent('Parent');
      String ptoken=parent.basicAuthToken;
      dynamic country = await httpService.getStudentDetail(ptoken, widget.sid,);
      if(country['status']){
        Studentdetaillist student=Studentdetaillist.fromJson(country);
        setState(() {
          studentDetails = student;
          listparent=studentDetails!.studentDetails.parentData;
          name=studentDetails!.studentDetails.sFname ?? "";
          bloodGroup=studentDetails!.studentDetails.sBloodgrp ?? "";
          dob= studentDetails!.studentDetails.sDob == null ?"-":DateFormat("dd/MM/yyyy").format(studentDetails!.studentDetails.sDob!);
          address=studentDetails!.studentDetails.sAddress ?? "";
          city=studentDetails!.studentDetails.sCity ?? "";
          pinCode=studentDetails!.studentDetails.sZipcode ?? "";
          Country=studentDetails!.studentDetails.sCountry ?? "";
          cid=studentDetails!.studentDetails.className ?? "";
          rollNo=studentDetails!.studentDetails.sRollno ?? "";
          datOfJoining= studentDetails!.studentDetails.sDoj == null ? "-" : DateFormat("dd/MM/yyyy").format(studentDetails!.studentDetails.sDoj!);
          imagePath=studentDetails!.studentDetails.stuImage ?? "";
          for (var element in parent.userdata.studentData!) {
            if(element.wpUsrId == widget.sid){
              isAddressVisible = true;
              break;
            }
          }
          isLoading=false;

        });
      }else{
        setState(() {
          isLoading=false;
        });
      }
    }

  }

}
