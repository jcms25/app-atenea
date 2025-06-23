// import UIKit
// import Flutter
// import Firebase
//
// @UIApplicationMain
// @objc class AppDelegate: FlutterAppDelegate {
//   override func application(
//     _ application: UIApplication,
//     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
//   ) -> Bool {
//     FirebaseApp.configure()
//     GeneratedPluginRegistrant.register(with: self)
//     return super.application(application, didFinishLaunchingWithOptions: launchOptions)
//   }
// }

import UIKit
import Flutter
import Firebase
import TPVVInLibrary


@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
  
    var flutterResult : FlutterResult?
    
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {

    // Configure Firebase
    FirebaseApp.configure()

    // Register Flutter plugins
    GeneratedPluginRegistrant.register(with: self)

    // Set up the MethodChannel for native sorting
    let controller: FlutterViewController = window?.rootViewController as! FlutterViewController
    let sortingChannel = FlutterMethodChannel(name: "native_sorting", binaryMessenger: controller.binaryMessenger)
    let channel = FlutterMethodChannel(name: "com.example.payment", binaryMessenger: controller.binaryMessenger)
    
      //sorting according to spanish character
      sortingChannel.setMethodCallHandler { (call: FlutterMethodCall, result: @escaping FlutterResult) in
        if call.method == "sortSpanish" {
            guard let args = call.arguments as? [String: Any],
                  let items = args["items"] as? [[String: Any]],
                  let key = args["key"] as? String else {
                result(FlutterError(code: "INVALID_ARGUMENTS", message: "Items or key is missing", details: nil))
                return
            }
            let sortedItems = self.sortObjectsByKey(items: items, key: key)
            result(sortedItems)
        } else {
            result(FlutterMethodNotImplemented)
        }
    }
      
    
      //Redsys payment calling method
//      channel.setMethodCallHandler { (call: FlutterMethodCall, result: @escaping FlutterResult) in
//              if call.method == "startRedsysPayment" {
//                  let args = call.arguments as? [String: Any] ?? [:]
//                  let orderId = args["orderId"] as? String ?? ""
//                  let newOrderId = "Ord_\(orderId)"
//                  let amount = args["amount"] as? Int ?? 0
//                  let paymentMethodType = args["payment_method"] as? String ?? "RedSys"
//                  let signature = args["signature"] as? String ?? ""
//                  let merchantParams = args["merchantParams"] as? String ?? ""
//                 
//                  
//                  
//                  self.startRedsysPayment(from: controller, flutterResult: result,
//                                          orderId : newOrderId,
//                                          amount : Double(amount),
//                                          paymentMethodType : paymentMethodType,
//                                          signature : signature,
//                                          merchantParams : merchantParams
//                                          
//                  )
//              } else {
//                  result(FlutterMethodNotImplemented)
//              }
//          }

      channel.setMethodCallHandler { call, result in
          if call.method == "startRedsysPayment" {
              
              self.flutterResult = result
              
              guard let args = call.arguments as? [String: Any],
                    let orderId = args["orderId"] as? String,
                    let amount = args["amount"] as? Double,
                    let method = args["payment_method"] as? String,
                    let signature = args["signature"] as? String,
                    let merchantParams = args["merchantParams"] as? String else {
                  result(FlutterError(code: "MISSING_ARGUMENT", message: "Required params not passed", details: nil))
                  return
              }

              if let rootVC = UIApplication.shared.windows.first?.rootViewController {
                  print("Hello")
                  self.startRedsysPayment(
                      from: rootVC,
                      flutterResult: result,
                      orderId: orderId,
                      amount: amount,
                      paymentMethodType: method,
                      signature: signature,
                      merchantParams: merchantParams
                  )
              } else {
                  print("NO_ROOT_CONTROLLER")
                  result(FlutterError(code: "NO_ROOT_CONTROLLER", message: "Can't get root controller", details: nil))
              }
          } else {
              print("This is executed")
              result(FlutterMethodNotImplemented)
          }
      }
      

    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }

  /// Native sorting function using `localizedStandardCompare`
  private func sortObjectsByKey(items: [[String: Any]], key: String) -> [[String: Any]] {
      return items.sorted {
          let value1 = ($0[key] as? String) ?? ""
          let value2 = ($1[key] as? String) ?? ""
          return value1.localizedStandardCompare(value2) == .orderedAscending
      }
  }
    
