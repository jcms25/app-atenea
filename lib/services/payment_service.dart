import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';


import 'dart:convert';
import 'package:crypto/crypto.dart';
import 'package:pointycastle/export.dart';

class PaymentService {
  static const platform = MethodChannel('com.example.payment');

  static Future<bool> startPayment({
    required String paymentMethod,
    required String orderId,
    required String amount,
  }) async {
    try {

      String normalized = amount.replaceAll(',', '.');
      double amountDouble = double.parse(normalized);
      int amountInCents = (amountDouble * 100).round();

      final random = Random();
      int threeDigitNumber = 100 + random.nextInt(900);
      // String newOrderId = "ORDER$orderId";  //12 chars
      String newOrderId = "$threeDigitNumber$orderId".padLeft(4,'0');
      const secretKeyBase64 = "Mk9m98IfEblmPfrpsawtFg=="; // test key

      // const secretKeyBase64 = "sq7HjrUOBfKmC576ILgskD5srU870gJ7";

      final merchantParams = json.encode({
        "Ds_Merchant_Amount": amountInCents.toString(),
        "Ds_Merchant_Order": newOrderId,
        "Ds_Merchant_MerchantCode": "348775818",
        // "Ds_Merchant_MerchantCode": "999008881",
        "Ds_Merchant_Currency": "978",
        "Ds_Merchant_TransactionType": "0",
        "Ds_Merchant_Terminal": "001",
        // "Ds_Merchant_Terminal": "1",
        "Ds_Merchant_MerchantURL": "https://example.com/notify",
        "Ds_Merchant_UrlOK": "https://example.com/success",
        "Ds_Merchant_UrlKO": "https://example.com/fail",
      });
      final base64Params = base64.encode(utf8.encode(merchantParams));
      final signature = generateRedsysSignature(
        base64Params: base64Params,
        order: newOrderId,
        secretKeyBase64: secretKeyBase64,
      );


      final result = await platform.invokeMethod('startRedsysPayment',{'orderId' : newOrderId,'payment_method' : paymentMethod,'signature':signature,'merchantParams' : base64Params,'amount' : amountInCents });


      return result['status'];
    } catch (e) {
      if (kDebugMode) {
        print('Payment initiation failed: $e');
      }
      return false;
    }
  }


  static Uint8List _encrypt3DES(Uint8List key, String message) {
    final keyParam = KeyParameter(key);
    final cipher = DESedeEngine()
      ..init(true, keyParam); // true=encrypt

    // Pad message to block size (8 bytes)
    final input = _pkcs5Padding(Uint8List.fromList(utf8.encode(message)));
    final output = Uint8List(input.length);

    for (int offset = 0; offset < input.length; offset += 8) {
      cipher.processBlock(input, offset, output, offset);
    }

    return output;
  }

  static Uint8List _pkcs5Padding(Uint8List input) {
    final blockSize = 8;
    final padLength = blockSize - (input.length % blockSize);
    return Uint8List.fromList([...input, ...List.filled(padLength, padLength)]);
  }

  static String generateRedsysSignature({
    required String base64Params,
    required String order,
    required String secretKeyBase64,
  }) {
    // Step 1: Decode the secret key
    final secretKey = base64.decode(secretKeyBase64);

    // Step 2: Encrypt the order using 3DES
    final encryptedKey = _encrypt3DES(Uint8List.fromList(secretKey), order);

    // Step 3: Create HMAC-SHA256 signature
    final hmacSha256 = Hmac(sha256, encryptedKey);
    final digest = hmacSha256.convert(utf8.encode(base64Params));

    // Step 4: Base64 encode the result
    return base64.encode(digest.bytes);
  }




}



