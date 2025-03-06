import 'package:colegia_atenea/services/app_shared_preferences.dart';
import 'package:colegia_atenea/utils/app_textstyle.dart';
import 'package:colegia_atenea/views/custom_widgets/custom_app_bar_widget.dart';
import 'package:colegia_atenea/views/custom_widgets/custom_loader.dart';
import 'package:colegia_atenea/views/screens/webview_screen/webview_provider.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:webview_flutter/webview_flutter.dart';
import '../../../utils/app_colors.dart';

class WebViewScreen extends StatefulWidget {
  final String label;
  final String loadURL;

  const WebViewScreen({super.key, required this.loadURL, required this.label});

  @override
  State<WebViewScreen> createState() => _WebViewScreenState();
}

class _WebViewScreenState extends State<WebViewScreen> {
  late WebViewController webViewController;


  @override
  void initState() {
    super.initState();
    String token = AppSharedPreferences.getUserData()?.tiendaToken ?? "";
    webViewController = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(
        NavigationDelegate(
          onNavigationRequest: (NavigationRequest request) {
            webViewController.loadRequest(
              Uri.parse(request.url),
              headers: {
                "Authorization": "Bearer $token",
                "Cache-Control": "no-cache, no-store, must-revalidate",
                "Pragma": "no-cache",
                "Expires": "0",
              },
            );
            return NavigationDecision.prevent;
          },
          onPageFinished: (String url) {
          },
        ),

      )
      ..loadRequest(
        Uri.parse(widget.loadURL),
        headers: {
          "Authorization": "Bearer $token",
          "Cache-Control": "no-cache, no-store, must-revalidate",
          "Pragma": "no-cache",
          "Expires": "0",
        }
      );
  }

  @override
  Widget build(BuildContext context) {


    return Scaffold(
      appBar: CustomAppBarWidget(
        title: Text(
          widget.label,
          style: AppTextStyle.getOutfit500(
            textSize: 20,
            textColor: AppColors.white,
          ),
        ),
        onLeadingIconClicked: () {
          Get.back();
        },
      ),
      body: Stack(
        children: [
          WebViewWidget(
              controller: webViewController
          ),
          Consumer<WebViewProvider>(
            builder: (context, webViewProvider, child) {
              return Visibility(
                visible: false, // Add logic if you want to show a loader
                child: LoadingLayout(),
              );
            },
          ),
        ],
      ),
    );
  }
}
