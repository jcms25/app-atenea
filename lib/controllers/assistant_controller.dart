//this controller will handle all operations related to assistant
import 'dart:convert';

import 'package:colegia_atenea/services/app_shared_preferences.dart';
import 'package:colegia_atenea/utils/app_constants.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';

import '../models/assistant/assistant_dashboard_model.dart';
import '../models/assistant/assistant_login_model.dart';
import '../services/api.dart';
import '../views/assistant_module/assistant_classes_screen.dart';

class AssistantController extends ChangeNotifier{

  //Loader Handler
  bool isLoading = false;
  void setIsLoading({required bool isLoading}){
    this.isLoading = isLoading;
    notifyListeners();
  }


  //Assistant Login
  AssistantData? assistant;
  void setAssistant({required AssistantData? assistant}) {
    this.assistant = assistant;
    notifyListeners();
  }

  //current bottom index selected
  int currentBottomIndexSelected = 0;
  void setCurrentBottomIndexSelected({required int currentBottomIndexSelected}){
    if(currentBottomIndexSelected == 1){
      Get.to(() => ChildScreen());
    }else{
      this.currentBottomIndexSelected = currentBottomIndexSelected;
      notifyListeners();
    }
  }

  
  
  //get assistant dashboard data
  AssistantDashboardModel? assistantDashboardModel;
  void setAssistantDashboardModel({required AssistantDashboardModel? assistantDashboardModel}){
    this.assistantDashboardModel = assistantDashboardModel;
    notifyListeners();
  }

  
  //assistant Dashboard API
  void getAssistantDashboardData() async{
    try{
      if(assistantDashboardModel == null){
        setIsLoading(isLoading: true);
      }
      String token = AppSharedPreferences.getBasicAthToken() ?? "";

      dynamic response = await Api.httpRequest(requestType: RequestType.get, endPoint: "dashboard?current_role=assistant", header: {
        'Content-Type': 'application/x-www-form-urlencoded; charset=UTF-8',
        'Authorization': "Basic $token",
        'Cookie': assistant?.cookie ?? ""
      });
      if(response["status"]){
        AssistantDashboardModel assistantDashboardModel = AssistantDashboardModel.fromJson(response);
        setAssistantDashboardModel(assistantDashboardModel: assistantDashboardModel);
      }
      setIsLoading(isLoading: false);
    }catch(e){
      setIsLoading(isLoading: false);
      AppConstants.showCustomToast(status: false, message: "$e");
    }

  }



  //assistant edit profile
  Future<void> updateAssistantEditProfile({
    required String email,
    required String phone,
    required String address,
    required String postCode,
    required String city,
    required String userId
  }) async{
    try{
  setIsLoading(isLoading: true);
  dynamic response =  await Api.httpRequest(requestType: RequestType.post, endPoint: "assistance_edit_profile/$userId",
      body: {
        "ppress_billing_phone":phone,
        "ppress_billing_address": address,
        "ppress_billing_city": city,
        "ppress_billing_postcode":postCode,
        "user_email":email
      }
  );

  if(response['status']){
    AssistantData? assistantData = AppSharedPreferences.getAssistantLoggedInData();

    assistantData?.userEmail = email;
    assistantData?.userPhone = phone;
    assistantData?.userAddress = address;
    assistantData?.city = city;
    assistantData?.postCode = postCode;

    await AppSharedPreferences.sharedPreferences?.setString('userdata', jsonEncode(assistantData));
    setAssistant(assistant: assistantData);
    AppConstants.showCustomToast(status: true, message: response['Message'] ?? response['message'] ?? "");
    setIsLoading(isLoading: false);
  }else{
    setIsLoading(isLoading: false);
    AppConstants.showCustomToast(status: false, message: response['message'] ?? response['Message'] ?? "");
  }

    }catch(e){
      setIsLoading(isLoading: false);
      AppConstants.showCustomToast(status: false, message: "$e");
    }


  }


  //Log out data reset
  void onLogout(){
    setCurrentBottomIndexSelected(currentBottomIndexSelected: 0);
    setAssistantDashboardModel(assistantDashboardModel: null);
    setAssistant(assistant: null);
  }


}