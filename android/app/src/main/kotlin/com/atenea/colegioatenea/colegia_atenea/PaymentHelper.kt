package com.atenea.colegioatenea.colegia_atenea

//import android.content.Context
//import android.content.Intent
//import com.redsys.tpvvinapplibrary.webview.WebViewPaymentActivity
//
//object PaymentHelper {
//    fun startWebViewPayment(context: Context, url: String) {
//        val intent = Intent(context, WebViewPaymentActivity::class.java).apply {
//            putExtra("url", url) // Ensure the key "url" is correct as per the SDK docs
//        }
//        context.startActivity(intent)
//    }
//}
//
//
//import android.app.Activity
//import android.content.Context
//import android.content.Intent
//import android.util.Log
//import com.redsys.tpvvinapplibrary.directPayment.DirectPaymentActivity
////import com.redsys.tpvvinapplibrary.configuration.TPVVConfiguration
//import com.redsys.tpvvinapplibrary.TPVVConfiguration
//import com.redsys.tpvvinapplibrary.TPVVConstants
//import com.redsys.tpvvinapplibrary.model.TPVVRequest
//
//object PaymentHelper {
//
//    const val PAYMENT_REQUEST_CODE = 1001
//
//    fun startDirectPayment(context: Activity, orderId: String, amountInCents: String) {
//        // Configure Redsys
//        TPVVConfiguration.setLicense("YOUR_LICENSE_HERE")
//        TPVVConfiguration.setEnvironment(TPVVConstants.ENVIRONMENT_TEST) // or ENVIRONMENT_REAL
//        TPVVConfiguration.setFuc("YOUR_MERCHANT_CODE")
//        TPVVConfiguration.setTerminal("1")
//        TPVVConfiguration.setCurrency("978") // EUR
//
//        // Create the payment request
//        val paymentRequest = TPVVRequest().apply {
//            amount = amountInCents
//            order = orderId
//            merchantName = "My Business"
//            productDescription = "Order Payment"
//            merchantData = "OptionalData"
//        }
//
//        // Start the DirectPaymentActivity
//        val intent = Intent(context, DirectPaymentActivity::class.java).apply {
//            putExtra("TPVVRequest", paymentRequest)
//        }
//
//        context.startActivityForResult(intent, PAYMENT_REQUEST_CODE)
//    }
//
//    fun handlePaymentResult(requestCode: Int, resultCode: Int, data: Intent?) {
//        if (requestCode == PAYMENT_REQUEST_CODE) {
//            if (resultCode == Activity.RESULT_OK) {
//                val result = data?.getStringExtra("TPVVResult")
//                Log.d("PaymentSuccess", "Result: $result")
//                // Notify success to UI or backend
//            } else {
//                Log.d("PaymentFailed", "Payment was canceled or failed.")
//                // Handle failure case
//            }
//        }
//    }
//}
//
