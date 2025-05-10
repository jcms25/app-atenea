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
    private fun startPayment() {
        try {
            val tpv = TPVV()

            // Configuration for test environment
            TPVVConfiguration.setEnvironment(TPVVConstants.ENVIRONMENT_TEST)  // Test environment
            TPVVConfiguration.setFuc("999008881")  // Use the correct test FUC
            TPVVConfiguration.setTerminal("1")  // Terminal number
            TPVVConfiguration.setCurrency("978")  // EUR currency
            TPVVConfiguration.setLicense("L6mRW1S9LAtZMhged7iq")  // Test license key (replace with your actual key)

            // Generate a unique order code
            val orderCode = "ORDER" + System.currentTimeMillis()

            // Extra parameters (you can pass CVV, Expiry Date, and Card Number here)
            val extraParams = hashMapOf(
                "Ds_Merchant_ProductDescription" to "Test Payment"
            )

            // Initiate direct payment
            TPVV.doDirectPayment(
                this,
                orderCode,  // Unique order code
                10.0,  // Amount in EUR
                TPVVConstants.PAYMENT_METHOD_Z,  // Operation type (0 is standard payment)
                null,  // Test FUC
                "Test Payment",  // Product description
                extraParams,
                object : IPaymentResult {
                    override fun paymentResultOK(result: ResultResponse) {
                        Log.d("PAYMENT", "✅ Success: ${result.responseCode}")
                        // Handle successful payment
                    }

                    override fun paymentResultKO(error: ErrorResponse) {
                        Log.e("PAYMENT", "❌ Failed: ${error.code} - ${error.desc}")
                        // Handle failure
                    }
                }
            )
        } catch (e: Exception) {
            Log.e("PaymentError", "Error starting payment: ${e.localizedMessage}")
        }
    }


//    private fun startPayment() {
//        try {
//            val tpv = TPVV()
//
//            val orderCode = "ORD123"
//            val amount = 10.0
//            val transactionType = "0"
//            val merchantCode = "999008881"
//            val productDescription = "This is test payment we are doing it."
//
//            // Only declare this once
//            val extraParams = HashMap<String, String>()
//
//            TPVVConfiguration.setCurrency("978")
//            TPVVConfiguration.setEnvironment(TPVVConstants.ENVIRONMENT_TEST)
//            TPVVConfiguration.setFuc(merchantCode)
//            TPVVConfiguration.setTerminal("1")
//            TPVVConfiguration.setLicense("L6mRW1S9LAtZMhged7iq")
//
//            val paymentResult = object : IPaymentResult {
//                override fun paymentResultOK(result: ResultResponse) {
//                    Log.d("Payment", "Payment successful: ${result.responseCode}")
//                    paymentResult?.success("Payment successful: ${result.responseCode}")
//                }
//
//                override fun paymentResultKO(error: ErrorResponse) {
//                    Log.e("Payment", "Payment failed: ${error.code} - ${error.desc}")
//                    paymentResult?.error("PAYMENT_FAILED", "Error ${error.code}: ${error.desc}", null)
//                }
//            }
//
//            TPVV.doDirectPayment(
//                this,
//                orderCode,
//                amount,
//                transactionType,
//                merchantCode,
//               productDescription,
//                extraParams,
//                paymentResult
//            )
//
//        } catch (e: Exception) {
//            Log.e("PaymentError", "Error starting payment: ${e.localizedMessage}")
//        }
//    }


//    private fun startPayment() {
//        try {
//            val tpv = TPVV()
//
//            val orderCode = "ORD123" // You can make this dynamic if needed
//            val amount = 10.0        // Same for amount
//            val transactionType = "0" // Normal payment
//            val merchantCode = "999008881"
//            val productDescription = "This is test payment we are doing it."
//
//            val extraParams = HashMap<String, String>()
//
//            // Setup configuration for test environment
//            TPVVConfiguration.setCurrency("978") // EUR
//            TPVVConfiguration.setEnvironment(TPVVConstants.ENVIRONMENT_TEST)
//            TPVVConfiguration.setFuc(merchantCode)
//            TPVVConfiguration.setTerminal("1")
//            TPVVConfiguration.setLicense("L6mRW1S9LAtZMhged7iq")
//
//            // Actual payment result handler
//            val resultHandler = object : IPaymentResult {
//                override fun paymentResultOK(result: ResultResponse) {
//                    Log.d("Payment", "Payment successful: ${result.responseCode}")
//                    paymentResult?.success("Payment successful: ${result.responseCode}")
//                    paymentResult = null
//                }
//
//                override fun paymentResultKO(error: ErrorResponse) {
//                    Log.e("Payment", "Payment failed: ${error.code} - ${error.desc}")
//                    paymentResult?.error("PAYMENT_FAILED", "Error ${error.code}: ${error.desc}", null)
//                    paymentResult = null
//                }
//            }
//
//            // Initiate payment
//            TPVV.doDirectPayment(
//                this,
//                orderCode,
//                amount,
//                transactionType,
//                merchantCode,
//                productDescription,
//                extraParams,
//                resultHandler
//            )
//
//        } catch (e: Exception) {
//            Log.e("PaymentError", "Error starting payment: ${e.localizedMessage}")
//            paymentResult?.error("EXCEPTION", e.localizedMessage, null)
//            paymentResult = null
//        }
//    }



    // Handle the result of the payment process
//    override fun onActivityResult(requestCode: Int, resultCode: Int, data: Intent?) {
//        super.onActivityResult(requestCode, resultCode, data)
////        if (requestCode == 1001) {
////            if (resultCode == RESULT_OK) {
////                Log.d("Payment", "Payment successful")
////            } else {
////                Log.d("Payment", "Payment failed or was canceled")
////            }
////        }else{
////            Log.d("Payment", "Request code will be : $resultCode")
////        }
//        PaymentHelper.handlePaymentResult(requestCode, resultCode, data)
//    }


}


