import 'package:colegia_atenea/models/Parent/Parentlogin.dart';
import 'package:colegia_atenea/models/assistant/assistant_login_model.dart';
import 'package:colegia_atenea/models/login_model.dart';
import 'package:colegia_atenea/services/app_shared_preferences.dart';
import 'package:colegia_atenea/views/assistant_module/assistant_new_communication_screen.dart';
import 'package:colegia_atenea/services/api_class.dart';
import 'package:colegia_atenea/services/session_management.dart';
import 'package:colegia_atenea/utils/app_colors.dart';
import 'package:colegia_atenea/views/custom_widgets/custom_loader.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../models/assistant/assistant_student_rpt_message_list_model.dart';
import '../../utils/text_style.dart';
import 'assistant_communication_report_details_screen.dart';

enum SelectOption { common, single }
//common for Common Message
//single for Single Student Report

class CommunicationListScreen extends StatefulWidget {
  final String showInParent;
  const CommunicationListScreen({super.key,required this.showInParent});

  @override
  State<StatefulWidget> createState() {
    return CommunicationListScreenChild();
  }
}

class CommunicationListScreenChild extends State<CommunicationListScreen> {
  SelectOption? selectOption = SelectOption.common;
  bool isLoading = false;

  //this message list will contain messages which is student report message.
  List<MessageData> listOfStudentReport = [];
  //this message list will contain message which is common message.
  List<MessageData> listOfCommonMessage = [];

  @override
  void initState() {
    super.initState();
    getMessageList(SelectOption.common);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: widget.showInParent == "1" ? AppBar(
        backgroundColor: AppColors.primary,
        elevation: 0.0,
        title: Text('cmn'.tr,style: CustomStyle.title.copyWith(color: AppColors.white,fontSize: 16)),
      ) : null,
        body: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
              child: Column(
                children: [
                  SizedBox(
                    width: MediaQuery.of(context).size.width,
                    height: 50,
                    child: Row(
                      children: [
                        Radio(
                          value: SelectOption.common,
                          groupValue: selectOption,
                          onChanged: (SelectOption? val) {
                            setState(() {
                              selectOption = val;
                            });
                            if(listOfCommonMessage.isEmpty){
                              getMessageList(SelectOption.common);
                            }
                          },
                          activeColor: AppColors.primary,
                        ),
                        Expanded(child: Text(
                          "option1".tr,
                          style: const TextStyle(
                              fontFamily: "Outfit",
                              fontSize: 16,
                              fontWeight: FontWeight.w400,
                              color: AppColors.secondary),
                        ),),
                        Radio(
                          value: SelectOption.single,
                          groupValue: selectOption,
                          onChanged: (SelectOption? val) {
                            setState(() {
                              selectOption = val;
                            });
                            if(listOfStudentReport.isEmpty){
                              getMessageList(SelectOption.single);
                            }
                          },
                          activeColor: AppColors.primary,
                        ),
                        Expanded(child: Text(
                          "option2".tr,
                          style: const TextStyle(
                              fontFamily: "Outfit",
                              fontSize: 16,
                              fontWeight: FontWeight.w400,
                              color: AppColors.secondary),
                        ),)
                      ],
                    ),
                  ),
                  isLoading ? const SizedBox.shrink() : Expanded(
                      child: SizedBox(
                        width: MediaQuery.of(context).size.width,
                        height: MediaQuery.of(context).size.height,
                        child: selectOption == SelectOption.single ? listOfStudentReport.isEmpty ? const EmptyListWidget() : BuildListWidget(listOfItem: listOfStudentReport, isCmnMessageOrStdReport: 1,) : listOfCommonMessage.isEmpty ? const EmptyListWidget() : BuildListWidget(listOfItem: listOfCommonMessage, isCmnMessageOrStdReport: 0,),
                      )),
                ],
              ),
            ),
            Visibility(
                visible: isLoading,
                child: Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              color: Colors.black54,
              child: const Center(
                child: LoadingLayout(),
              ),
            ))
          ],
        ),
        floatingActionButton: widget.showInParent == "1" ? null : Visibility(
          visible: selectOption == SelectOption.common,
          child: FloatingActionButton(
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          const NewCommunication(isCommonMessageOrStudentReport: 0)));
            },
            backgroundColor: AppColors.primary,
            elevation: 0,
            child: const Icon(Icons.add),
          ),
        )
    );
  }

  void getMessageList(SelectOption singleOption) async{
    // SessionManagement sessionManagement = SessionManagement();
    // int? role = await sessionManagement.getRole('');

    String? role = AppSharedPreferences.getUserLoggedInRole();

    if(singleOption == SelectOption.common){
      setState(() {
        isLoading = true;
      });

      if(role == "assistant"){
        Assistant? assistant = AppSharedPreferences.getAssistantLoggedInData();
        String token = assistant?.basicAuthToken ?? "";
        getCommonMessageList(token,role!,assistant?.userdata.data.cookie ?? "");
      }else{
        // Parentlogin parentLogin = await sessionManagement.getModelParent('');
        LoginModel? loginModel = AppSharedPreferences.getUserData();
        String token = loginModel?.basicAuthToken ?? "";
        getCommonMessageList(token,role!,loginModel?.userdata?.cookies ?? "");
      }

    }else{
      setState(() {
        isLoading = true;
      });
        //if selected radio is select then student report list we wil retrieve.

      if(role == "assistant"){
        Assistant? assistant = AppSharedPreferences.getAssistantLoggedInData();
        String token = assistant?.basicAuthToken ?? "";
        getStudentReportList(token,role ?? "",assistant?.userdata.data.cookie ?? "");
      }
      else{
        LoginModel? loginModel = AppSharedPreferences.getUserData();
        String token = loginModel?.basicAuthToken ?? "";
        getStudentReportList(token,role!,loginModel?.userdata?.cookies ?? "");
      }
    }
  }

  void getStudentReportList(String token,String assistantOrParent,String cookie) async{
      ApiClass apiClass = ApiClass();
      dynamic res = await apiClass.getStudentReportMessageList(token,cookie);
      if(res['status']){
        MessageListModel reportListModel = MessageListModel.fromJson(res);
        setState(() {
          listOfStudentReport = assistantOrParent == "assistant" ? reportListModel.sendList : reportListModel.receiveList ;
          isLoading = false;
        });
      }else{
        setState(() {
          isLoading = false;
        });
      }

  }

  void getCommonMessageList(String token,String parentOrAssistant,String cookie) async{
    ApiClass apiClass = ApiClass();
    dynamic res = await apiClass.getCommonMessageList(token,cookie);
    if(res['status']){
      MessageListModel commonListModel = MessageListModel.fromJson(res);
      setState(() {
        listOfCommonMessage = parentOrAssistant == "assistant" ? commonListModel.sendList : commonListModel.receiveList;
        isLoading = false;
      });
    }
    else{
      setState(() {
        isLoading = false;
      });
    }
  }
}

