import 'package:colegia_atenea/services/app_shared_preferences.dart';
import 'package:colegia_atenea/utils/text_style.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../models/assistant/assistant_login_model.dart';
import '../../models/assistant/assistant_student_rpt_message_list_model.dart';
import '../../services/api_class.dart';
import '../../utils/app_colors.dart';
import '../custom_widgets/custom_loader.dart';
import 'assistant_communication_report_details_screen.dart';
import 'assistant_communication_list_screen.dart';
import 'assistant_new_communication_screen.dart';
import 'message_received_by_assistant_from_parent/assistant_received_message_detail_screen.dart';

enum MessageType { received, send }

class CommonMessageListScreen extends StatefulWidget {
  const CommonMessageListScreen({super.key});

  @override
  State<CommonMessageListScreen> createState() =>
      _CommonMessageListScreenState();
}

class _CommonMessageListScreenState extends State<CommonMessageListScreen> {
  //this message list will contain message which is common message.
  List<MessageData> listOfReceivedMessage = [];
  List<MessageData> listOfSentMessage = [];
  bool isLoading = false;

  MessageType messageType = MessageType.received;

  @override
  void initState() {
    super.initState();
    getCommonMessageList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
            child: Column(
              children: [
                Row(
                  children: [
                    Radio(
                        value: MessageType.received,
                        activeColor: AppColors.primary,
                        groupValue: messageType,
                        onChanged: (MessageType? value) {
                          setState(() {
                            messageType = value!;
                          });
                        }),
                    Text(
                      'receiveOption'.tr,
                      style: CustomStyle.textValue,
                    ),
                    Radio(
                        value: MessageType.send,
                        activeColor: AppColors.primary,
                        groupValue: messageType,
                        onChanged: (MessageType? value) {
                          setState(() {
                            messageType = value!;
                          });
                        }),
                    Text(
                      'Enviadas'.tr,
                      style: CustomStyle.textValue,
                    ),
                  ],
                ),
                isLoading
                    ? const SizedBox.shrink()
                    : Expanded(
                        child: SizedBox(
                          width: MediaQuery.of(context).size.width,
                          height: MediaQuery.of(context).size.height,
                          child: CommonMessageWidget(
                            listOfItem: messageType == MessageType.received ? listOfReceivedMessage : listOfSentMessage,
                            messageType: messageType,
                          ),
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
      floatingActionButton: FloatingActionButton(
        backgroundColor: AppColors.primary,
        elevation: 0,
        onPressed: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => const NewCommunication(
                        isCommonMessageOrStudentReport: 0,
                      )));
        },
        child: const Icon(
          Icons.add,
          color: AppColors.white,
        ),
      ),
    );
  }

  void getCommonMessageList() async {
    setState(() {
      isLoading = true;
    });

    Assistant? assistant =  AppSharedPreferences.getAssistantLoggedInData();
    String token = assistant?.basicAuthToken ?? "";
    ApiClass apiClass = ApiClass();
    dynamic res = await apiClass.getCommonMessageList(token,assistant?.userdata.data.cookie ?? "");
    if (res['status']) {
      MessageListModel commonListModel = MessageListModel.fromJson(res);
      setState(() {
        listOfSentMessage = commonListModel.sendList;
        listOfReceivedMessage = commonListModel.receiveList;
        isLoading = false;
      });
    } else {
      setState(() {
        isLoading = false;
      });
    }
  }
}

class CommonMessageWidget extends StatelessWidget {
  final List<MessageData> listOfItem;
  final MessageType messageType;
  const CommonMessageWidget({super.key, required this.listOfItem,required this.messageType});

  @override
  Widget build(BuildContext context) {
    return listOfItem.isEmpty ? const EmptyListWidget() : ScrollConfiguration(
        behavior: const ScrollBehavior().copyWith(overscroll: false),
        child: ListView.separated(
          itemCount: listOfItem.length,
          itemBuilder: (context, index) {
            MessageData messageData = listOfItem[index];
            return GestureDetector(
              onTap: () {
                if(messageType == MessageType.received){
                  Navigator.push(context, MaterialPageRoute(builder: (context)=> AssistantMessageReceivedDetailScreen(id: messageData.id,)));
                }else{
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => CommunicationDetail(
                            isCommonMessageOrStudentReport: 0,
                            messageId: messageData.id,
                            receiverName: messageData.recieverName,
                            isButtonView: true,
                            fromParent: false,
                          )));
                }
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
