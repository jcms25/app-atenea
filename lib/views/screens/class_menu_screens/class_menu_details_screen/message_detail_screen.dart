import 'package:colegia_atenea/controllers/student_parent_teacher_controller.dart';
import 'package:colegia_atenea/models/Failed.dart';
import 'package:colegia_atenea/models/Parent/Parentlogin.dart';
import 'package:colegia_atenea/models/Student/Studentlogin.dart';
import 'package:colegia_atenea/models/login_model.dart';
import 'package:colegia_atenea/models/single_message_detail_model.dart';
import 'package:colegia_atenea/services/api_class.dart';
import 'package:colegia_atenea/services/app_shared_preferences.dart';
import 'package:colegia_atenea/utils/app_textstyle.dart';
import 'package:colegia_atenea/views/custom_widgets/custom_app_bar_widget.dart';
import 'package:colegia_atenea/views/custom_widgets/custom_loader.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../services/session_management.dart';
import '../../../../utils/app_colors.dart';

class MessageDetail extends StatefulWidget {
  final String messageId;

  const MessageDetail(this.messageId, {super.key});

  @override
  State<StatefulWidget> createState() {
    return MessageDetailChild();
  }
}

class MessageDetailChild extends State<MessageDetail> {
  String name = "";
  String messageDate = "";
  String messageTime = "";
  String imagePath = "";
  String messageDescription = "";
  String messageSubject = "";
  String attachment = "";
  bool isLoading = false;
  bool dataget = false;
  String message = "";

  TextStyle textStyle = const TextStyle(
      fontFamily: "Outfit",
      fontSize: 18,
      fontWeight: FontWeight.w400,
      color: AppColors.secondary);

