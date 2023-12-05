import 'dart:async';
import 'dart:io';

import 'package:colegia_atenea/models/Failed.dart';
import 'package:colegia_atenea/models/Parent/Parentlogin.dart';
import 'package:colegia_atenea/models/Student/Studentlogin.dart';
import 'package:colegia_atenea/views/nav_screens/navigation_screen.dart';
import 'package:colegia_atenea/views/assistant_module/assistant_main_screen.dart';
import 'package:colegia_atenea/services/api_class.dart';
import 'package:colegia_atenea/services/session_management.dart';
import 'package:colegia_atenea/utils/app_colors.dart';
import 'package:colegia_atenea/utils/app_images.dart';
import 'package:colegia_atenea/utils/text_style.dart';
import 'package:colegia_atenea/widgets/custom_loader.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart' hide Response;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import '../models/assistant/assistant_login_model.dart';



class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key, title}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  TextEditingController username = TextEditingController();
  TextEditingController password = TextEditingController();
  bool _isObscure = true;
  bool isLoading=false;
  var items = [
    "selectrole".tr,
    "prent".tr,
    "stu".tr,
    "assistant".tr
  ];
  String dropdownvalue = "selectrole".tr;
  bool  isRememberMe =false;
  bool _validate = false;
  bool _validate1 = false;

  @override
  void initState() {
    super.initState();
    getData();

  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final oldCheckboxTheme = theme.checkboxTheme;
    final newCheckBoxTheme = oldCheckboxTheme.copyWith(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(3),
      ),
      side: MaterialStateBorderSide.resolveWith(
            (states) => const BorderSide(width: 1.0, color: AppColors.secondary),
      ),
    );
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Stack(
        children: [
          SizedBox(
            width: MediaQuery.of(context).size.width,
            child: Column(
              children: [
                Container(
                  height: ((MediaQuery.of(context).size.height) / 2) - 20,
                  color: AppColors.primary,
                ),
                Container(
                  height: ((MediaQuery.of(context).size.height) / 2) - 255,
                  color: Colors.white,
                ),
              ],
            ),
          ),
          ScrollConfiguration(
            behavior:
            const MaterialScrollBehavior().copyWith(overscroll: false),
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Stack(alignment: Alignment.topCenter, children: [
                Container(
                  margin: const EdgeInsets.only(top: 20),
                  width: 320,
                  height: 320,
                  decoration:  BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white.withOpacity(0.06)),
                ),
                Container(
                  margin: const EdgeInsets.only(top: 60),
                  width: 230,
                  height: 230,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white.withOpacity(0.1),
                  ),
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Container(
                        margin: const EdgeInsets.only(top: 170),
                        padding:  EdgeInsets.only(top: 100, bottom:MediaQuery.of(context).viewInsets.bottom>0?220:120),
                        width: MediaQuery.of(context).size.width,
                        decoration: const BoxDecoration(
                            borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(30),
                                topRight: Radius.circular(30)),
                            color: Colors.white),
                        child: Container(
                          color: Colors.white,
                          margin: const EdgeInsets.symmetric(
                              vertical: 0, horizontal: 20),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.end,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "login".tr,
                                style: CustomStyle.login,
                              ),
                              Container(
                                margin:
                                const EdgeInsets.fromLTRB(0, 20, 0, 30),
                                child:  Text(
                                  "Every".tr,
                                  style: CustomStyle.everything,
                                ),
                              ),
                              Padding(padding: const EdgeInsets.only(left: 10),child:
                              Text(
                                "user".tr,
                                style: CustomStyle.textValue,
                              ),),
                              Container(
                                height: 60,
                                margin:
                                const EdgeInsets.fromLTRB(0, 10, 0, 15),
                                padding: const EdgeInsets.only(
                                    left: 10, right: 10),
                                decoration: BoxDecoration(
                                    borderRadius:
                                    const BorderRadius.all(Radius.circular(12)),
                                    color: AppColors.secondary.withOpacity(0.06)),
                                child: Center(
                                  child: TextField(
                                    controller: username,
                                    autofocus: false,
                                    enableInteractiveSelection: false,
                                    decoration:  InputDecoration(
                                        hintText:  "user".tr,
                                        hintStyle: CustomStyle.textHintValue,
                                        errorText: _validate ? 'Value Can\'t Be Empty' : null,
                                        contentPadding:
                                        const EdgeInsets.all(
                                            20),
                                        border: InputBorder.none),
                                    style: CustomStyle.textValue,
                                    textInputAction:
                                    TextInputAction.done,
                                  ),
                                ),
                              ),
                              Padding(padding: const EdgeInsets.only(left: 10),child:  Text(
                                "password".tr,
                                style: CustomStyle.textValue,
                              ),),
                              Container(
                                height: 60,
                                padding: const EdgeInsets.only(
                                    left: 10, right: 10),
                                margin:
                                const EdgeInsets.fromLTRB(0, 10, 0, 15),
                                decoration: BoxDecoration(
                                    borderRadius:
                                    const BorderRadius.all(Radius.circular(12)),
                                    color: AppColors.secondary.withOpacity(0.06)),
                                child: Center(
                                  child: TextField(
                                    controller: password,
                                    autofocus: false,
                                    decoration: InputDecoration(
                                        suffixIcon: IconButton(
                                          icon: Icon(
                                            _isObscure
                                                ? Icons
                                                .visibility_off
                                                : Icons
                                                .visibility,
                                            color: AppColors
                                                .primary,
                                          ),
                                          onPressed: () {
                                            setState(() {
                                              _isObscure =
                                              !_isObscure;
                                            });
                                          },
                                        ),
                                        hintText: '*******',
                                        hintStyle: CustomStyle.textHintValue,
                                        errorText: _validate1 ? 'Value Can\'t Be Empty' : null,
                                        contentPadding:
                                        const EdgeInsets.all(
                                            20),
                                        border: InputBorder.none),
                                    style: CustomStyle.textValue,
                                    obscureText: _isObscure,
                                    keyboardType: TextInputType
                                        .visiblePassword,
                                    textInputAction:
                                    TextInputAction.done,
                                  ),
                                ),
                              ),
                              Row(
                                children: [
                                  SizedBox(
                                      height: 20,
                                      width: 20,
                                      child: Theme(
                                        data: theme.copyWith(
                                          checkboxTheme:
                                          newCheckBoxTheme,
                                          unselectedWidgetColor:
                                          AppColors
                                              .secondary,
                                        ),
                                        child: Checkbox(
                                          value:
                                          isRememberMe,
                                          tristate: false,
                                          materialTapTargetSize:
                                          MaterialTapTargetSize
                                              .shrinkWrap,
                                          activeColor:
                                          AppColors
                                              .secondary,
                                          shape: RoundedRectangleBorder(
                                              borderRadius:
                                              BorderRadius.circular(
                                                  5)),
                                          onChanged:
                                              (bool?
                                          value) {
                                            setState(() {
                                              isRememberMe = value!;
                                            });
                                          },
                                        ),
                                      )
                                  ),
                                  GestureDetector(
                                    onTap: () {
                                      setState((){
                                        isRememberMe=!isRememberMe;
                                      });

                                    },
                                    child: Container(
                                      margin: const EdgeInsets.fromLTRB(
                                          10, 0, 0, 0),
                                      child:   Text("rember".tr,
                                        style: CustomStyle.txtvalue1,
                                      ),
                                    ),
                                  ),
                                  const Spacer(),
                                  GestureDetector(
                                    onTap: (){
                                      openurl();
                                    },
                                    child: Text("forgot".tr,
                                      style: CustomStyle.txtvalue1,
                                    ),
                                  )
                                ],
                              ),
                              Container(
                                margin: const EdgeInsets.only(top: 10),
                                width: double.infinity,
                                height: 60,
                                padding: const EdgeInsets.only(top:10,bottom:10,right:20,left:20),
                                decoration: BoxDecoration(
                                  color: AppColors.secondary.withOpacity(0.06),
                                  borderRadius:
                                  BorderRadius.circular(
                                      12.0),
                                ),
                                child:
                                DropdownButtonHideUnderline(
                                    child:
                                    DropdownButton(
                                      icon: SvgPicture.asset(
                                        AppImages.dropdown,height: 5,width: 15,fit: BoxFit.scaleDown,),
                                      value: dropdownvalue,
                                      items: items.map((String items) {
                                        return DropdownMenuItem(
                                          value: items,
                                          child: Text(
                                            items,style: CustomStyle.txtvalue2.copyWith(
                                              color: AppColors.secondary
                                          ),
                                          ),
                                        );
                                      }).toList(),
                                      onChanged:
                                          (String? newValue) {
                                        setState(() {
                                          dropdownvalue =
                                          newValue!;
                                        });
                                      },
                                    )),
                              )
                            ],
                          ),
                        )),
                  ],
                ),
                Container(
                  padding: const EdgeInsets.all(30),
                  margin: const EdgeInsets.only(top: 90),
                  height: 160,
                  width: 160,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(
                        color: AppColors.primary,
                        width: 3.0,
                        style: BorderStyle.solid),
                    borderRadius:
                    const BorderRadius.all(Radius.circular(160)),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.primary.withOpacity(0.5),
                        spreadRadius: 0,
                        blurRadius: 25,
                        offset: const Offset(
                            0, 0), // changes position of shadow
                      ),
                    ],
                  ),
                  child: Image.asset(AppImages.logo),
                )
              ]),
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              height: 100,
              decoration: const BoxDecoration(
                color: Colors.white,
              ),
              padding: const EdgeInsets.all(20),
              child: ElevatedButton(
                  onPressed: () {
                    if(username.text.isNotEmpty && password.text.isNotEmpty ){
                      if(dropdownvalue=='selectrole'.tr){
                        Fluttertoast.showToast(msg: "Please Select Role Of User.");
                      }else{
                        setState((){
                          isLoading=true;
                        });
                        checkLogin(username.text, password.text,dropdownvalue, isRememberMe);
                      }
                    }else{
                      setState((){
                        username.text.isEmpty ? _validate = true : _validate = false;
                        password.text.isEmpty ? _validate1 = true : _validate1 = false;
                      }); }


                  },
                  style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      shadowColor: AppColors.primary.withOpacity(0.4),
                      elevation: 25,
                      shape: const RoundedRectangleBorder(
                          borderRadius:
                          BorderRadius.all(Radius.circular(12)))),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children:    [
                      Text(
                        "singin".tr,
                        style: CustomStyle.txtvalue2.copyWith(
                            color: AppColors.white
                        ),
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      const Icon(Icons.arrow_forward)
                    ],
                  )),
            ),
          ),
          Visibility(
              visible: isLoading,
              child:  Container(
                color: Colors.black.withOpacity(0.5),
                height: MediaQuery.of(context).size.height,
                width: MediaQuery.of(context).size.width,
                child: const Center(
                  child: LoadingLayout(),
                ),
              ))
        ],

      ),
    );
  }

  void checkLogin(String username, String password,String role,bool isRememberMe) async {
    ApiClass httpService = ApiClass();
    SharedPreferences shre=await SharedPreferences.getInstance();
    //get the device FCM token for push notifications.
    String? fcmToken= await FirebaseMessaging.instance.getToken();
    dynamic login = await httpService.loginCheck(username, password,role=="prent".tr?"parent":role=="stu".tr?"student":"assistant",fcmToken ?? "",Platform.isAndroid ? "Android" : "Ios");
    if(login['status']==true){
      if(role=="stu".tr){
        Studentlogin student= Studentlogin.fromJson(login);
        SessionManagement sessionManagement= SessionManagement();
        Studentlogin studentData=student;
        sessionManagement.createSession(studentData);
        await shre.setString("cookieUserName", username);
      }
      else if(role=="prent".tr) {
        Parentlogin parent=Parentlogin.fromJson(login);
        SessionManagement sessionManagement= SessionManagement();
        sessionManagement.createSessionParent(parent);
      }
      else{
        Assistant assistant= Assistant.fromJson(login);
        SessionManagement sessionManagement = SessionManagement();
        sessionManagement.saveAssistant(assistant);
      }
      if(isRememberMe){
        await shre.setString('username', username);
        await shre.setString('password', password);
        await shre.setString('role', role);
        await shre.setBool('remember',isRememberMe);
      }
      await shre.setBool('Login', true);
      setState((){
        isLoading=false;
      });
      Fluttertoast.showToast(msg: 'loginDone'.tr,backgroundColor: AppColors.primary);
      role=="assistant".tr? Timer( const Duration(seconds: 0),
              ()=> Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=> const AssistantScreen(currentIndex: 0,)))
      ):
      Timer( const Duration(seconds: 0),
              ()=> Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>const NavigationScreen()))
      );



      //
      // await httpService.getDashboard(login['basicAuthToken']);
      // setState(() {
      //   isLoading = false;
      // });
    }
    else{
      Failed fail=  Failed.fromJson(login);
      Fluttertoast.showToast(msg: fail.message,backgroundColor: AppColors.primary,gravity: ToastGravity.SNACKBAR);
      setState((){
        isLoading=false;
      });
    }

  }

  void openurl() async {

    var url = Uri.parse("http://colegioatenea.es/solicitud-de-credenciales-de-acceso/");
    if(!await launchUrl(url)){
      Fluttertoast.showToast(msg: "Can't launch url");
    }
  }

  void getData() async {
    SharedPreferences shre= await SharedPreferences.getInstance();
    if(shre.getString("role") != null){
      String name= shre.getString("username") ?? "";
      String pass= shre.getString("password") ?? "";
      String role= shre.getString("role") ?? "";

      setState((){
        username.text= name;
        password.text=pass;
        dropdownvalue=role;
      });
    }
  }

  // void tempLogin() async{
  //   try {
  //     SharedPreferences preferences = await SharedPreferences.getInstance();
  //     final Response response = await post(
  //
  //       Uri.parse('${Apiclass().BASEURL}login'),
  //       headers: <String, String>{
  //         'Content-Type': 'application/x-www-form-urlencoded; charset=UTF-8',
  //       },
  //       body: <String, dynamic>{
  //         'username': username.text,
  //         'password': password.text,
  //         'reg_select_role': 'assistant'
  //       },
  //     );
  //     var data = jsonDecode(response.body);
  //     print(data);
  //     if(data['status']){
  //       if(isRememberMe){
  //         await preferences.setString('username', username.text);
  //         await preferences.setString('password', password.text);
  //         await preferences.setString('role', 'assistant'.tr);
  //         await preferences.setBool('remember',true);
  //       }
  //       await preferences.setBool('Login', true);
  //       Assistant assistant= Assistant.fromJson(data);
  //       print(data);
  //       SessionManagement sessionManagement = SessionManagement();
  //       sessionManagement.saveAssistant(assistant);
  //       setState(() {
  //         isLoading = false;
  //       });
  //       gotoAssistant();
  //     }
  //     else{
  //       setState(() {
  //         isLoading = false;
  //       });
  //     }
  //   } catch (exception) {
  //       setState(() {
  //         isLoading = false;
  //       });
  //       Fluttertoast.showToast(msg: "$exception");
  //      }
  //
  //
  // }

  void gotoAssistant() {
    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>const AssistantScreen(currentIndex: 0,)));
  }
}
