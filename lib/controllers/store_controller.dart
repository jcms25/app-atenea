import 'dart:async';
import 'dart:convert';

import 'package:colegia_atenea/models/store_model/billing_detail_model.dart';
import 'package:colegia_atenea/models/store_model/cart_response_model.dart';
import 'package:colegia_atenea/models/store_model/checkout_model.dart' hide BillingAddress,ShippingAddress;
import 'package:colegia_atenea/models/store_model/order_details_model.dart';
import 'package:colegia_atenea/models/store_model/product_item_model.dart';
import 'package:colegia_atenea/models/store_model/subcategory_list_model.dart';
import 'package:colegia_atenea/utils/app_constants.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart' hide Response;
import 'package:http/http.dart';

import '../models/store_model/order_list_model.dart';
import '../services/api.dart';
import '../services/app_shared_preferences.dart';
import '../services/store_api.dart';

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

          if (selectedClass != null &&
              selectedClass.runtimeType == List<String>) {
            selectedClassItem = selectedClass;
            notifyListeners();
          }

          String billingState =
              billingDetailModel.data?.billingState?.trim() ?? "";
          if (billingState.isNotEmpty) {
            if (AppConstants.spainProvince.contains(billingState)) {
              setSelectedProvince(selectedProvince: billingState);
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
    try {
      setIsLoading(isLoading: true);
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
    } catch (exception) {
      AppConstants.showCustomToast(status: false, message: "$exception");
      setIsLoading(isLoading: false);
    }
  }

  //Stores Category API :

  //list of subcategory for Libros and Material
  List<SubCategoryItemModel> filteredData = [];

  void setFilteredData({required List<SubCategoryItemModel> filteredData}) {
    this.filteredData = filteredData;
    notifyListeners();
  }

  List<SubCategoryItemModel> listOfSubCategory = [];

  void setListOfSubCategory(
      {required List<SubCategoryItemModel> listOfSubCategory}) {
    this.listOfSubCategory = listOfSubCategory;
    filteredData = listOfSubCategory;
    notifyListeners();
  }

  //get subcategories of parent category : Libros and Material both have subcategories
  Future<void> getSubCategoriesOfCategory(
      {required String categoryName, required String tiendaToken}) async {
    try {
      setIsLoading(isLoading: true);
      var url = Uri.parse('${StoreApi.localBaseURL}/products/categories');

      var body = categoryName == "Libros"
          ? jsonEncode({
              "include":
                  "464,465,466,1001,467,468,469,470,471,472,473,474,475,476,477,478,479",
              "order": "asc"
            })
          : jsonEncode({
              "include": "855,856,857,858,859,860,861,862,863,864",
              "order": "asc"
            });

      var response = Request('GET', url)
        ..headers.addAll({
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $tiendaToken'
        })
        ..body = body;

      var streamedResponse = await response.send();
      var responseData = await Response.fromStream(streamedResponse);

      if (responseData.statusCode == 200) {
        dynamic data = jsonDecode(responseData.body);
        if (data.isNotEmpty) {
          List<SubCategoryItemModel> listOfSubCategoryItemModel =
              List<SubCategoryItemModel>.from(
                  data.map((e) => SubCategoryItemModel.fromJson(e)).toList());
          setListOfSubCategory(listOfSubCategory: listOfSubCategoryItemModel);
        }
      } else {
        dynamic data = jsonDecode(responseData.body);
        AppConstants.showCustomToast(
            status: false, message: '${data['message'] ?? ""}');
      }

      setIsLoading(isLoading: false);
    } catch (exception) {
      setIsLoading(isLoading: false);
      AppConstants.showCustomToast(status: false, message: "$exception");
    }
  }

  //searching in sub category using debouncing technique to reduce search time and optimize performance
  Timer? _debounceTime;

  void searchInSubCategoryList(String query) {
    if (_debounceTime?.isActive ?? false) _debounceTime?.cancel();

    _debounceTime = Timer(const Duration(milliseconds: 300), () {
      final normalizeQuery = query.toLowerCase();

      setFilteredData(
          filteredData: normalizeQuery.isEmpty
              ? listOfSubCategory
              : listOfSubCategory.where((e) {
                  return e.name
                          ?.toLowerCase()
                          .replaceAll(" ", "")
                          .contains(query.toLowerCase().replaceAll(" ", "")) ??
                      false;
                }).toList());
    });
  }

  //List of products
  List<ProductItem> listOfProducts = [];
  List<ProductItem> filterProducts = [];

  void setProductList({required List<ProductItem> listOfProducts}) {
    this.listOfProducts = listOfProducts;
    filterProducts = listOfProducts;
    notifyListeners();
  }

  void setFilterProductList({required List<ProductItem> tempProductList}) {
    filterProducts = tempProductList;
    notifyListeners();
  }

  //get product list from categories
  Future<void> getProductList(
      {required String categoryId, required String tiendaToken}) async {
    try {
      setIsLoading(isLoading: true);
      var url = Uri.parse(
          '${StoreApi.localBaseURL}/products?category=$categoryId&per_page=100');

      var response = Request('GET', url)
        ..headers.addAll({
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $tiendaToken'
        });

      var streamedResponse = await response.send();
      var responseData = await Response.fromStream(streamedResponse);

      if (responseData.statusCode == 200) {
        dynamic data = jsonDecode(responseData.body);
        if (data.isNotEmpty) {
          List<ProductItem> listOfProducts = List<ProductItem>.from(
              data.map((e) => ProductItem.fromJson(e)).toList());
          setProductList(listOfProducts: listOfProducts);
        }
      } else {
        dynamic data = jsonDecode(responseData.body);
        AppConstants.showCustomToast(
            status: false, message: '${data['message'] ?? ""}');
      }
      setIsLoading(isLoading: false);
    } catch (exception) {
      setIsLoading(isLoading: false);
      AppConstants.showCustomToast(status: false, message: "$exception");
    }
  }

  //search in product list
  void searchInProductList(String query) {
    if (_debounceTime?.isActive ?? false) _debounceTime?.cancel();

    _debounceTime = Timer(const Duration(milliseconds: 300), () {
      final normalizeQuery = query.toLowerCase();

      setFilterProductList(
          tempProductList: normalizeQuery.isEmpty
              ? listOfProducts
              : listOfProducts.where((e) {
                  return e.name
                          ?.toLowerCase()
                          .replaceAll(" ", "")
                          .contains(query.toLowerCase().replaceAll(" ", "")) ??
                      false;
                }).toList());
    });
  }

  //product item detail
  ProductItem? productItem;

  void setProductItem({required ProductItem? productItem}) {
    this.productItem = productItem;
    notifyListeners();
  }

  //List of variations attributes
  List<Variations> listOfVariations = [];

  void setListOfVariationAttributes(
      {required List<Variations> listOfVariations}) {
    this.listOfVariations = listOfVariations;
    notifyListeners();
  }

  //current selected variations
  Variations? selectedVariations;

  void setSelectedVariations({Variations? selectedVariations}) {
    this.selectedVariations = selectedVariations;
    notifyListeners();
  }

  //Variation Detail
  ProductItem? variationProduct;

  void setSelectedVariationDetail({required ProductItem? productItem}) {
    variationProduct = productItem;
    notifyListeners();
  }

  Future<void> getProductDetail(
      {required String productId,
      required String tiendaToken,
      bool? variationProductDetail}) async {
    try {
      setIsLoading(isLoading: true);
      var url = Uri.parse('${StoreApi.localBaseURL}/products/$productId');

      var response = Request('GET', url)
        ..headers.addAll({
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $tiendaToken'
        });

      var streamedResponse = await response.send();
      var responseData = await Response.fromStream(streamedResponse);

      if (responseData.statusCode == 200) {
        dynamic data = jsonDecode(responseData.body);
        ProductItem productItem = ProductItem.fromJson(data);
        if (variationProductDetail != null) {
          setSelectedVariationDetail(productItem: productItem);
        } else {
          setProductItem(productItem: productItem);
          setListOfVariationAttributes(
              listOfVariations: productItem.variations ?? []);
        }
      } else {
        dynamic data = jsonDecode(responseData.body);
        AppConstants.showCustomToast(
            status: false, message: '${data['message'] ?? ""}');
      }
      setIsLoading(isLoading: false);
    } catch (exception) {
      AppConstants.showCustomToast(status: false, message: "$exception");
      setIsLoading(isLoading: false);
    }
  }

  int quantity = 1; // Default quantity

  /// Set the quantity
  void setQuantity(int newQuantity) {
    if (newQuantity > 0) {
      quantity = newQuantity;
      notifyListeners();
    }
  }

  /// Increase the quantity
  void increaseQuantity() {
    quantity++;
    notifyListeners();
  }

  /// Decrease the quantity (minimum: 1)
  void decreaseQuantity() {
    if (quantity > 1) {
      quantity--;
      notifyListeners();
    }
  }

  //handling add to cart into product list
  final Set<String> _loadingProducts = {};

  //is set contain product
  bool isProductLoading(String productId) {
    return _loadingProducts.contains(productId);
  }

  //add to cart API
  Future<void> addToCart(
      {required int fromProductListOrFromDetails,
      required int noOfItems,
      required String tiendaToken,
      Variations? variation,
      String? productId,
      String? variationProductId}) async {
    try {
      setIsLoading(isLoading: true);

      //this will tell that we are adding product from product list screen
      if (fromProductListOrFromDetails == 1) {
        _loadingProducts.add(productId ?? "");
        notifyListeners(); // Notify UI about loading state change
      }

      var url = Uri.parse('${StoreApi.localBaseURL}/v1/cart/add-item');

      var body = jsonEncode({
        "id": productId ?? variationProductId ?? "",
        "quantity": noOfItems,
      });

      var response = Request('POST', url)
        ..headers.addAll({
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $tiendaToken'
        })
        ..body = body;

      var streamedResponse = await response.send();
      var responseData = await Response.fromStream(streamedResponse);
      if (responseData.statusCode == 200 || responseData.statusCode == 201) {
        AppConstants.showCustomToast(
            status: true, message: "Item added into cart");
        setQuantity(1);
        setSelectedVariations(selectedVariations: null);
        setSelectedVariationDetail(productItem: null);
        _loadingProducts.remove(productId);
        notifyListeners(); // Notify UI that loading has finished
      } else {
        dynamic data = jsonDecode(responseData.body);
        AppConstants.showCustomToast(
            status: false, message: '${data['message'] ?? ""}');
        _loadingProducts.remove(productId);
        notifyListeners(); // Notify UI that loading has finished
      }

      setIsLoading(isLoading: false);
    } catch (exception) {
      setIsLoading(isLoading: false);
      AppConstants.showCustomToast(status: false, message: "$exception");
    }
  }

  //cart response
  CartResponse? cartResponse;

  void setCartResponse({CartResponse? cartResponse}) {
    this.cartResponse = cartResponse;
    notifyListeners();
  }

  //get cart details
  void getCartDetails({required String tiendaToken}) async {
    try {
      setIsLoading(isLoading: true);

      var url = Uri.parse('${StoreApi.localBaseURL}/cart');

      var response = Request('GET', url)
        ..headers.addAll({
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $tiendaToken'
        });

      var streamedResponse = await response.send();
      var responseData = await Response.fromStream(streamedResponse);
      if (responseData.statusCode == 200 || responseData.statusCode == 201) {
        dynamic data = jsonDecode(responseData.body);
        CartResponse cartResponse = CartResponse.fromJson(data);
        setCartResponse(cartResponse: cartResponse);
      } else {
        dynamic data = jsonDecode(responseData.body);
        AppConstants.showCustomToast(
            status: false, message: '${data['message'] ?? ""}');
      }

      setIsLoading(isLoading: false);
    } catch (exception) {
      AppConstants.showCustomToast(status: false, message: "$exception");
      setIsLoading(isLoading: false);
    }
  }

  //update cart Item
  Future<void> updateCartItem(
      {required int increaseOrDecrease,
      required String itemKey,
      required int noOfItem,
      required String tiendaToken}) async {
    //0 means increase quantity
    //1 means decrease quantity

    try {
      setIsLoading(isLoading: true);

      var url = Uri.parse('${StoreApi.localBaseURL}/cart/update-item');

      var response = Request('POST', url)
        ..headers.addAll({
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $tiendaToken'
        })
        ..body = jsonEncode({
          "key": itemKey,
          "quantity":
              increaseOrDecrease == 0 ? "${noOfItem + 1}" : "${noOfItem - 1}"
        });

      var streamedResponse = await response.send();
      var responseData = await Response.fromStream(streamedResponse);
      if (responseData.statusCode == 200 || responseData.statusCode == 201) {
        dynamic data = jsonDecode(responseData.body);
        CartResponse cartResponse = CartResponse.fromJson(data);
        setCartResponse(cartResponse: cartResponse);
        AppConstants.showCustomToast(
            status: true, message: "Item Updated Successfully.");
      } else {
        dynamic data = jsonDecode(responseData.body);
        AppConstants.showCustomToast(
            status: false, message: '${data['message'] ?? ""}');
      }
      setIsLoading(isLoading: false);
    } catch (exception) {
      AppConstants.showCustomToast(status: false, message: "$exception");
      setIsLoading(isLoading: false);
    }
  }

  //remove cart item
  Future<void> removeCartItem(
      {required String itemKey, required String tiendaToken}) async {
    try {
      setIsLoading(isLoading: true);

      var url = Uri.parse('${StoreApi.localBaseURL}/cart/remove-item');

      var response = Request('POST', url)
        ..headers.addAll({
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $tiendaToken'
        })
        ..body = jsonEncode({"key": itemKey});

      var streamedResponse = await response.send();
      var responseData = await Response.fromStream(streamedResponse);
      if (responseData.statusCode == 200 || responseData.statusCode == 201) {
        dynamic data = jsonDecode(responseData.body);
        CartResponse cartResponse = CartResponse.fromJson(data);
        setCartResponse(cartResponse: cartResponse);
      } else {
        dynamic data = jsonDecode(responseData.body);
        AppConstants.showCustomToast(
            status: false, message: '${data['message'] ?? ""}');
      }

      setIsLoading(isLoading: false);
    } catch (exception) {
      setIsLoading(isLoading: false);
      AppConstants.showCustomToast(status: false, message: "$exception");
    }
  }

  //bottom sheet loader
  bool isBottomSheetLoader = false;

  void setIsBottomSheetLoader({required bool isBottomSheetLoader}) {
    this.isBottomSheetLoader = isBottomSheetLoader;
    notifyListeners();
  }

  //Apply Coupons
  Future<void> applyOrRemoveCoupon(
      {required int applyOrRemove,
      required String couponCode,
      required String tiendaToken}) async {
    try {
      setIsBottomSheetLoader(isBottomSheetLoader: true);

      var url = applyOrRemove == 0
          ? Uri.parse('${StoreApi.localBaseURL}/cart/apply-coupon')
          : Uri.parse('${StoreApi.localBaseURL}/cart/remove-coupon');

      var response = Request('POST', url)
        ..headers.addAll({
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $tiendaToken'
        })
        ..body = jsonEncode({"code": couponCode});

      var streamedResponse = await response.send();
      var responseData = await Response.fromStream(streamedResponse);
      if (responseData.statusCode == 200 || responseData.statusCode == 201) {
        dynamic data = jsonDecode(responseData.body);
        CartResponse cartResponse = CartResponse.fromJson(data);
        setCartResponse(cartResponse: cartResponse);
      } else {
        dynamic data = jsonDecode(responseData.body);
        AppConstants.showCustomToast(
            status: false, message: '${data['message'] ?? ""}');
      }

      setIsBottomSheetLoader(isBottomSheetLoader: false);
    } catch (exception) {
      AppConstants.showCustomToast(status: false, message: "$exception");
      setIsBottomSheetLoader(isBottomSheetLoader: false);
    }
  }

  //selected payment option
  PaymentOptionModel selectedPaymentOption =
      AppConstants.listOfPaymentsMethod[0];

  void setSelectedPaymentOption(
      {required PaymentOptionModel? selectedPaymentOption}) {
    this.selectedPaymentOption =
        selectedPaymentOption ?? AppConstants.listOfPaymentsMethod[0];
    notifyListeners();
  }

  //paypal payment function
  Future<void> checkout({required String tiendaToken}) async {
    try {
      setIsBottomSheetLoader(isBottomSheetLoader: true);

      var url =  Uri.parse('${StoreApi.localBaseURL}/v1/checkout');

      BillingAddress? billingAddress = cartResponse?.billingAddress;
      ShippingAddress? shippingAddress = cartResponse?.shippingAddress;


      var response = Request('POST', url)
        ..headers.addAll({
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $tiendaToken'
        })
        ..body = jsonEncode({
          {
            "billing_address": {
              "first_name": billingAddress?.firstName ?? "",
              "last_name": billingAddress?.lastName ?? "",
              "email": billingAddress?.email ?? "",
              "city": billingAddress?.city ?? "",
              "postcode": billingAddress?.postcode ?? "",
              "country": billingAddress?.country ?? ""
            },
            "shipping_address": {
              "first_name": shippingAddress?.firstName ?? "",
              "last_name": shippingAddress?.lastName ?? "",
              "address_1": shippingAddress?.address1 ?? "",
              "city": shippingAddress?.city ?? "",
              "postcode": shippingAddress?.postcode ?? "",
              "country": shippingAddress?.country ?? ""
            },
            "payment_method": selectedPaymentOption.optionName
          }
        });

      var streamedResponse = await response.send();
      var responseData = await Response.fromStream(streamedResponse);
      if (responseData.statusCode == 200 || responseData.statusCode == 201) {
        dynamic data = jsonDecode(responseData.body);
        CheckoutResponse checkoutResponse = CheckoutResponse.fromJson(data);


      } else {
        dynamic data = jsonDecode(responseData.body);
        AppConstants.showCustomToast(
            status: false, message: '${data['message'] ?? ""}');
      }

      setIsBottomSheetLoader(isBottomSheetLoader: false);
    } catch (exception) {
      AppConstants.showCustomToast(status: false, message: "$exception");
      setIsBottomSheetLoader(isBottomSheetLoader: false);
    }
  }
}
