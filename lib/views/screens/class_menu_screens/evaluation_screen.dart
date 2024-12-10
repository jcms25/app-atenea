import 'package:auto_size_text/auto_size_text.dart';
import 'package:colegia_atenea/models/Evaluationlist.dart';
import 'package:colegia_atenea/models/Evaluationreportmodel.dart';
import 'package:colegia_atenea/models/login_model.dart';
import 'package:colegia_atenea/services/app_shared_preferences.dart';
import 'package:colegia_atenea/utils/app_constants.dart';
import 'package:colegia_atenea/views/screens/class_menu_screens/class_menu_details_screen/evaluation_report_screen.dart';
import 'package:colegia_atenea/services/api_class.dart';
import 'package:colegia_atenea/utils/app_colors.dart';
import 'package:colegia_atenea/utils/app_images.dart';
import 'package:colegia_atenea/utils/text_style.dart';
import 'package:colegia_atenea/views/custom_widgets/custom_loader.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';


class EvaluationScreen extends StatefulWidget {
  final String cid;
  final String wpId;
  final String studentName;

  const EvaluationScreen({super.key, required this.studentName,required this.cid,required this.wpId, });

  @override
  TableExample createState() => TableExample();
}

class TableExample extends State<EvaluationScreen> {
  List<Datum> evaluationList = [];
  bool isLoading = true;
  String sub = "";

