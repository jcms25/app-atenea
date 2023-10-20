import 'package:auto_size_text/auto_size_text.dart';
import 'package:colegia_atenea/models/Evaluationlist.dart';
import 'package:colegia_atenea/models/Evaluationreportmodel.dart';
import 'package:colegia_atenea/models/Parent/Parentlogin.dart';
import 'package:colegia_atenea/models/Student/Studentlogin.dart';
import 'package:colegia_atenea/screens/details_screen/evaluation_report_screen.dart';
import 'package:colegia_atenea/services/api_class.dart';
import 'package:colegia_atenea/services/session_management.dart';
import 'package:colegia_atenea/utils/app_colors.dart';
import 'package:colegia_atenea/utils/app_images.dart';
import 'package:colegia_atenea/utils/text_style.dart';
import 'package:colegia_atenea/widgets/custom_loader.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: '',
      home: evaluationscreen("", ""),
    );
  }
}

class evaluationscreen extends StatefulWidget {
  var cid;
  var wpid;

  evaluationscreen(this.cid, this.wpid, {Key? key}) : super(key: key);

  @override
  TableExample createState() => TableExample();
}

class TableExample extends State<evaluationscreen> {
  List<Datum> Evaluationlist = [];
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
            title: Text(
              "evaluation".tr,
            ),
            leading: Container(
              margin: const EdgeInsets.all(10),
              child: GestureDetector(
                onTap: () {
                  Navigator.pop(context);
                },
                child: SvgPicture.asset(
                  AppImages.arrow,
                  color: AppColors.orange,
                ),
              ),
            )),
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
                      itemCount: Evaluationlist.isEmpty ? 1 : Evaluationlist.length,
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
                                        Evaluationlist.isEmpty
                                            ? " "
                                            : Evaluationlist[position].subject,
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
                                            Evaluationlist.isEmpty
                                                ? " "
                                                : Evaluationlist[position].marks.evaluation1,
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
                                          Evaluationlist.isEmpty
                                              ? " "
                                              : Evaluationlist[position].marks.evaluation2,
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
                                          Evaluationlist.isEmpty
                                              ? " "
                                              : Evaluationlist[position].marks.evaluation3,
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
                                          Evaluationlist.isEmpty
                                              ? " "
                                              : Evaluationlist[position].marks.evaluation4,
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
                                    if (Evaluationlist.isEmpty) {
                                      showAlertDialog(context);
                                    } else {
                                      onclick(1, "1st".tr);
                                    }
                                  },
                                  child: SvgPicture.asset(
                                    AppImages.view,
                                    color: AppColors.white,
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
                                    if (Evaluationlist.isEmpty) {
                                      showAlertDialog(context);
                                    } else {
                                      onclick(2, "2nd".tr);
                                    }
                                  },
                                  child: SvgPicture.asset(
                                    AppImages.view,
                                    color: AppColors.white,
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
                                    if (Evaluationlist.isEmpty) {
                                      showAlertDialog(context);
                                    } else {
                                      onclick(3, "3rd".tr);
                                    }
                                  },
                                  child: SvgPicture.asset(
                                    AppImages.view,
                                    color: AppColors.white,
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
                                    if (Evaluationlist.isEmpty) {
                                      showAlertDialog(context);
                                    } else {
                                      onclick(4, "final".tr);
                                    }
                                  },
                                  child: SvgPicture.asset(
                                    AppImages.view,
                                    color: AppColors.white,
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
    ApiClass httpService = ApiClass();
    SessionManagement sessionManagment = SessionManagement();
    int? Role = await sessionManagment.getRole("Role");
    if (Role == 0) {
      Studentlogin login = await sessionManagment.getModel('Student');
      String token = login.basicAuthToken;
      dynamic country =
          await httpService.getEvaluation(token, widget.wpid, widget.cid);
      if (country['status']) {
        print(country['status']);
        Evaluation evalution = Evaluation.fromJson(country);
        setState(() {
          Evaluationlist = evalution.data;
          isLoading = false;
        });
      } else {
        setState(() {
          isLoading = false;
        });
      }
    } else {
      Parentlogin parent = await sessionManagment.getModelParent('Parent');
      String ptoken = parent.basicAuthToken;
      dynamic? country =
          await httpService.getEvaluation(ptoken, widget.wpid, widget.cid);
      if (country['status']) {
        Evaluation evalution = Evaluation.fromJson(country);
        setState(() {
          Evaluationlist = evalution.data;
          isLoading = false;
        });
      } else {
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  void onclick(int evaluation, String evaluationName) {
    List<Evaluationreport> evolutionReport = [];
    print(evaluation);
    for (int i = 0; i < Evaluationlist.length; i++) {
      String evaluationremark = evaluation == 1
          ? Evaluationlist[i].observation.observation1
          : evaluation == 2
              ? Evaluationlist[i].observation.observation2
              : evaluation == 3
                  ? Evaluationlist[i].observation.observation3
                  : Evaluationlist[i].observation.observation4;
        if(evaluationremark.isEmpty){
          continue;
        }else{
          evolutionReport
              .add(Evaluationreport(Evaluationlist[i].subject, evaluationremark));
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
        primary: AppColors.primary,
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
