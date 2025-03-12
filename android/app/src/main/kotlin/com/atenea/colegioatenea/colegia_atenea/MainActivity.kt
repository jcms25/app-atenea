package com.atenea.colegioatenea.colegia_atenea

import android.os.Bundle
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import java.text.Collator
import java.util.Locale

class MainActivity: FlutterActivity() {
    private val CHANNEL = "native_sorting"

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL).setMethodCallHandler { call, result ->
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
    }

    private fun sortObjectsByKey(items: List<Map<String, Any>>, key: String): List<Map<String, Any>> {
        val collator = Collator.getInstance(Locale("es", "ES")) // Spanish sorting rules
        return items.sortedWith(compareBy(collator) { it[key]?.toString() ?: "" })
    }
}
