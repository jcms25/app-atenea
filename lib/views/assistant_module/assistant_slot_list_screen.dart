import 'package:colegia_atenea/models/assistant/assistant_slotlist_model.dart';
import 'package:colegia_atenea/services/app_shared_preferences.dart';
import 'package:colegia_atenea/views/assistant_module/assistant_children_list_screen.dart';
import 'package:colegia_atenea/utils/app_colors.dart';
import 'package:colegia_atenea/views/custom_widgets/custom_loader.dart';
import 'package:flutter/material.dart';

import '../../models/assistant/assistant_login_model.dart';
import '../../services/api_class.dart';

class SlotList extends StatefulWidget{
  final String classId;

  const SlotList(this.classId, {super.key});

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return SlotListChild();
  }

}

class SlotListChild extends State<SlotList> {
  List<SlotDatum> timeSlot = [];
  bool isLoading = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setState(() {
      isLoading = true;
    });
    getAsSlotList();
  }
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        title: const Text("Working day",style: TextStyle(fontFamily: "Outfit",fontWeight: FontWeight.w500,fontSize: 20,color: AppColors.white),),
        backgroundColor: AppColors.primary,
        elevation: 0,
      ),
      body : Stack(
        children: [
          ListView.builder(
              itemCount: timeSlot.length,
              itemBuilder: (context,index){
                return GestureDetector(
                  onTap: (){
                    Navigator.push(context, MaterialPageRoute(builder: (context)=>AssistantChildrenScreen(widget.classId)));
                  },
                  child: Container(
                    margin: const EdgeInsets.all(10),
                    height: 100,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: AppColors.primary.withOpacity(0.05)
                    ),
                    child: Row(
                      children: [
                        Container(
                          width: 10,
                          decoration: const BoxDecoration(
                            color: AppColors.primary,
                            borderRadius: BorderRadius.only(topRight: Radius.circular(10), bottomRight: Radius.circular(10)
                            ),
                          ),),
                        const SizedBox(width: 10,),
                        Text("${timeSlot[index].startTime}-${timeSlot[index].endTime}",style: const TextStyle(
                            fontFamily: "Outfit",
                            fontWeight: FontWeight.w600,
                            fontSize: 20,
                            color: AppColors.primary
                        ),)
                      ],
                    ),
                  ),
                );
              }),
          Visibility(visible: isLoading,child: Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            color: Colors.black54,
            child: const Center(
              child: LoadingLayout(),
            ),
          ),)
        ],
      )
    );
  }
  void getAsSlotList() async{
    // ApiClass apiClass = ApiClass();
    // Assistant assistant = await sessionManagement.getAssistantDetail();
    // String token = assistant.basicAuthToken;
    Assistant? assistant = AppSharedPreferences.getAssistantLoggedInData();
    dynamic tempClassList = await ApiClass().getAsSlot(assistant?.basicAuthToken ?? "",assistant?.userdata.data.cookie ?? "");
    if(tempClassList['status']){
      SlotListModel slotListModel = SlotListModel.fromJson(tempClassList);
      setState(() {
        timeSlot = slotListModel.data;
        isLoading = false;
      });
    }
    else{
      setState(() {
        isLoading = false;
      });
    }
  }
}