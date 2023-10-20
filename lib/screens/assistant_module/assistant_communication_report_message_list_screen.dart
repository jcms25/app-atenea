import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../models/Parent/Parentlogin.dart';
import '../../models/assistant/assistant_login_model.dart';
import '../../models/assistant/assistant_student_rpt_message_list_model.dart';
import '../../services/api_class.dart';
import '../../services/session_mangement.dart';
import '../../utils/app_colors.dart';
import '../../utils/text_style.dart';
import '../../widgets/custom_loader.dart';
import 'assistant_communication_details_screen.dart';
import 'assistant_communication_list_screen.dart';

class ReportListScreen extends StatefulWidget {
  final String showInParent;
  const ReportListScreen({Key? key,required this.showInParent}) : super(key: key);

  @override
  State<ReportListScreen> createState() => _ReportListScreenState();
}

class _ReportListScreenState extends State<ReportListScreen> {

  //this message list will contain messages which is student report message.
  List<MessageData> listOfStudentReport = [];

  bool isLoading = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getStudentReportList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: widget.showInParent == "1" ? AppBar(
        backgroundColor: AppColors.primary,
        elevation: 0.0,
        title: Text('reportOption'.tr,style: CustomStyle.title.copyWith(color: AppColors.white,fontSize: 16)),
      ) : null,
      body:  Stack(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
            child: Column(
              children: [
                isLoading
                    ? const SizedBox.shrink()
                    : Expanded(
                    child: SizedBox(
                      width: MediaQuery.of(context).size.width,
                      height: MediaQuery.of(context).size.height,
                      child: listOfStudentReport.isEmpty
                          ? const EmptyListWidget()
                          : ReportList(listOfItem: listOfStudentReport,),
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
    );
  }

  void getStudentReportList() async{

    SessionManagement sessionManagement = SessionManagement();
    int? role = await sessionManagement.getRole('');

    setState(() {
      isLoading = true;
    });
    //if selected radio is select then student report list we wil retrieve.

    if(role == 2){
      Assistant assistant = await sessionManagement.getAssistantDetail();
      String token = assistant.basicAuthToken;
      getList(token,2);
    }
    else{
      Parentlogin parentLogin = await sessionManagement.getModelParent('');
      String token = parentLogin.basicAuthToken;
      getList(token,1);
    }
  }

  void getList(String token,int role) async{
    ApiClass apiClass = ApiClass();
    dynamic res = await apiClass.getStudentReportMessageList(token);
    if(res['status']){
      MessageListModel reportListModel = MessageListModel.fromJson(res);
      setState(() {
        listOfStudentReport = role == 2 ? reportListModel.sendList : reportListModel.receiveList ;
        isLoading = false;
      });
    }else{
      setState(() {
        isLoading = false;
      });
    }

  }
}


class ReportList extends StatelessWidget {
  final List<MessageData> listOfItem;

  const ReportList({super.key, required this.listOfItem});

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return ScrollConfiguration(
        behavior: const ScrollBehavior().copyWith(overscroll: false),
        child: ListView.separated(
          itemCount: listOfItem.length,
          itemBuilder: (context, index) {
            MessageData messageData = listOfItem[index];
            return GestureDetector(
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => CommunicationDetail(
                          isCommonMessageOrStudentReport: 1,
                          messageId: messageData.id,
                          receiverName: messageData.recieverName, isButtonView: false,
                          fromParent: false,
                        )));
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
                        Expanded(
                            child: Text(
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
                      // messageData.msg.length > 15
                      //     ? messageData.msg
                      //     .replaceAll("\n", "")
                      //     .substring(0, 20)
                      //     : messageData.msg,
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
