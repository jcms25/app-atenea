import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import '../../../services/app_shared_preferences.dart' show AppSharedPreferences;

class WebViewProvider extends ChangeNotifier {
  late WebViewController webViewController;
  String token = "";

  WebViewProvider() {
    _initializeWebView();
  }

  /// Initializes the WebView Controller
  void _initializeWebView() {
    token = AppSharedPreferences.getUserData()?.tiendaToken ?? "";

    webViewController = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(
        NavigationDelegate(
          onNavigationRequest: (NavigationRequest request) {
            _loadPageWithHeaders(request.url);
            return NavigationDecision.prevent;
          },
          onPageFinished: (String url) {},
        ),
      );
  }

  /// Loads a page with headers
  void _loadPageWithHeaders(String url) {
    webViewController.loadRequest(
      Uri.parse(url),
      headers: _buildHeaders(),
    );
  }

  /// Returns headers with authentication token
  Map<String, String> _buildHeaders() {
    return {
      "Authorization": "Bearer $token",
      "Cache-Control": "no-cache, no-store, must-revalidate",
      "Pragma": "no-cache",
      "Expires": "0",
    };
  }

  /// Loads the initial URL when the WebView is first created
  void loadInitialUrl(String url) {
    _loadPageWithHeaders(url);
  }
}
