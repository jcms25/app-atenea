import 'package:colegia_atenea/services/app_shared_preferences.dart';
import 'package:colegia_atenea/utils/app_textstyle.dart';
import 'package:colegia_atenea/views/custom_widgets/custom_app_bar_widget.dart';
import 'package:colegia_atenea/views/screens/webview_screen/webview_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../utils/app_colors.dart';

class WebViewScreen extends StatefulWidget {
  final String label;
  final String loadURL;

  const WebViewScreen({super.key, required this.loadURL, required this.label});

  @override
  State<WebViewScreen> createState() => _WebViewScreenState();
}

class _WebViewScreenState extends State<WebViewScreen> {
  // late WebViewController webViewController;
  late WebViewProvider webViewProvider;
  InAppWebViewController? inAppWebViewController;
  String? token;


  String? previousUrl;


  Future<void> setWooCommerceSessionCookie() async {
    await CookieManager.instance().setCookie(
      url: WebUri.uri(Uri.parse(widget.loadURL)), // Your WooCommerce domain
      name: "wp_woocommerce_session_61445afb8ff4b73feb642dafdd90e08b",         // 👈 REPLACE with your actual cookie name
      value: "2701%7C%7C1744783989%7C%7C1744780389%7C%7Cd6134e51996d19d0740ba5f6b5a86a07",                         // 👈 REPLACE with actual session value
      domain: "colegioatenea.es",
      path: "/",
      isSecure: true,
    );

    // Delay a bit to ensure cookie is set before loading page
    Future.delayed(const Duration(milliseconds: 300), () {
      inAppWebViewController?.loadUrl(
        urlRequest: URLRequest(url:  WebUri.uri(Uri.parse(widget.loadURL))),
      );
    });
  }

