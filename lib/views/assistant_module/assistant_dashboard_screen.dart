import 'package:auto_size_text/auto_size_text.dart';
import 'package:colegia_atenea/utils/app_textstyle.dart';
import 'package:colegia_atenea/views/assistant_module/assistant_classes_screen.dart';
import 'package:colegia_atenea/utils/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import '../../controllers/assistant_controller.dart';
import '../../controllers/student_parent_teacher_controller.dart';
import '../../utils/app_images.dart';
import '../../utils/text_style.dart';
import '../custom_widgets/custom_loader.dart';
import '../screens/edit_profile_screen.dart';

class AssistantDashboard extends StatefulWidget {
  final String username;
  const AssistantDashboard(this.username, {super.key});

  @override
  State<StatefulWidget> createState() {
    return AssistantDashboardChild();
  }
}

class AssistantDashboardChild extends State<AssistantDashboard> {
  AssistantController? assistantController;


  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((res){
      assistantController = Provider.of<AssistantController>(context,listen: false);
      assistantController?.getAssistantDashboardData();
    });
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
              child:  Consumer<AssistantController>(
                builder: (context, assistantController, child) {
                  String profileImage = assistantController.assistant?.userImage ?? "";
                  return GestureDetector(
                    onTap: () {
                      Get.to(() => EditProfileScreen(
                        roleType: RoleType.assistant,
                        assistantData: assistantController.assistant,
                        userdata: null,
                      ));
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const SizedBox(width: 20,),
                        SizedBox(
                          height: 45,
                          width: 45,
                          child: profileImage.isEmpty
                              ? const CircleAvatar(
                            backgroundImage: AssetImage(AppImages.people),
                          )
                              : CircleAvatar(
                            radius: 16.0,
                            backgroundColor: AppColors.primary,
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(65.0),
                              child: Image.network(
                                profileImage,
                                fit: BoxFit.cover,
                                height: 65,
                                width: 65,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(
                          width: 20,
                        ),
                        Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  "hello".tr,
                                  style: AppTextStyle.getOutfit300(
                                      textSize: 16, textColor: AppColors.white),
                                ),
                                AutoSizeText(
                                    maxLines: 1,
                                    assistantController.assistant?.displayName ?? "",
                                    style: AppTextStyle.getOutfit600(
                                        textSize: 20, textColor: AppColors.white))
                              ],
                            )),
                      ],
                    ),
                  );
                },
              ),
            ),

            Container(
              width: MediaQuery.of(context).size.width,
              margin: const EdgeInsets.symmetric(horizontal: 15),
              padding: const EdgeInsets.all(15),
              height: 100,
              decoration: BoxDecoration(
                  borderRadius: const BorderRadius.only(bottomLeft: Radius.circular(20),bottomRight: Radius.circular(20)),
                  // color: AppColors.dashBack.withOpacity(0.06)
                  color: AppColors.dashBack.withValues(alpha: 0.06)
              ),
              child: Text(
                "live".tr,
                style: CustomStyle.textValue,
              ),
            ),
            const SizedBox(height: 10,),
            GestureDetector(
              onTap: (){
                // Navigator.push(context, MaterialPageRoute(builder: (context) => const ChildScreen()));
                Get.to(() => ChildScreen());
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
                            Consumer<AssistantController>(
                              builder: (context,assistantController,child){
                                return Text(
                                  assistantController.assistantDashboardModel?.count.classCount ?? "",
                                  style: CustomStyle
                                      .cardText
                                      .copyWith(
                                      color: AppColors
                                          .blue),
                                );
                              },
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
                          Consumer<AssistantController>(
                            builder: (context,assistantController,child){
                              return Text(
                                assistantController.assistantDashboardModel != null ? "${assistantController.assistantDashboardModel?.count.commonMessageCount}" : "",
                                style: CustomStyle
                                    .cardText
                                    .copyWith(
                                    color: AppColors
                                        .green),
                              );
                            },
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
                // color: Colors.orange.withOpacity(0.10),
                color: AppColors.orange.withValues(alpha: 0.10)
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
                         Consumer<AssistantController>(
                           builder: (context,assistantController,child){
                             return  Text(
                               assistantController.assistantDashboardModel != null ? "${assistantController.assistantDashboardModel?.count.reportCount}" : "",
                               style: CustomStyle
                                   .cardText
                                   .copyWith(
                                   color: AppColors
                                       .orange),
                             );
                           },
                         )
                        ],
                      ))
                ],
              ),
            )
          ],
        ),
        Consumer<AssistantController>(
          builder: (context,assistantController,child){
            return Visibility(
                visible: assistantController.isLoading,
                child: LoadingLayout());
          },
        )
      ],
    );
  }

}