//    //start payment method
//    func startRedsysPayment(from controller: UIViewController, flutterResult: @escaping FlutterResult, orderId : String, amount : Double,paymentMethodType : String, signature : String, merchantParams : String) {
//
//        print("Hello")
//      
////       let tpvv = TPVV
////        
//    
//        let config = TPVVConfiguration.shared
//        config.appEnviroment = .Test
//        config.appFuc = "348775818"
//        config.appTerminal = "001"
//        config.appCurrency = "978" // EUR
//        config.appLicense = "SVpKYSNRmlNPHixFOUG9"
//        
//        
//        print("Order Id \(orderId)")
//        print("Amount is \(amount)")
//        print("Payment Method Type \(paymentMethodType)")
//        print("Signature \(signature)")
//        print("Merchant Params \(merchantParams)")
////
////        let controller = WebViewPaymentController(orderNumber: <#T##String#>, amount: "12.45" productDescription: "Test Payment", transactionType: TransactionType., identifier: <#T##String#>, extraParams: <#T##[String : String]?#>)
////            config.environment = .test
////            config.fuc = ""
////            config.terminal = ""
////            config.currency = "978"
////            config.license = "SVpKYSNRmlNPHixFOUG9"
//
//        
//        var extraParams: [String: String] = [:]
//            extraParams["Ds_SignatureVersion"] = "HMAC_SHA256_V1"
//            extraParams["Ds_MerchantParameters"] = merchantParams
//            extraParams["Ds_Signature"] = signature
//
//            // Bizum payment method
//        if paymentMethodType == "Bizum" {
//                extraParams["Ds_Merchant_PayMethods"] = "z"
//            }
//        
//        
//        let paymentVC = WebViewPaymentController(
//            signature: signature,
//            merchantParameters: merchantParams,
//            extraParams: extraParams,
//            onResponseOK: { responseOK in
//                print("success:\(responseOK.Ds_Order)")
//            },
//            onResponseKO: { responseKO in
//                print("failure:\(responseKO.desc)")
//            }
//        )
//        
//        
////            let order = "\(Int(Date().timeIntervalSince1970))"
////            
////            tpvv.doDirectPayment(
////              order: order,
////              amount: 10.0,
////              operationType: "0",
////              merchantCode: config.fuc,
////              productDescription: "Test Payment",
////              extraParams: ["Ds_Merchant_ConsumerLanguage": "001"],  // optional
////              in: viewController,
////              success: { response in
////                print("✅ Success: \(response.responseCode ?? "")")
////              },
////              failure: { error in
////                print("❌ Failed: \(error.code) - \(error.message)")
////              }
////            )
//    }
    
    
    func startRedsysPayment(
        from controller: UIViewController,
        flutterResult: @escaping FlutterResult,
        orderId: String,
        amount: Double,
        paymentMethodType: String,
        signature: String,
        merchantParams: String
    ) {
        print("🟡 Starting Redsys Payment")
        print("Order ID: \(orderId)")
        print("Amount: \(amount)")
        print("Payment Method: \(paymentMethodType)")
        print("Signature: \(signature)")
        print("Merchant Params: \(merchantParams)")

        // ✅ 1. Configure Redsys SDK
        let config = TPVVConfiguration.shared
        config.appEnviroment = .Test  // Use `.production` for live
        config.appFuc = "348775818"
        config.appTerminal = "001"
        config.appCurrency = "978"
        config.appLicense = "SVpKYSNRmlNPHixFOUG9"  // Only if your version needs it
        config.appMerchantDescription = "Test Payment"
        config.appMerchantConsumerLanguage = "001"
     /*   config.appMerchantPayMethods = "Cz" */ // Accept both Card + Bizum

        // ✅ 2. Build extra parameters (required by Redsys)
        var extraParams: [String: String] = [
            "Ds_SignatureVersion": "HMAC_SHA256_V1",
            "Ds_MerchantParameters": merchantParams,
            "Ds_Signature": signature
        ]

        // ✅ Optional: limit to Bizum
        if paymentMethodType == "Bizum" {
            extraParams["Ds_Merchant_PayMethods"] = "z"
        }

        let webViewPaymentController = WebViewPaymentController(orderNumber: orderId, amount: amount, productDescription: "Test Payemnt", transactionType: TransactionType.normal, identifier: "", extraParams: extraParams)
        
        
        
        webViewPaymentController.delegate = self
        
        controller.present(webViewPaymentController, animated: true, completion: nil)

        
    }
}

extension AppDelegate: WebViewPaymentResponseDelegate {
    func responsePaymentOK(response: WebViewPaymentResponseOK) {
        
        let resultData: [String: Any] = [
             "status": "true",
             "order": response.Ds_Order ?? "",
             "amount": response.Ds_Amount ?? "",
             "currency": response.Ds_Currency ?? "",
             "authCode": response.Ds_AuthorisationCode ?? "",
             "date": response.Ds_Date ?? "",
             "time": response.Ds_Hour ?? "",
             "merchantData": response.Ds_MerchantData ?? ""
         ]

        
        flutterResult?(resultData)
        flutterResult = nil
    }

    func responsePaymentKO(response: WebViewPaymentResponseKO) {
        let resultData: [String: Any] = [
                "status": "false",
                "raw" : "\(response)"
            ]

        flutterResult?(resultData)
        flutterResult = nil
    }
}