  @override
  void initState() {
    super.initState();
    token = AppSharedPreferences.getUserData()?.tiendaToken ?? "";
    webViewProvider = Provider.of<WebViewProvider>(context, listen: false);

    //web view for opening payment link
    _prepareWebView();

    // webViewController = WebViewController()
    //   ..setJavaScriptMode(JavaScriptMode.unrestricted)
    //   ..setNavigationDelegate(
    //     NavigationDelegate(
    //       onNavigationRequest: (NavigationRequest request) {
    //         webViewController.loadRequest(
    //           Uri.parse(request.url),
    //           headers: {
    //             "Authorization": "Bearer $token",
    //             "Cache-Control": "no-cache, no-store, must-revalidate",
    //             "Pragma": "no-cache",
    //             "Expires": "0",
    //           },
    //         );
    //         return NavigationDecision.prevent;
    //       },
    //       onPageStarted: (String url) {
    //         webViewProvider.updateProgress(0);
    //       },
    //       onPageFinished: (String url){
    //         webViewProvider.updateProgress(100);
    //
    //       },
    //       onProgress: (progress){
    //           webViewProvider.updateProgress(progress);
    //       },
    //       onHttpError: (httpResponseError){
    //         if (kDebugMode) {
    //           print(httpResponseError);
    //         }
    //       },
    //       onWebResourceError: (webRequestError){
    //         if (kDebugMode) {
    //           print(webRequestError);
    //         }
    //   }
    //     ),
    //   )
    //   ..loadRequest(
    //       Uri.parse(widget.loadURL),
    //       headers: {
    //         "Authorization": "Bearer $token",
    //         "Cache-Control": "no-cache, no-store, must-revalidate",
    //         "Pragma": "no-cache",
    //         "Expires": "0",
    //       }
    //       );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBarWidget(
        title: Text(
          widget.label,
          style: AppTextStyle.getOutfit500(
            textSize: 28,
            textColor: AppColors.white,
          ),
        ),
        showLeadingIcon: false,
        // onLeadingIconClicked: () {
        //   Get.back();
        // },
        actionIcons: [
          IconButton(
              onPressed: () async {
                // if(await webViewController.canGoBack()){
                //   webViewController.goBack();
                // }
                // else{
                //   webViewController.clearCache();
                //   await WebViewCookieManager().clearCookies();
                //   Get.back();
                // }

                Get.back();
              },
              icon: Icon(
                Icons.arrow_back,
                color: AppColors.white,
              )),
          IconButton(
              onPressed: () async {
                inAppWebViewController?.reload();
              },
              icon: Icon(
                Icons.refresh,
                color: AppColors.white,
              ))
        ],
      ),
      body: Stack(
        children: [
          SizedBox(
            height: MediaQuery.sizeOf(context).height,
            child:
            // InAppWebView(
            //   initialUrlRequest: URLRequest(
            //     url: WebUri.uri(Uri.parse(widget.loadURL)),
            //     headers: {
            //       "Authorization" : "Bearer $token"
            //     }
            //   ),
            //   initialSettings: InAppWebViewSettings(
            //     javaScriptEnabled: true,
            //     useShouldOverrideUrlLoading: true,
            //     mediaPlaybackRequiresUserGesture: false,
            //     allowsInlineMediaPlayback: true,
            //   ),
            //   onWebViewCreated: (webController) {
            //     inAppWebViewController = webController;
            //   },
            //   shouldOverrideUrlLoading: (controller, navigationAction) async {
            //     final uri = navigationAction.request.url!;
            //     if (uri.scheme.startsWith("http")) {
            //       return NavigationActionPolicy.ALLOW;
            //     } else {
            //       // Handle external links or custom schemes (e.g., intent://, upi://, etc.)
            //       return NavigationActionPolicy.CANCEL;
            //     }
            //   },
            //   onReceivedError: (controller,request,error){
            //     print(error);
            //   },
            //   onReceivedHttpError: (controller, request, error) {
            //       print(error);
            //   },
            // )

            InAppWebView(
              initialUrlRequest: URLRequest(
                url: WebUri.uri(Uri.parse(widget.loadURL),),
                headers: {
                  "Authorization" : "Bearer $token"
                }
              ),
              initialSettings: InAppWebViewSettings(
                javaScriptEnabled: true,
                allowsInlineMediaPlayback: true,
                allowsBackForwardNavigationGestures: true,
                useShouldOverrideUrlLoading: true,
                mediaPlaybackRequiresUserGesture: false,
                sharedCookiesEnabled: true,
                thirdPartyCookiesEnabled: true,
                cacheEnabled: true,
                clearSessionCache: false
              ),
              onWebViewCreated: (controller) {
                inAppWebViewController = controller;
              },
              shouldOverrideUrlLoading: (controller, navigationAction) async {
                final uri = navigationAction.request.url!;

                // Handle non-http(s) schemes like intent://, tel:, mailto:
                if (!["http", "https"].contains(uri.scheme)) {
                  if (await canLaunchUrl(uri)) {
                    await launchUrl(uri);
                    return NavigationActionPolicy.CANCEL;
                  }
                }

                return NavigationActionPolicy.ALLOW;
              },
              onReceivedServerTrustAuthRequest: (controller, challenge) async {
                // Auto trust SSL certificates (not recommended for production if unsure)
                return ServerTrustAuthResponse(
                  action: ServerTrustAuthResponseAction.PROCEED,
                );
              },
              onLoadStop: (controller, url) async {
                debugPrint("Loaded URL: $url");
              },
              onReceivedError: (controller,request,error){
                  debugPrint("Error While Loading : $error");
              },
              onConsoleMessage: (controller, consoleMessage) {
                debugPrint("Console: ${consoleMessage.message}");
              },
            )


            // child: WebViewWidget(controller: webViewController),
//             child: InAppWebView(
//               // initialUrlRequest: URLRequest(
//               //   url: WebUri.uri(Uri.parse(widget.loadURL)),
//               //   headers: {
//               //     "Authorization": "Bearer $token",
//               //     "Cache-Control": "no-cache, no-store, must-revalidate",
//               //     "Pragma": "no-cache",
//               //     "Expires": "0",
//               //   },
//               // ),
//                       initialUrlRequest: URLRequest(
//     url: WebUri("https://flutter.dev"),
// ),
//               onWebViewCreated: (controller) {
//                 print(token);
//                 inAppWebViewController = controller;
//               },
//               shouldOverrideUrlLoading: (controller, navigationAction) async {
//                 final uri = navigationAction.request.url;

//                 // For external URLs or resources you don’t want to intercept
//                 if (uri == null || !uri.isScheme("http") && !uri.isScheme("https")) {
//                   return NavigationActionPolicy.ALLOW;
//                 }

//                 await controller.loadUrl(
//                   urlRequest: URLRequest(
//                     url: uri,
//                     headers: {
//                       "Authorization": "Bearer $token",
//                       "Cache-Control": "no-cache, no-store, must-revalidate",
//                       "Pragma": "no-cache",
//                       "Expires": "0",
//                     },
//                   ),
//                 );

//                 return NavigationActionPolicy.CANCEL; // Cancel the original request
//               },

//             )
//             ,

            // child: InAppWebView(
            //   initialUrlRequest: URLRequest(
            //       // url: Uri.parse("https://flutter.dev").toWebUri(),
            //       url: WebUri.uri(Uri.parse("https://flutter.dev"))),
            //   onWebViewCreated: (controller) {
            //     print("WebView created");
            //     inAppWebViewController = controller;
            //   },
            //   onLoadStop: (controller, url) {
            //     print("WebView finished loading: $url");
            //   },
            //   onReceivedError: (controller, request, error) {
            //     print("WebView error: ${error.description}");
            //   },
            // ),
          ),
          Consumer<WebViewProvider>(
            builder: (context, webViewProvider, child) {
              return webViewProvider.progress < 100
                  ? LinearProgressIndicator(
                      value: webViewProvider.progress / 100.0,
                      backgroundColor: Colors.grey.shade300,
                      valueColor:
                          AlwaysStoppedAnimation<Color>(AppColors.primary),
                    )
                  : SizedBox.shrink();
            },
          ),
        ],
      ),
      // body: InAppWebView(
      //   initialUrlRequest: URLRequest(url: WebUri(widget.loadURL)),
      //   onWebViewCreated: (controller) {
      //     inAppWebViewController = controller;
      //   },
      //   onLoadStart: (controller,url){
      //     print("WebView loaded: $url");
      //   },
      //   onLoadStop: (controller, url) {
      //     print("WebView loaded: $url");
      //   },
      //   onReceivedError: (controller, request, error) {
      //     print("WebView Error: ${error.description}");
      //   },
      // ),
    );
  }

  Future<void> _prepareWebView() async {
    final cookieManager = CookieManager.instance();

    await cookieManager
        .deleteAllCookies(); // Delete cookies (important for iOS)
    await InAppWebViewController.clearAllCache(); // Clear WebView cache


  }
}

