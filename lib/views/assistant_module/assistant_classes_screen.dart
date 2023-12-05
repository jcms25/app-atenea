import 'package:auto_size_text/auto_size_text.dart';
import 'package:colegia_atenea/models/assistant/assistant_classlist_model.dart';
import 'package:colegia_atenea/views/assistant_module/assistant_children_list_screen.dart';
import 'package:colegia_atenea/services/api_class.dart';
import 'package:colegia_atenea/utils/app_colors.dart';
import 'package:colegia_atenea/utils/text_style.dart';
import 'package:colegia_atenea/widgets/custom_loader.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../models/assistant/assistant_login_model.dart';
import '../../services/session_management.dart';

class ChildScreen extends StatefulWidget {
  const ChildScreen({super.key});


  @override
  State<StatefulWidget> createState() {
    return ChildScreenState();
  }
}

class ChildScreenState extends State<ChildScreen> {
  List<Datum> classList = [];
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    setState(() {
      isLoading = true;
    });
    getClassLisData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: GestureDetector(
          onTap: () {
            Navigator.pop(context);
          },
          child: const Icon(Icons.arrow_back),
        ),
        title: Text('asClassTitle'.tr,
        style: const TextStyle(
          fontFamily: "Outfit",
          fontSize: 18,
          fontWeight: FontWeight.w400,
          color: Colors.white
        ),),
        backgroundColor: AppColors.primary,
        elevation: 0,
      ),
      body:Stack(
        children: [
          isLoading ? const SizedBox.shrink() : classList.isEmpty ? SizedBox(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            child: Center(
              child: Text("noData".tr,style: CustomStyle.textValue,),
            ),
          ) : ListView.builder(
              itemCount: classList.length,
              itemBuilder: (context, index) {
                Datum data = classList[index];
                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => AssistantChildrenScreen(data.cid)));
                  },
                  child: Container(
                    width: MediaQuery.of(context).size.width,
                    height: 100,
                    margin: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                        color: AppColors.primary.withOpacity(0.05),
                        borderRadius: BorderRadius.circular(15)),
                    child: Row(
                      children: [
                        Container(
                          width: 100,
                          height: MediaQuery.of(context).size.height,
                          decoration: BoxDecoration(
                              color: AppColors.primary,
                              borderRadius: BorderRadius.circular(15)),
                          padding: const EdgeInsets.all(5),
                          child: Center(
                            child: AutoSizeText(
                              data.cName.replaceFirst(" ", "\n"),
                              style: const TextStyle(
                                  fontSize: 18,
                                  fontFamily: "Outfit",
                                  fontWeight: FontWeight.w400,
                                  color: AppColors.white
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(
                          width: 20,
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              // AppStrings.ass_classes,
                              'as1'.tr,
                              style: const TextStyle(
                                  fontSize: 20,
                                  fontFamily: "Outfit",
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.primary),
                            ),
                            const SizedBox(
                              height: 5,
                            ),
                            Text(
                              classList[index].cName,
                              style: const TextStyle(
                                  fontSize: 16,
                                  fontFamily: "Outfit",
                                  fontWeight: FontWeight.w400,
                                  color: AppColors.secondary),
                            )
                          ],
                        )
                      ],
                    ),
                  ),
                );
              }),
          Visibility(
              visible: isLoading,
              child: Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            color: Colors.black54,
            child: const Center(
              child: LoadingLayout(),
            ),
          ))
        ],
      ),
    );
  }

  void getClassLisData() async{
    ApiClass apiclass = ApiClass();
    SessionManagement sessionManagement = SessionManagement();
    Assistant assistant = await sessionManagement.getAssistantDetail();
    String token = assistant.basicAuthToken;
    dynamic tempClassList = await apiclass.getAsClassList(token,assistant.userdata.data.cookie ?? "");
    if(tempClassList['status']){
      ClassListModel classListModel = ClassListModel.fromJson(tempClassList);
      setState(() {
        classList = classListModel.data ?? [];
        isLoading = false;
      });
    }else{
      setState(() {
        isLoading = false;
      });
    }
  }
}
