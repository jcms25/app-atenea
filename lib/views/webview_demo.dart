import 'package:colegia_atenea/controllers/student_parent_teacher_controller.dart';
import 'package:colegia_atenea/utils/app_textstyle.dart';
import 'package:colegia_atenea/views/custom_widgets/custom_app_bar_widget.dart';
import 'package:colegia_atenea/views/custom_widgets/custom_loader.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:webview_flutter/webview_flutter.dart';


import '../utils/app_colors.dart';

class WebView extends StatefulWidget {
  final String label;
  final String loadURL;
  const WebView({super.key, required this.loadURL, required this.label});

  @override
  State<WebView> createState() => _WebViewState();
}

class _WebViewState extends State<WebView> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBarWidget(
        title: Text(
          widget.label,
          style: AppTextStyle.getOutfit500(
              textSize: 20, textColor: AppColors.white),
        ),
        onLeadingIconClicked: (){
          Get.back();
        },
      ),
      body: Stack(
        children: [
          Consumer<StudentParentTeacherController>(
              builder : (context,studentParentTeacherController,child){
                Map<String,String> header = {
                  "Authorization" : "Bearer ${studentParentTeacherController.userdata?.tiendaToken}"
                };

                // return InAppWebView(
                //
                //   onLoadStart: (ter,ctx){
                //
                //   },
                //   onLoadStop: (ter,ctx){
                //
                //   },
                //   onCloseWindow: (inApp){
                //     closeInAppWebView();
                //   },
                //   initialUrlRequest: URLRequest(
                //     url: WebUri(widget.loadURL),
                //     headers: header,
                //     method: 'GET'
                //   ),
                //
                // );
                
                
                return WebViewWidget(
              controller: WebViewController()
                  ..setJavaScriptMode(JavaScriptMode.unrestricted)
                  ..loadRequest(Uri.parse(widget.loadURL),headers: header),


                );

                // return Container();

              }
          ),
          Consumer<StudentParentTeacherController>(
              builder : (context,studentParentTeacherController,child){
                return Visibility(
                    visible: studentParentTeacherController.isLoading,
                    child: LoadingLayout());


              }
          ),

        ],
      ),
    );
  }
}