// class _WebViewScreenState extends State<WebViewScreen> {
//   InAppWebViewController? inAppWebViewController;
//   late WebViewProvider webViewProvider;
//   String? token;
//
//   @override
//   void initState() {
//     super.initState();
//     webViewProvider = Provider.of<WebViewProvider>(context, listen: false);
//     token = AppSharedPreferences.getUserData()?.tiendaToken ?? "";
//   }
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
//         actionIcons: [
//           IconButton(
//             onPressed: () => Get.back(),
//             icon: Icon(Icons.arrow_back, color: AppColors.white),
//           ),
//           IconButton(
//             onPressed: () => inAppWebViewController?.reload(),
//             icon: Icon(Icons.refresh, color: AppColors.white),
//           ),
//         ],
//       ),
//       body: token == null || token!.isEmpty
//           ? Center(child: CircularProgressIndicator())
//           : Stack(
//         children: [
//           SizedBox(
//             height: MediaQuery.sizeOf(context).height,
//             child: InAppWebView(
//               initialUrlRequest: URLRequest(
//                 url: WebUri.uri(Uri.parse(widget.loadURL)),
//                 headers: {
//                   "Authorization": "Bearer $token",
//                   "Cache-Control": "no-cache, no-store, must-revalidate",
//                   "Pragma": "no-cache",
//                   "Expires": "0",
//                 },
//               ),
//               onWebViewCreated: (controller) {
//                 inAppWebViewController = controller;
//               },
//               onLoadStop: (controller, url) async {
//                 // Inject JS to override fetch and add token to headers
//                 await controller.evaluateJavascript(source: '''
//                         window.jwtToken = "$token";
//                         (function() {
//                           const origFetch = window.fetch;
//                           window.fetch = function() {
//                             arguments[1] = arguments[1] || {};
//                             arguments[1].headers = arguments[1].headers || {};
//                             arguments[1].headers["Authorization"] = "Bearer $token";
//                             return origFetch.apply(this, arguments);
//                           };
//
//                           const origXHROpen = XMLHttpRequest.prototype.open;
//                           XMLHttpRequest.prototype.open = function() {
//                             this.setRequestHeader("Authorization", "Bearer $token");
//                             origXHROpen.apply(this, arguments);
//                           };
//                         })();
//                       ''');
//               },
//               shouldOverrideUrlLoading: (controller, navigationAction) async {
//                 final uri = navigationAction.request.url;
//
//                 if (uri == null) return NavigationActionPolicy.CANCEL;
//                 if (!["http", "https"].contains(uri.scheme)) {
//                   return NavigationActionPolicy.ALLOW;
//                 }
//
//                 await controller.loadUrl(
//                   urlRequest: URLRequest(
//                     url: uri,
//                     headers: {
//                       "Authorization": "Bearer $token",
//                       "Cache-Control": "no-cache, no-store, must-revalidate",
//                       "Pragma": "no-cache",
//                       "Expires": "0",
//                     },
//                   ),
//                 );
//                 return NavigationActionPolicy.CANCEL;
//               },
//               onProgressChanged: (controller, progress) {
//                 webViewProvider.updateProgress(progress);
//               },
//             ),
//           ),
//           Consumer<WebViewProvider>(
//             builder: (context, provider, child) {
//               return provider.progress < 100
//                   ? LinearProgressIndicator(
//                 value: provider.progress / 100.0,
//                 backgroundColor: Colors.grey.shade300,
//                 valueColor: AlwaysStoppedAnimation<Color>(AppColors.primary),
//               )
//                   : SizedBox.shrink();
//             },
//           ),
//         ],
//       ),
//     );
//   }
// }

