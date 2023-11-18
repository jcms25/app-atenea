import 'package:colegia_atenea/models/Parent/Parentlogin.dart';
import 'package:colegia_atenea/models/Singleexam.dart';
import 'package:colegia_atenea/models/Student/Studentlogin.dart';
import 'package:colegia_atenea/services/api_class.dart';
import 'package:colegia_atenea/services/session_management.dart';
import 'package:colegia_atenea/utils/app_colors.dart';
import 'package:colegia_atenea/utils/app_images.dart';
import 'package:colegia_atenea/utils/text_style.dart';
import 'package:colegia_atenea/widgets/custom_loader.dart';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

class TestDetails extends StatefulWidget {
  final String id;
  final String sID;
  final String professorName;
  const TestDetails(this.id,this.sID,this.professorName, {super.key});

  @override
  State<TestDetails> createState() => _TestDetailsChild();
}

class _TestDetailsChild extends State<TestDetails> {
  String subject="";
  String professor="";
  String date="";
  String title="";
  String comments="";
  String hour="";
  String note="";
  Singleexam? list;
  bool isLoading=true;
  List<Subdetails> subDetail=[];


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
            title:  Text("testdetail".tr,
              style: CustomStyle.appBarTitle,),
            leading: Container(
              margin: const EdgeInsets.all(10),
              child: GestureDetector(
                onTap: () {
                  Navigator.pop(context);
                },
                child: SvgPicture.asset(
                  AppImages.arrow,color: AppColors.orange,
                ),
              ),
            )),
        body:Stack(
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [

                Expanded(
                    child: SingleChildScrollView(
                      scrollDirection: Axis.vertical,
                      physics: const BouncingScrollPhysics(),
                      child: Column(
                        children: [
                          Align(alignment: Alignment.center,
                            child:  Padding(padding: const EdgeInsets.only(top: 20),
                              child:  Image.asset(AppImages.studying),),),
                          Container(
                              margin: const EdgeInsets.all(20),

                              padding: const EdgeInsets.all(20),
                              decoration: BoxDecoration(
                                  color: AppColors.primary.withOpacity(0.05),
                                  borderRadius: const BorderRadius.all(Radius.circular(15))
                              ),
                              child: Padding(
                                padding: const EdgeInsets.only(
                                    left: 00,right: 00),
                                child: Column(
                                  children: [

                                    const SizedBox(height: 10,),
                                    Row(
                                      children: [
                                        Expanded(child:  Text("subject".tr,style: CustomStyle.txtvalue4,
                                         ),),
                                        Expanded(child: Text(subject,style: CustomStyle.txtvalue4.copyWith(fontWeight: FontWeight.w600),
                                          ))
                                      ],
                                    ),
                                    const SizedBox(height: 5,),
                                    CustomStyle.dottedLine,
                                    const SizedBox(height: 10,),
                                    Row(
                                      children: [
                                        Expanded(child:  Text("professor".tr,style: CustomStyle.txtvalue4,
                                          ),),
                                       Expanded(child:  Text(
                                         widget.professorName,style: CustomStyle.txtvalue4.copyWith(fontWeight: FontWeight.w600),
                                       ))
                                      ],
                                    ),
                                    const SizedBox(height: 5,),
                                    CustomStyle.dottedLine,
                                    const SizedBox(height: 10,),
                                    Row(
                                      children: [
                                        Expanded(child:  Text("title".tr,style: CustomStyle.txtvalue4,
                                          ),),
                                     Expanded(child:    Text(
                                       title,style: CustomStyle.txtvalue4.copyWith(fontWeight: FontWeight.w600),
                                     ))
                                      ],
                                    ),
                                    const SizedBox(height: 5,),
                                    CustomStyle.dottedLine,
                                    const SizedBox(height: 10,),
                                    Row(
                                      children: [
                                        Expanded(child:  Text("date".tr,style: CustomStyle.txtvalue4,
                                        ),),
                                        Expanded(child: Text(
                                          date,style: CustomStyle.txtvalue4.copyWith(fontWeight: FontWeight.w600),
                                        ))
                                      ],
                                    ),
                                    const SizedBox(height: 5,),
                                    CustomStyle.dottedLine,
                                    const SizedBox(height: 10,),
                                    Row(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Expanded(child: Text(
                                          "hour".tr,style: CustomStyle.txtvalue4,
                                        ),),
                                        const SizedBox(height: 10,),
                                        Expanded(child: Text(
                                          hour,style: CustomStyle.txtvalue4.copyWith(fontWeight: FontWeight.w600),
                                        ))
                                      ],
                                    ),
                                    const SizedBox(height: 5,),
                                    CustomStyle.dottedLine,
                                    const SizedBox(height: 10,),
                                    Row(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Expanded(child: Text(
                                          "comment".tr,style: CustomStyle.txtvalue4,
                                        ),),
                                        const SizedBox(height: 10,),
                                       Expanded(child:  Text(
                                         comments,style: CustomStyle.txtvalue4.copyWith(fontWeight: FontWeight.w600),
                                       ))
                                      ],
                                    ),
                                    const SizedBox(height: 5,),
                                    CustomStyle.dottedLine,
                                  ],
                                ),
                              )
                          )
                        ],
                      ),
                    ))
              ],
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
      dynamic country = await httpService.getSingleExam(token,widget.id);
      if(country['status']){
        Singleexam exam= Singleexam.fromJson(country);
        String listsub="";
        for(var i in exam.data!.subdetails!){
          if(i.id==widget.sID){
            listsub=i.name!;
            break;
          }
        }

        setState((){
          list=exam;
          subDetail=exam.data!.subdetails!;
          subject=listsub;
          professor=list!.data!.cName!;
          date=list!.data!.eSDate!;
          hour=list!.data!.time!;
          title=list!.data!.eName!;
          comments=list!.data!.comments ?? "-";
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
      dynamic country = await httpService.getSingleExam(ptoken,widget.id);
      if(country['status']){
        Singleexam exam= Singleexam.fromJson(country);
        String listsub="";
        for(var i in exam.data!.subdetails!){
          if(i.id==widget.sID){
            listsub=i.name!;
            break;
          }
        }

        setState((){
          list=exam;
          subDetail=exam.data!.subdetails!;
          subject=listsub;
          professor=list!.data!.cName!;
          date=list!.data!.eSDate!;
          hour=list!.data!.time!;
          title=list!.data!.eName!;
          comments=list!.data!.comments ?? "-";
          isLoading=false;
        });
      }else {
        setState((){
          isLoading=false;
        });
      }

    }


  }





}
