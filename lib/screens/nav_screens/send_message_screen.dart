// ignore_for_file: unnecessary_null_comparison

import 'dart:io';

import 'package:colegia_atenea/models/Failed.dart';
import 'package:colegia_atenea/models/Student/Studentlogin.dart';
import 'package:colegia_atenea/models/get_teacher_list_send_message_model.dart';
import 'package:colegia_atenea/services/api_class.dart';
import 'package:colegia_atenea/services/session_mangement.dart';
import 'package:colegia_atenea/utils/app_colors.dart';
import 'package:colegia_atenea/widgets/custom_loader.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';

import 'package:colegia_atenea/models/Parent/Parentlogin.dart';

class MessageSendScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return MessageSendScreenChild();
  }
}

class MessageSendScreenChild extends State<MessageSendScreen> {
  final TextEditingController _messageController = TextEditingController();
  final TextEditingController _affairController = TextEditingController();
  String fileName = 'chooseTitle'.tr;
  int isFileSelected = 0; //0 means not selected and 1 selected


  bool isLoading = false;
  late TeacherData selectTeacher;
  List<TeacherData> teacherList = [TeacherData(wpUsrId: "igexSol404", teacherName: "---${'selectTitle'.tr}---")];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    selectTeacher = teacherList[0];
    setState(() {
      isLoading = true;
    });
    getTeacherList();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
        appBar: AppBar(
          backgroundColor: AppColors.primary,
          elevation: 0,
          title: Text(
            'sendNewTitle'.tr,
            style: const TextStyle(
                fontFamily: "Outfit",
                fontSize: 20,
                fontWeight: FontWeight.w500),
          ),
        ),
        body: Stack(
          children: [
            SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(15),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('selectTitle'.tr,style: const TextStyle(
                        fontFamily: "Outfit",
                        fontWeight: FontWeight.w500,
                        fontSize: 18,
                        color: AppColors.secondary),),
                    const SizedBox(height: 10,),
                    Container(
                      width: MediaQuery.of(context).size.width,
                      height: 60,
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5),
                          color: AppColors.primary.withOpacity(0.05)
                      ),
                      child: DropdownButton<TeacherData>(
                        isExpanded: true,
                        value: selectTeacher,
                        underline: const SizedBox(),
                        icon: const Icon(Icons.arrow_drop_down_sharp),
                        items: teacherList.map((TeacherData e){
                          return DropdownMenuItem<TeacherData>(value: e,child: Text(e.teacherName,style: TextStyle(fontFamily: "Outfit",fontWeight: FontWeight.w400,color: AppColors.secondary.withOpacity(0.5),fontSize: 18)),);
                        }).toList(), onChanged: (TeacherData? value) {
                        setState(() {
                          selectTeacher = value!;
                        });
                      },
                      ),
                    ),
                    const SizedBox(height: 10,),
                    Text(
                      'afTitle'.tr,
                      style: const TextStyle(
                          fontFamily: "Outfit",
                          fontWeight: FontWeight.w500,
                          fontSize: 18,
                          color: AppColors.secondary),
                    ),
                    const SizedBox(height: 10,),
                    Container(
                      width: MediaQuery.of(context).size.width,
                      height: 50,
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5),
                          color: AppColors.secondary.withOpacity(0.06)
                      ),
                      child: TextField(
                        controller: _affairController,
                        decoration: const InputDecoration(
                          border: InputBorder.none
                        ),
                        cursorColor: AppColors.primary,
                        style: const TextStyle(
                          fontFamily: "Outfit",
                          fontSize: 16,
                          fontWeight: FontWeight.w400,
                          color: Colors.black
                      ),
                      ),
                    ),
                    const SizedBox(height: 20,),
                    Text(
                      'msgTitle'.tr,
                      style: const TextStyle(
                          fontFamily: "Outfit",
                          fontWeight: FontWeight.w500,
                          fontSize: 18,
                          color: AppColors.secondary),
                    ),
                    const SizedBox(height: 10,),
                    Container(
                      width: MediaQuery.of(context).size.width,
                      height: 120,
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5),
                          color: AppColors.secondary.withOpacity(0.06)
                      ),
                      child: TextField(
                        controller: _messageController,
                        decoration: const InputDecoration(
                          border: InputBorder.none,
                        ),
                        style: const TextStyle(
                            fontFamily: "Outfit",
                            fontSize: 16,
                            fontWeight: FontWeight.w400,
                            color: Colors.black
                        ),
                        cursorColor: AppColors.primary,
                        minLines: 1,
                        maxLines: 5,
                      ),
                    ),
                    const SizedBox(height: 20,),
                    Text(
                      'attachTitle'.tr,
                      style: const TextStyle(
                          fontFamily: "Outfit",
                          fontWeight: FontWeight.w500,
                          fontSize: 18,
                          color: AppColors.secondary),
                    ),
                    const SizedBox(height: 10,),
                    GestureDetector(onTap: (){
                      pickFile();
                    },
                      child: Container(
                      width: MediaQuery.of(context).size.width,
                      height: 60,
                      padding: const EdgeInsets.only(left: 10),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5),
                          color: AppColors.secondary.withOpacity(0.06)),
                      child:Align(
                        alignment: Alignment.centerLeft,
                        child: Text(fileName != 'chooseTitle'.tr ? fileName.split("/").last : fileName,textAlign: TextAlign.start,),
                      ),
                    ),),
                    const SizedBox(
                      height: 10,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        SizedBox(
                          width: 100,
                          height: 50,
                          child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                  backgroundColor: AppColors.primary,
                                  elevation: 0,
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10)
                                  )
                              ),
                              onPressed: () {
                                setState(() {
                                  isLoading = true;
                                });
                                if(isFileSelected == 0){
                                  sendMessageToTeacher(isFileSelectedOrNot: 0,teacherData: selectTeacher,subject: _affairController.text,message: _messageController.text);
                                }else{
                                  sendMessageToTeacher(isFileSelectedOrNot: 1,attachment: fileName,teacherData: selectTeacher,subject: _affairController.text,message: _messageController.text);
                                }
                                },
                              child: Text(
                                "sendTitle".tr,
                                style: const TextStyle(
                                    fontFamily: "Outfit",
                                    fontWeight: FontWeight.w400,
                                    color: AppColors.white,
                                    fontSize: 16),
                              )),
                        )
                      ],
                    )
                  ],
                ),
              ),
            ),
              Visibility(
                  visible: isLoading,
                  child:Container(
                color: AppColors.black.withOpacity(0.5),
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height,
                child: const Center(
                  child: LoadingLayout(),
                ),
              ))
          ],
        ));
  }


  void sendMessageToTeacher({required int isFileSelectedOrNot,String? attachment,required TeacherData teacherData,required String subject,required String message}) async{
    //isFileSelectedOrNot == 0 means file not selected and == 1 means file selected.


    SessionManagement sessionManagement = SessionManagement();
    int? role = await sessionManagement.getRole('Role');

    if(role == 0){
      Studentlogin studentLogin = await sessionManagement.getModel('student');
      String token = studentLogin.basicAuthToken;
      String senderId = studentLogin.userdata.wpUsrId!;
      if(isFileSelectedOrNot == 0){
        sendMessage( token: token , senderId: senderId, receivedId: teacherData.wpUsrId,subject: subject,message: message);
      }else{
        sendMessage( token: token , senderId: senderId, receivedId: teacherData.wpUsrId,subject: subject,message: message , attachment: attachment!);
      }
   }else{
      Parentlogin parentLogin = await sessionManagement.getModelParent('Parent');
      String token = parentLogin.basicAuthToken;
      String senderId = parentLogin.userdata.parentWpUsrId!;
      if(isFileSelectedOrNot == 0){
        sendMessage( token: token , senderId: senderId, receivedId: teacherData.wpUsrId,subject: subject,message: message);
      }else{
        sendMessage( token: token , senderId: senderId, receivedId: teacherData.wpUsrId,subject: subject,message: message , attachment: attachment!);
      }
    }
  }

  void sendMessage({required String token,String? senderId,String? receivedId,String? subject,String? message,String? attachment}) async{
    Apiclass apiclass = Apiclass();
    dynamic response = await apiclass.sendMessageToTeacher(token,attachment ?? "",senderId!,selectTeacher.wpUsrId,subject!,message!);
    if(response['status']){
      Fluttertoast.showToast(msg: 'parentSendMessage'.tr);
      setState(() {
        isLoading = false;
        fileName = "";
        isFileSelected = 0;
        _messageController.clear();
        _affairController.clear();
      });
      navigateToBack();
    }
    else{
      setState(() {
        isLoading = false;
      });
    }
    // //without attachment or with attachment
    // if(isFileSelectedOrNot == 0){
    //   Map<String,dynamic> bodyData = FormBodyData(senderId!,selectTeacher.wpUsrId,subject!,message!);
    //   dynamic response =  await apiclass.sendMessageToTeacherWithOutAttachment(token,bodyData);
    //   if(response['status']){
    //     setState(() {
    //       isLoading = false;
    //       selectTeacher = teacherList[0];
    //       _affairController.clear();
    //       _messageController.clear();
    //     });
    //   }
    //   else{
    //     setState(() {
    //       isLoading = false;
    //     });
    //   }
    // }
    // else{
    //   //send only message  attachment
    //
    // }
  }

  //pick file
  void pickFile() async{
    FilePickerResult? result = await FilePicker.platform.pickFiles();
    if(result == null){
    }else{
      setState(() {
        fileName = result.files.single.path!;
        isFileSelected = 1;
      });
      // File file = File(result.files.single.path);
    }
  }

  //get teacher list
  void getTeacherList() async{
    Apiclass apiclass = Apiclass();
    SessionManagement sessionManagement = SessionManagement();
    int? role = await sessionManagement.getRole("Role");
    if(role == 0){
      Studentlogin studentlogin = await sessionManagement.getModel('Student');
      String token = studentlogin.basicAuthToken;
      dynamic response = await apiclass.getTeacherListForSendMessage(token);
      List<TeacherData> tempTeacherList = [];
      tempTeacherList.add(TeacherData(wpUsrId: "igexSol404", teacherName: "---${'selectTitle'.tr}---"));
      if(response['status']){
        TeacherListForSend teacherListForSend = TeacherListForSend.fromJson(response);
        for(var x in teacherListForSend.data){
          tempTeacherList.add(x);
        }
        setState(() {
          teacherList = tempTeacherList;
          selectTeacher = tempTeacherList[0];
          isLoading = false;
        });
      }else{
        Failed failed = Failed.fromJson(response);
        setState(() {
          isLoading = false;
        });
      }
    }
    else{
      Parentlogin parentlogin = await sessionManagement.getModelParent('Parent');
      String token = parentlogin.basicAuthToken;
      dynamic response = await apiclass.getTeacherListForSendMessage(token);
      print(response);
      List<TeacherData> tempTeacherList = [];
      tempTeacherList.add(TeacherData(wpUsrId: "igexSol404", teacherName: "---${'selectTitle'.tr}---"));
      if(response['status']){
        TeacherListForSend teacherListForSend = TeacherListForSend.fromJson(response);
        for(var x in teacherListForSend.data){
          tempTeacherList.add(x);
        }
        setState(() {
          teacherList = tempTeacherList;
          selectTeacher = tempTeacherList[0];
          isLoading = false;
        });
      }else{
        Failed failed = Failed.fromJson(response);
        setState(() {
          isLoading = false;
        });
      }
    }

  }

  Map<String, dynamic> FormBodyData(String senderId, String recieverId, String subject, String message) {
    Map<String,dynamic> tempMap = {};
    tempMap["sender_id"] = senderId;
    // for(int i=0;i<recieverList.length;i++){
    //   tempMap["reciever_id[$i]"] = recieverList[i];
    // }
    tempMap["reciever_id[0]"] = recieverId;
    tempMap["subject"] = subject;
    tempMap["msg"] = message;

    return tempMap;
  }


  //once message sent successfully this will get back message screen.
  void navigateToBack() {
    Navigator.pop(context);
  }
}
