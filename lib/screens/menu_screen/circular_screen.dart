// ignore_for_file: camel_case_types, non_constant_identifier_names, import_of_legacy_library_into_null_safe

import 'package:colegia_atenea/models/Parent/Parentlogin.dart';
import 'package:colegia_atenea/screens/details_screen/circular_detail_screen.dart';
import 'package:colegia_atenea/services/api_class.dart';
import 'package:colegia_atenea/services/session_mangement.dart';
import 'package:colegia_atenea/utils/app_colors.dart';
import 'package:colegia_atenea/utils/app_images.dart';
import 'package:colegia_atenea/utils/text_style.dart';
import 'package:colegia_atenea/widgets/custom_loader.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

import '../../models/circularlist.dart';

class CircularScreen extends StatefulWidget {
  const CircularScreen({super.key});

  @override
  State<CircularScreen> createState() => _Circular();
}

class _Circular extends State<CircularScreen> {
  List<Datum> list_circular = [];
  List<Datum> tempList = [];
  bool isLoading = true;
  String imagePath = "";

  TextStyle title = const TextStyle(
    fontFamily: "Outfit",
    fontWeight: FontWeight.w400,
    color: AppColors.primary,
    fontSize: 16
  );

  @override
  void initState() {
    super.initState();
    getCircularList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
            titleSpacing: 0,
            elevation: 0,
            backgroundColor: AppColors.primary,
            title: Text(
              "circular".tr,
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
            Column(
              children: [
                Container(
                    height: 90,
                    decoration: const BoxDecoration(
                        borderRadius: BorderRadius.only(
                            bottomLeft: Radius.circular(20),
                            bottomRight: Radius.circular(20)),
                        color: AppColors.primary),
                    child: Padding(
                      padding: const EdgeInsets.only(left: 15, right: 15),
                      child: Row(
                        children: [
                          Expanded(
                            child: Container(
                              height: 50,
                              decoration: BoxDecoration(
                                color: AppColors.white,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: TextField(
                                //controller: search,
                                autofocus: false,
                                decoration: InputDecoration(
                                    prefixIcon: IconButton(
                                      icon: const Icon(
                                        Icons.search,
                                        color: AppColors.searchicon,
                                      ),
                                      onPressed: () {},
                                    ),
                                    hintText: 'searchInList'.tr,
                                    hintStyle: TextStyle(
                                        fontFamily: "Outfit",
                                        fontWeight: FontWeight.w400,
                                        fontSize: 16,
                                        color: AppColors.secondary.withOpacity(0.5)
                                    ),
                                    contentPadding: const EdgeInsets.all(10),
                                    border: InputBorder.none),
                                style: CustomStyle.txtvalue,
                                cursorColor: AppColors.primary,
                                keyboardType: TextInputType.text,
                                textInputAction: TextInputAction.next,
                                onChanged: onSearchTextChanged,
                              ),
                            ),
                          ),
                        ],
                      ),
                    )),
                Expanded(
                    child: isLoading ? const SizedBox.shrink() : tempList.isEmpty ? Center(
                      child: Text('noStudentFound'.tr,style: const TextStyle(
                        fontFamily: "Outfit",
                        fontSize: 20,
                        fontWeight: FontWeight.w400,
                        color: AppColors.secondary
                      ),),
                    ): Padding(
                      padding: const EdgeInsets.all(10),
                      child: ScrollConfiguration(
                        behavior: const ScrollBehavior().copyWith(overscroll: false),
                        child: GridView.builder(
                            itemCount: tempList.length,
                            gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                                mainAxisSpacing: 10.0,
                                crossAxisSpacing: 10.0,
                                crossAxisCount: 2),
                            itemBuilder: (context, index) {
                              Datum data = tempList[index];
                              return GestureDetector(
                                onTap: (){
                                  Navigator.push(context, MaterialPageRoute(builder: (context)=> CircularDetail(data.id)));
                                },
                                child: Container(
                                  height: 200,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                      color: AppColors.primary
                                          .withOpacity(0.06)),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Container(
                                        width: MediaQuery.of(context).size.width,
                                        height: 100,
                                        margin: const EdgeInsets.all(10),
                                        padding: data.image == null ? const EdgeInsets.all(5) : null,
                                        child: data.image == null || data.image!.isEmpty ? Image.asset(AppImages.document,fit: BoxFit.contain,) : AspectRatio(aspectRatio: 16/9, child: Image.network(data.image!,fit: BoxFit.contain,),),
                                      ),
                                      data.title.length > 15 ? Text("${data.title.substring(0,14)}${".."}",style: title,) : Text(data.title,style: title,),
                                      Text(data.date,style: title.copyWith(fontSize: 14),)
                                    ],
                                  ),
                                ),
                              );
                            }),
                      ),
                    ) )
              ],
            ),
            Visibility(
                visible: isLoading,
                child: Container(
                  color: Colors.black.withOpacity(0.5),
                  height: MediaQuery.of(context).size.height,
                  width: MediaQuery.of(context).size.width,
                  child: const Center(
                    child: LoadingLayout(),
                  ),
                ))
          ],
        ));
  }

  void getCircularList() async {
    //this will only accesssible through parent
    Apiclass httpService = Apiclass();
    SessionManagement sessionManagement = SessionManagement();

    Parentlogin parent = await sessionManagement.getModelParent('Parent');
    String ptoken = parent.basicAuthToken;
    dynamic response = await httpService.getCircular(ptoken);
    if (response['status']) {
      Circular circularData = Circular.fromJson(response);
      setState(() {
        list_circular = circularData.data;
        tempList = circularData.data;
        isLoading = false;
      });
    } else {
      setState(() {
        isLoading = false;
      });
    }
  }

  onSearchTextChanged(String text) async {
    if (text.isEmpty) {
      setState(() {
        tempList = list_circular;
      });
      return;
    }
    List<Datum> searchData = [];
    for (var userDetail in list_circular) {
      if (userDetail.title.isCaseInsensitiveContains(text) || userDetail.date.isCaseInsensitiveContains(text)) {
        searchData.add(userDetail);
      }
    }
    setState(() {
      tempList = searchData;
    });
  }
}
