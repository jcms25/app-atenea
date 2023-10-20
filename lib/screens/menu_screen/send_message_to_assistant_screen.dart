import 'package:colegia_atenea/models/Parent/Parentlogin.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';

import '../../models/assistant_list_model.dart';
import '../../services/api_class.dart';
import '../../services/session_management.dart';
import '../../utils/app_colors.dart';
import '../../widgets/custom_loader.dart';

class SendMessageToAssistant extends StatefulWidget {
  final String studentId;
  const SendMessageToAssistant({Key? key,required this.studentId}) : super(key: key);

  @override
  State<SendMessageToAssistant> createState() => _SendMessageToAssistantState();
}

class _SendMessageToAssistantState extends State<SendMessageToAssistant> {
  final TextEditingController _affairController = TextEditingController();
  final TextEditingController _messageController = TextEditingController();

  String fileName = 'chooseTitle'.tr;
  int isFileSelected = 0; //0 means not selected and 1 selected

  late AssistantData selectedAssistant;
  bool isLoading = false;
  List<AssistantData> listOfAssistant = [AssistantData(id: 404, firstName: "-- ${'selectAssistant'.tr}", lastName: "")];
   //List<TeacherData> teacherList = [TeacherData(wpUsrId: "igexSol404", teacherName: "---${'selectTitle'.tr}---")];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    selectedAssistant = listOfAssistant[0];
    getAssistantList();
  }

  @override
  Widget build(BuildContext context) {
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
          ScrollConfiguration(
            behavior: const ScrollBehavior().copyWith(overscroll: false),
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 10,),
                    Text('selectAssistant'.tr,style: const TextStyle(
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
                      child: DropdownButton<AssistantData>(
                        isExpanded: true,
                        value: selectedAssistant,
                        underline: const SizedBox(),
                        icon: const Icon(Icons.arrow_drop_down_sharp),
                        items: listOfAssistant.map((AssistantData e){
                          return DropdownMenuItem<AssistantData>(value: e,child: Text("${e.firstName} ${e.lastName}",style: TextStyle(fontFamily: "Outfit",fontWeight: FontWeight.w400,color: AppColors.secondary.withOpacity(0.5),fontSize: 18)),);
                        }).toList(), onChanged: (AssistantData? value) {
                        setState(() {
                          selectedAssistant = value!;
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
                          child: Text(fileName.split("/").last,style: TextStyle(fontFamily: "Outfit",fontWeight: FontWeight.w400,color: AppColors.secondary.withOpacity(0.5),fontSize: 18)),),
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
                                if(_affairController.text.isEmpty){
                                  Fluttertoast.showToast(msg: 'asSubject'.tr);
                                }else{
                                  sendMessage();
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
      ),
    );
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

  void sendMessage() async{
    setState(() {
      isLoading = true;
    });
    ApiClass apiClass = ApiClass();
    SessionManagement sessionManagement = SessionManagement();
    Parentlogin parentLogin = await sessionManagement.getModelParent('');
    dynamic response = await apiClass.sendMessageToAssistant(token: parentLogin.basicAuthToken, senderId: parentLogin.userdata.parentWpUsrId!, receiverId: "${selectedAssistant.id}", studentId: widget.studentId, subject: _affairController.text, message: _messageController.text, attachment: fileName == 'chooseTitle'.tr ? "" : fileName);
    if(response['status']){
      setState(() {
        isLoading = false;
      });
      Fluttertoast.showToast(msg:'asMessageSent'.tr);
      back();
    }else{
      Fluttertoast.showToast(msg: response['message']);
      setState(() {
        isLoading = false;
      });
    }
  }

  void getAssistantList() async{
    setState(() {
      isLoading = true;
    });
    ApiClass apiClass = ApiClass();
    SessionManagement sessionManagement = SessionManagement();
    Parentlogin parentLogin = await sessionManagement.getModelParent('');
    dynamic response = await apiClass.getAssistantList(parentLogin.basicAuthToken);
    List<AssistantData> tempAssistantList = [];
    tempAssistantList.add(AssistantData(id: 404, firstName: "-- ${'selectAssistant'.tr}", lastName: ""));
    if(response['status']){
      AssistantList assistantList = AssistantList.fromJson(response);
      for(var x in assistantList.data){
        tempAssistantList.add(x);
      }
      setState(() {
        listOfAssistant = tempAssistantList;
        selectedAssistant = tempAssistantList[0];
        isLoading = false;
      });

    }else{
      Fluttertoast.showToast(msg: response['message']);
      setState(() {
        isLoading = false;
      });
    }
  }

  void back() {
    Navigator.pop(context);
  }
}
