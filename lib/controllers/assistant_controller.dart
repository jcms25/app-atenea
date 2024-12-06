//this controller will handle all operations related to assistant
import 'package:flutter/widgets.dart';

import '../models/assistant/assistant_login_model.dart';

class AssistantController extends ChangeNotifier{

  //Assistant Login
  Assistant? assistant;
  void setAssistant({required Assistant? assistant}) {
    this.assistant = assistant;
    notifyListeners();
  }


  //current bottom index selected
  int currentBottomIndexSelected = 0;
  void setCurrentBottomIndexSelected({required int currentBottomIndexSelected}){
    this.currentBottomIndexSelected = currentBottomIndexSelected;
    notifyListeners();
  }





}