  @override
  void initState() {
    super.initState();
    getEvaluationList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
            titleSpacing: 0,
            elevation: 0,
            backgroundColor: AppColors.primary,
            title: AutoSizeText(
              "Informe de Evaluación de ${widget.studentName}",
              maxLines: 1,
            ),
            leading: Container(
              margin: const EdgeInsets.all(10),
              child: GestureDetector(
                onTap: () {
                  Get.back();
                },
                child: SvgPicture.asset(
                  AppImages.arrow,
                  colorFilter: const ColorFilter.mode(AppColors.orange, BlendMode.srcIn),
                ),
              ),
            ),
            actions: [
              IconButton(onPressed: () async{
                try{

                }catch(e){
                  AppConstants.showCustomToast(status: false, message: "$e");
                }
              }, icon: const Icon(Icons.download,color: AppColors.white,))
            ],
        ),
        body: Stack(
          children: [
            SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child:  Column(children: <Widget>[
                  Row(
                    children: [
                      Expanded(
                        flex: 3,
                        child: Container(
                            padding: const EdgeInsets.only(left: 10),
                            height: 60,
                            decoration: const BoxDecoration(
                              color: AppColors.primary,
                              border: Border(
                                top: BorderSide(
                                    color: Colors.black,
                                    width: 1,
                                    style: BorderStyle.solid),
                                left: BorderSide(
                                    color: Colors.black,
                                    width: 1,
                                    style: BorderStyle.solid),
                                bottom: BorderSide(
                                    color: Colors.black,
                                    width: 1,
                                    style: BorderStyle.solid),
                              ),
                            ),
                            child: Align(
                              alignment: Alignment.centerLeft,
                              child:
                              Text("subjects".tr, style: CustomStyle.hello),
                            )),
                      ),
                      Expanded(
                        flex: 1,
                        child: Container(
                            height: 60,
                            decoration: const BoxDecoration(
                              color: AppColors.primary,
                              border: Border(
                                top: BorderSide(
                                    color: Colors.black,
                                    width: 1,
                                    style: BorderStyle.solid),
                                left: BorderSide(
                                    color: Colors.black,
                                    width: 1,
                                    style: BorderStyle.solid),
                                bottom: BorderSide(
                                    color: Colors.black,
                                    width: 1,
                                    style: BorderStyle.solid),
                              ),
                            ),
                            child: Center(
                              child: Text("1st".tr, style: CustomStyle.hello),
                            )),
                      ),
                      Expanded(
                        flex: 1,
                        child: Container(
                            height: 60,
                            decoration: const BoxDecoration(
                              color: AppColors.primary,
                              border: Border(
                                top: BorderSide(
                                    color: Colors.black,
                                    width: 1,
                                    style: BorderStyle.solid),
                                left: BorderSide(
                                    color: Colors.black,
                                    width: 1,
                                    style: BorderStyle.solid),
                                bottom: BorderSide(
                                    color: Colors.black,
                                    width: 1,
                                    style: BorderStyle.solid),
                              ),
                            ),
                            child: Center(
                              child: Text("2nd".tr, style: CustomStyle.hello),
                            )),
                      ),
                      Expanded(
                        flex: 1,
                        child: Container(
                            height: 60,
                            decoration: const BoxDecoration(
                              color: AppColors.primary,
                              border: Border(
                                top: BorderSide(
                                    color: Colors.black,
                                    width: 1,
                                    style: BorderStyle.solid),
                                left: BorderSide(
                                    color: Colors.black,
                                    width: 1,
                                    style: BorderStyle.solid),
                                bottom: BorderSide(
                                    color: Colors.black,
                                    width: 1,
                                    style: BorderStyle.solid),
                              ),
                            ),
                            child: Center(
                              child: Text("3rd".tr, style: CustomStyle.hello),
                            )),
                      ),
                      Expanded(
                        flex: 1,
                        child: Container(
                            height: 60,
                            decoration: const BoxDecoration(
                              color: AppColors.primary,
                              border: Border(
                                top: BorderSide(
                                    color: Colors.black,
                                    width: 1,
                                    style: BorderStyle.solid),
                                left: BorderSide(
                                    color: Colors.black,
                                    width: 1,
                                    style: BorderStyle.solid),
                                bottom: BorderSide(
                                    color: Colors.black,
                                    width: 1,
                                    style: BorderStyle.solid),
                              ),
                            ),
                            child: Center(
                              child: Text("final".tr, style: CustomStyle.hello),
                            )),
                      ),
                    ],
                  ),
                  ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: evaluationList.isEmpty ? 1 : evaluationList.length,
                      itemBuilder: (context, position) {
                        return Row(
                          children: [
                            Expanded(
                                flex: 3,
                                child: Container(
                                    padding: const EdgeInsets.only(left: 10),
                                    height: 60,
                                    decoration: const BoxDecoration(
                                      border: Border(
                                        left: BorderSide(
                                            color: Colors.black,
                                            width: 1,
                                            style: BorderStyle.solid),
                                        bottom: BorderSide(
                                            color: Colors.black,
                                            width: 1,
                                            style: BorderStyle.solid),
                                      ),
                                    ),
                                    child: Align(
                                      alignment: Alignment.centerLeft,
                                      child: AutoSizeText(
                                        evaluationList.isEmpty
                                            ? " "
                                            : evaluationList[position].subject,
                                        style: CustomStyle.hello
                                            .copyWith(color: AppColors.secondary),
                                        maxLines: 3,
                                      ),
                                    ))),
                            Expanded(
                                flex: 1,
                                child: Container(
                                    height: 60,
                                    decoration: const BoxDecoration(
                                      border: Border(
                                        left: BorderSide(
                                            color: Colors.black,
                                            width: 1,
                                            style: BorderStyle.solid),
                                        bottom: BorderSide(
                                            color: Colors.black,
                                            width: 1,
                                            style: BorderStyle.solid),
                                      ),
                                    ),
                                    child: Align(
                                      alignment: Alignment.center,
                                      child: Center(
                                        child: Text(
                                            evaluationList.isEmpty
                                                ? " "
                                                : evaluationList[position].marks.evaluation1,
                                            style: CustomStyle.hello.copyWith(
                                                color: AppColors.secondary)),
                                      ),
                                    ))),
                            Expanded(
                                flex: 1,
                                child: Container(
                                    height: 60,
                                    decoration: const BoxDecoration(
                                      border: Border(
                                        left: BorderSide(
                                            color: Colors.black,
                                            width: 1,
                                            style: BorderStyle.solid),
                                        bottom: BorderSide(
                                            color: Colors.black,
                                            width: 1,
                                            style: BorderStyle.solid),
                                      ),
                                    ),
                                    child: Center(
                                      child: Text(
                                          evaluationList.isEmpty
                                              ? " "
                                              : evaluationList[position].marks.evaluation2,
                                          style: CustomStyle.hello.copyWith(
                                              color: AppColors.secondary)),
                                    ))),
                            Expanded(
                                flex: 1,
                                child: Container(
                                    height: 60,
                                    decoration: const BoxDecoration(
                                      border: Border(
                                        left: BorderSide(
                                            color: Colors.black,
                                            width: 1,
                                            style: BorderStyle.solid),
                                        bottom: BorderSide(
                                            color: Colors.black,
                                            width: 1,
                                            style: BorderStyle.solid),
                                      ),
                                    ),
                                    child: Center(
                                      child: Text(
                                          evaluationList.isEmpty
                                              ? " "
                                              : evaluationList[position].marks.evaluation3,
                                          style: CustomStyle.hello.copyWith(
                                              color: AppColors.secondary)),
                                    ))),
                            Expanded(
                                flex: 1,
                                child: Container(
                                    height: 60,
                                    decoration: const BoxDecoration(
                                      border: Border(
                                        left: BorderSide(
                                            color: Colors.black,
                                            width: 1,
                                            style: BorderStyle.solid),
                                        right: BorderSide(
                                            color: Colors.black,
                                            width: 1,
                                            style: BorderStyle.solid),
                                        bottom: BorderSide(
                                            color: Colors.black,
                                            width: 1,
                                            style: BorderStyle.solid),
                                      ),
                                    ),
                                    child: Center(
                                      child: Text(
                                          evaluationList.isEmpty
                                              ? " "
                                              : evaluationList[position].marks.evaluation4,
                                          style: CustomStyle.hello.copyWith(
                                              color: AppColors.secondary)),
                                    ))),
                          ],
                        );
                      }),
                  Row(
                    children: [
                      Expanded(
                        flex: 3,
                        child: Container(
                            padding: const EdgeInsets.only(left: 10),
                            height: 60,
                            decoration: const BoxDecoration(
                              color: AppColors.primary,
                              border: Border(
                                //top: BorderSide(color: Colors.black, width: 2, style: BorderStyle.solid),
                                left: BorderSide(
                                    color: Colors.black,
                                    width: 1,
                                    style: BorderStyle.solid),

                                bottom: BorderSide(
                                    color: Colors.black,
                                    width: 1,
                                    style: BorderStyle.solid),
                              ),
                            ),
                            child: Align(
                              alignment: Alignment.centerLeft,
                              child: Text("obser".tr, style: CustomStyle.hello),
                            )),
                      ),
                      Expanded(
                        flex: 1,
                        child: Container(
                            height: 60,
                            decoration: const BoxDecoration(
                              color: AppColors.primary,
                              border: Border(
                                //top: BorderSide(color: Colors.black, width: 2, style: BorderStyle.solid),
                                left: BorderSide(
                                    color: Colors.black,
                                    width: 1,
                                    style: BorderStyle.solid),
                                bottom: BorderSide(
                                    color: Colors.black,
                                    width: 1,
                                    style: BorderStyle.solid),
                              ),
                            ),
                            child: Center(
                                child: GestureDetector(
                                  onTap: () {
                                    if (evaluationList.isEmpty) {
                                      showAlertDialog(context);
                                    } else {
                                      onclick(1, "1st".tr);
                                    }
                                  },
                                  child: SvgPicture.asset(
                                    AppImages.view,
                                    colorFilter: const ColorFilter.mode(AppColors.white, BlendMode.srcIn),
                                  ),
                                ))),
                      ),
                      Expanded(
                        flex: 1,
                        child: Container(
                            height: 60,
                            decoration: const BoxDecoration(
                              color: AppColors.primary,
                              border: Border(
                                //top: BorderSide(color: Colors.black, width: 2, style: BorderStyle.solid),
                                left: BorderSide(
                                    color: Colors.black,
                                    width: 1,
                                    style: BorderStyle.solid),
                                bottom: BorderSide(
                                    color: Colors.black,
                                    width: 1,
                                    style: BorderStyle.solid),
                              ),
                            ),
                            child: Center(
                                child: GestureDetector(
                                  onTap: () {
                                    if (evaluationList.isEmpty) {
                                      showAlertDialog(context);
                                    } else {
                                      onclick(2, "2nd".tr);
                                    }
                                  },
                                  child: SvgPicture.asset(
                                    AppImages.view,
                                    colorFilter: const ColorFilter.mode(AppColors.white, BlendMode.srcIn),
                                  ),
                                ))),
                      ),
                      Expanded(
                        flex: 1,
                        child: Container(
                            height: 60,
                            decoration: const BoxDecoration(
                              color: AppColors.primary,
                              border: Border(
                                // top: BorderSide(color: Colors.black, width: 2, style: BorderStyle.solid),
                                left: BorderSide(
                                    color: Colors.black,
                                    width: 1,
                                    style: BorderStyle.solid),
                                bottom: BorderSide(
                                    color: Colors.black,
                                    width: 1,
                                    style: BorderStyle.solid),
                              ),
                            ),
                            child: Center(
                                child: GestureDetector(
                                  onTap: () {
                                    if (evaluationList.isEmpty) {
                                      showAlertDialog(context);
                                    } else {
                                      onclick(3, "3rd".tr);
                                    }
                                  },
                                  child: SvgPicture.asset(
                                    AppImages.view,
                                    colorFilter: const ColorFilter.mode(AppColors.white, BlendMode.srcIn),
                                  ),
                                ))),
                      ),
                      Expanded(
                        flex: 1,
                        child: Container(
                            height: 60,
                            decoration: const BoxDecoration(
                              color: AppColors.primary,
                              border: Border(
                                //top: BorderSide(color: Colors.black, width: 2, style: BorderStyle.solid),
                                left: BorderSide(
                                    color: Colors.black,
                                    width: 1,
                                    style: BorderStyle.solid),
                                bottom: BorderSide(
                                    color: Colors.black,
                                    width: 1,
                                    style: BorderStyle.solid),
                                right: BorderSide(
                                    color: Colors.black,
                                    width: 1,
                                    style: BorderStyle.solid),
                              ),
                            ),
                            child: Center(
                                child: GestureDetector(
                                  onTap: () {
                                    if (evaluationList.isEmpty) {
                                      showAlertDialog(context);
                                    } else {
                                      onclick(4, "final".tr);
                                    }
                                  },
                                  child: SvgPicture.asset(
                                    AppImages.view,
                                    colorFilter: const ColorFilter.mode(AppColors.white, BlendMode.srcIn),
                                  ),
                                ))),
                      ),
                    ],
                  ),
                ]),
              ),
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

