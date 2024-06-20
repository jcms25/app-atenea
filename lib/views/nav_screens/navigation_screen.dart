import 'dart:convert';

import 'package:colegia_atenea/models/Parent/Parentlogin.dart';
import 'package:colegia_atenea/models/Student/Studentlogin.dart';
import 'package:colegia_atenea/views/menu_screen/send_message_to_assistant_screen.dart';
import 'package:colegia_atenea/views/nav_screens/classes_.dart';
import 'package:colegia_atenea/views/nav_screens/event_screen.dart';
import 'package:colegia_atenea/views/nav_screens/message_screen.dart';
import 'package:colegia_atenea/views/nav_screens/parent_student_info_screen.dart';
import 'package:colegia_atenea/views/menu_screen/attendence_screen.dart';
import 'package:colegia_atenea/views/menu_screen/circular_screen.dart';
import 'package:colegia_atenea/views/menu_screen/evaluation_screen.dart';
import 'package:colegia_atenea/views/menu_screen/grade_screen.dart';
import 'package:colegia_atenea/views/menu_screen/sujects_screen.dart';
import 'package:colegia_atenea/views/menu_screen/teacher_screen.dart';
import 'package:colegia_atenea/views/menu_screen/timetable_screen.dart';
import 'package:colegia_atenea/views/nav_screens/desk_screen.dart';
import 'package:colegia_atenea/views/login_screen.dart';
import 'package:colegia_atenea/views/menu_screen/student_screen.dart';
import 'package:colegia_atenea/views/menu_screen/test_screen.dart';
import 'package:colegia_atenea/views/menu_screen/transportation_screen.dart';
import 'package:colegia_atenea/services/session_management.dart';
import 'package:colegia_atenea/utils/app_colors.dart';
import 'package:colegia_atenea/utils/app_images.dart';
import 'package:colegia_atenea/utils/text_style.dart';
import 'package:colegia_atenea/widgets/custom_loader.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart' hide Response;
import 'package:http/http.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../assistant_module/assistant_communication_report_message_list_screen.dart';

const String dashboard = "Page 1";
const String student = "Page 2";
const String attendance = "Page 3";
const String title = "DashBoard";

class NavigationScreen extends StatelessWidget {
  const NavigationScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MyHomePage(
      title: title,
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _MyHomePageState();
  }
}

class _MyHomePageState extends State<MyHomePage> {
  String fName = "";
  String mName = "";
  String Imagepath = "";
  String classid = "";
  String name = "";
  String cid = "";
  String wpId = "";

  late int _currentIndex;
  var onClicked;
  var onClickedDrawer;
  var userName = "";
  var imagePath = "";
  String userRole = "";
  var options = [];
  var option = [];
  bool isSwitched = true;
  var textValue = 'English';
  bool isLoading = false;

  //key for scaffold
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  //this is drawerList which we have to show in drawer.
  List<DrawerMenuOption> drawerOption = [];

  //when parent is login then this drawer list show.
  List parentDrawerList = [
    {
      "name": "drawerOption1".tr,
      "icon": AppImages.dashboard,
    },
    {
      "name": "drawerOption5".tr,
      "icon": AppImages.circular,
    },
    {
      "name": "drawerOption6".tr,
      "icon": AppImages.message,
    },
    {
      "name": "drawerOption7".tr,
      "icon": AppImages.people,
    },
    {
      "name": "drawerOption4".tr,
      "icon": AppImages.event,
    },
  ];

  //when student is login then this drawer list show.
  List studentDrawerList = [
    {
      "name": "drawerOption1".tr,
      "icon": AppImages.dashboard,
    },
    {
      "name": "drawerOption6".tr,
      "icon": AppImages.message,
    },
    {
      "name": "drawerOption2".tr,
      "icon": AppImages.people,
    },
    {
      "name": "drawerOption3".tr,
      "icon": AppImages.calender,
    },
    {
      "name": "drawerOption4".tr,
      "icon": AppImages.event,
    },
  ];

