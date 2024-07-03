// ignore_for_file: prefer_final_fields


import 'package:auto_size_text/auto_size_text.dart';
import 'package:colegia_atenea/models/Parent/Parentlogin.dart';
import 'package:colegia_atenea/models/assistant/assistant_student_report_detail_model.dart';
import 'package:colegia_atenea/views/assistant_module/assistant_new_communication_screen.dart';
import 'package:colegia_atenea/services/api_class.dart';
import 'package:colegia_atenea/utils/text_style.dart';
import 'package:colegia_atenea/widgets/custom_loader.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../models/assistant/assistant_login_model.dart';
import '../../services/session_management.dart';
import '../../utils/app_colors.dart';

class CommunicationDetail extends StatefulWidget {
  final int isCommonMessageOrStudentReport;
  final bool isButtonView;
  final bool fromParent;

  //0 means user came here to see details of common message.
  //1 means user came here to see details of student report.
  //2 means user came here to see details of student report and user also can see previous report using date  picker.
  final String? messageId;
  final String? studentId;
  final String? messageDate;
  final String? receiverName;


  const CommunicationDetail(
      {super.key,
      required this.isCommonMessageOrStudentReport,
      required this.isButtonView,
      required this.fromParent,
      this.messageId,
      this.studentId,
      this.messageDate,
      this.receiverName});

  @override
  State<StatefulWidget> createState() {
    return CommunicationDetailChild();
  }
}

class CommunicationDetailChild extends State<CommunicationDetail> {
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

  List<String> tempList = [
    "He had a very good breakfast",
    "About anything",
    "3",
    "4",
    "5",
    "6",
    "7",
    "8",
    "9",
    "10"
  ];

  List<ReportData> studentReport = [];
  String message = "";
  String subject = "";
  String messageDate = "";
  String receiverName = "-";
  String? attachments = "";
  String? childName = "";
  bool isLoading = false;
  late String titleName;

  MessageDetailModel? messageDetailModel;

