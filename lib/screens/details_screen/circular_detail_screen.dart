import 'package:cached_network_image/cached_network_image.dart';
import 'package:colegia_atenea/models/Parent/Parentlogin.dart';
import 'package:colegia_atenea/models/Student/Studentlogin.dart';
import 'package:colegia_atenea/models/singlecircular.dart';
import 'package:colegia_atenea/screens/nav_screens/navigation_screen.dart';
import 'package:colegia_atenea/services/api_class.dart';
import 'package:colegia_atenea/services/session_mangement.dart';
import 'package:colegia_atenea/utils/app_colors.dart';
import 'package:colegia_atenea/utils/app_images.dart';
import 'package:colegia_atenea/utils/text_style.dart';
import 'package:colegia_atenea/widgets/custom_loader.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';

class CircularDetail extends StatefulWidget {
  final String cid;

  const CircularDetail(this.cid, {super.key});

  @override
  State<CircularDetail> createState() => CircularData();
}

class CircularData extends State<CircularDetail> {
  Singlecircular? list;

  String Name = "";
  String imagepath = "";
  String Description = "";
  String Date = "";
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    isLoading = true;
    callAPI();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            titleSpacing: 0,
            elevation: 0,
            backgroundColor: AppColors.primary,
            title: Text(
              "circulardetail".tr,
              style: CustomStyle.appbartitle,
            ),
            leading: Container(
              margin: const EdgeInsets.all(10),
              child: GestureDetector(
                onTap: () {
                  Navigator.pop(context);
                },
                child: SvgPicture.asset(
                  AppImages.Arrow,
                  color: AppColors.orange,
                ),
              ),
            )),
        body: Stack(
          children: [
            Container(
              color: AppColors.primary,
              child: SafeArea(
                child: Stack(
                  children: [
                    Column(
                      children: [
                        Expanded(
                          child: Container(
                            color: AppColors.primary,
                          ),
                        ),
                        Expanded(
                          child: Container(
                            color: AppColors.white,
                          ),
                        )
                      ],
                    ),
                    SingleChildScrollView(
                      physics: const BouncingScrollPhysics(),
                      child: Stack(
                        children: [
                          Container(
                            width: MediaQuery.of(context).size.width,
                            height: MediaQuery.of(context).size.height,
                            margin: const EdgeInsets.only(top: 50, bottom: 30),
                            decoration: const BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.only(
                                    topRight: Radius.circular(30),
                                    topLeft: Radius.circular(30))),
                            child: Padding(
                              padding: const EdgeInsets.all(10),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(Name,style: CustomStyle.txtvalue3.copyWith(fontSize: 24),),
                                  const SizedBox(height: 10,),
                                  Text(Date,style: CustomStyle.txtvalue,),
                                  const SizedBox(height: 30,),
                                  imagepath.isEmpty ? SizedBox(
                                    height: 200,
                                    width: MediaQuery.of(context).size.width,) :
                                  SizedBox(
                                    height: 200,
                                    width: MediaQuery.of(context).size.width,
                                  //   decoration: BoxDecoration(
                                  //   // image: DecorationImage(
                                  //   //   image: NetworkImage(imagepath),
                                  //   //   fit: BoxFit.fill
                                  //   // )
                                  // ),
                                    child: AspectRatio(aspectRatio: 16/9, child: Image.network(imagepath,fit: BoxFit.contain,),),
                                  ),
                                  const SizedBox(height: 20,),
                                  HtmlWidget(Description,onTapUrl: (url) async{
                                    bool launchedOrNot =  await _launchURL(url);
                                    return launchedOrNot;
                                  },)
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Visibility(
                visible: isLoading,
                child: Container(
                  color: Colors.black45,
                  height: MediaQuery.of(context).size.height,
                  width: MediaQuery.of(context).size.width,
                  child: const Center(
                    child: LoadingLayout(),
                  ),
                )),

          ],
        ));
  }

  void callAPI() async {
    Apiclass httpService = Apiclass();
    SessionManagement sessionManagment = SessionManagement();

    Parentlogin parent = await sessionManagment.getModelParent('Parent');
    String ptoken = parent.basicAuthToken;
    dynamic singleCircularDetails = await httpService.getSingleCircular(
      ptoken,
      widget.cid,
    );
    if (singleCircularDetails['status']) {
      Singlecircular circular = Singlecircular.fromJson(singleCircularDetails);
      setState(() {
        list = circular;
        Name = list!.data!.title!;
        list!.data!.image == null ? imagepath == "" : imagepath = list!.data!.image!;
        Description = list!.data!.description!;
        Date = list!.data!.date!;
        isLoading = false;
      });
    }else{
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<bool> _launchURL(String url) async {
    if (await canLaunchUrl(Uri.parse(url))) {
      await launchUrl(Uri.parse(url),mode: LaunchMode.externalApplication);
      return true;
    } else {
      return false;
    }
  }
}
