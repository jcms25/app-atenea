  import 'package:colegia_atenea/utils/app_constants.dart';
import 'package:colegia_atenea/views/assistant_module/assistant_communication_report_details_screen.dart';
import 'package:colegia_atenea/views/custom_widgets/message_list_widget.dart';
import 'package:colegia_atenea/views/screens/send_message_screen.dart';
import 'package:colegia_atenea/utils/app_colors.dart';
import 'package:colegia_atenea/utils/text_style.dart';
import 'package:colegia_atenea/views/custom_widgets/custom_loader.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

import '../../controllers/student_parent_teacher_controller.dart';
import '../../models/list_of_messages_model.dart';
import '../../utils/app_textstyle.dart';
import 'class_menu_screens/class_menu_details_screen/message_detail_screen.dart';

class MessageScreen extends StatefulWidget {
  final String studentOrParent;

  const MessageScreen({super.key, required this.studentOrParent});

  @override
  State<MessageScreen> createState() => MessageListScreen();
}

class MessageListScreen extends State<MessageScreen> {

  StudentParentTeacherController? appController;


  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp){
      appController = Provider.of<StudentParentTeacherController>(context,listen: false);
      appController?.getMessageList(showLoader: !(appController?.listOfMessagesModel != null));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Stack(
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                  height: 90,
                  width: MediaQuery.of(context).size.width,
                  decoration: const BoxDecoration(
                      borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(20),
                          bottomRight: Radius.circular(20)),
                      color: AppColors.primary),
                  child: Padding(
                    padding: const EdgeInsets.only(left: 15, right: 15),
                    child: Row(
                      children: [
                        Expanded(
                          child: Container(
                            height: 50,
                            decoration: BoxDecoration(
                              color: AppColors.white,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Consumer<StudentParentTeacherController>(
                              builder: (context,appController,child){
                                return TextField(
                                  autofocus: false,
                                  decoration: InputDecoration(
                                      prefixIcon: IconButton(
                                        icon: const Icon(
                                          Icons.search,
                                          color: AppColors.searchIcon,
                                        ),
                                        onPressed: () {},
                                      ),
                                      hintText: 'searchInList'.tr,
                                      hintStyle: AppTextStyle.getOutfit400(textSize: 16, textColor: AppColors.secondary.withOpacity(0.5)),
                                      contentPadding: const EdgeInsets.all(10),
                                      border: InputBorder.none),
                                  style: CustomStyle.textValue,
                                  keyboardType: TextInputType.text,
                                  textInputAction: TextInputAction.done,
                                  cursorColor: AppColors.primary,
                                  onChanged: appController.searchInMessageList,
                                );
                              },
                            ),
                          ),
                        ),
                      ],
                    ),
                  )),
              const SizedBox(height: 20,),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  CustomRadioWidget(messageType: AppConstants.messageType1),
                  CustomRadioWidget(messageType: AppConstants.messageType2),

                ],
              ),
              const SizedBox(height: 20,),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                child: ScrollConfiguration(
                    behavior: const ScrollBehavior().copyWith(overscroll: false),
                    child: Consumer<StudentParentTeacherController>(
                      builder: (context,appController,child){
                        return appController.tempMessageList.isEmpty ?
                            Center(
                              child: Text("No hay mensajes",style: AppTextStyle.getOutfit400(textSize: 16, textColor: AppColors.secondary),),
                            )
                            : ListView.separated(
                            itemBuilder: (context, index) {
                              MessageItem messageItem = appController.tempMessageList[index];
                              return MessageListWidget(messageItem: messageItem, onPressed: (){

                                if(messageItem.id != null){
                                  Get.to(() => CommunicationDetail(isCommonMessageOrStudentReport: 0, messageId: messageItem.id,isButtonView: false, fromParent: true));
                                }else{
                                  Get.to(() => MessageDetail(messageItem.mid ?? ""));
                                }
                              });
                            },
                            separatorBuilder: (context, index) {
                              return const SizedBox(height: 20);
                            },
                            itemCount: appController.tempMessageList.length);
                      },
                    )
                ),
                ) ,
              ),
            ],
          ),
          Consumer<StudentParentTeacherController>(
            builder: (context,appController,child){
              return Visibility(
                  visible: appController.isLoading,
                  child: const LoadingLayout());
            },
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(context, MaterialPageRoute(builder: (context) {
            return const MessageSendScreen();
          }));
        },
        backgroundColor: AppColors.primary,
        elevation: 0,
        child: const Icon(
          Icons.add,
          color: AppColors.white,
        ),
      ),
    );
  }

}


class CustomRadioWidget extends StatelessWidget {
  final String messageType;
  const CustomRadioWidget({super.key, required this.messageType});

  @override
  Widget build(BuildContext context) {
    return Consumer<StudentParentTeacherController>(
      builder: (context,appController,child){
        return Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            SizedBox(
              width: 25,
              height: 25,
              child: Radio(
                  value: messageType, groupValue: appController.currentSelectedMessageListType, onChanged: (String? value){
                appController.setCurrentSelectedMessageType(currentSelectedMessageListType: messageType);
              }),
            ),
            const SizedBox(width: 5,),
            Text(messageType,style: AppTextStyle.getOutfit400(textSize: 16, textColor: AppColors.secondary),)
          ],
        );
      },
    );
  }
}
