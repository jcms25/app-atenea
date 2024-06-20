import 'package:colegia_atenea/models/assistant/assistant_dashboard_model.dart';
import 'package:colegia_atenea/models/assistant/assistant_login_model.dart';
import 'package:colegia_atenea/views/assistant_module/assistant_classes_screen.dart';
import 'package:colegia_atenea/services/api_class.dart';
import 'package:colegia_atenea/services/session_management.dart';
import 'package:colegia_atenea/utils/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import '../../utils/app_images.dart';
import '../../utils/text_style.dart';
import '../../widgets/custom_loader.dart';

class AssistantDashboard extends StatefulWidget {
  final String username;
  const AssistantDashboard(this.username, {super.key});

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return AssistantDashboardChild();
  }
}

class AssistantDashboardChild extends State<AssistantDashboard> {
  String imagePath = "";
  bool isLoading = false;
  String classCount = "";
  String commonMessageCount ="";
  String studentReportCount = "";
  String username = "-";

  @override
  void initState() {
    super.initState();
    setUsername();
    getDashboardData();
  }
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Column(
          children: [
            Container(
              width: MediaQuery.of(context).size.width,
              height: 100,
              decoration: const BoxDecoration(
                  borderRadius: BorderRadius.only(bottomLeft: Radius.circular(20),bottomRight: Radius.circular(20)),
                  color: AppColors.primary
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(width: 10,),
                  const SizedBox(
                    height: 65,
                    width: 65,
                    child: CircleAvatar(
                      radius: 16.0,
                      backgroundColor: Colors.grey,
                      child: Icon(Icons.person,color: AppColors.primary,size: 50,),
                    ),
                  ),
                  const SizedBox(width: 10,),
                  Padding(
                    padding: const EdgeInsets.all(5),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "hello".tr,
                          style: const TextStyle(
                              color: AppColors.white,
                              fontSize: 16,
                              fontFamily: 'Outfit',
                              fontWeight: FontWeight.w300),
                        ),
                         Text(
                          username,
                          style: const TextStyle(
                              color: AppColors.white,
                              fontSize: 20,
                              fontFamily: 'Outfit',
                              fontWeight: FontWeight.w600),
                        )
                      ],
                    ),
                  )
                ],
              ),
            ),
            Container(
              width: MediaQuery.of(context).size.width,
              margin: const EdgeInsets.symmetric(horizontal: 15),
              padding: const EdgeInsets.all(15),
              height: 100,
              decoration: BoxDecoration(
                  borderRadius: const BorderRadius.only(bottomLeft: Radius.circular(20),bottomRight: Radius.circular(20)),
                  color: AppColors.dashBack.withOpacity(0.06)
              ),
              child: Text(
                "live".tr,
                style: CustomStyle.textValue,
              ),
            ),
            const SizedBox(height: 10,),
            GestureDetector(
              onTap: (){
                Navigator.push(context, MaterialPageRoute(builder: (context) => const ChildScreen()));
              },
              child: Container(
                height: 100,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  color: AppColors.blueLight,
                ),
                margin: const EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                        height: 100,
                        width: 60,
                        decoration: const BoxDecoration(
                          color: AppColors.blue,
                          borderRadius:
                          BorderRadius.only(
                              topRight: Radius
                                  .circular(160),
                              bottomRight:
                              Radius.circular(
                                  160),
                              bottomLeft:
                              Radius.circular(
                                  50),
                              topLeft:
                              Radius.circular(
                                  50)),
                        ),
                        child: Padding(
                          padding:
                          const EdgeInsets.only(
                              top: 20,
                              right: 20,
                              bottom: 20,
                              left: 5),
                          child: SvgPicture.asset(
                            AppImages.cardImg,
                          ),
                        )),
                    Padding(
                        padding:
                        const EdgeInsets.all(10),
                        child: Column(
                          crossAxisAlignment:
                          CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'asClassTitle'.tr,
                              softWrap: true,
                              style: CustomStyle
                                  .textValue
                                  .copyWith(
                                  color: AppColors
                                      .blue),
                            ),
                            Text(
                              classCount,
                              style: CustomStyle
                                  .cardText
                                  .copyWith(
                                  color: AppColors
                                      .blue),
                            )
                          ],
                        ))
                  ],
                ),
              ),
            ),
            const SizedBox(height: 10,),
            Container(
              height: 100,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                color: AppColors.greenLight,
              ),
              margin: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                      height: 100,
                      width: 60,
                      decoration: const BoxDecoration(
                        color: AppColors.green,
                        borderRadius:
                        BorderRadius.only(
                            topRight: Radius
                                .circular(160),
                            bottomRight:
                            Radius.circular(
                                160),
                            bottomLeft:
                            Radius.circular(
                                50),
                            topLeft:
                            Radius.circular(
                                50)),
                      ),
                      child: Padding(
                        padding:
                        const EdgeInsets.only(
                            top: 20,
                            right: 20,
                            bottom: 20,
                            left: 5),
                        child: SvgPicture.asset(
                          AppImages.cardImg,
                        ),
                      )),
                  Padding(
                      padding:
                      const EdgeInsets.all(10),
                      child: Column(
                        crossAxisAlignment:
                        CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "option1".tr,
                            softWrap: true,
                            style: CustomStyle
                                .textValue
                                .copyWith(
                                color: AppColors
                                    .green),
                          ),
                          Text(
                            commonMessageCount,
                            style: CustomStyle
                                .cardText
                                .copyWith(
                                color: AppColors
                                    .green),
                          )
                        ],
                      ))
                ],
              ),
            ),
            const SizedBox(height: 10,),
            Container(
              height: 100,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                color: Colors.orange.withOpacity(0.10),
              ),
              margin: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                      height: 100,
                      width: 60,
                      decoration: const BoxDecoration(
                        color: Colors.orange,
                        borderRadius:
                        BorderRadius.only(
                            topRight: Radius
                                .circular(160),
                            bottomRight:
                            Radius.circular(
                                160),
                            bottomLeft:
                            Radius.circular(
                                50),
                            topLeft:
                            Radius.circular(
                                50)),
                      ),
                      child: Padding(
                        padding:
                        const EdgeInsets.only(
                            top: 20,
                            right: 20,
                            bottom: 20,
                            left: 5),
                        child: SvgPicture.asset(
                          AppImages.cardImg,
                        ),
                      )),
                  Padding(
                      padding:
                      const EdgeInsets.only(left: 10,top: 10,bottom: 10),
                      child: Column(
                        crossAxisAlignment:
                        CrossAxisAlignment.start,
                        children: [
                          Text(
                            "option2".tr,
                            softWrap: true,
                            style: CustomStyle
                                .textValue
                                .copyWith(
                                color: AppColors
                                    .orange),
                          ),
                          Text(
                            studentReportCount,
                            style: CustomStyle
                                .cardText
                                .copyWith(
                                color: AppColors
                                    .orange),
                          )
                        ],
                      ))
                ],
              ),
            )
          ],
        ),
        Visibility(visible: isLoading ,child: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          color: Colors.black54,
          child: const Center(
            child: LoadingLayout(),
          ),
        ),)
      ],
    );
  }

  void getDashboardData() async{
    setState(() {
      isLoading = true;
    });
    ApiClass apiclass = ApiClass();
    SessionManagement sessionManagement = SessionManagement();
    Assistant assistant = await sessionManagement.getAssistantDetail();
    dynamic dashboardData = await apiclass.getAsDashboard(assistant.basicAuthToken,assistant.userdata.data.cookie ?? "");
    if(dashboardData['status']){
      AssistantDashboardModel assistantDashboard = AssistantDashboardModel.fromJson(dashboardData);
      String tempClassCount = assistantDashboard.count.classCount;
      String tempCommonMessageCount = assistantDashboard.count.commonMessageCount;
      String tempStudentCount = assistantDashboard.count.reportCount;
      setState(() {
        classCount = tempClassCount.isEmpty ? "-" : tempClassCount;
        commonMessageCount = tempCommonMessageCount.isEmpty ? "-" : tempCommonMessageCount;
        studentReportCount = tempStudentCount.isEmpty ? "-" : tempStudentCount;
        isLoading = false;
      });
    }else{
      setState(() {
        isLoading = false;
      });
    }
  }

  void setUsername() async{
    SessionManagement  sessionManagement = SessionManagement();
    Assistant assistant = await sessionManagement.getAssistantDetail();
    setState(() {
        username = assistant.userdata.data.displayName
        ;
    });
  }
}
