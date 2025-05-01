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

import android.app.Activity
import android.content.Intent
import android.os.Bundle
import android.widget.Toast
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import java.text.Collator
import java.util.Locale
import com.redsys.tpvvinapplibrary.TPVV  // Import TPVV class
import com.redsys.tpvvinapplibrary.IPaymentResult
import com.redsys.tpvvinapplibrary.ResultResponse
import com.redsys.tpvvinapplibrary.ErrorResponse// Import payment result interface
import java.util.HashMap
import android.util.Log
import com.redsys.tpvvinapplibrary.TPVVConfiguration
import com.redsys.tpvvinapplibrary.TPVVConstants

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
            // Initialize TPVV with context
            val tpv = TPVV()

            // Payment parameters
            val orderCode = "123456789"
            val amount = 100.0
            val operationType = TPVVConstants.PAYMENT_TYPE_NORMAL
            val merchantIdentifier = "999008881"
            val productDescription = "Sample Product"
            val extraParams = HashMap<String, String>()


            TPVVConfiguration.setCurrency("978")
            TPVVConfiguration.setEnvironment(TPVVConstants.ENVIRONMENT_TEST)
            TPVVConfiguration.setFuc("999008881")
            TPVVConfiguration.setLicense("L6mRW1S9LAtZMhged7iq");
            TPVVConfiguration.setTerminal("1");

            // Define the payment result callback
            val paymentResult = object : IPaymentResult {
                override fun paymentResultOK(result: ResultResponse) {
                    Log.d("Payment", "Payment successful: ${result.responseCode}")
                }

                override fun paymentResultKO(error: ErrorResponse) {
//                    Log.e("Payment", "Payment failed: ${error.errorCode} - ${error.errorMessage}")
                    val errorCode = error.getCode()  // Use getCode() to access the error code
                    val errorMessage = error.getDesc()  // Use getDesc() to access the error description

                    // Log the error
                    Log.e("Payment", "Payment failed: $errorCode - $errorMessage")
                }
            }

            // Call direct payment method
            TPVV.doDirectPayment(
                this, orderCode, amount, "tipoOperación", merchantIdentifier, productDescription, extraParams, paymentResult
            )
            // Or call WebView payment method if you prefer:
            // tpv.doWebViewPayment(
            //     this, orderCode, amount, operationType, merchantIdentifier, productDescription, extraParams, paymentResult
            // )

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
        }
    }


}


