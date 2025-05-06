//package com.atenea.colegioatenea.colegia_atenea
//
//import android.os.Bundle
//import io.flutter.embedding.android.FlutterActivity
//import io.flutter.embedding.engine.FlutterEngine
//import io.flutter.plugin.common.MethodChannel
//import java.text.Collator
//import java.util.Locale
//
//class MainActivity: FlutterActivity() {
//    private val CHANNEL = "native_sorting"
//
//    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
//        super.configureFlutterEngine(flutterEngine)
//
//        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL).setMethodCallHandler { call, result ->
//            try {
//                if (call.method == "sortSpanish") {
//                    val args = call.arguments as? Map<*, *>
//                    val items = args?.get("items") as? List<Map<String, Any>>
//                    val key = args?.get("key") as? String
//
//                    if (items == null || key == null) {
//                        result.error("INVALID_ARGUMENTS", "Items or key is null", null)
//                        return@setMethodCallHandler
//                    }
//
//                    val sortedItems = sortObjectsByKey(items, key)
//                    result.success(sortedItems)
//                } else {
//                    result.notImplemented()
//                }
//            } catch (e: Exception) {
//                result.error("SORTING_ERROR", "Error occurred: ${e.localizedMessage}", null)
//            }
//        }
//    }
//
//    private fun sortObjectsByKey(items: List<Map<String, Any>>, key: String): List<Map<String, Any>> {
//        val collator = Collator.getInstance(Locale("es", "ES")) // Spanish sorting rules
//        return items.sortedWith(compareBy(collator) { it[key]?.toString() ?: "" })
//    }
//}


package com.atenea.colegioatenea.colegia_atenea

import android.content.Intent
import android.util.Log
import com.redsys.tpvvinapplibrary.ErrorResponse
import com.redsys.tpvvinapplibrary.IPaymentResult
import com.redsys.tpvvinapplibrary.ResultResponse
import com.redsys.tpvvinapplibrary.TPVV
import com.redsys.tpvvinapplibrary.TPVVConfiguration
import com.redsys.tpvvinapplibrary.TPVVConstants
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import java.text.Collator
import java.util.HashMap
import java.util.Locale


class MainActivity: FlutterActivity() {
    private val SORTING_CHANNEL = "native_sorting"
    private val CHANNEL = "com.example.payment"

    private var paymentResult: MethodChannel.Result? = null

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        // Sorting Channel
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, SORTING_CHANNEL)
            .setMethodCallHandler { call, result ->
                try {
                    if (call.method == "sortSpanish") {
                        val args = call.arguments as? Map<*, *>
                        val items = args?.get("items") as? List<Map<String, Any>>
                        val key = args?.get("key") as? String

                        if (items == null || key == null) {
                            result.error("INVALID_ARGUMENTS", "Items or key is null", null)
                            return@setMethodCallHandler
                        }

                        val sortedItems = sortObjectsByKey(items, key)
                        result.success(sortedItems)
                    } else {
                        result.notImplemented()
                    }
                } catch (e: Exception) {
                    result.error("SORTING_ERROR", "Error occurred: ${e.localizedMessage}", null)
                }
            }

        //Payment channel
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL).setMethodCallHandler {
                call, result ->
            if (call.method == "startRedsysPayment") {
                startPayment()  // Call the function to start the payment
                result.success("Payment started")
            }
        }
    }

    private fun sortObjectsByKey(items: List<Map<String, Any>>, key: String): List<Map<String, Any>> {
        val collator = Collator.getInstance(Locale("es", "ES")) // Spanish sorting
        return items.sortedWith(compareBy(collator) { it[key]?.toString() ?: "" })
    }