  @override
  void initState() {
    super.initState();
    setState(() {
      isLoading = true;
    });
    getSingleMessageDetail(widget.messageId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBarWidget(
        onLeadingIconClicked: (){
          Get.back();
        },
        title: Text(
          "mTitle".tr,
          style: AppTextStyle.getOutfit500(
              textSize: 20, textColor: AppColors.white),
        ),
      ),

      body: Stack(
        children: [
          SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(10),
              child: dataget
                  ? Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(
                          height: 10,
                        ),
                        SizedBox(
                          width: MediaQuery.of(context).size.width,
                          height: 80,
                          child: Row(
                            children: [
                              imagePath.isEmpty
                                  ? const SizedBox.shrink()
                                  : CircleAvatar(
                                      radius: 30.0,
                                      backgroundImage: NetworkImage(imagePath),
                                      backgroundColor: AppColors.primary,
                                    ),
                              const SizedBox(
                                width: 20,
                              ),
                              Expanded(
                                  child: SizedBox(
                                child: Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Expanded(
                                          child: Text(
                                            name,
                                            style: textStyle.copyWith(
                                                fontSize: 16),
                                          ),
                                        ),
                                        Text(
                                          messageTime,
                                          style: textStyle.copyWith(
                                              color: AppColors.secondary
                                                  .withOpacity(0.5),
                                              fontSize: 14),
                                        )
                                      ],
                                    ),
                                    Text(
                                      messageDate,
                                      style: textStyle.copyWith(
                                          color: AppColors.secondary
                                              .withOpacity(0.5),
                                          fontSize: 14),
                                    )
                                  ],
                                ),
                              )),
                              const SizedBox(
                                width: 10,
                              )
                            ],
                          ),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        Text(
                          messageSubject,
                          style:
                              textStyle.copyWith(fontWeight: FontWeight.w600),
                          textAlign: TextAlign.start,
                        ),
                        const SizedBox(
                          height: 30,
                        ),
                        Text(
                          messageDescription,
                          style: textStyle.copyWith(
                              color: AppColors.secondary.withOpacity(0.5)),
                        ),
                        Visibility(
                            visible: attachment.isNotEmpty,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const SizedBox(
                                  height: 20,
                                ),
                                Text(
                                  'asAtch'.tr,
                                  style: textStyle.copyWith(fontSize: 16),
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                GestureDetector(
                                  onTap: () {
                                    _launchAttachment(attachment);
                                  },
                                  child: Container(
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(5),
                                        color: AppColors.secondary
                                            .withOpacity(0.05)),
                                    width: MediaQuery.of(context).size.width,
                                    padding: const EdgeInsets.all(10),
                                    child: Text(
                                      attachment.split("/").last,
                                      style: const TextStyle(
                                          color: AppColors.secondary,
                                          fontSize: 16),
                                    ),
                                  ),
                                )
                              ],
                            ))
                      ],
                    )
                  : isLoading
                      ? const SizedBox.shrink()
                      : Center(
                          child: Text(message),
                        ),
            ),
          ),
          Consumer<StudentParentTeacherController>(
            builder: (context,studentParentTeacherController,child){
              return Visibility(
                visible: isLoading,
                child: const Center(
                  child: LoadingLayout(),
                ),
              );
            }
          )
        ],
      ),
    );
  }

  void getSingleMessageDetail(String messageId) async {

    try{
      LoginModel? loginModel = AppSharedPreferences.getUserData();
      String? token = loginModel?.basicAuthToken;
      String? cookie = loginModel?.userdata?.cookies;

      dynamic response = await ApiClass().getSingleMessageDetail(
          token ?? "", messageId, cookie ?? "");
      if (response['status']) {
        SingleMessageDetailModel singleMessageDetailModel =
        SingleMessageDetailModel.fromJson(response);
        setState(() {
          name = singleMessageDetailModel.data.name ?? "";
          messageDate = DateFormat("dd/MM/yy")
              .format(DateTime.parse(singleMessageDetailModel.data.mDate ?? ""));
          messageTime = DateFormat("HH:mm ")
              .format(DateTime.parse(singleMessageDetailModel.data.mDate ?? ""));
          imagePath = singleMessageDetailModel.data.image ?? "";
          messageSubject = singleMessageDetailModel.data.subject ?? "";
          messageDescription = singleMessageDetailModel.data.msg ?? "";
          attachment = singleMessageDetailModel.data.attachments ?? "";
          dataget = true;
          isLoading = false;
        });
      } else {
        setState(() {
          isLoading = false;
        });
      }
    }catch(exception){
     setState(() {
       isLoading = false;
     });
    }

    // ApiClass apiClass = ApiClass();
    // SessionManagement sessionManagement = SessionManagement();
    // int? role = await sessionManagement.getRole("Role");
    // if (role == 0) {
    //   Studentlogin login = await sessionManagement.getModel('Student');
    //   String token = login.basicAuthToken;
    //   try {
    //     dynamic response = await apiClass.getSingleMessageDetail(
    //         token, messageId, login.userdata.cookie ?? "");
    //     if (response['status']) {
    //       SingleMessageDetailModel singleMessageDetailModel =
    //           SingleMessageDetailModel.fromJson(response);
    //       setState(() {
    //         name = singleMessageDetailModel.data.name ?? "";
    //         messageDate = DateFormat("dd/MM/yy")
    //             .format(DateTime.parse(singleMessageDetailModel.data.mDate ?? ""));
    //         messageTime = DateFormat("HH:mm ")
    //             .format(DateTime.parse(singleMessageDetailModel.data.mDate ?? ""));
    //         imagePath = singleMessageDetailModel.data.image ?? "";
    //         messageSubject = singleMessageDetailModel.data.subject ?? "";
    //         messageDescription = singleMessageDetailModel.data.msg ?? "";
    //         attachment = singleMessageDetailModel.data.attachments ?? "";
    //         dataget = true;
    //         isLoading = false;
    //       });
    //     } else {
    //       Failed failed = Failed.fromJson(response);
    //       setState(() {
    //         isLoading = false;
    //         message = failed.message;
    //       });
    //     }
    //   } catch (exception) {
    //     setState(() {
    //       isLoading = false;
    //     });
    //   }
    // }
    //
    // else {
    //   Parentlogin parentLogin =
    //       await sessionManagement.getModelParent('Parent');
    //   String token = parentLogin.basicAuthToken;
    //   dynamic response = await apiClass.getSingleMessageDetail(
    //       token, messageId, parentLogin.userdata.cookie ?? "");
    //   if (response['status']) {
    //     SingleMessageDetailModel singleMessageDetailModel =
    //         SingleMessageDetailModel.fromJson(response);
    //     setState(() {
    //       name = singleMessageDetailModel.data.name ?? "";
    //       messageDate = DateFormat("dd/MM/yy")
    //           .format(DateTime.parse(singleMessageDetailModel.data.mDate ?? ""));
    //       messageTime =
    //           DateFormat("HH:mm").format(DateTime.parse(singleMessageDetailModel.data.mDate ?? ""));
    //       imagePath = singleMessageDetailModel.data.image ?? "";
    //       messageSubject = singleMessageDetailModel.data.subject ?? "";
    //       messageDescription = singleMessageDetailModel.data.msg ?? "";
    //       attachment = singleMessageDetailModel.data.attachments ?? "";
    //       dataget = true;
    //       isLoading = false;
    //     });
    //   } else {
    //     Failed failed = Failed.fromJson(response);
    //     setState(() {
    //       isLoading = false;
    //       message = failed.message;
    //     });
    //   }
    // }
  }

  void _launchAttachment(String attachment) async {
    var url = Uri.parse(attachment);
    if (await canLaunchUrl(url)) {
      await launchUrl(url, mode: LaunchMode.externalApplication);
    } else {
      Fluttertoast.showToast(msg: "canNot".tr);
    }
  }
}
