import 'package:auto_size_text/auto_size_text.dart';
import 'package:colegia_atenea/models/Parent/Parentlogin.dart';
import 'package:colegia_atenea/models/Singleteacher.dart';
import 'package:colegia_atenea/models/Student/Studentlogin.dart';
import 'package:colegia_atenea/services/api_class.dart';
import 'package:colegia_atenea/services/session_mangement.dart';
import 'package:colegia_atenea/utils/app_colors.dart';
import 'package:colegia_atenea/utils/app_images.dart';
import 'package:colegia_atenea/utils/text_style.dart';
import 'package:colegia_atenea/widgets/custom_loader.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';


class TeacherDetails extends StatefulWidget {
  final String id;
  final String subject;
  final String inCharge;
  const TeacherDetails(this.id,this.subject,this.inCharge, {super.key});

  @override
  State<TeacherDetails> createState() => _TeacherDetailsChild();
}

class _TeacherDetailsChild extends State<TeacherDetails> {
  String name="";
  String lastName = "";
  String familyCareHours="";
  String email="";
  String image="";
  bool isLoading=true;


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
            title: Text("techerdetail".tr,style: CustomStyle.appBarTitle,),
            leading: Container(
              margin: const EdgeInsets.all(10),
              child:
              GestureDetector(
                onTap: () {
                  Navigator.pop(context);
                },
                child: SvgPicture.asset(
                  AppImages.arrow,color: AppColors.orange,
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
                                  //crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.only(top: 100),
                                      margin: const EdgeInsets.only(left: 20,right: 20,top: 10),
                                      child: Column(
                                        crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                        children: [
                                          Padding(
                                            padding:
                                            const EdgeInsets.only(bottom: 70),
                                            child: Column(
                                              crossAxisAlignment: CrossAxisAlignment.center,
                                              children: [
                                                Container(
                                                    width:MediaQuery.of(context).size.width,
                                                    margin:const EdgeInsets.symmetric(horizontal: 60),
                                                    child:Center(
                                                      child:Column(
                                                        children: [
                                                          AutoSizeText(
                                                            maxLines:5,
                                                            name,
                                                            style: CustomStyle.login,
                                                          ),
                                                          AutoSizeText(
                                                           maxLines: 5,
                                                           lastName,
                                                           style: CustomStyle.login.copyWith(fontSize: 16,color: AppColors.secondary.withOpacity(0.5)),
                                                          )
                                                        ],
                                                      ),
                                                    )
                                                ),
                                                Container(
                                                  margin: const EdgeInsets.only(top: 20),
                                                  child: Column(
                                                    mainAxisAlignment:
                                                    MainAxisAlignment.start,
                                                    crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                    children: [
                                                      Text(
                                                        "subjects".tr,style: CustomStyle.textValue.copyWith(color: AppColors.secondary.withOpacity(0.75)),
                                                      ),
                                                      const SizedBox(height: 10,),
                                                      Container(
                                                          width: MediaQuery.of(context).size.width,
                                                          decoration: BoxDecoration(
                                                              borderRadius: BorderRadius.circular(12),
                                                              color: AppColors.secondary.withOpacity(0.06)
                                                          ),
                                                          child: Padding(
                                                            padding: const EdgeInsets.all(15),
                                                            child: Text(
                                                              widget.subject,style: CustomStyle.textHintValue.copyWith(color: AppColors.secondary),
                                                              textAlign: TextAlign.left,
                                                            ),
                                                          )
                                                      ),
                                                      const SizedBox(height: 20,),
                                                      Text(
                                                        "iotc".tr,style: CustomStyle.textValue.copyWith(color: AppColors.secondary.withOpacity(0.75)),
                                                      ),
                                                      const SizedBox(height: 10,),
                                                      Container(
                                                          width: MediaQuery.of(context).size.width,
                                                          height: 60,
                                                          decoration: BoxDecoration(
                                                              borderRadius: BorderRadius.circular(12),
                                                              color: AppColors.secondary.withOpacity(0.06)
                                                          ),
                                                          child: Padding(
                                                            padding: const EdgeInsets.all(15),
                                                            child: Text(
                                                              widget.inCharge.isEmpty ? "-" : widget.inCharge,style: CustomStyle.textHintValue.copyWith(color: AppColors.secondary),
                                                              textAlign: TextAlign.left,
                                                            ),
                                                          )
                                                      ),
                                                      const SizedBox(height: 20,),
                                                      Text(
                                                        "fch".tr,style: CustomStyle.textValue.copyWith(color: AppColors.secondary.withOpacity(0.75)),
                                                      ),
                                                      const SizedBox(height: 10,),
                                                      Container(
                                                          width: MediaQuery.of(context).size.width,
                                                          height: 60,
                                                          decoration: BoxDecoration(
                                                              borderRadius: BorderRadius.circular(12),
                                                              color: AppColors.secondary.withOpacity(0.06)
                                                          ),
                                                          child: Padding(
                                                            padding: const EdgeInsets.all(15),
                                                            child: Text(
                                                              familyCareHours,
                                                              textAlign: TextAlign.left,
                                                              style: CustomStyle.textHintValue.copyWith(color: AppColors.secondary),
                                                            ),
                                                          )
                                                      ),
                                                      const SizedBox(height: 20,),
                                                      Text(
                                                        "email".tr,style: CustomStyle.textValue.copyWith(color: AppColors.secondary.withOpacity(0.75)),
                                                      ),
                                                      const SizedBox(height: 10,),
                                                      Container(
                                                          width: 350,
                                                          height: 60,
                                                          decoration: BoxDecoration(
                                                              borderRadius: BorderRadius.circular(12),
                                                              color: AppColors.secondary.withOpacity(0.06)
                                                          ),
                                                          child: Padding(
                                                            padding: const EdgeInsets.all(15),
                                                            child: Text(
                                                              email,
                                                              textAlign: TextAlign.left,
                                                              style: CustomStyle.textHintValue.copyWith(color: AppColors.secondary),
                                                            ),
                                                          )
                                                      )
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
                            child: image.isEmpty ?Center(child:  SvgPicture.asset(AppImages.people,width: 100,height: 100,color: AppColors.primary,),) : CircleAvatar(
                              radius: 16.0,
                              backgroundColor: AppColors.primary,
                              backgroundImage: NetworkImage(image),
                              // child: ClipRRect(
                              //   borderRadius: BorderRadius.circular(160.0),
                              //   child: Image.network(
                              //     image.isEmpty
                              //         ? "http://colegioatenea.embedinfosoft.com/wp-content/plugins/scl-rest-api/img/default_avtar.jpg"
                              //         : image,
                              //     height: 180,
                              //     width: 180,
                              //     fit: BoxFit.fitHeight,
                              //   ),
                              // ),
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
    SessionManagement sessionManagement = SessionManagement();
    int? role=await sessionManagement.getRole("Role");
    if(role==0){
      Studentlogin login= await sessionManagement.getModel('Student');
      String token=login.basicAuthToken;
      dynamic country = await httpService.getSingleTeacher(token,widget.id);
      if(country['status']){
        Singleteacher teacherDetails= Singleteacher.fromJson(country);

        setState((){
          name= teacherDetails.data![0].firstName!;
          lastName = teacherDetails.data![0].lastName!;
          familyCareHours = teacherDetails.data![0].familyCareHour!;
          email=teacherDetails.data![0].userEmail!;
          image=teacherDetails.data![0].image!;
          isLoading=false;
        });


      }else {
        setState(() {
          isLoading = false;
        });
      }
    }else{
      Parentlogin parent= await sessionManagement.getModelParent('Parent');
      String ptoken=parent.basicAuthToken;
      dynamic country = await httpService.getSingleTeacher(ptoken,widget.id);
      if(country['status']){
        Singleteacher? teacherDetails= Singleteacher.fromJson(country);
        setState((){
          name= teacherDetails.data![0].firstName!;
          lastName = teacherDetails.data![0].lastName!;
          familyCareHours = teacherDetails.data![0].familyCareHour!;
          email= teacherDetails.data![0].userEmail!;
          image= teacherDetails.data![0].image!;
          isLoading=false;
        });
      }else{
        setState((){
          isLoading=false;
        });
      }

    }


  }
}