  void getEvaluationList() async {


    try{
      LoginModel? loginModel = AppSharedPreferences.getUserData();
      dynamic response = await ApiClass().getEvaluation(loginModel?.basicAuthToken ?? "", widget.wpId, widget.cid, loginModel?.userdata?.cookies ?? "");
      if (response['status']) {
        Evaluation evaluation = Evaluation.fromJson(response);
        setState(() {
          evaluationList = evaluation.data;
          isLoading = false;
        });
      }
      else {
        setState(() {
          isLoading = false;
        });
      }

    }catch(exception){
        setState(() {
          isLoading = false;
        });
    }

    // ApiClass httpService = ApiClass();
    // SessionManagement sessionManagement = SessionManagement();
    // int? role = await sessionManagement.getRole("Role");
    // if (role == 0) {
    //   Studentlogin login = await sessionManagement.getModel('Student');
    //   String token = login.basicAuthToken;
    //   dynamic country =
    //       await httpService.getEvaluation(token, widget.wpid, widget.cid,login.userdata.cookie ?? "");
    //   if (country['status']) {
    //     Evaluation evaluation = Evaluation.fromJson(country);
    //     setState(() {
    //       evaluationList = evaluation.data;
    //       isLoading = false;
    //     });
    //   }
    //   else {
    //     setState(() {
    //       isLoading = false;
    //     });
    //   }
    // }
    //
    // else {
    //   Parentlogin parent = await sessionManagement.getModelParent('Parent');
    //   String ptoken = parent.basicAuthToken;
    //   dynamic country =
    //       await httpService.getEvaluation(ptoken, widget.wpid, widget.cid,parent.userdata.cookie ?? "");
    //   if (country['status']) {
    //     Evaluation evaluation = Evaluation.fromJson(country);
    //     setState(() {
    //       evaluationList = evaluation.data;
    //       isLoading = false;
    //     });
    //   }
    //   else {
    //     setState(() {
    //       isLoading = false;
    //     });
    //   }
    // }
  }

