import 'package:colegia_atenea/models/Parent/Parentlogin.dart';
import 'package:colegia_atenea/models/Student/Studentlogin.dart';
import 'package:colegia_atenea/models/messgelist.dart';
import 'package:colegia_atenea/views/assistant_module/assistant_communication_details_screen.dart';
import 'package:colegia_atenea/views/details_screen/message_detail_screen.dart';
import 'package:colegia_atenea/views/nav_screens/send_message_screen.dart';
import 'package:colegia_atenea/services/api_class.dart';
import 'package:colegia_atenea/services/session_management.dart';
import 'package:colegia_atenea/utils/app_colors.dart';
import 'package:colegia_atenea/utils/app_images.dart';
import 'package:colegia_atenea/utils/text_style.dart';
import 'package:colegia_atenea/widgets/custom_loader.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class MessageScreen extends StatefulWidget {
  final String studentOrParent;

  const MessageScreen({super.key, required this.studentOrParent});

  @override
  State<MessageScreen> createState() => MessageListScreen();
}

class MessageListScreen extends State<MessageScreen> {
  List<DeletelistElement> listInbox = [];
  List<DeletelistElement> tempList = [];
  TextEditingController search = TextEditingController();
  bool isLoading = true;
  int role = 0;

  @override
  void initState() {
    super.initState();
    getMessageList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        titleSpacing: 0,
        elevation: 0,
        backgroundColor: AppColors.primary,
        title: Text(
          "message".tr,
          style: CustomStyle.appBarTitle,
        ),
        leading: widget.studentOrParent == "0"
            ? Container(
                margin: const EdgeInsets.all(10),
                child: GestureDetector(
                  onTap: () {
                    Scaffold.of(context).openDrawer();
                  },
                  child: SvgPicture.asset(
                    AppImages.humBurg,
                    color: AppColors.orange,
                  ),
                ),
              )
            : IconButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: const Icon(Icons.arrow_back)),
      ),
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
                            child: TextField(
                              controller: search,
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
                                  hintStyle: TextStyle(
                                      fontFamily: "Outfit",
                                      fontWeight: FontWeight.w400,
                                      fontSize: 16,
                                      color:
                                          AppColors.secondary.withOpacity(0.5)),
                                  contentPadding: const EdgeInsets.all(10),
                                  border: InputBorder.none),
                              style: CustomStyle.textValue,
                              keyboardType: TextInputType.text,
                              textInputAction: TextInputAction.next,
                              cursorColor: AppColors.primary,
                              onChanged: onSearchTextChanged,
                            ),
                          ),
                        ),
                      ],
                    ),
                  )),
              Expanded(
                flex: 9,
                child: isLoading
                    ? const SizedBox.shrink()
                    : tempList.isEmpty
                        ? Center(
                            child: Text(
                              'noStudentFound'.tr,
                              style: const TextStyle(
                                  fontFamily: "Outfit",
                                  fontWeight: FontWeight.w400,
                                  fontSize: 18,
                                  color: AppColors.secondary),
                            ),
                          )
                        : ScrollConfiguration(behavior: const ScrollBehavior().copyWith(overscroll: false), child: ListView.separated(
                    itemBuilder: (context, index) {
                      DeletelistElement data = tempList[index];
                      return GestureDetector(
                        onTap: () {
                          if(data.id != null){
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        CommunicationDetail(isCommonMessageOrStudentReport: 0,messageId: data.id, isButtonView : false,fromParent: true,)));
                          }else{
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        MessageDetail(data.mid!)));
                          }
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: (Padding(
                            padding: const EdgeInsets.all(10),
                            child: Column(
                              children: [
                                Row(
                                  children: [
                                    Expanded(
                                      child: Text(
                                        data.subject ?? "",
                                        style: CustomStyle.txtvalue2
                                            .copyWith(
                                          color: AppColors.secondary,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 10,),
                                    Text(
                                        DateFormat("dd/MM/yy")
                                            .format(data.mDate),
                                        style: CustomStyle.txtvalue1)
                                  ],
                                ),
                                const SizedBox(height: 10,),
                                Align(
                                  alignment:
                                  AlignmentDirectional.bottomStart,
                                  child: Text(
                                    // data.msg == null ? "" : data.msg!.length > 25
                                    //     ? data.msg!
                                    //     .substring(0, 25)
                                    //     .replaceAll("\n", "")
                                    //     : data.msg!,
                                      data.senderName ?? "",
                                      style: CustomStyle.hello.copyWith(
                                          color: AppColors.secondary
                                              .withOpacity(0.5))),
                                ),
                              ],
                            ),
                          )),
                        ),
                      );
                    },
                    separatorBuilder: (context, index) {
                      return const SizedBox(height: 10);
                    },
                    itemCount: tempList.length)),
              ),
            ],
          ),
          Visibility(
              visible: isLoading,
              child: Container(
                color: Colors.black.withOpacity(0.5),
                height: MediaQuery.of(context).size.height,
                width: MediaQuery.of(context).size.width,
                child: const Center(
                  child: LoadingLayout(),
                ),
              )),
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

  void getMessageList() async {
    ApiClass httpService = ApiClass();
    SessionManagement sessionManagement = SessionManagement();
    int? role = await sessionManagement.getRole("Role");
    if (role == 0) {
      Studentlogin login = await sessionManagement.getModel('Student');
      String token = login.basicAuthToken;
      dynamic country = await httpService.getMessageAll(token,login.userdata.cookie ?? "");
      if (country["status"]) {
        try{
          Messagelist message = Messagelist.fromJson(country);
          setState(() {
            listInbox = message.data.inboxlist;
            tempList = message.data.inboxlist;
            isLoading = false;
            role = role!;
          });
        }catch(exception){
          Fluttertoast.showToast(msg: "$exception");
        }
      } else {
        setState(() {
          isLoading = false;
        });
      }
    } else {
      Parentlogin parent = await sessionManagement.getModelParent('Parent');
      String ptoken = parent.basicAuthToken;
      dynamic allMessage = await httpService.getMessageAll(ptoken,parent.userdata.cookie ?? "");
      if (allMessage['status']) {
        try{
          Messagelist message = Messagelist.fromJson(allMessage);
          setState(() {
            listInbox = message.data.inboxlist;
            tempList = message.data.inboxlist;
            isLoading = false;
            role = role!;
          });
        }catch(exception){
          Fluttertoast.showToast(msg: "$exception");
        }
      } else {
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  onSearchTextChanged(String text) async {
    if (text.isEmpty) {
      setState(() {
        tempList = listInbox;
      });
      return;
    }

    List<DeletelistElement> searchData = [];
    for (var userDetail in listInbox) {
      if (userDetail.subject!.isCaseInsensitiveContains(text) ||
          DateFormat("dd/MM/yy")
              .format(userDetail.mDate)
              .isCaseInsensitiveContains(text)) {
        searchData.add(userDetail);
      }
    }
    setState(() {
      tempList = searchData;
    });
  }
}