  @override
  void initState() {
    super.initState();
    titleName = widget.isCommonMessageOrStudentReport == 0 ? 'cmn_det'.tr : widget.isCommonMessageOrStudentReport == 1 ?'cmn_report'.tr : "";
    if (widget.isCommonMessageOrStudentReport == 0 ||
        widget.isCommonMessageOrStudentReport == 1) {
      getCommunicationDetail(
          isCommonMessageOrStudentReport:
              widget.isCommonMessageOrStudentReport);
    } else {
      getCommunicationDetail(
          isCommonMessageOrStudentReport: widget.isCommonMessageOrStudentReport,
          dateForMessage: DateFormat("yyyy-MM-dd").format(DateTime.now()),
          studentId: widget.studentId);
    }
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
          titleName,
          style: const TextStyle(
              fontFamily: "Outfit",
              fontWeight: FontWeight.w500,
              fontSize: 20,
              color: AppColors.white),
        ),
      ),
      body: Stack(
        children: [
          Visibility(
            visible: !isLoading,
            child: ScrollConfiguration(
              behavior: const ScrollBehavior().copyWith(overscroll: false),
              child: SingleChildScrollView(
                child: Padding(
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
                                    textAlign: TextAlign.right,
                                  ),
                                  const SizedBox(
                                    width: 10,
                                  ),
                                  Visibility(
                                    visible:
                                        widget.isCommonMessageOrStudentReport ==
                                            2,
                                    child: GestureDetector(
                                      onTap: () {
                                        pickDate();
                                      },
                                      child: SvgPicture.asset(
                                        "Assets/transfer_icon.svg",
                                        width: 18,
                                        height: 18,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(
                                    width: 4,
                                  )
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
                                  ),
                                  Expanded(child: AutoSizeText(
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
                            Visibility(
                                visible: !widget.fromParent,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(10),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        "${'asPadre'.tr} :",
                                        style: textStyleRegularWithOpacity_50,
                                      ),
                                      AutoSizeText(
                                        receiverName,
                                        style: textStyleBold,
                                        textAlign: TextAlign.end,
                                      ),
                                    ],
                                  ),
                                ),
                                CustomStyle.dottedLine
                              ],
                            )),
                            Visibility(
                                visible: childName != null,
                                child: Padding(
                              padding: const EdgeInsets.all(10),
                              child: Row(
                                children: [
                                  Text(
                                    "Petite :",
                                    style: textStyleRegularWithOpacity_50,
                                  ),
                                  Expanded(child: AutoSizeText(
                                    childName ?? "-",
                                    style: textStyleBold,
                                    textAlign: TextAlign.right,
                                  )),
                                  const SizedBox(
                                    width: 5,
                                  ),
                                ],
                              ),
                            )),
                          ],
                        ),
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      widget.isCommonMessageOrStudentReport == 0
                          ? const SizedBox.shrink()
                              : Text('asRpt'.tr,style: const TextStyle(fontSize: 20),),
                      widget.isCommonMessageOrStudentReport == 0
                          ? const SizedBox.shrink()
                          : const SizedBox(height: 10,),
                      widget.isCommonMessageOrStudentReport == 0
                          ? const SizedBox.shrink()
                          : studentReport.isEmpty
                              ? const SizedBox.shrink()
                              : const SizedBox(
                                  height: 10,
                                ),
                      widget.isCommonMessageOrStudentReport == 0
                          ? const SizedBox.shrink()
                          : Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                            CustomSummaryRow(label: "Desayuno", value: messageDetailModel?.data.breakFast),
                            const SizedBox(height: 5,),
                          CustomSummaryRow(label: "Merienda", value: messageDetailModel?.data.snack),
                          const SizedBox(height: 5,),
                          CustomSummaryRow(label: "Comida", value: messageDetailModel?.data.food),
                          const SizedBox(height: 5,),
                          CustomSummaryRow(label: "Aseo", value: messageDetailModel?.data.cleanliness),
                          const SizedBox(height: 5,),
                          CustomSummaryRow(label: "Sueño", value: messageDetailModel?.data.sleep),
                          const SizedBox(height: 5,),
                        ],
                      ),
                      widget.isCommonMessageOrStudentReport == 0
                          ? const SizedBox.shrink()
                          : studentReport.isEmpty
                          ? const SizedBox.shrink()
                          : const SizedBox(
                        height: 10,
                      ),
                      widget.isCommonMessageOrStudentReport == 0
                          ? const SizedBox.shrink()
                          : studentReport.isEmpty
                              ? const SizedBox.shrink()
                              : Container(
                                  decoration: BoxDecoration(
                                      border: Border.all(
                                          color: AppColors.primary, width: 3)),
                                  child: Column(
                                    children: [
                                      widget.isCommonMessageOrStudentReport == 0
                                          ? const SizedBox.shrink()
                                          : studentReport.isEmpty
                                              ? const SizedBox.shrink()
                                              : CustomTableRow(
                                                  'asHrs'.tr,
                                                  'asCmt'.tr,
                                                  AppColors.primary),
                                      Column(
                                        children: studentReport.map((e) {
                                          return CustomTableRow(
                                              "${e.beginTime}-${e.endTime}\n${e.subName}",
                                              e.text ?? "",
                                              AppColors.white);
                                        }).toList(),
                                      )
                                    ],
                                  ),
                                ),
                      const SizedBox(
                        height: 10,
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
                          visible: attachments == null ? false : attachments!.isNotEmpty,
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
                                onTap: (){
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
                                      attachments == null ? "" : attachments!.split("/").last,
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
              ),
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
      floatingActionButton: Visibility(
        visible: widget.isButtonView,
        child: FloatingActionButton(
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
      ),
    );
  }

  void pickDate() async {
    DateTime? pickDate = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime(1950),
        lastDate: DateTime(2050));
    if (pickDate != null) {
      getCommunicationDetail(
          isCommonMessageOrStudentReport: 2,
          dateForMessage: pickDate.toString(),
          studentId: widget.studentId);
    }
  }

  void getCommunicationDetail(
      {required int isCommonMessageOrStudentReport,
      String? dateForMessage,
      String? studentId}) async {
    ApiClass apiClass = ApiClass();
    SessionManagement sessionManagement = SessionManagement();
    String token = "";
    String cookie = "";
    int? role = await sessionManagement.getRole('');
    if (role == 2) {
      Assistant assistant = await sessionManagement.getAssistantDetail();
      token = assistant.basicAuthToken;
      cookie = assistant.userdata.data.cookie ?? "";
    } else {
      Parentlogin parentLogin = await sessionManagement.getModelParent('');
      token = parentLogin.basicAuthToken;
      cookie = parentLogin.userdata.cookie ?? "";
    }
    if (isCommonMessageOrStudentReport == 0) {
      //this will  get details of common message.
      setState(() {
        isLoading = true;
      });
      dynamic res = await apiClass.getMessageDetails(
          isCommonOrStudentReport: 0,
          token: token,
          messageId: widget.messageId!, cookie: cookie);
      if (res['status']) {
        MessageDetailModel commonMessageModel =
            MessageDetailModel.fromJson(res);
        setState(() {
          messageDetailModel = commonMessageModel;
          messageDate =  commonMessageModel.data.mDate == null ? "" :
              DateFormat("dd-MM-yy").format(commonMessageModel.data.mDate!);
          subject = commonMessageModel.data.subject ?? "";
          message = commonMessageModel.data.msg ?? "";
          attachments = commonMessageModel.data.attachments;
          receiverName = widget.receiverName ?? "";
          titleName = 'cmn_det'.tr;
          isLoading = false;
        });
      } else {
        setState(() {
          isLoading = false;
        });
      }
    }
    else {
      //this will get details of student report message.
      if (isCommonMessageOrStudentReport == 1) {
        //means user came here to just see student report message detail from message list screen.
        setState(() {
          isLoading = true;
        });
        dynamic res = await apiClass.getMessageDetails(
            isCommonOrStudentReport: 1,
            token: token,
            messageId: widget.messageId!, cookie: cookie);
        if (res['status']) {
          if (isCommonMessageOrStudentReport == 1) {
            MessageDetailModel studentReportDetailModel =
                MessageDetailModel.fromJson(res);
            setState(() {
              messageDetailModel = studentReportDetailModel;
              studentReport = studentReportDetailModel.data.reportData;
              message = studentReportDetailModel.data.msg ?? "";
              messageDate = studentReportDetailModel.data.mDate == null ? "" :
              DateFormat("dd-MM-yy")
                  .format(studentReportDetailModel.data.mDate!);
              subject = studentReportDetailModel.data.subject ?? "";
              attachments = studentReportDetailModel.data.attachments;
              childName = studentReportDetailModel.data.studentName;
              receiverName = widget.receiverName ?? studentReportDetailModel.data.receiverName!;
              titleName = 'cmn_report'.tr;
              isLoading = false;
            });
          }
        } else {
          setState(() {
            isLoading = false;
          });
        }
      } else {
        //user can also see older report of student
        //user came here from clicking on child list screen.
        setState(() {
          isLoading = true;
          receiverName = "";
        });
        dynamic res = await apiClass.getMessageDetailsUsingDate(
            token: token, date: dateForMessage!, studentId: studentId!, cookie: cookie);
        if (res['status']) {
          MessageDetailModel studentReportDetailModel =
          MessageDetailModel.fromJson(res);
          setState(() {
            messageDetailModel = studentReportDetailModel;
            studentReport = studentReportDetailModel.data.reportData;
            message = studentReportDetailModel.data.msg ?? "";
            messageDate = studentReportDetailModel.data.mDate == null ? "" :
            DateFormat("dd-MM-yy")
                .format(studentReportDetailModel.data.mDate!);
            subject = studentReportDetailModel.data.subject ?? "";
            attachments = studentReportDetailModel.data.attachments;
            titleName = studentReportDetailModel.data.slotId == null ? 'cmn_det'.tr : 'cmn_report'.tr;
            receiverName = studentReportDetailModel.data.receiverName ?? studentReportDetailModel.data.receiverName!;
            childName = studentReportDetailModel.data.studentName ?? "-";
            isLoading = false;
          }
          );
        } else {
          setState(() {
            studentReport = [];
            isLoading = false;
            message = "There is no message available for selected date.";
            messageDate =
                DateFormat("dd-MM-yy").format(DateTime.parse(dateForMessage));
            subject = "-";
            receiverName = "-";
            titleName = 'cmn_det'.tr;
          });
        }
      }
    }
  }

  void _launchAttachment(String attachment) async{
    var url = Uri.parse(attachment);
    if(await canLaunchUrl(url)){
      await launchUrl(url,mode: LaunchMode.externalApplication);
    }else{
      Fluttertoast.showToast(msg: "canNot".tr);
    }
  }

}

