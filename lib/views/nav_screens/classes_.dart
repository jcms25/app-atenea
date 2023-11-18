import 'package:colegia_atenea/models/Model.dart';
import 'package:colegia_atenea/models/Parent/Parentlogin.dart';
import 'package:colegia_atenea/models/Student/Studentlogin.dart';
import 'package:colegia_atenea/views/nav_screens/classmenu_screen.dart';
import 'package:colegia_atenea/services/session_management.dart';
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
  List<StudentDatum> studentList=[];
  TextEditingController search =TextEditingController();
  String classname="";
  String classId="";
  String studentName="";
  String wpId="";
  var userRole = -1 ;
  bool isLoading=true;

  @override
  void initState() {
    super.initState();
   setData();
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
                  Scaffold.of(context).openDrawer();
                },
                child: SvgPicture.asset(
                  AppImages.humBurg,
                ),)
          ),

          title:  Text(
            "classes".tr,
            style: CustomStyle.appBarTitle,
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
            userRole==2?
            const SizedBox():
            userRole==0?
            //student login
            GestureDetector(
              onTap: (){
                Navigator.push(context, MaterialPageRoute(builder: (context)=> ClassMenuScreen(Model(wpUserid: wpId, classId: classId, className: classname, role: userRole))));
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
                                padding: const EdgeInsets.all(5),
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
                                  Text(studentName,
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
                 const SizedBox(height: 20,),
                 Expanded(
                     child: ScrollConfiguration(
                       behavior: const ScrollBehavior().copyWith(overscroll: false),
                       child: ListView.separated(
                         itemCount:userRole==-1?0:userRole==1?studentList.length:list.length,
                         itemBuilder: (context,position){
                           return  GestureDetector(
                             onTap: (){
                               Navigator.push(context, MaterialPageRoute(builder: (context)=> ClassMenuScreen(Model(wpUserid: studentList[position].wpUsrId!, classId: studentList[position].classId!, className: studentList[position].className! , showAssistant: studentList[position].showAssistant! == "0" ? null : "1", role: userRole))));
                             },
                             child: Container(
                               margin: const EdgeInsets.symmetric(horizontal: 10),
                               decoration: BoxDecoration(
                                   color: AppColors.secondary.withOpacity(0.06),
                                   borderRadius: const BorderRadius.all(Radius.circular(5))
                               ),
                               padding: const EdgeInsets.all(15),
                               child: (
                                   Row(
                                     children: [
                                       Container(
                                         width: 70,
                                         constraints: const BoxConstraints(
                                            minHeight: 70,
                                         ),
                                         padding: const EdgeInsets.all(5),
                                         decoration: const BoxDecoration(
                                             color: AppColors.primary,
                                             borderRadius: BorderRadius.all(Radius.circular(5))
                                         ),
                                         child: Center(
                                           child: Text((userRole==-1?"Name":userRole==1?studentList[position].className:list[position].pFname)!,
                                             style: CustomStyle.txtvalue1.copyWith(color: AppColors.white),
                                             textAlign: TextAlign.center,
                                           ),
                                         ),
                                       ),
                                       const SizedBox(width: 10,),
                                       Column(
                                         crossAxisAlignment: CrossAxisAlignment.start,
                                         mainAxisAlignment: MainAxisAlignment.center,
                                         children: [
                                           Text((userRole==-1?"Name":userRole==1?studentList[position].sFname:list[position].pFname)!,
                                               style: CustomStyle.txtvalue3
                                           )
                                         ],
                                       ),

                                     ],
                                   )
                               ),
                             ),
                           );
                         }, separatorBuilder: (BuildContext context, int index) {
                         return const SizedBox(height: 10,);
                       },),
                     )
                 )
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

  void setData() async {
    SessionManagement sessionManagement = SessionManagement();
    int? role = await sessionManagement.getRole("Role");
    if(role==0){
      Studentlogin login= await sessionManagement.getModel('Student');
      setState(() {
        userRole=0;
        list = login.userdata.parentData!;
        studentName=login.userdata.sFname!;
        classId=login.userdata.classId!;
        classname=login.userdata.className!;
        wpId=login.userdata.wpUsrId!;
        isLoading=false;
      });

    }
    else {
      Parentlogin parent= await sessionManagement.getModelParent('Parent');
      setState(() {
        userRole=1;
        studentList = parent.userdata.studentData! ;
        isLoading=false;
      });
    }



  }


}
