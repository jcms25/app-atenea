import 'dart:convert';

import 'package:colegia_atenea/models/assistant/assistant_login_model.dart';
import 'package:colegia_atenea/services/app_shared_preferences.dart';
import 'package:colegia_atenea/utils/app_constants.dart';
import 'package:colegia_atenea/utils/app_routes.dart';
import 'package:colegia_atenea/views/assistant_module/assistant_communication_common_message_list_screen.dart';
import 'package:colegia_atenea/views/assistant_module/assistant_communication_report_message_list_screen.dart';
import 'package:colegia_atenea/views/assistant_module/assistant_dashboard_screen.dart';
import 'package:colegia_atenea/utils/text_style.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart' hide Response;
import 'package:http/http.dart';

import '../../utils/app_colors.dart';
import '../../utils/app_images.dart';
import '../custom_widgets/custom_loader.dart';
import 'assistant_classes_screen.dart';

class AssistantScreen extends StatefulWidget{
  final int currentIndex;
  const AssistantScreen({super.key,required this.currentIndex});

  @override
  State<StatefulWidget> createState() {
    return AssistantScreenChild();
  }

}

class AssistantScreenChild extends State<AssistantScreen>{
  // final GlobalKey<ScaffoldState> _globalKey = GlobalKey<ScaffoldState>();
  int _currentIndex = 0;
  String currentLanguage = "English";
  String username = "";
  bool isLoading = false;


