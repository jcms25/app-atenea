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


class MainActivity : FlutterActivity() {
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
        MethodChannel(
            flutterEngine.dartExecutor.binaryMessenger,
            CHANNEL
        ).setMethodCallHandler { call, result ->
            if (call.method == "startRedsysPayment") {
                val orderId = "Ord_${call.argument<Int>("orderId")}"
                val paymentMethodType = call.argument<String>("payment_method") ?: "RedSys"
                val signature = call.argument<String>("signature") ?: ""
                val merchantParams = call.argument<String>("merchantParams") ?: ""
                val amountReceived = call.argument<Int>("amount") ?: 0
//                startPayment(
//                    orderId = orderId,
//                    paymentMethod = paymentMethodType,
//                    merchantParams = merchantParams,
//                    signature = signature,
//                    amount = amountReceived.toDouble()
//                )  // Call the function to start the payment
                startPayment(orderId, paymentMethodType, signature, merchantParams, amountReceived.toDouble()) { paymentResult ->
                    result.success(paymentResult)
                }
            }
        }


    }

    private fun sortObjectsByKey(
        items: List<Map<String, Any>>,
        key: String
    ): List<Map<String, Any>> {
        val collator = Collator.getInstance(Locale("es", "ES")) // Spanish sorting
        return items.sortedWith(compareBy(collator) { it[key]?.toString() ?: "" })
    }

//    private fun startPayment(orderId: String, paymentMethod: String, signature : String, merchantParams : String,amount : Double) : Map<String,T> {
//        try {
//            val tpv = TPVV()
//
//            // Configuration for test environment
//
//            //Test environment
//            TPVVConfiguration.setEnvironment(TPVVConstants.ENVIRONMENT_TEST)
////            TPVVConfiguration.setFuc("999008881")
////            TPVVConfiguration.setTerminal("1")
//            TPVVConfiguration.setLicense("L6mRW1S9LAtZMhged7iq")  // Test license key (replace with your actual key)
//
//            //Production Environment
////            TPVVConfiguration.setEnvironment(TPVVConstants.ENVIRONMENT_REAL)
//            TPVVConfiguration.setFuc("348775818")
//            TPVVConfiguration.setTerminal("001")
////            TPVVConfiguration.setLicense("AepJ83ytmfpF5ToI1gO")
//
//            TPVVConfiguration.setCurrency("978")  // EUR currency
//
//            // Extra parameters (you can pass CVV, Expiry Date, and Card Number here)
////            val extraParams = hashMapOf(
////                "Ds_Merchant_ProductDescription" to "Test Payment"
////            )
//            Log.e("Signature",signature)
//            val extraParams = HashMap<String, String>()
//            extraParams["Ds_SignatureVersion"] = "HMAC_SHA256_V1"
//            extraParams["Ds_MerchantParameters"] = merchantParams
//            extraParams["Ds_Signature"] = signature
//
//            if (paymentMethod == "Bizum") {
//                extraParams["Ds_Merchant_PayMethods"] = "z"
//            }
//
//
//
////            extraParams["Ds_Merchant_CardNumber"] = "4548812049400004"
////            extraParams["Ds_Merchant_ExpiryDate"] = "1225"
////            extraParams["Ds_Merchant_CVV2"] = "123"
////            extraParams["Ds_Merchant_Identifier"] = ""
////            extraParams["Ds_Merchant_UrlOK"] = "https://yourdomain.com/payment-success"
////            extraParams["Ds_Merchant_UrlKO"] = "https://yourdomain.com/payment-failure"
////            extraParams["Ds_Merchant_MerchantURL"] = "https://yourdomain.com/redsys/notify"
//
//
//
//            // Initiate direct payment
////            TPVV.doDirectPayment(
////                this,
////                orderId,  // Unique order code
////                amount,  // Amount in EUR
////                "0",  // Operation type (0 is standard payment)
////                null,  // Test FUC
////                "Test Payment",  // Product description
////                extraParams,
////                object : IPaymentResult {
////                    override fun paymentResultOK(result: ResultResponse) {
////                        Log.e("Payment Response", "${result}")
////                        Log.d("PAYMENT", "✅ Success: ${result.responseCode}")
//////                        result.success("success");
////                        // Handle successful payment
////                    }
////
////                    override fun paymentResultKO(error: ErrorResponse) {
////                        Log.e("Payment Response", "${error}")
////                        Log.e("PAYMENT", "❌ Failed: ${error.code} - ${error.desc}")
////                        // Handle failure
//////                        result.error("REDSYS_ERROR", error.desc, error.code);
////                    }
////                }
////            )
//
//
//            val resultMap = map<String,T>();
//
//            TPVV.doWebViewPayment(
//                this,
//                orderId,
//                amount,
//                "0",
//                null,
//                "Test Payment",
//                extraParams,
//                object : IPaymentResult {
//                    override fun paymentResultOK(result: ResultResponse) {
//                        Log.e("Payment Response", "${result}")
//                        result["status"] = true
//                        Log.d("PAYMENT", "✅ Success: ${result.responseCode}")
////                        result.success("success");
//                        // Handle successful payment
//                    }
//
//                    override fun paymentResultKO(error: ErrorResponse) {
//                        Log.e("Payment Response", "${error}")
//                        Log.e("PAYMENT", "❌ Failed: ${error.code} - ${error.desc}")
//                        // Handle failure
////                        result.error("REDSYS_ERROR", error.desc, error.code);
//                        resultMap["status"] = false;
//                    }
//                }
//            )
//
//            return  resultMap;
//        } catch (e: Exception) {
//            Log.e("PaymentError", "Error starting payment: ${e.localizedMessage}")
//            val map = mapOf("status" to false)
//            return map;
//        }
//    }

fun startPayment(
    orderId: String,
    paymentMethod: String,
    signature: String,
    merchantParams: String,
    amount: Double,
    callback: (Map<String, Any>) -> Unit
) {
    try {
        val tpv = TPVV()

        // Test Environment
        TPVVConfiguration.setEnvironment(TPVVConstants.ENVIRONMENT_TEST)
        TPVVConfiguration.setFuc("348775818")
        TPVVConfiguration.setTerminal("001")
        TPVVConfiguration.setLicense("L6mRW1S9LAtZMhged7iq")
        TPVVConfiguration.setCurrency("978")

        val extraParams = HashMap<String, String>()
        extraParams["Ds_SignatureVersion"] = "HMAC_SHA256_V1"
        extraParams["Ds_MerchantParameters"] = merchantParams
        extraParams["Ds_Signature"] = signature
        if (paymentMethod == "Bizum") {
            extraParams["Ds_Merchant_PayMethods"] = "z"
        }

        TPVV.doWebViewPayment(
            context,
            orderId,
            amount,
            "0",
            null,
            "Test Payment",
            extraParams,
            object : IPaymentResult {
                override fun paymentResultOK(result: ResultResponse) {
                    val resultMap = mapOf(
                        "status" to true,
                        "responseCode" to result.responseCode,
                        "raw" to result.toString()
                    )
                    Log.e("Payment Native Status","$result")
                    callback(resultMap)
                }

                override fun paymentResultKO(error: ErrorResponse) {
                    val resultMap = mapOf(
                        "status" to false,
                        "errorCode" to error.code,
                        "errorDesc" to error.desc,
                        "raw" to error.toString()
                    )
                    callback(resultMap)
                }
            }
        )

    } catch (e: Exception) {
        val map = mapOf(
            "status" to false,
            "error" to e.localizedMessage
        )
        callback(map)
    }
}

}