// import 'package:flutter/material.dart';
// import 'package:flutter_inappwebview/flutter_inappwebview.dart';
//
// class WebViewScreen extends StatefulWidget {
//   final String url;
//
//   const WebViewScreen({super.key, required this.url});
//
//   @override
//   State<WebViewScreen> createState() => _WebViewScreenState();
// }
//
// class _WebViewScreenState extends State<WebViewScreen> {
//   InAppWebViewController? webViewController;
//
//   @override
//   void initState() {
//     super.initState();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text("WebView Screen"),
//         backgroundColor: Colors.blue,
//       ),
//       body: InAppWebView(
//         initialUrlRequest: URLRequest(
//           url: WebUri.uri(Uri.parse(widget.url)),
//         ),
//         // initialOptions: InAppWebViewOptions(
//         //   javaScriptEnabled: true,
//         //   mediaPlaybackRequiresUserGesture: false,
//         // ),
//         // androidOptions: AndroidInAppWebViewOptions(
//         //   useHybridComposition: true,
//         // ),
//         // iosOptions: IOSInAppWebViewOptions(
//         //   allowsInlineMediaPlayback: true,
//         // ),
//         onWebViewCreated: (controller) {
//           webViewController = controller;
//         },
//         onLoadStart: (controller, url) {
//           debugPrint("Started loading: $url");
//         },
//         onLoadStop: (controller, url) async {
//           debugPrint("Finished loading: $url");
//         },
//         onReceivedError: (controller, request, error) {
//           // debugPrint("ERROR: ${error.description} (${error.code})");
//         },
//         onConsoleMessage: (controller, consoleMessage) {
//           debugPrint("Console: ${consoleMessage.message}");
//         },
//       ),
//     );
//   }
// }