  void changeTab(int index) {
    if(index == 1){
      Navigator.push(context, MaterialPageRoute(builder: (context)=> const ChildScreen()));
    }else{
      setState(() {
        _currentIndex = index;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    setData();
  }
  @override
  Widget build(BuildContext context) {
    return SafeArea(child: Scaffold(
      key: AppConstants.assistantKey,
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.menu_rounded,size: 30,),
          onPressed: (){
            AppConstants.assistantKey.currentState!.openDrawer();
          },
        ),
        title: _currentIndex == 0 ?  Text("desk".tr,style: const TextStyle(fontFamily: "Outfit",fontWeight: FontWeight.w500,fontSize: 20,color: Colors.white),) : _currentIndex == 2 ?  Text('option1'.tr,style: const TextStyle(fontFamily: "Outfit",fontWeight: FontWeight.w500,fontSize: 18 ,color: Colors.white),) : Text('reportOption'.tr,style: const TextStyle(fontFamily: "Outfit",fontWeight: FontWeight.w500,fontSize: 18 ,color: Colors.white),),
      ),
      body: Stack(
        children: [
          _currentIndex == 0 ? AssistantDashboard(username) : _currentIndex == 2 ? const CommonMessageListScreen() : const ReportListScreen(showInParent: "2"),
          Visibility(
              visible: isLoading,
              child: Container(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height,
                color: Colors.black26,
                child: const LoadingLayout(),
              ))
        ],
      ),
      drawer: Drawer(
        child: Column(
          children: [
            Container(
        decoration: const BoxDecoration(
        color: AppColors.primary,
            borderRadius: BorderRadius.only(
              bottomRight: Radius.circular(30),
              bottomLeft: Radius.circular(30),
            )),
        padding: const EdgeInsets.all(15),
        width: 310,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                const SizedBox(
                  height: 65,
                  width: 65,
                  child: CircleAvatar(
                    radius: 16.0,
                    backgroundColor: Colors.grey,
                    child: Icon(Icons.person,color: AppColors.primary,size: 50,),
                  ),
                ),
                Expanded(child: SizedBox(
                  width: MediaQuery.of(context).size.width,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(10),
                        child: Column(
                          crossAxisAlignment:
                          CrossAxisAlignment.start,
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
                              softWrap: true,
                              style: const TextStyle(
                                  color: AppColors.white,
                                  fontFamily: 'Outfit',
                                  fontWeight: FontWeight.w600),
                            )
                          ],
                        ),
                      )
                    ],
                  ),
                )),
                Image.asset(AppImages.whiteAppLogo,width: 50,height: 50)
              ],
            )
          ],
        ),
      ),
            const SizedBox(height: 10,),
            ListTile(
              leading: SvgPicture.asset(AppImages.asDashBoardActive,),
              onTap: (){
                if(_currentIndex == 0){
                  Navigator.pop(context);
                }else{
                  Navigator.pop(context);
                  setState(() {
                    _currentIndex = 0;
                  });
                }
              },
              title: Text('drawerOption1'.tr,style: const TextStyle(fontSize: 18,fontFamily: 'Outfit',color: AppColors.primary),),
            ),
            ListTile(
              leading: SvgPicture.asset(
                AppImages.asClassesActive
            ),
              onTap: (){
                Navigator.push(context, MaterialPageRoute(builder: (context) => const ChildScreen()));
              },
              title: Text('asClassTitle'.tr,style: const TextStyle(fontSize: 18,fontFamily: 'Outfit',color: AppColors.primary),),
            ),
            ListTile(
              leading: SvgPicture.asset(
                  AppImages.asMessageActive
              ),
              onTap: (){
                if(_currentIndex == 2){
                  Navigator.pop(context);
                }else{
                  Navigator.pop(context);
                  setState(() {
                    _currentIndex = 2;
                  });
                }
              },
              title: Text('option1'.tr,style: const TextStyle(fontSize: 18,fontFamily: 'Outfit',color: AppColors.primary),),
            ),
            ListTile(
              leading: const Icon(Icons.sticky_note_2_outlined,size: 30,color: AppColors.primary,),
              onTap: (){
                if(_currentIndex == 3){
                  Navigator.pop(context);
                }else{
                  Navigator.pop(context);
                  setState(() {
                    _currentIndex = 3;
                  });
                }
              },
              title: Text('reportOption'.tr,style: const TextStyle(fontSize: 18,fontFamily: 'Outfit',color: AppColors.primary),),
            ),
            const Spacer(),
            // ListTile(
            //   title: const Text("English"),
            //   trailing: Transform.scale(
            //       scale: 1,
            //       child: Switch(
            //         onChanged: (data) {
            //           changeSwitchState(data);
            //         },
            //         value: _currentSwitchState,
            //         activeColor: AppColors.primary,
            //         activeTrackColor: AppColors.secondary,
            //         inactiveThumbColor: AppColors.primary,
            //         inactiveTrackColor: AppColors.secondary,
            //       )),
            // ),
            Container(
              padding: const EdgeInsets.all(20),
              color: AppColors.white,
              child: SizedBox(
                  height: 50,
                  width: 360,
                  child: Directionality(
                    textDirection: TextDirection.rtl,
                    child: ElevatedButton.icon(
                      icon: SvgPicture.asset(AppImages.loginArrow),
                      style: ButtonStyle(
                          shadowColor: WidgetStateProperty.all(AppColors.primary),
                          backgroundColor: WidgetStateProperty.all(AppColors.primary),
                          shape: WidgetStateProperty.all(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          )),
                      onPressed: () {
                          onLogOutButtonClick(context);
                      },
                      label: Text(
                        "logout".tr,
                        style: const TextStyle(
                            fontSize: 18,
                            fontFamily: 'Outfit',
                            fontWeight: FontWeight.w500,
                            color: AppColors.white),
                      ),
                    ),
                  )),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Container(
        decoration: const BoxDecoration(
          borderRadius: BorderRadius.only(
              topRight: Radius.circular(30), topLeft: Radius.circular(30)),
        ),
        child: ClipRRect(
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(30.0),
            topRight: Radius.circular(30.0),
          ),
          child: BottomNavigationBar(
            backgroundColor: Colors.white,
            onTap: (index) => changeTab(index),
            currentIndex: _currentIndex,
            items: [
              BottomNavigationBarItem(
                icon: SvgPicture.asset(AppImages.asDashboard,),
                label: 'Dashboard',
                activeIcon: SvgPicture.asset(AppImages.asDashBoardActive)
              ),
              BottomNavigationBarItem(
                icon: SvgPicture.asset(
                    AppImages.asClasses,
                  colorFilter: const ColorFilter.mode(AppColors.secondary, BlendMode.srcIn),
                ),
                label: 'classes',
                activeIcon: SvgPicture.asset(
                    AppImages.asClassesActive
                ),
              ),
              BottomNavigationBarItem(
                icon: SvgPicture.asset(
                  AppImages.asMessage
                ),label: 'communication',
                activeIcon: SvgPicture.asset(
                    AppImages.asMessageActive
                ),
              ),
              const BottomNavigationBarItem(
                icon: Icon(Icons.sticky_note_2_outlined,size: 30,color: AppColors.secondary,),
                label: 'send report communication',
                activeIcon: Icon(Icons.sticky_note_2_outlined,size: 30,color: AppColors.primary,),
              ),

            ],
            type: BottomNavigationBarType.fixed,
            selectedItemColor: AppColors.primary,
            showSelectedLabels: false,
            showUnselectedLabels: false,
          ),
        ),
      ),
    ));
  }

  // void changeSwitchState(bool data) {
  //   setState(() {
  //     _currentSwitchState = data;
  //   });
  // }



  Future<void> onLogOutButtonClick(BuildContext context) async {

    showDialog(context: context, builder: (context){
      return AlertDialog(
        content: Text('sure'.tr,style: CustomStyle.textValue,),
        actions: [
          ElevatedButton(
              style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5)
                  ),
                  backgroundColor: AppColors.primary,
                  elevation: 0.0
              ),
              onPressed: (){
                Navigator.pop(context);
              }, child: Text('negativeButton'.tr,style: CustomStyle.txtvalue1.copyWith(color: AppColors.white),)),
          ElevatedButton(
              style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5)
                  ),
                  backgroundColor: AppColors.primary,
                  elevation: 0.0
              ),
              onPressed: (){
                setState(() {
                  isLoading = true;
                });
                Navigator.pop(context);
                AppConstants.assistantKey.currentState!.closeDrawer();
                getSenderId();
              }, child: Text('positiveButton'.tr,style: CustomStyle.txtvalue1.copyWith(color: AppColors.white),))
        ],
      );
    });

  }
  void logout() async {

    AppSharedPreferences.loggedOutUser();
    goToLoginScreen();
  }

  void setData() async{
    Assistant? assistant = AppSharedPreferences.getAssistantLoggedInData();
    setState(() {
      username = assistant?.userdata.data.displayName ?? "";
      _currentIndex = widget.currentIndex;
    });
  }

  void goToLoginScreen() {
    // Navigator.pushReplacement(
    //   context,
    //   MaterialPageRoute(
    //     builder: (context) => const LoginScreen1(),
    //   ),
    // );
    Get.offNamedUntil(AppRoutes.loginScreen, (routes) => false);
  }

  Future<void> getSenderId() async{
    // SessionManagement sessionManagement = SessionManagement();
    // Assistant assistant = await sessionManagement.getAssistantDetail();
    Assistant? assistant = AppSharedPreferences.getAssistantLoggedInData();
    logOutApi(assistant?.userdata.data.id ?? "");
  }

  void logOutApi(String senderId) async{
    try{
      final Response response = await post(
          Uri.parse("https://colegioatenea.es/wp-json/scl-api/v1/logout"),
          body: <String,dynamic>{
            "user_id" : senderId
          }
      );

      if(response.statusCode == 200){
        var data = jsonDecode(response.body);
        if(data["status"]){
          logout();
        }else{
          Fluttertoast.showToast(msg: data["message"]);
          setState(() {
            isLoading = false;
          });
        }
      }else{
        setState(() {
          isLoading = false;
        });
      }
    }catch(exception){
      setState(() {
        isLoading = false;
      });
    }
  }

}
