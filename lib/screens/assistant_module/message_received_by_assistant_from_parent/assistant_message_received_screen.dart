import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../models/assistant/assistant_login_model.dart';
import '../../../models/assistant/assistant_student_rpt_message_list_model.dart';
import '../../../services/api_class.dart';
import '../../../services/session_management.dart';
import '../../../utils/app_colors.dart';
import '../../../widgets/custom_loader.dart';
import 'assistant_received_message_detail_screen.dart';

class AssistantMessageReceivedScreen extends StatefulWidget {
  const AssistantMessageReceivedScreen({Key? key}) : super(key: key);

  @override
  State<AssistantMessageReceivedScreen> createState() => _AssistantMessageReceivedScreenState();
}

class _AssistantMessageReceivedScreenState extends State<AssistantMessageReceivedScreen> {
  //this message list will contain message which is common message.
  List<MessageData> listOfReceivedMessage = [];
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    getReceiveMessageList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.all(10),
            child: isLoading ? const SizedBox.shrink() :
            listOfReceivedMessage.isEmpty ? SizedBox(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              child: const Center(
                child: Text("No Message."),
              ),
            ) :
            ListView.separated(
              itemBuilder: (context,index){
                MessageData messageData = listOfReceivedMessage[index];
                return GestureDetector(
                  onTap: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context)=> AssistantMessageReceivedDetailScreen(id: messageData.id,)));
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
                          messageData.msg.length > 15
                              ? messageData.msg
                              .replaceAll("\n", "")
                              .substring(0, 20)
                              : messageData.msg,
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
              separatorBuilder: (context,index){
                return const SizedBox(
                  height: 10,
                );
              },
              itemCount: listOfReceivedMessage.length,
            ),
          ),
          Visibility(
              visible: isLoading,
              child: Container(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height,
                color: Colors.black54,
                child: const LoadingLayout(),
              ))
        ],
      )
    );
  }

  void getReceiveMessageList() async{
    setState(() {
      isLoading = true;
    });
    SessionManagement sessionManagement = SessionManagement();
    Assistant assistant = await sessionManagement.getAssistantDetail();
    String token = assistant.basicAuthToken;
    ApiClass apiClass = ApiClass();
    dynamic res = await apiClass.getCommonMessageList(token);
    if(res['status']){
      MessageListModel commonListModel = MessageListModel.fromJson(res);
      setState(() {
        listOfReceivedMessage = commonListModel.receiveList;
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
