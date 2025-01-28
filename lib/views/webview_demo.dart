import 'package:colegia_atenea/controllers/student_parent_teacher_controller.dart';
import 'package:colegia_atenea/utils/app_textstyle.dart';
import 'package:colegia_atenea/views/custom_widgets/custom_app_bar_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../utils/app_colors.dart';

class WebviewDemo extends StatefulWidget {
  const WebviewDemo({super.key});

  @override
  State<WebviewDemo> createState() => _WebviewDemoState();
}

class _WebviewDemoState extends State<WebviewDemo> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBarWidget(
        title: Text(
          'Web View',
          style: AppTextStyle.getOutfit500(
              textSize: 20, textColor: AppColors.white),
        ),
        onLeadingIconClicked: (){
          Get.back();
        },
      ),
      body: Consumer<StudentParentTeacherController>(
        builder : (context,studentParentTeacherController,child){
          Map<String,String> header = {
            "Authorization" : "Bearer ${studentParentTeacherController.userdata?.tiendaToken}"
          };

          return WebViewWidget(
            controller: WebViewController()
              ..setJavaScriptMode(JavaScriptMode.unrestricted)
              ..setNavigationDelegate(
                NavigationDelegate(
                  onProgress: (int progress) {
                    // Update loading bar.
                  },
                  onPageStarted: (String url) {
                  },
                  onPageFinished: (String url) {
                  },
                  onHttpError: (HttpResponseError error) {
                  },
                  onWebResourceError: (WebResourceError error) {
                  },
                  onNavigationRequest: (NavigationRequest request) {
                    return NavigationDecision.navigate;
                  },
                ),
              )
              ..loadRequest(Uri.parse('https://colegioatenea.es/tienda-online'),
                  method: LoadRequestMethod.get,
                  headers: header),

          );
        }
      ),
    );
  }
}
