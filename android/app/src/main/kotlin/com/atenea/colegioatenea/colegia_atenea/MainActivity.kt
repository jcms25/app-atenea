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


