import 'package:colegia_atenea/models/store_model/billing_detail_model.dart';
import 'package:colegia_atenea/models/store_model/order_details_model.dart';
import 'package:colegia_atenea/utils/app_constants.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../models/store_model/order_list_model.dart';
import '../services/api.dart';
import '../services/app_shared_preferences.dart';

class StoreController extends ChangeNotifier {
  //check box on billing address screen regarding subscribe to email
  bool isOptional = false;

  void setIsOptional({required bool isOptional}) {
    this.isOptional = isOptional;
    notifyListeners();
  }

  //API Loader
  bool isLoading = false;

  void setIsLoading({required bool isLoading}) {
    this.isLoading = isLoading;
    notifyListeners();
  }

  //billing details
  BillingDetail? billingDetail;

  void setBillingDetailModel({required BillingDetail? billingDetail}) {
    this.billingDetail = billingDetail;
    notifyListeners();
  }

  //class list
  List<ClassItem> classList = [];

  void setListOfClass({required List<ClassItem> classList}) {
    this.classList = classList;
    notifyListeners();
  }

  //selected class of student in parent billing address
  List<String> selectedClassItem = [];

  void setSelectedClassItem({required List<String> selectedClassItem}) {
    this.selectedClassItem = selectedClassItem;
    notifyListeners();
  }

  void addToSelectedClassItem({required String className}) {
    if (!selectedClassItem.contains(className)) {
      selectedClassItem.add(className);
    }
    notifyListeners();
  }

  void removeSelectedClassItem({required String className}) {
    if (selectedClassItem.contains(className)) {
      selectedClassItem.remove(className);
    }
    notifyListeners();
  }

  //selected province
  String? selectedProvince;

  void setSelectedProvince({required String? selectedProvince}) {
    this.selectedProvince = selectedProvince;
    notifyListeners();
  }

  //get billing details
  Future<void> getBillingDetails({required String parentWpUserId}) async {
    try {
      setIsLoading(isLoading: true);
      await Api.httpRequest(
              requestType: RequestType.get,
              // endPoint: "${Api.billingDetailEndPoint}?user_id=$parentWpUserId"
              endPoint: "${Api.billingDetailEndPoint}?user_id=$parentWpUserId")
          .then((res) {
        if (res['status']) {
          BillingDetailModel billingDetailModel =
              BillingDetailModel.fromJson(res);
          setBillingDetailModel(billingDetail: billingDetailModel.data);
          setListOfClass(classList: billingDetailModel.classlist ?? []);

          dynamic selectedClass = billingDetail?.billingAlumnosClassName;
          if (selectedClass != null && selectedClass.runtimeType == List) {
            setSelectedClassItem(selectedClassItem: selectedClass);
          }

          String city = billingDetailModel.data?.billingCity ?? "";
          if (city.isNotEmpty) {
            if (AppConstants.spainProvince.contains(city)) {
              setSelectedProvince(selectedProvince: city);
            }
          }
        }
        AppConstants.showCustomToast(
            status: res['status'],
            message: res['message'] ?? res['Message'] ?? "");
        setIsLoading(isLoading: false);
      });
    } catch (exception) {
      AppConstants.showCustomToast(status: false, message: "$exception");
      setIsLoading(isLoading: false);
    }
  }

  //edit billing details
  Future<void> editBillingDetails(
      {required String wpUserId,
      required String billingName,
      required String billingLastName,
      required String billingNIF,
      required String billingNIFOptional,
      required String billingPhoneNumber,
      required String billingAddress,
      required String billingPostCode,
      required String billingCity,
      required String billingState,
      required String billingEmail,
      required String billingAlumnosName,
      required List<String> billingAlumnosClass}) async {
    try {
      setIsLoading(isLoading: true);

      String token = AppSharedPreferences.getBasicAthToken() ?? "";
      String cookies = AppSharedPreferences.getUserData()?.cookies ?? "";

      Map<String, dynamic> bodyData = {
        "billing_first_name": billingName,
        "billing_last_name": billingLastName,
        "billing_myfield3": billingNIF,
        "billing_vat": billingNIFOptional,
        "billing_phone": billingPhoneNumber,
        "billing_address_1": billingAddress,
        "billing_postcode": billingPostCode,
        "billing_city": billingCity,
        "billing_state": billingState,
        "billing_email": billingEmail,
        "billing_wooccm10": billingAlumnosName
      };

      if (selectedClassItem.isNotEmpty) {
        for (int i = 0; i < selectedClassItem.length; i++) {
          bodyData['billing_wooccm12[$i]'] = selectedClassItem[i];
        }
      } else {
        bodyData['billing_wooccm12'] = "";
      }
      await Api.httpRequest(
              requestType: RequestType.post,
              body: bodyData,
              header: {
                'Content-Type':
                    'application/x-www-form-urlencoded; charset=UTF-8',
                'Authorization': "Basic $token",
                'Cookie': cookies
              },
              endPoint: "${Api.billingEditDetailEndPoint}?user_id=$wpUserId")
          .then((res) {
        setIsLoading(isLoading: false);
        AppConstants.showCustomToast(
            status: res['status'],
            message: res['message'] ?? res['Message'] ?? "");
        if (res['status']) {
          Get.back();
        }
      });
    } catch (exception) {
      AppConstants.showCustomToast(status: false, message: "$exception");
      setIsLoading(isLoading: false);
    }
  }

  //list of orders
  List<OrderItem> listOfOrders = [];

  void setListOfOrders({required List<OrderItem> listOfOrders}) {
    this.listOfOrders = listOfOrders;
    notifyListeners();
  }

  //list of orders
  void getListOfOrders({required String wpUserId}) async {
    try {
      setIsLoading(isLoading: true);
      await Api.httpRequest(
              requestType: RequestType.get,
              endPoint: "${Api.orderListEndPoint}=$wpUserId")
          .then((res) {
        if (res['status']) {
          OrderList orderList = OrderList.fromJson(res);
          setListOfOrders(listOfOrders: orderList.data ?? []);
        }
        setIsLoading(isLoading: false);
      });
    } catch (exception) {
      AppConstants.showCustomToast(status: false, message: "$exception");
      setIsLoading(isLoading: false);
    }
  }

  //order details
  OrderDetailModel? orderDetailModel;

  void setOrderDetailModel({required OrderDetailModel? orderDetailModel}) {
    this.orderDetailModel = orderDetailModel;
    notifyListeners();
  }

  //details of order
  void getOrderDetails({required String orderId}) async {
    // try {
    //   setIsLoading(isLoading: true);
    //
    // } catch (exception) {
    //   AppConstants.showCustomToast(status: false, message: "$exception");
    //   setIsLoading(isLoading: false);
    // }
    await Api.httpRequest(
        requestType: RequestType.get,
        endPoint: "${Api.orderDetailEndPoint}=$orderId")
        .then((res) {
      if (res['status']) {
        OrderDetailModel orderDetailModel = OrderDetailModel.fromJson(res);
        setOrderDetailModel(orderDetailModel: orderDetailModel);
      }
      setIsLoading(isLoading: false);
    });
  }


}
