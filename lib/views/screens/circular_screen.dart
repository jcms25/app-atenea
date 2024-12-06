import 'package:colegia_atenea/models/Parent/Parentlogin.dart';
import 'package:colegia_atenea/models/login_model.dart';
import 'package:colegia_atenea/services/app_shared_preferences.dart';
import 'package:colegia_atenea/utils/app_textstyle.dart';
import 'package:colegia_atenea/views/custom_widgets/custom_app_bar_widget.dart';
import 'package:colegia_atenea/views/screens/class_menu_screens/class_menu_details_screen/circular_detail_screen.dart';
import 'package:colegia_atenea/services/api_class.dart';
import 'package:colegia_atenea/services/session_management.dart';
import 'package:colegia_atenea/utils/app_colors.dart';
import 'package:colegia_atenea/utils/app_images.dart';
import 'package:colegia_atenea/utils/text_style.dart';
import 'package:colegia_atenea/views/custom_widgets/custom_loader.dart';
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
  List<Datum> listOfCircular = [];
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
                                        color: AppColors.searchIcon,
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
                                style: CustomStyle.textValue,
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
    try{

      LoginModel? loginModel = AppSharedPreferences.getUserData();
      dynamic response = await ApiClass().getCircular(loginModel?.basicAuthToken ?? "",loginModel?.userdata?.cookies ?? "");
      if (response['status']) {
        Circular circularData = Circular.fromJson(response);
        setState(() {
          listOfCircular = circularData.data;
          tempList = circularData.data;
          isLoading = false;
        });
      }

      else {
        setState(() {
          isLoading = false;
        });
      }

      // ApiClass httpService = ApiClass();
      // SessionManagement sessionManagement = SessionManagement();
      //
      // Parentlogin parent = await sessionManagement.getModelParent('Parent');
      // String ptoken = parent.basicAuthToken;
      // dynamic response = await httpService.getCircular(ptoken,parent.userdata.cookie ?? "");
      // if (response['status']) {
      //   Circular circularData = Circular.fromJson(response);
      //   setState(() {
      //     listOfCircular = circularData.data;
      //     tempList = circularData.data;
      //     isLoading = false;
      //   });
      // }
      //
      // else {
      //   setState(() {
      //     isLoading = false;
      //   });
      // }
    }catch(e){
      setState(() {
        isLoading = false;
      });
    }
  }

  onSearchTextChanged(String text) async {
    if (text.isEmpty) {
      setState(() {
        tempList = listOfCircular;
      });
      return;
    }
    List<Datum> searchData = [];
    for (var userDetail in listOfCircular) {
      if (userDetail.title.isCaseInsensitiveContains(text) || userDetail.date.isCaseInsensitiveContains(text)) {
        searchData.add(userDetail);
      }
    }
    setState(() {
      tempList = searchData;
    });
  }
}