  //this is submenu which is attach to enrolled class menu.
  List subMenuList = [
    {
      "name": "subMenuDrawer1".tr,
    },
    {
      "name": "subMenuDrawer2".tr,
    },
    {
      "name": "subMenuDrawer3".tr,
    },
    {
      "name": "subMenuDrawer4".tr,
    },
    {
      "name": "subMenuDrawer5".tr,
    },
    {
      "name": "subMenuDrawer6".tr,
    },
    {
      "name": "subMenuDrawer7".tr,
    },
    // {
    //   "name": "subMenuDrawer8".tr,
    // },
    {
      "name": "subMenuDrawer9".tr,
    },
  ];

  @override
  void initState() {
    // toggleSwitch(isSwitched);
    setData();
    dataInEnglish();
    // setDataEnglish();
    // setDataSpanish();
    _currentIndex = 0;
    super.initState();
  }

  void changeTab(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    debugPrintBeginFrameBanner = false;
    return Scaffold(
      key: _scaffoldKey,
      body: Stack(
        children: [
          getScreen(),
          Visibility(
              visible: isLoading,
              child: Container(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height,
                color: Colors.black26,
                child: const LoadingLayout(),
              ))
        ],
      ),
      bottomNavigationBar: Container(
        decoration: const BoxDecoration(
          borderRadius: BorderRadius.only(
              topRight: Radius.circular(30), topLeft: Radius.circular(30)),
        ),
        child: ClipRRect(
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(30.0),
            topRight: Radius.circular(30.0),
          ),
          child: BottomNavigationBar(
            onTap: (index) => changeTab(index),
            currentIndex: _currentIndex,
            backgroundColor: Colors.white,
            items: bottomStudentNavigationBarItemList,
            type: BottomNavigationBarType.fixed,
            selectedItemColor: AppColors.primary,
            showSelectedLabels: false,
            showUnselectedLabels: false,
          ),
        ),
      ),
      drawer: Drawer(
        child: SafeArea(
          child: Column(
            children: <Widget>[
              Container(
                decoration: const BoxDecoration(
                    color: AppColors.primary,
                    borderRadius: BorderRadius.only(
                      bottomRight: Radius.circular(30),
                      bottomLeft: Radius.circular(30),
                    )),
                padding: const EdgeInsets.all(15),
                height: 100,
                width: 310,
                child: Column(
                  children: [
                    Row(
                      children: [
                        SizedBox(
                          height: 65,
                          width: 65,
                          child: Imagepath.isEmpty
                              ? const CircleAvatar(
                                  backgroundImage: AssetImage(AppImages.people),
                                )
                              : CircleAvatar(
                                  radius: 16.0,
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(65.0),
                                    child: Image.network(
                                      Imagepath,
                                      fit: BoxFit.cover,
                                      height: 65,
                                      width: 65,
                                    ),
                                  ),
                                ),
                        ),
                        Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(10),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "hello".tr,
                                    style: const TextStyle(
                                        color: AppColors.white,
                                        fontSize: 16,
                                        fontFamily: 'Outfit',
                                        fontWeight: FontWeight.w300),
                                  ),
                                  Text(
                                    fName,
                                    style: const TextStyle(
                                        color: AppColors.white,
                                        fontSize: 20,
                                        fontFamily: 'Outfit',
                                        fontWeight: FontWeight.w600),
                                  )
                                ],
                              ),
                            )
                          ],
                        ),
                        const Spacer(),
                        Image.asset("Assets/white_logo_atenea.png",width: 50,height: 50)
                      ],
                    )
                  ],
                ),
              ),
              Expanded(
                child: ListView.builder(
                  physics: const BouncingScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: drawerOption.length,
                  itemBuilder: (context, index) {
                    return _buildListOfDrawerOption(drawerOption[index]);
                  },
                ),

                // child: isSwitched == true
                //     ? ListView.builder(
                //         physics: const BouncingScrollPhysics(),
                //         shrinkWrap: true,
                //         itemCount: option.length,
                //         itemBuilder: (context, index) {
                //           return _buildListSpan(option[index]);
                //         },
                //       )
                //     : ListView.builder(
                //         physics: const BouncingScrollPhysics(),
                //         shrinkWrap: true,
                //         itemCount: options.length,
                //         itemBuilder: (context, index) {
                //           return _buildList(options[index]);
                //         },
                //       ),
              ),
              // Container(
              //   padding: const EdgeInsets.only(left: 20, right: 20),
              //   child: Row(
              //     children: [
              //       Expanded(
              //         child: Text(
              //           textValue,
              //           style: const TextStyle(
              //               fontSize: 20,
              //               fontFamily: "Outfit",
              //               fontWeight: FontWeight.w600,
              //               color: Colors.black),
              //         ),
              //       ),
              //       Transform.scale(
              //           scale: 1,
              //           child: Switch(
              //             onChanged: (data) {
              //               toggleSwitch(data);
              //             },
              //             value: isSwitched,
              //             activeColor: AppColors.primary,
              //             activeTrackColor: AppColors.secondary,
              //             inactiveThumbColor: AppColors.primary,
              //             inactiveTrackColor: AppColors.secondary,
              //           )),
              //     ],
              //   ),
              // ),
              Container(
                padding: const EdgeInsets.all(20),
                color: AppColors.white,
                child: SizedBox(
                    height: 50,
                    width: 360,
                    child: Directionality(
                      textDirection: TextDirection.rtl,
                      child: ElevatedButton.icon(
                        icon: SvgPicture.asset(AppImages.loginArrow),
                        style: ButtonStyle(
                            shadowColor: WidgetStateProperty.all(AppColors.primary),
                            backgroundColor: WidgetStateProperty.all(AppColors.primary),
                            shape: WidgetStateProperty.all(
                              RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            )),
                        onPressed: () {
                          onLogOutButtonClick(context);
                        },
                        label: Text(
                          "logout".tr,
                          style: const TextStyle(
                              fontSize: 18,
                              fontFamily: 'Outfit',
                              fontWeight: FontWeight.w500,
                              color: AppColors.white),
                        ),
                      ),
                    )),
              ),
            ],
          ),
        ),
      ),
    );
  }

  List<BottomNavigationBarItem> bottomParentNavigationBarItemList = [
    BottomNavigationBarItem(
      icon: SvgPicture.asset(
        AppImages.dashboard,
        colorFilter: const ColorFilter.mode(Colors.grey, BlendMode.srcIn)
      ),
      label: '',
      activeIcon:
          SvgPicture.asset(AppImages.dashboard,
              colorFilter: const ColorFilter.mode(AppColors.primary, BlendMode.srcIn)
          ),
    ),
    BottomNavigationBarItem(
      icon: SvgPicture.asset(
        AppImages.people,
        colorFilter: const ColorFilter.mode(Colors.grey, BlendMode.srcIn),
        height: 24,
        width: 18,
      ),
      label: 'people',
      activeIcon: SvgPicture.asset(AppImages.people,
          height: 24, width: 18,  colorFilter: const ColorFilter.mode(AppColors.primary, BlendMode.srcIn)),
    ),
    BottomNavigationBarItem(
      icon: SvgPicture.asset(
        AppImages.calender,
      ),
      label: 'people',
      activeIcon:
          SvgPicture.asset(AppImages.calender,  colorFilter: const ColorFilter.mode(AppColors.primary, BlendMode.srcIn)),
    ),
    BottomNavigationBarItem(
      icon: SvgPicture.asset(
        AppImages.event,
      ),
      label: 'people',
      activeIcon: SvgPicture.asset(AppImages.event,  colorFilter: const ColorFilter.mode(AppColors.primary, BlendMode.srcIn)),
    ),
  ];

  List<BottomNavigationBarItem> bottomStudentNavigationBarItemList = [
    BottomNavigationBarItem(
      icon: SvgPicture.asset(
        AppImages.dashboard,
        colorFilter: const ColorFilter.mode(Colors.grey, BlendMode.srcIn)
      ),
      label: '',
      activeIcon:
          SvgPicture.asset(AppImages.dashboard,  colorFilter: const ColorFilter.mode(AppColors.primary, BlendMode.srcIn)),
    ),
    BottomNavigationBarItem(
      icon: SvgPicture.asset(
        AppImages.message,
        colorFilter: const ColorFilter.mode(Colors.grey, BlendMode.srcIn)
      ),
      label: 'video',
      activeIcon: SvgPicture.asset(AppImages.message,  colorFilter: const ColorFilter.mode(AppColors.primary, BlendMode.srcIn)),
    ),
    BottomNavigationBarItem(
      icon: SvgPicture.asset(
        AppImages.people,
        colorFilter: const ColorFilter.mode(Colors.grey, BlendMode.srcIn),
        height: 24,
        width: 18,
      ),
      label: 'people',
      activeIcon: SvgPicture.asset(AppImages.people,
          height: 24, width: 18,  colorFilter: const ColorFilter.mode(AppColors.primary, BlendMode.srcIn)),
    ),
    BottomNavigationBarItem(
      icon: SvgPicture.asset(
        AppImages.calender,
      ),
      label: 'people',
      activeIcon:
          SvgPicture.asset(AppImages.calender,
              colorFilter: const ColorFilter.mode(AppColors.primary, BlendMode.srcIn),),
    ),
    BottomNavigationBarItem(
      icon: SvgPicture.asset(
        AppImages.event,
      ),
      label: 'people',
      activeIcon: SvgPicture.asset(AppImages.event,  colorFilter: const ColorFilter.mode(AppColors.primary, BlendMode.srcIn)),
    ),
  ];

  //common function and basic details.
  Future<void> setData() async {
    SessionManagement sessionManagement = SessionManagement();
    int? role = await sessionManagement.getRole("Role");
    if (role == 0) {
      Studentlogin student = await sessionManagement.getModel('Student');
      setState(() {
        fName = student.userdata.sFname!;
        Imagepath = student.userdata.stuImage!;
        cid = student.userdata.classId!;
        wpId = student.userdata.wpUsrId!;
        userRole = "$role";
      });
    } else {
      Parentlogin parent = await sessionManagement.getModelParent('Parent');
      setState(() {
        fName = (parent.userdata.pFname)!;
        Imagepath = (parent.userdata.parentImage)!;
        cid = (parent.userdata.studentData![0].classId)!;
        wpId = (parent.userdata.studentData![0].wpUsrId)!;
        userRole = "$role";
      });
    }
  }

  Future<void> getSenderId() async {
    SessionManagement sessionManagement = SessionManagement();
    int? role = await sessionManagement.getRole("Role");
    if (role == 0) {
      Studentlogin student = await sessionManagement.getModel('Student');
      logOutApi(student.userdata.wpUsrId!);
    } else {
      Parentlogin parent = await sessionManagement.getModelParent('Parent');
      logOutApi(parent.userdata.parentWpUsrId!);
    }
  }

  Future<void> onLogOutButtonClick(BuildContext context) async {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            content: Text(
              'sure'.tr,
              style: CustomStyle.textValue,
            ),
            actions: [
              ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5)),
                      backgroundColor: AppColors.primary,
                      elevation: 0.0),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text(
                    'negativeButton'.tr,
                    style:
                        CustomStyle.txtvalue1.copyWith(color: AppColors.white),
                  )),
              ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5)),
                      backgroundColor: AppColors.primary,
                      elevation: 0.0),
                  onPressed: () {
                    setState(() {
                      isLoading = true;
                    });
                    Navigator.pop(context);
                    _scaffoldKey.currentState!.closeDrawer();
                    getSenderId();
                  },
                  child: Text(
                    'positiveButton'.tr,
                    style:
                        CustomStyle.txtvalue1.copyWith(color: AppColors.white),
                  ))
            ],
          );
        });
  }

  void logOutApi(String senderId) async {
    try {
      final Response response = await post(
          Uri.parse("https://colegioatenea.es/wp-json/scl-api/v1/logout"),
          body: <String, dynamic>{"user_id": senderId});

      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        if (data["status"]) {
          SessionManagement sessionManagement = SessionManagement();
          int? role = await sessionManagement.getRole("Role");
          SharedPreferences sharedPreferences =
              await SharedPreferences.getInstance();
          sharedPreferences.setBool('Login', false);
          if (role == 0) {
            sessionManagement.destroySession();
          } else {
            sessionManagement.destroySessionParent();
          }
          Fluttertoast.showToast(
              msg: 'logOut'.tr, backgroundColor: AppColors.primary);
          navigateTo();
        } else {
          Fluttertoast.showToast(msg: data["message"]);
          setState(() {
            isLoading = false;
          });
        }
      } else {
        setState(() {
          isLoading = false;
        });
      }
    } catch (exception) {
      setState(() {
        isLoading = false;
      });
    }
  }

  void toggleSwitch(bool value) async {
    SharedPreferences shre = await SharedPreferences.getInstance();
    if (value == true) {
      await shre.setBool('Language', true);
      dataInEnglish();
      setState(() {
        isSwitched = true;
        textValue = 'Español';
        var locale = const Locale('es', 'ES');
        Get.updateLocale(locale);
      });
    } else {
      dataInEnglish();
      setState(() {
        isSwitched = false;
        textValue = 'English';
        var locale = const Locale('en', 'US');
        Get.updateLocale(locale);
      });
    }
  }

  void navigateTo() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => const LoginScreen(),
      ),
    );
  }

  Widget _buildListOfDrawerOption(DrawerMenuOption drawerMenuOption) {
    if (drawerMenuOption.subMenu == null) {
      return ListTile(
        leading: drawerMenuOption.icon == null
            ? const SizedBox.shrink()
            : SvgPicture.asset(
                drawerMenuOption.icon!,
          colorFilter: const ColorFilter.mode(AppColors.secondary, BlendMode.srcIn),
                width: 25,
                height: 25,
              ),
        onTap: () {
          onClickDrawerOption(drawerMenuOption);
        },
        title: Text(
          drawerMenuOption.name!,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w500,
            fontFamily: 'Outfit',
            color: AppColors.secondary,
          ),
        ),
      );
    } else {
      return ExpansionTile(
        leading: drawerMenuOption.icon == null
            ? const SizedBox.shrink()
            : SvgPicture.asset(
                drawerMenuOption.icon!,
                width: 25,
                height: 25,
          colorFilter: const ColorFilter.mode(AppColors.secondary, BlendMode.srcIn),
              ),
        collapsedIconColor: AppColors.secondary,
        iconColor: AppColors.secondary,
        title: Text(drawerMenuOption.name!,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w500,
              fontFamily: 'Outfit',
              color: AppColors.secondary,
            )),
        children:
            drawerMenuOption.subMenu!.map(_buildListOfDrawerOption).toList(),
      );
    }
  }

  //this will set data in drawer.
  Future<void> dataInEnglish() async {
    SessionManagement sessionManagement = SessionManagement();
    int? role = await sessionManagement.getRole('role');
    List<DrawerMenuOption> listOfOptions = [];
    if (role == 0) {
      Studentlogin studentData = await sessionManagement.getModel('');
      for (var e in studentDrawerList) {
        DrawerMenuOption drawerMenuOption = DrawerMenuOption.fromJson(e);
        if (drawerMenuOption.name! == 'drawerOption3'.tr) {
          drawerMenuOption.subMenu ??= [
            DrawerMenuOption(
                name: studentData.userdata.className!,
                subMenu: buildSubMenu(
                    classId: studentData.userdata.classId!,
                    studentId: studentData.userdata.wpUsrId!))
          ];
        }
        listOfOptions.add(drawerMenuOption);
      }
    } else {
      Parentlogin parentData = await sessionManagement.getModelParent('');
      for (var e in parentDrawerList) {
        DrawerMenuOption drawerMenuOption = DrawerMenuOption.fromJson(e);
        if (drawerMenuOption.name! == 'drawerOption7'.tr) {
          if (drawerMenuOption.subMenu == null) {
            List<DrawerMenuOption> tempList = [];
            for (var student in parentData.userdata.studentData!) {
              tempList.add(DrawerMenuOption(
                name:
                    "${student.sFname}\t${student.sLname}\t(${student.className})",
                icon: AppImages.people,
                subMenu: student.showAssistant == "0"
                    ? buildSubMenu(
                        classId: student.classId!,
                        studentId: student.wpUsrId!,
                      )
                    : buildSubMenu(
                        classId: '', studentId: '', isShowAssistant: "1"),
              ));
            }
            drawerMenuOption.subMenu = tempList;
          }
        }
        listOfOptions.add(drawerMenuOption);
      }
    }
    setState(() {
      drawerOption = listOfOptions;
    });
  }

  List<DrawerMenuOption> buildSubMenu(
      {required String classId,
      required String studentId,
      String? isShowAssistant}) {
    List<DrawerMenuOption> subMenu = [];
    if (isShowAssistant != null) {
      DrawerMenuOption drawerMenuOption = DrawerMenuOption.fromJson({
        "name": "menu1".tr,
      });
      subMenu.add(drawerMenuOption);

      DrawerMenuOption drawerMenuOption1 = DrawerMenuOption.fromJson({
        "name": "menu2".tr,
      });
      drawerMenuOption1.studentWpId = studentId;
      subMenu.add(drawerMenuOption1);
    } else {
      for (var e in subMenuList) {
        DrawerMenuOption drawerMenuOption = DrawerMenuOption.fromJson(e);
        drawerMenuOption.classId = classId;
        drawerMenuOption.studentWpId = studentId;
        subMenu.add(drawerMenuOption);
      }
    }
    return subMenu;
  }

  void onClickDrawerOption(DrawerMenuOption drawerMenuOption) {
    switch (drawerMenuOption.name) {
      case 'Escritorio':
        if (_currentIndex != 0) {
          changeTab(0);
        }
        Navigator.pop(context);
        break;
      case 'Padres':
        if (_currentIndex != 2) {
          changeTab(2);
        }
        Navigator.pop(context);
        break;
      case 'Eventos':
        if (_currentIndex != 4) {
          changeTab(4);
        }
        Navigator.pop(context);
        break;
      case 'Circulares':
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => const CircularScreen()));
        break;
      case 'Comunicaciones':
        if (_currentIndex != 1) {
          changeTab(1);
        }
        Navigator.pop(context);
        break;
      case 'Horario':
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) =>
                    TimeTableScreen(drawerMenuOption.classId)));
        break;
      case 'Profesores':
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => TeacherScreen(
                    drawerMenuOption.classId ?? "", drawerMenuOption.studentWpId ?? "")));
        break;
      case 'Alumnos':
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => StudentScreen(
                    drawerMenuOption.classId ?? "", drawerMenuOption.studentWpId ?? "")));
        break;
      case 'Asignaturas':
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => SubjectScreen(
                    drawerMenuOption.classId ?? "", drawerMenuOption.studentWpId ?? "")));
        break;
      case 'Exámenes/Trabajos':
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => TestScreen(
                    drawerMenuOption.classId!, drawerMenuOption.studentWpId!)));
        break;
      case 'Notas':
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => GradeScreen(
                    drawerMenuOption.classId ?? "", drawerMenuOption.studentWpId ?? "")));
        break;
      case 'Evaluaciones':
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => evaluationscreen(
                    drawerMenuOption.classId, drawerMenuOption.studentWpId)));
        break;
      case 'Ausencias':
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => AttendanceScreen(
                    drawerMenuOption.classId ?? "", drawerMenuOption.studentWpId ?? "")));
        break;
      case 'Transporte':
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => const TransportationScreen()));
        break;
      case 'Informes':
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => const ReportListScreen(
                      showInParent: "1",
                    )));
        break;
      case 'Enviar mensaje a la Asistente':
        Navigator.pop(context);
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => SendMessageToAssistant(
                      studentId: drawerMenuOption.studentWpId!,
                    )));
        break;
      default:
    }
  }

  Widget getScreen() {
    return _currentIndex == 0
        ? const DashboardScreen()
        : _currentIndex == 1
            ? const MessageScreen(
                studentOrParent: "0",
              )
            : _currentIndex == 2
                ? const ParentStudentInfo()
                : _currentIndex == 3
                    ? const ClassesScreen()
                    : const EventScreen();
    // if(userRole == "0"){
    //
    // }
    // else{
    //  return _currentIndex == 0
    //       ? const DashboardScreen()
    //       : _currentIndex == 1
    //       ? ParentStudentInfo()
    //       : _currentIndex == 2
    //       ? const ClassesScreen()
    //       : const EventScreen();
    // }
  }
}

class DrawerMenuOption {
  //studentData means when parent login in which parent get data of student.
  //userData is data when student login and data of that student.

  String? name;
  String? icon;
  List<DrawerMenuOption>? subMenu;
  String? studentWpId;
  String? classId;

  DrawerMenuOption(
      {required this.name,
      this.icon,
      this.subMenu,
      this.studentWpId,
      this.classId});

  DrawerMenuOption.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    icon = json['icon'];
    if (json['subMenu'] != null) {
      subMenu!.clear();
      json['subMenu'].forEach((v) {
        subMenu!.add(DrawerMenuOption.fromJson(v));
      });
    }
  }
}
