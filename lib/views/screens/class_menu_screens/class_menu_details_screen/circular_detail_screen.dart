import 'package:colegia_atenea/models/login_model.dart';
import 'package:colegia_atenea/models/singlecircular.dart';
import 'package:colegia_atenea/services/api_class.dart';
import 'package:colegia_atenea/services/app_shared_preferences.dart';
import 'package:colegia_atenea/utils/app_colors.dart';
import 'package:colegia_atenea/utils/app_images.dart';
import 'package:colegia_atenea/utils/text_style.dart';
import 'package:colegia_atenea/views/custom_widgets/custom_loader.dart';
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

  String name = "";
  String imagePath = "";
  String description = "";
  String date = "";
  String adjuntoUrl = "";
  String adjuntoNombre = "";
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
              style: CustomStyle.appBarTitle,
            ),
            leading: Container(
              margin: const EdgeInsets.all(10),
              child: GestureDetector(
                onTap: () {
                  Navigator.pop(context);
                },
                child: SvgPicture.asset(
                  AppImages.arrow,
                  colorFilter: const ColorFilter.mode(AppColors.orange, BlendMode.srcIn),
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
                            constraints: BoxConstraints(
                              minHeight: MediaQuery.of(context).size.height,
                            ),
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
                                  Text(name, style: CustomStyle.txtvalue3.copyWith(fontSize: 24)),
                                  const SizedBox(height: 10),
                                  Text(date, style: CustomStyle.textValue),
                                  const SizedBox(height: 30),
                                  imagePath.isEmpty ? const SizedBox(height: 10) :
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(10),
                                    child: AspectRatio(
                                      aspectRatio: 2 / 1,
                                      child: Image.network(imagePath, fit: BoxFit.contain),
                                    ),
                                  ),
                                  const SizedBox(height: 20),
                                  HtmlWidget(description, onTapUrl: (url) async {
                                    bool launchedOrNot = await _launchURL(url);
                                    return launchedOrNot;
                                  }),
                                  if (adjuntoUrl.isNotEmpty) ...[
                                    const SizedBox(height: 20),
                                    const Divider(),
                                    const SizedBox(height: 10),
                                    GestureDetector(
                                      onTap: () => _launchURL(adjuntoUrl),
                                      child: Row(
                                        children: [
                                          const Icon(Icons.attach_file, color: Colors.blue),
                                          const SizedBox(width: 8),
                                          Expanded(
                                            child: Text(
                                              adjuntoNombre.isNotEmpty ? adjuntoNombre : adjuntoUrl,
                                              style: const TextStyle(
                                                color: Colors.blue,
                                                decoration: TextDecoration.underline,
                                                fontSize: 14,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
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
    Userdata? parent = AppSharedPreferences.getUserData();
    String ptoken = AppSharedPreferences.getBasicAthToken() ?? "";
    dynamic singleCircularDetails = await ApiClass().getSingleCircular(
      ptoken,
      widget.cid,
      parent?.cookies ?? ""
    );
    if (singleCircularDetails['status']) {
      Singlecircular circular = Singlecircular.fromJson(singleCircularDetails);
      setState(() {
        list = circular;
        name = list!.data!.title!;
        list!.data!.image == null ? imagePath == "" : imagePath = list!.data!.image!;
        description = list!.data!.description!;
        date = list!.data!.date!;
        adjuntoUrl = list!.data!.adjuntoUrl ?? "";
        adjuntoNombre = list!.data!.adjuntoNombre ?? "";
        isLoading = false;
      });
    } else {
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<bool> _launchURL(String url) async {
    if (await canLaunchUrl(Uri.parse(url))) {
      await launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication);
      return true;
    } else {
      return false;
    }
  }
}