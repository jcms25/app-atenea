import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../models/assistant/assistant_login_model.dart';
import '../../../models/assistant/assistant_student_report_detail_model.dart';
import '../../../services/api_class.dart';
import '../../../services/session_management.dart';
import '../../../utils/app_colors.dart';
import '../../../utils/text_style.dart';
import '../../../widgets/custom_loader.dart';

class AssistantMessageReceivedDetailScreen extends StatefulWidget {
  final String id;

  const AssistantMessageReceivedDetailScreen({Key? key, required this.id})
      : super(key: key);

  @override
  State<AssistantMessageReceivedDetailScreen> createState() =>
      _AssistantMessageReceivedDetailScreenState();
}

class _AssistantMessageReceivedDetailScreenState
    extends State<AssistantMessageReceivedDetailScreen> {
  bool isLoading = false;
  String message = "";
  String? attachments = "";
  String subject = "";
  String messageDate = "";
  String senderName = "";
  TextStyle textStyleBold = const TextStyle(
      fontFamily: "Outfit",
      fontSize: 16,
      fontWeight: FontWeight.w500,
      color: AppColors.secondary);
  TextStyle textStyleRegularWithOpacity_50 = TextStyle(
      fontFamily: "Outfit",
      fontSize: 16,
      fontWeight: FontWeight.w400,
      color: AppColors.secondary.withOpacity(0.5));

  @override
  void initState() {
    super.initState();
    getDetailOfMessage();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text(
          'cmn_det'.tr,
          style: const TextStyle(
              fontFamily: "Outfit",
              fontWeight: FontWeight.w500,
              fontSize: 20,
              color: AppColors.white),
        ),
      ),
      body: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.all(10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: MediaQuery.of(context).size.width,
                  padding: const EdgeInsets.all(5),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: AppColors.primary.withOpacity(0.06)),
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(10),
                        child: Row(
                          children: [
                            Text(
                              "${'asDate'.tr} :",
                              style: textStyleRegularWithOpacity_50,
                            ),
                            const Spacer(),
                            Text(
                              messageDate,
                              style: textStyleBold,
                            ),
                          ],
                        ),
                      ),
                      CustomStyle.dottedLine,
                      Padding(
                        padding: const EdgeInsets.all(10),
                        child: Row(
                          children: [
                            Text(
                              "${'asSub'.tr} :",
                              style: textStyleRegularWithOpacity_50,
                              textAlign: TextAlign.right,
                            ),
                            Expanded(
                                child: Text(
                              subject,
                              style: textStyleBold,
                              textAlign: TextAlign.right,
                            )),
                            const SizedBox(
                              width: 5,
                            ),
                          ],
                        ),
                      ),
                      CustomStyle.dottedLine,
                      Padding(
                        padding: const EdgeInsets.all(10),
                        child: Row(
                          children: [
                            Text(
                              "${'asSendName'.tr} :",
                              style: textStyleRegularWithOpacity_50,
                            ),
                            Expanded(
                                child: AutoSizeText(
                                  senderName,
                                  style: textStyleBold,
                                  textAlign: TextAlign.right,
                                )),
                            const SizedBox(
                              width: 5,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 15,
                ),
                const SizedBox(
                  height: 20,
                ),
                Text(
                  "${'asMsg'.tr} :",
                  style: CustomStyle.textStyleBold
                      .copyWith(fontWeight: FontWeight.w600),
                ),
                const SizedBox(
                  height: 5,
                ),
                Container(
                  width: MediaQuery.of(context).size.width,
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                      color: AppColors.primary.withOpacity(0.05)),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: AutoSizeText(
                      message,
                      style: const TextStyle(
                          fontFamily: "Outfit",
                          fontWeight: FontWeight.w400,
                          fontSize: 16,
                          color: AppColors.secondary),
                    ),
                  ),
                ),
                Visibility(
                    visible:
                        attachments == null ? false : attachments!.isNotEmpty,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(
                          height: 10,
                        ),
                        Text(
                          "${'asAtch'.tr} :",
                          style: CustomStyle.textStyleBold
                              .copyWith(fontWeight: FontWeight.w600),
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                        GestureDetector(
                          onTap: () {
                            _launchAttachment(attachments!);
                          },
                          child: Container(
                            width: MediaQuery.of(context).size.width,
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(5),
                                color: AppColors.primary.withOpacity(0.05)),
                            child: Align(
                              alignment: Alignment.centerLeft,
                              child: AutoSizeText(
                                attachments == null
                                    ? ""
                                    : attachments!.split("/").last,
                                style: const TextStyle(
                                    fontFamily: "Outfit",
                                    fontWeight: FontWeight.w400,
                                    fontSize: 16,
                                    color: AppColors.secondary),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ))
              ],
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
      ),
    );
  }

  void getDetailOfMessage() async {
    setState(() {
      isLoading = true;
    });
    ApiClass apiClass = ApiClass();
    SessionManagement sessionManagement = SessionManagement();
    Assistant assistant = await sessionManagement.getAssistantDetail();
    String token = assistant.basicAuthToken;
    dynamic res = await apiClass.getMessageDetails(
        isCommonOrStudentReport: 0, token: token, messageId: widget.id);
    if (res['status']) {
      MessageDetailModel commonMessageModel = MessageDetailModel.fromJson(res);
      setState(() {
        message = commonMessageModel.data.msg ?? "-";
        attachments = commonMessageModel.data.attachments;
        subject = commonMessageModel.data.subject ?? "-";
        messageDate = commonMessageModel.data.mDate == null
            ? ""
            : DateFormat("dd-MM-yy").format(commonMessageModel.data.mDate!);
        isLoading = false;
        senderName = commonMessageModel.data.senderName ?? "-";

      });
    } else {
      setState(() {
        isLoading = false;
      });
    }
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
