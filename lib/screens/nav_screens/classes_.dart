import 'package:colegia_atenea/models/Model.dart';
import 'package:colegia_atenea/models/Parent/Parentlogin.dart';
import 'package:colegia_atenea/models/Student/Studentlogin.dart';
import 'package:colegia_atenea/screens/nav_screens/classmenu_screen.dart';
import 'package:colegia_atenea/services/session_mangement.dart';
import 'package:colegia_atenea/utils/app_colors.dart';
import 'package:colegia_atenea/utils/app_images.dart';
import 'package:colegia_atenea/utils/text_style.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';


class ClassesScreen extends StatefulWidget {
  const ClassesScreen({super.key});

  @override
  State<ClassesScreen> createState() => Classes();
}

class Classes extends State<ClassesScreen> {
  List<ParentDatum> list =  [];
  List<StudentDatum> list_student=[];
  TextEditingController search =TextEditingController();
  String classname="";
  String classid="";
  String studentname="";
  String wpid="";
  var role = 2 ;
  bool isLoading=true;

  @override
  void initState() {
    super.initState();
   setdata();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          titleSpacing: 0,
          elevation: 0,
          backgroundColor: AppColors.primary,
          leading:  Padding(
              padding: const EdgeInsets.all(10),
              child: GestureDetector(
                onTap: (){
                  print("object");
                  Scaffold.of(context).openDrawer();
                },
                child: SvgPicture.asset(
                  AppImages.humburg,
                ),)
          ),

          title:  Text(
            "classes".tr,
            style: CustomStyle.appbartitle,
          ),
          // actions: <Widget>[
          //   Padding(
          //     padding: const EdgeInsets.only(right: 20.0),
          //     child: GestureDetector(
          //       onTap: () {},
          //       child: SvgPicture.asset(
          //         AppImages.bell,
          //         height: 26,
          //         width: 26,
          //       ),
          //     ),
          //   ),
          //
          // ],
        ),
        body: Stack(
          children: [
            role==2?
            Container():
            role==0?
            //student login
            GestureDetector(
              onTap: (){
                Navigator.push(context, MaterialPageRoute(builder: (context)=> ClassMenuScreen(Model(wpUserid: wpid, classId: classid, className: classname, role: role))));
              },
              child: SizedBox(
                width: MediaQuery.of(context).size.width,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Container(
                      margin:const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                          color: AppColors.secondary.withOpacity(0.06),
                          borderRadius: const BorderRadius.all(Radius.circular(5))
                      ),
                      padding: const EdgeInsets.all(15),
                      child: (
                          Row(
                            children: [
                              Container(
                                height:70,
                                width: 70,
                                decoration: const BoxDecoration(
                                    color: AppColors.primary,
                                    borderRadius: BorderRadius.all(Radius.circular(5))
                                ),
                                child: Center(
                                  child: Text(classname,style: CustomStyle.txtvalue1.copyWith(color: AppColors.white),),
                                )
                              ),
                              const SizedBox(width: 10,),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(studentname,
                                      style: CustomStyle.txtvalue3
                                  )
                                ],
                              ),

                            ],
                          )
                      ),
                    )
                  ],
                ),
              ),
            ):
             //parent login
             SizedBox(
             width: MediaQuery.of(context).size.width,
             child: Column(
               mainAxisAlignment: MainAxisAlignment.start,
               crossAxisAlignment: CrossAxisAlignment.start,
               children: [
                 Expanded(child: ListView.builder(
                     physics: const BouncingScrollPhysics(),
                     itemCount:role==2?5:role==1?list_student.length:list.length,
                     itemBuilder: (context,position){
                   return  GestureDetector(
                     onTap: (){
                       Navigator.push(context, MaterialPageRoute(builder: (context)=> ClassMenuScreen(Model(wpUserid: list_student[position].wpUsrId!, classId: list_student[position].classId!, className: list_student[position].className! , showAssistant: list_student[position].showAssistant! == "0" ? null : "1", role: role))));
                     },
                     child: Container(
                       width: MediaQuery.of(context).size.width,
                       margin: const EdgeInsets.only(top: 10),
                       child: Column(
                         mainAxisAlignment: MainAxisAlignment.start,
                         children: [
                           Container(
                             margin: const EdgeInsets.all(15),
                             decoration: BoxDecoration(
                                 color: AppColors.secondary.withOpacity(0.06),
                                 borderRadius: const BorderRadius.all(Radius.circular(5))
                             ),
                             padding: const EdgeInsets.all(15),
                             child: (
                                 Row(
                                   children: [
                                     Container(
                                       height:70,
                                       width: 70,
                                       decoration: const BoxDecoration(
                                           color: AppColors.primary,
                                           borderRadius: BorderRadius.all(Radius.circular(5))
                                       ),
                                       child: Center(
                                         child: Text((role==2?"Name":role==1?list_student[position].className:list[position].pFname)!,style: CustomStyle.txtvalue1.copyWith(color: AppColors.white),
                                         ),
                                       ),
                                     ),
                                     const SizedBox(width: 10,),
                                     Column(
                                       crossAxisAlignment: CrossAxisAlignment.start,
                                       mainAxisAlignment: MainAxisAlignment.center,
                                       children: [
                                         Text((role==2?"Name":role==1?list_student[position].sFname:list[position].pFname)!,
                                             style: CustomStyle.txtvalue3
                                         )
                                       ],
                                     ),

                                   ],
                                 )
                             ),
                           )
                         ],
                       ),
                     ),
                   );
                 }))
               ],
             ),
           )
            // Visibility(
            //     visible: isLoading,
            //     child:  Container(
            //       color: Colors.black.withOpacity(0.5),
            //       height: MediaQuery.of(context).size.height,
            //       width: MediaQuery.of(context).size.width,
            //       child: Center(
            //         child: LoadingLayout(),
            //       ),
            //     ))
          ],
        )

    );
  }

  void setdata() async {
    SessionManagement sessionManagment = SessionManagement();
    int? Role = await sessionManagment.getRole("Role");
    if(Role==0){
      Studentlogin login= await sessionManagment.getModel('Student');
      setState(() {
        role=0;
        list = login.userdata.parentData!;
        studentname=login.userdata.sFname!;
        classid=login.userdata.classId!;
        classname=login.userdata.className!;
        wpid=login.userdata.wpUsrId!;
        isLoading=false;
      });

    }
    else {
      Parentlogin Parent= await sessionManagment.getModelParent('Parent');
      setState(() {
        role=1;
        list_student = Parent.userdata.studentData! ;
        isLoading=false;
      });
    }



  }


}
