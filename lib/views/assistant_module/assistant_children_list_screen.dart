import 'package:auto_size_text/auto_size_text.dart';
import 'package:colegia_atenea/models/assistant/assistant_child_detail_temp_model.dart';
import 'package:colegia_atenea/models/assistant/parent_model_assistant_model.dart';
import 'package:colegia_atenea/views/assistant_module/assistant_children_details_screen.dart';
import 'package:colegia_atenea/views/assistant_module/assistant_communication_details_screen.dart';
import 'package:colegia_atenea/views/assistant_module/assistant_new_communication_screen.dart';
import 'package:colegia_atenea/views/assistant_module/assistant_parents_details_screen.dart';
import 'package:colegia_atenea/utils/app_colors.dart';
import 'package:colegia_atenea/utils/app_images.dart';
import 'package:colegia_atenea/widgets/custom_loader.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

import '../../models/assistant/assistant_child_list_detail_model.dart';
import '../../models/assistant/assistant_login_model.dart';
import '../../services/api_class.dart';
import '../../services/session_management.dart';

class AssistantChildrenScreen extends StatefulWidget {
  final String classId;

  const AssistantChildrenScreen(this.classId, {super.key});

  @override
  State<StatefulWidget> createState() {
    return AssistantChildrenScreenState();
  }
}

class AssistantChildrenScreenState extends State<AssistantChildrenScreen> {
  TextStyle textStyle = const TextStyle(
    fontFamily: "Outfit",
  );
  List<ChildListDatum> childList = [];
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    setState(() {
      isLoading = true;
    });
    getStudentListOfClass();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: GestureDetector(
          onTap: () {
            Navigator.pop(context);
          },
          child: const Icon(Icons.arrow_back),
        ),
        title: Text(
          'asChild'.tr,
          style: const TextStyle(
              fontFamily: "Outfit", fontWeight: FontWeight.w500, fontSize: 20),
        ),
        backgroundColor: AppColors.primary,
        elevation: 0,
      ),
      body: ScrollConfiguration(
        behavior: const ScrollBehavior().copyWith(overscroll: false),
        child: Stack(
          children: [
            isLoading ? const SizedBox.shrink() : childList.isEmpty ? Center(
              child: Text('asNoStd'.tr),
            ) :
            Padding(padding: const EdgeInsets.symmetric(vertical: 10),child:  ListView.separated(
              itemCount: childList.length,
              itemBuilder: (context, index) {
                List<TempParentModel> parent = childList[index].parentData.map((e){
                  return TempParentModel(e.parentName, e.pEmail);
                }).toList();
                String studentId = childList[index].wpUsrId;
                String imagePath = childList[index].studImage;
                String name = childList[index].studentName;
                String address = childList[index].sAddress;
                String className = childList[index].className;
                TempChildModel childTempData = TempChildModel(imagePath, name, address, parent, className);

                return Padding(padding: const EdgeInsets.symmetric(horizontal: 10),child: Container(
                  height: 100,
                  decoration: BoxDecoration(
                      color: AppColors.primary.withOpacity(0.05),
                      borderRadius: BorderRadius.circular(15)),
                  child: Row(
                    children: [
                      const SizedBox(
                        width: 5,
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => ChildDetail(childTempData)));
                        },
                        child: CircleAvatar(
                          radius: 30,
                          backgroundImage: NetworkImage(childList[index].studImage),
                          backgroundColor: AppColors.primary,
                        ),
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          GestureDetector(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          ChildDetail(childTempData)));
                            },
                            child: Text(
                              childList[index].studentName,
                              style: textStyle.copyWith(
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.secondary,
                                  fontSize: 16),
                            ),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Row(
                            children: childList[index].parentData.map((e){
                              return Row(
                                children: [
                                  SvgPicture.asset(
                                    AppImages.asPeoplePrimary,
                                    width: 14,
                                    height: 14,
                                  ),
                                  const SizedBox(
                                    width: 2,
                                  ),
                                  GestureDetector(
                                    onTap: () {
                                      Navigator.push(context, MaterialPageRoute(builder: (context)=>AssistantParentDetails(e)));
                                    },
                                    child: AutoSizeText(
                                      e.parentName.length > 6 ? "${e.parentName.substring(0,10)}..." : e.parentName,
                                      // e.parentName,
                                      style: textStyle.copyWith(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w400,
                                          color: AppColors.secondary
                                              .withOpacity(0.7)),
                                    ),
                                  ),
                                  const SizedBox(
                                    width: 5,
                                  ),
                                ],
                              );
                            }).toList(),
                          )
                        ],
                      ),
                      const Spacer(),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          GestureDetector(
                            onTap: () {
                              Navigator.push(context, MaterialPageRoute(builder: (context)=>NewCommunication(isCommonMessageOrStudentReport: 1,classId: widget.classId,studentId: studentId,listOfParent: parent,)));
                            },
                            child: SvgPicture.asset(
                              "Assets/compose_icon.svg",
                              width: 18,
                              height: 18,
                            ),
                          ),
                          const SizedBox(height: 10,),
                          GestureDetector(
                            onTap: () {
                              Navigator.push(context, MaterialPageRoute(builder: (context)=> CommunicationDetail(isCommonMessageOrStudentReport: 2,studentId: childList[index].wpUsrId, isButtonView: false,fromParent: false,)));
                            },
                            child: const Icon(Icons.chat,color: AppColors.primary,),
                          ),
                        ],
                      ),
                      const SizedBox(
                        width: 15,
                      )
                    ],
                  ),
                ),);
              },
              separatorBuilder: (BuildContext context, int index) {
                return const SizedBox(
                  height: 10,
                );
              },
            ),),
            Visibility(
                visible: isLoading,
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height,
                  decoration: const BoxDecoration(
                      color: Colors.black54
                  ),
                  child: const LoadingLayout(),
                ))
          ],
        ),
      ),
    );
  }

  void getStudentListOfClass() async{
    ApiClass apiClass = ApiClass();
    SessionManagement sessionManagement = SessionManagement();
    Assistant assistant = await sessionManagement.getAssistantDetail();
    String token = assistant.basicAuthToken;
    dynamic tempChildList = await apiClass.getAsSlotChildList(token,widget.classId,assistant.userdata.data.cookie ?? "");
    if(tempChildList['status']){
        ChildListDetailModel childListDetailModel = ChildListDetailModel.fromJson(tempChildList);
        childListDetailModel.data.sort((a,b) => a.studentName.compareTo(b.studentName));
        setState(() {
        childList = childListDetailModel.data;
        isLoading = false;
      });
    }else{
      setState(() {
        isLoading = false;
      });
    }
  }
}