class CustomTableRow extends StatelessWidget {
  final String _label;
  final String _value;
  final Color _backColor;

  const CustomTableRow(this._label, this._value, this._backColor, {super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
            child: Container(
                height: 60,
                decoration: BoxDecoration(
                    border: Border.all(
                        width: 1, color: Colors.grey.withOpacity(0.05)),
                    color: _backColor),
                padding: const EdgeInsets.only(left: 20),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: AutoSizeText(
                    _label,
                    maxLines: 3,
                    style: CustomStyle.textStyleBold.copyWith(
                        color: _backColor == AppColors.primary
                            ? AppColors.white
                            : AppColors.secondary,
                        fontSize: 18),
                  ),
                ))),
        Expanded(
            child: Container(
                height: 60,
                padding: const EdgeInsets.only(left: 20),
                decoration: BoxDecoration(
                  border: Border.all(
                      width: 1, color: Colors.grey.withOpacity(0.05)),
                  color: _backColor,
                ),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: AutoSizeText(
                    _value,
                    maxLines: 3,
                    style: CustomStyle.textStyleBold.copyWith(
                        color: _backColor == AppColors.primary
                            ? AppColors.white
                            : AppColors.secondary,
                        fontSize: 18),
                  ),
                ))),
      ],
    );
  }
}



class CustomSummaryRow extends StatelessWidget {
  final String label;
  final String? value;
  const CustomSummaryRow({super.key, required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(label,style: const TextStyle(
            fontFamily: "Outfit",
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: Colors.black
          ),
        ),
        const Text(":\t\t",style: TextStyle(color: Colors.black,fontSize: 18,fontWeight: FontWeight.w400),),
        Expanded(child: Text(value?.isEmpty ?? false ? "-" : value ?? "-" ,style: const TextStyle(
            fontFamily: "Outfit",
            fontSize: 16,
            fontWeight: FontWeight.w400,
            color: Colors.black,),
        ))
      ],
    );
  }
}