  void onclick(int evaluation, String evaluationName) {
    List<Evaluationreport> evolutionReport = [];
    for (int i = 0; i < evaluationList.length; i++) {
      String evaluationRemark = evaluation == 1
          ? evaluationList[i].observation.observation1
          : evaluation == 2
              ? evaluationList[i].observation.observation2
              : evaluation == 3
                  ? evaluationList[i].observation.observation3
                  : evaluationList[i].observation.observation4;
        if(evaluationRemark.isEmpty){
          continue;
        }else{
          evolutionReport
              .add(Evaluationreport(evaluationList[i].subject, evaluationRemark));
        }
          }
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) =>
                EvaluationReportScreen(evolutionReport, evaluationName)));
  }
}

showAlertDialog(BuildContext context) {
  // Create button
  Widget okButton = ElevatedButton(
    style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.primary,
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(12)))),
    child: Text(
      "OK",
      style: CustomStyle.txtvalue2,
    ),
    onPressed: () {
      Navigator.of(context, rootNavigator: true).pop();
    },
  );

  // Create AlertDialog
  AlertDialog alert = AlertDialog(
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(30),
    ),

    //title:
    content: const Text("NO HAY OBSERVACIONES PARA ESTA EVALUACIÓN"),
    actions: [
      okButton,
    ],
  );

  // show the dialog
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return alert;
    },
  );
}
