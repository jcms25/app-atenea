import 'package:flutter/services.dart';

class PaymentService {
  static const platform = MethodChannel('com.example.payment');

  static Future<void> startPayment() async {
    try {
      await platform.invokeMethod('startRedsysPayment');
    } catch (e) {
      print('Payment initiation failed: $e');

    }
  }
}