import 'package:flutter/services.dart';

class NativeSorter {
  static const MethodChannel _channel = MethodChannel('native_sorting');

  /// Calls the native sorting method on Android & iOS
  static Future<List<Map<String, dynamic>>> sortSpanish(
      List<Map<String, dynamic>> items, String key) async {
    try {
      final List<dynamic>? sortedItems = await _channel.invokeMethod<List<dynamic>>(
        'sortSpanish',
        {'items': items, 'key': key},
      );
      if (sortedItems != null) {
        return sortedItems.map((e) => Map<String, dynamic>.from(e)).toList();
      } else {
        return items; // Return original list if sorting fails
      }
    } catch (e) {
      return items; // Return original list in case of failure
    }
  }
}