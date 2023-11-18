import 'package:colegia_atenea/views/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../services/share_preferences.dart';

class LifeCycleManager extends StatefulWidget {
  const LifeCycleManager({Key? key, required this.child}) : super(key: key);

  final Widget child;

  @override
  State<StatefulWidget> createState() {
    return _LifeCycleManagerState();
  }

}

class _LifeCycleManagerState extends State<LifeCycleManager> with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    initializeShared();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);

    switch(state){
      case AppLifecycleState.resumed:
        // TODO: Handle this case.
       bool firstStatus = SharedPref.checkLogin();
       SharedPref.pref.reload().then((value){
         bool status = SharedPref.pref.getBool('Login') ?? false;
         if(status != firstStatus){
           Get.to(()=>const LoginScreen());
         }
       });
        break;
      case AppLifecycleState.inactive:
        // TODO: Handle this case.
        break;
      case AppLifecycleState.paused:
        // TODO: Handle this case.
        break;
      case AppLifecycleState.detached:
        // TODO: Handle this case.
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  void initializeShared() async{
    await SharedPref.initialization();
  }
}