//    private fun startPayment() {
//        try {
//            val tpv = TPVV()
//
//            // Set up the correct parameters for test
//            val orderCode = "COLEGIO123456"  // Unique order code, can be alphanumeric
//            val amount = 10.0              // Test amount, ensure it's a double
//            val operationType = "0"        // Normal payment type
//            val merchantCode = "999008881" // Test FUC (merchant code)
//            val productDescription = "License Test" // Sample description
//            val extraParams = HashMap<String, String>() // Optional additional params
//
//            // Correct environment and configuration settings for the test
//            TPVVConfiguration.setCurrency("978")                // EUR currency
//            TPVVConfiguration.setEnvironment(TPVVConstants.ENVIRONMENT_TEST) // Use test environment
//            TPVVConfiguration.setFuc(merchantCode)             // Set the test FUC
//            TPVVConfiguration.setTerminal("1")                 // Test terminal is "1"
//            TPVVConfiguration.setLicense("L6mRW1S9LAtZMhged7iq") // Correct test license
//            // Payment result callback
//            val paymentResult = object : IPaymentResult {
//                override fun paymentResultOK(result: ResultResponse) {
//                    Log.d("Payment", "Payment successful: ${result.responseCode}")
//                }
//
//                override fun paymentResultKO(error: ErrorResponse) {
//                    val errorCode = error.getCode()  // Error code
//                    val errorMessage = error.getDesc()  // Error description
//                    Log.e("Payment", "Payment failed: $errorCode - $errorMessage")
//                }
//            }
//
//            // Call payment method
////            TPVV.doDirectPayment(
////                this, orderCode, amount, operationType, merchantCode, productDescription, extraParams, paymentResult
////            )
//            val extraParams = hashMapOf(
//                "Ds_Merchant_ProductDescription" to "This is test payment we are doing it."
//            )
//            TPVV.doDirectPayment(
//                this,
//                "colegio1234",
//                amount,
//                "0",
//                TPVVConstants.REQUEST_REFERENCE,
//                extraParams,
//                paymentResult
//
//            )
//
////            val webView = WebView(this)
////            webView.settings.javaScriptEnabled = true
////            webView.settings.setAppCacheEnabled(true)
////            webView.settings.domStorageEnabled = true
////            webView.settings.cacheMode = WebSettings.LOAD_DEFAULT
//
////            TPVV.doWebViewPayment(
////                this, orderCode, amount, operationType, merchantCode, productDescription, extraParams, paymentResult
////            )
//
//        } catch (e: Exception) {
//            Log.e("PaymentError", "Error starting payment: ${e.localizedMessage}")
//        }
//    }

    private fun startPayment() {
        try {
            val tpv = TPVV()

            val orderCode = "ORD123"
            val amount = 10.0
            val transactionType = "0"
            val merchantCode = "999008881"
            val productDescription = "This is test payment we are doing it."

            // Only declare this once
            val extraParams = HashMap<String, String>()

            TPVVConfiguration.setCurrency("978")
            TPVVConfiguration.setEnvironment(TPVVConstants.ENVIRONMENT_TEST)
            TPVVConfiguration.setFuc(merchantCode)
            TPVVConfiguration.setTerminal("1")
            TPVVConfiguration.setLicense("L6mRW1S9LAtZMhged7iq")

            val paymentResult = object : IPaymentResult {
                override fun paymentResultOK(result: ResultResponse) {
                    Log.d("Payment", "Payment successful: ${result.responseCode}")
                    paymentResult?.success("Payment successful: ${result.responseCode}")
                }

                override fun paymentResultKO(error: ErrorResponse) {
                    Log.e("Payment", "Payment failed: ${error.code} - ${error.desc}")
                    paymentResult?.error("PAYMENT_FAILED", "Error ${error.code}: ${error.desc}", null)
                }
            }

            TPVV.doDirectPayment(
                this,
                orderCode,
                amount,
                transactionType,
                merchantCode,
               productDescription,
                extraParams,
                paymentResult
            )

        } catch (e: Exception) {
            Log.e("PaymentError", "Error starting payment: ${e.localizedMessage}")
        }
    }

    // Handle the result of the payment process
    override fun onActivityResult(requestCode: Int, resultCode: Int, data: Intent?) {
        super.onActivityResult(requestCode, resultCode, data)
        if (requestCode == 1001) {
            if (resultCode == RESULT_OK) {
                Log.d("Payment", "Payment successful")
            } else {
                Log.d("Payment", "Payment failed or was canceled")
            }
        }else{
            Log.d("Payment", "Request code will be : $resultCode")
        }
    }


}


