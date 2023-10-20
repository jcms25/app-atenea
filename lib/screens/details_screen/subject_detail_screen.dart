import 'package:auto_size_text/auto_size_text.dart';
import 'package:colegia_atenea/models/Parent/Parentlogin.dart';
import 'package:colegia_atenea/models/Singlesubjectmodel.dart';
import 'package:colegia_atenea/models/Student/Studentlogin.dart';
import 'package:colegia_atenea/services/api_class.dart';
import 'package:colegia_atenea/services/session_management.dart';
import 'package:colegia_atenea/utils/app_colors.dart';
import 'package:colegia_atenea/utils/app_images.dart';
import 'package:colegia_atenea/utils/text_style.dart';
import 'package:colegia_atenea/widgets/custom_loader.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

class subjectdetailscreen extends StatefulWidget {
  var subid;
  var group;

  subjectdetailscreen(this.subid, this.group);

  @override
  State<subjectdetailscreen> createState() => SubjectsDetail();
}

class SubjectsDetail extends State<subjectdetailscreen> {
  Singlesubject? list;
  Datum? listsubject;
  bool isLoading=true;
  String subname="";
  String subcode="";
  String faculty="";
  String nameofbook="";
  String Imagepath="";
  String group = "";

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
            title: Text("subjectdetail".tr,style: CustomStyle.appBarTitle,),
            leading: Container(
              margin: const EdgeInsets.all(10),
              child:
              GestureDetector(
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
                            margin: const EdgeInsets.only(top: 100, bottom: 30),
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
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.only(top: 100),
                                      margin: const EdgeInsets.only(top: 10),
                                      child: Column(
                                        crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                        children: [
                                          Padding(
                                            padding:
                                            const EdgeInsets.only(bottom: 70),
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
                                                        subname,
                                                        style: CustomStyle.login,
                                                      ),
                                                    )
                                                ),

                                                Container(
                                                  margin: const EdgeInsets.only(top: 20,left: 20,right: 20),
                                                  child: Column(
                                                    mainAxisAlignment:
                                                    MainAxisAlignment.start,
                                                    crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                    children: [
                                                      Row(
                                                        children: [
                                                          Expanded(child: Text('groupName'.tr,style: CustomStyle.textValue.copyWith(color: AppColors.secondary.withOpacity(0.75)),
                                                          )),
                                                          Expanded(child: Text(widget.group,style: CustomStyle.txtvalue4.copyWith(fontWeight: FontWeight.w600)
                                                          ))
                                                        ],
                                                      ),
                                                      const SizedBox(height: 5,),
                                                      CustomStyle.dottedLine,
                                                      Row(
                                                        children: [
                                                          Expanded(child: Text("subjectcode".tr,style: CustomStyle.textValue.copyWith(color: AppColors.secondary.withOpacity(0.75)),
                                                          )),
                                                          Expanded(child: Text(subcode,style: CustomStyle.txtvalue4.copyWith(fontWeight: FontWeight.w600)
                                                          ))
                                                        ],
                                                      ),
                                                      const SizedBox(height: 5,),
                                                      CustomStyle.dottedLine,
                                                      Row(
                                                        children: [
                                                          Expanded(child: Text("faculty".tr,style: CustomStyle.textValue.copyWith(color: AppColors.secondary.withOpacity(0.75)),
                                                          )),
                                                          Expanded(child: Text(faculty,style: CustomStyle.txtvalue4.copyWith(fontWeight: FontWeight.w600)
                                                          ))
                                                        ],
                                                      ),
                                                      const SizedBox(height: 5,),
                                                      CustomStyle.dottedLine,
                                                      Row(
                                                        crossAxisAlignment: CrossAxisAlignment.start,
                                                        children: [
                                                          Expanded(child: Text("nameofthebook".tr,style: CustomStyle.textValue.copyWith(color: AppColors.secondary.withOpacity(0.75)),
                                                          )),
                                                          Expanded(child: Text(nameofbook,style: CustomStyle.txtvalue4.copyWith(fontWeight: FontWeight.w600)
                                                          ))
                                                        ],
                                                      ),
                                                      const SizedBox(height: 5,),
                                                      CustomStyle.dottedLine,
                                                    ],
                                                  ),
                                                )
                                              ],
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          Container(
                            //
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
                            child: CircleAvatar(
                              backgroundColor: AppColors.white,
                              radius: 16.0,
                              child: SvgPicture.asset(
                                AppImages.book,
                                //
                              ),
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
        )
    );
  }

  void callAPI() async {
    ApiClass httpService = ApiClass();
    SessionManagement sessionManagment = SessionManagement();
    int? Role = await sessionManagment.getRole("Role");
    if (Role == 0) {
      Studentlogin login = await sessionManagment.getModel('Student');
      String token = login.basicAuthToken;
      dynamic country = await httpService.getSingleSubject(token, widget.subid);
      if (country['status']) {
        Singlesubject subject = Singlesubject.fromJson(country);
        print(subject.data[0].firstName);
        setState(() {
          list = subject;
          subname = list!.data[0].subName;
          subcode = list!.data[0].subCode;
          faculty = "${list!.data[0].firstName}\n${list!.data[0].lastName}";
          nameofbook = list!.data[0].bookName;
          group = widget.group;
          isLoading = false;
        });
      } else {
        print("Hello");
        setState(() {
          isLoading = false;
        });
      }
    } else {
      Parentlogin parent = await sessionManagment.getModelParent('Parent');
      String ptoken = parent.basicAuthToken;
      dynamic country = await httpService.getSingleSubject(
          ptoken, widget.subid);
      print(country);
      if (country['status']) {
        Singlesubject subject = Singlesubject.fromJson(country);
        setState(() {
          list = subject;
          subname = list!.data[0].subName;
          subcode = list!.data[0].subCode;
          faculty = "${list!.data[0].firstName}\n${list!.data[0].lastName}";
          nameofbook = list!.data[0].bookName;
          group = widget.group;
          isLoading = false;
        });
      } else {
        print("Hello");
        setState(() {
          isLoading = false;
        });
      }
    }
  }
}
