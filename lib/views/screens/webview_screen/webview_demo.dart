// import 'package:colegia_atenea/services/app_shared_preferences.dart';
// import 'package:colegia_atenea/utils/app_textstyle.dart';
// import 'package:colegia_atenea/views/custom_widgets/custom_app_bar_widget.dart';
// import 'package:colegia_atenea/views/screens/webview_screen/webview_provider.dart';
// import 'package:flutter/foundation.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_inappwebview/flutter_inappwebview.dart';
// import 'package:get/get.dart';
// import 'package:provider/provider.dart';
// import 'package:webview_flutter/webview_flutter.dart';
// import '../../../utils/app_colors.dart';
//
// class WebViewScreen extends StatefulWidget {
//   final String label;
//   final String loadURL;
//
//   const WebViewScreen({super.key, required this.loadURL, required this.label});
//
//   @override
//   State<WebViewScreen> createState() => _WebViewScreenState();
// }
//
// class _WebViewScreenState extends State<WebViewScreen> {
//   late WebViewController webViewController;
//   late WebViewProvider webViewProvider;
//   String? token;
//
//
//   @override
//   void initState() {
//     super.initState();
//     token = AppSharedPreferences.getUserData()?.tiendaToken ?? "";
//     webViewProvider = Provider.of<WebViewProvider>(context, listen: false);
//     webViewController = WebViewController()
//       ..setJavaScriptMode(JavaScriptMode.unrestricted)
//       ..setNavigationDelegate(
//         NavigationDelegate(
//           onNavigationRequest: (NavigationRequest request) {
//             webViewController.loadRequest(
//               Uri.parse(request.url),
//               headers: {
//                 "Authorization": "Bearer $token",
//                 "Cache-Control": "no-cache, no-store, must-revalidate",
//                 "Pragma": "no-cache",
//                 "Expires": "0",
//               },
//             );
//             return NavigationDecision.prevent;
//           },
//           onPageStarted: (String url) {
//             webViewProvider.updateProgress(0);
//           },
//           onPageFinished: (String url){
//             webViewProvider.updateProgress(100);
//
//           },
//           onProgress: (progress){
//               webViewProvider.updateProgress(progress);
//           },
//           onHttpError: (httpResponseError){
//             if (kDebugMode) {
//               print(httpResponseError);
//             }
//           },
//           onWebResourceError: (webRequestError){
//             if (kDebugMode) {
//               print(webRequestError);
//             }
//       }
//         ),
//       )
//       ..loadRequest(
//           Uri.parse(widget.loadURL),
//           headers: {
//             "Authorization": "Bearer $token",
//             "Cache-Control": "no-cache, no-store, must-revalidate",
//             "Pragma": "no-cache",
//             "Expires": "0",
//           }
//           );
//   }
//
//
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: CustomAppBarWidget(
//         title: Text(
//           widget.label,
//           style: AppTextStyle.getOutfit500(
//             textSize: 28,
//             textColor: AppColors.white,
//           ),
//         ),
//         showLeadingIcon: false,
//         // onLeadingIconClicked: () {
//         //   Get.back();
//         // },
//         actionIcons: [
//           IconButton(onPressed: () async{
//             if(await webViewController.canGoBack()){
//               webViewController.goBack();
//             }else{
//               webViewController.clearCache();
//               await WebViewCookieManager().clearCookies();
//               Get.back();
//             }
//           }, icon: Icon(Icons.arrow_back,color: AppColors.white,)),
//           IconButton(
//               onPressed: () async {
//                 webViewController.reload();
//               },
//               icon: Icon(
//                 Icons.refresh,
//                 color: AppColors.white,
//               ))
//         ],
//       ),
//       body: Stack(
//         children: [
//           SizedBox(height: MediaQuery.sizeOf(context).height,
//
//             child: WebViewWidget(controller: webViewController),
//             // child: InAppWebView(
//             //   initialUrlRequest: URLRequest(
//             //     headers:   {
//             //       "Authorization": "Bearer $token",
//             //       "Cache-Control": "no-cache, no-store, must-revalidate",
//             //       "Pragma": "no-cache",
//             //       "Expires": "0",
//             //     }
//             //   ),
//             //   onWebViewCreated: (controller){},
//             // ),
//           ),
//           Consumer<WebViewProvider>(
//             builder: (context, webViewProvider, child) {
//               return webViewProvider.progress < 100
//                   ? LinearProgressIndicator(
//                 value: webViewProvider.progress / 100.0,
//                 backgroundColor: Colors.grey.shade300,
//                 valueColor: AlwaysStoppedAnimation<Color>(AppColors.primary),
//               )
//                   : SizedBox.shrink();
//             },
//           ),
//         ],
//       ),
//       // body: InAppWebView(
//       //   initialUrlRequest: URLRequest(url: WebUri(widget.loadURL)),
//       //   onWebViewCreated: (controller) {
//       //     inAppWebViewController = controller;
//       //   },
//       //   onLoadStart: (controller,url){
//       //     print("WebView loaded: $url");
//       //   },
//       //   onLoadStop: (controller, url) {
//       //     print("WebView loaded: $url");
//       //   },
//       //   onReceivedError: (controller, request, error) {
//       //     print("WebView Error: ${error.description}");
//       //   },
//       // ),
//     );
//   }
// }