class EmptyListWidget extends StatelessWidget{
  const EmptyListWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text("${'noStudentFound'.tr}.",style: CustomStyle.textValue,),
    );
  }

}

class BuildListWidget extends StatelessWidget {
  final List<MessageData> listOfItem;
  final int isCmnMessageOrStdReport;
  const BuildListWidget({super.key,required this.listOfItem,required this.isCmnMessageOrStdReport});

  @override
  Widget build(BuildContext context) {
    return ScrollConfiguration(behavior: const ScrollBehavior().copyWith(overscroll: false), child: ListView.separated(
      itemCount: listOfItem.length,
      itemBuilder: (context, index) {
        MessageData messageData = listOfItem[index];
        return GestureDetector(
          onTap: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) =>
                        CommunicationDetail(isCommonMessageOrStudentReport: isCmnMessageOrStdReport,messageId: messageData.id,receiverName: messageData.recieverName, isButtonView : isCmnMessageOrStdReport == 0 ? true : false,fromParent: false,)));
          },
          child: Container(
            width: MediaQuery.of(context).size.width,
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: AppColors.primary.withOpacity(0.05)),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(child: Text(
                      messageData.subject,
                      style: const TextStyle(
                          fontFamily: "Outfit",
                          fontSize: 18,
                          fontWeight: FontWeight.w600),
                    )),
                    Text(
                      DateFormat("dd-MM-yy").format(messageData.mDate),
                      style: const TextStyle(
                          fontFamily: "Outfit",
                          fontSize: 14,
                          fontWeight: FontWeight.w400),
                    )
                  ],
                ),
                Text(
                  // messageData.msg.length > 15 ? messageData.msg.replaceAll("\n", "").substring(0,20) : messageData.msg,
                  messageData.senderName,
                  style: const TextStyle(
                      fontFamily: "Outfit",
                      fontSize: 16,
                      fontWeight: FontWeight.w400,
                      color: AppColors.secondary),
                )
              ],
            ),
          ),
        );
      },
      separatorBuilder: (BuildContext context, int index) {
        return const SizedBox(
          height: 10,
        );
      },
    ));
  }
}
