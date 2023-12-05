import 'package:colegia_atenea/models/Parent/Parentlogin.dart';
import 'package:colegia_atenea/models/Student/Studentlogin.dart';
import 'package:colegia_atenea/services/api_class.dart';
import 'package:colegia_atenea/services/session_management.dart';
import 'package:colegia_atenea/utils/app_colors.dart';
import 'package:colegia_atenea/utils/app_images.dart';
import 'package:colegia_atenea/utils/text_style.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import '../../models/transportationlist.dart';
import '../../widgets/custom_loader.dart';


class TransportationScreen extends StatefulWidget {
  const TransportationScreen({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _TransportScreenChild();
  }
}

class _TransportScreenChild extends State<TransportationScreen> {
  List<Datum> listOfTransfer = [];
  List<Datum> tempList =[];
  TextEditingController search = TextEditingController();
  bool isLoading=false;

  List<String> nameOfTh= ["svdjjvn f jnkbfd","aficvsinsnvd","cvosbnvosv","cvnsdb;vdlbfvd"];
  @override
  void initState() {
    super.initState();
    setState(() {
      isLoading=true;
    });
    getTransportList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
            titleSpacing: 0,
            elevation: 0,
            backgroundColor: AppColors.primary,
            title:  Text("trans".tr,
              style: const TextStyle(
                  fontWeight: FontWeight.w500,
                  fontSize: 20,
                  fontFamily: 'Outfit'
              ),),
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
            SizedBox(
              width: MediaQuery.of(context).size.width,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                      height: 90,
                      decoration: const BoxDecoration(
                          borderRadius: BorderRadius.only(
                              bottomLeft: Radius.circular(20),
                              bottomRight: Radius.circular(20)),
                          color: AppColors.primary),
                      child: Container(
                        // height: 50,
                        margin: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: AppColors
                              .white,
                          borderRadius:
                          BorderRadius.circular(10),
                        ),
                        child:  TextField(
                          maxLines: 1,
                          controller:search ,
                          autofocus: false,
                          decoration: InputDecoration(
                              prefixIcon: IconButton(
                                icon: const Icon(
                                  Icons.search,
                                  color: AppColors
                                      .searchIcon,
                                ), onPressed: () {  },

                              ),
                              hintText: 'searchInList'.tr,
                              hintStyle: TextStyle(
                                  fontFamily: "Outfit",
                                  fontWeight: FontWeight.w400,
                                  fontSize: 16,
                                  color: AppColors.secondary.withOpacity(0.5)
                              ),
                              border: InputBorder.none),
                          // style: txtValueStyle,
                          keyboardType: TextInputType
                              .emailAddress,
                          textInputAction:
                          TextInputAction.next,
                          onChanged: onSearchTextChanged,

                        ),

                      ),
                  ),
                  Expanded(
                      child: isLoading ? const SizedBox.shrink() :
                          tempList.isEmpty ? Center(
                            child: Text(
                              'noTransport'.tr,
                              style: const TextStyle(
                                fontFamily: "Outfit",
                                fontWeight: FontWeight.w400,
                                fontSize: 16,
                                color: AppColors.secondary
                              ),
                            ),
                          ) :
                              Padding(padding: const EdgeInsets.all(10),
                              child: ListView.separated(itemBuilder: (context,index){
                                Datum data = tempList[index];
                                return Container(
                                  width: MediaQuery.of(context).size.width,
                                  padding: const EdgeInsets.all(10),
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(5),
                                      color: AppColors.primary.withOpacity(0.05)
                                  ),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Container(
                                        height: 25,
                                        padding: const EdgeInsets.all(5),
                                        decoration: BoxDecoration(
                                          color: AppColors.primary,
                                          borderRadius: BorderRadius.circular(5)
                                        ),
                                        child: Text(data.busNo,style: const TextStyle(color: AppColors.white,fontFamily: "Outfit",fontWeight: FontWeight.w400,fontSize: 15),),
                                      ),
                                      const SizedBox(height: 20,),
                                      CustomRow('vname'.tr, data.busName),
                                      const SizedBox(height: 10,),
                                      CustomStyle.dottedLine,
                                      const SizedBox(height: 10,),

                                      CustomRow('dname'.tr, data.driverName),
                                      const SizedBox(height: 10,),
                                      CustomStyle.dottedLine,
                                      const SizedBox(height: 10,),

                                      CustomRow('dnumber'.tr, data.phoneNo),
                                      const SizedBox(height: 10,),
                                      CustomStyle.dottedLine,
                                      const SizedBox(height: 10,),

                                      CustomRow('rrate'.tr, data.routeFees),
                                      const SizedBox(height: 10,),
                                      CustomStyle.dottedLine,
                                      const SizedBox(height: 10,),

                                      CustomRow('vroute'.tr, data.busRoute),
                                      const SizedBox(height: 10,),
                                      CustomStyle.dottedLine,
                                      const SizedBox(height: 10,),
                                    ],
                                  ),
                                );
                              }, separatorBuilder: (context,index){
                                return const SizedBox(height: 10,);
                              }, itemCount: tempList.length),)

                  )
                ],
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
        )
    );
  }

  void getTransportList() async {
    ApiClass httpService=ApiClass();
    SessionManagement sessionManagement = SessionManagement();
    int? role= await sessionManagement.getRole("Role");
    if(role==0){
      Studentlogin login = await sessionManagement.getModel('Student');
      String token  = login.basicAuthToken;
      dynamic response=await httpService.getTransfer(token,login.userdata.cookie ?? "");
      if(response['status']) {
        Transportation transportData = Transportation.fromJson(response);
        setState(() {
          listOfTransfer = transportData.data;
          tempList = transportData.data;
          isLoading=false;
        });
      }else {
        setState(() {
          isLoading = false;
        });
      }
    }else{
      Parentlogin parent = await sessionManagement.getModelParent('Parent');
      String token  = parent.basicAuthToken;
      dynamic response=await httpService.getTransfer(token,parent.userdata.cookie ?? "");
      if(response['status']) {
        Transportation transportData = Transportation.fromJson(response);
        setState(() {
          listOfTransfer = transportData.data;
          tempList = transportData.data;
          isLoading=false;
        });
      }else {
        setState(() {
          isLoading = false;
        });
      }

    }
  }
  onSearchTextChanged(String text) async {
    if (text.isEmpty) {
      setState(() {
        tempList = listOfTransfer;
      });
      return;
    }

    List<Datum> searchData = [];
    listOfTransfer.forEach((userDetail) {
      if (userDetail.driverName.isCaseInsensitiveContains(text) || userDetail.busNo.isCaseInsensitiveContains(text)) {
        searchData.add(userDetail);
      }
    });

    setState(() {
      tempList = searchData;
    });
  }
}

class CustomRow extends StatelessWidget{
  String Label;
  String value;

  CustomRow(this.Label, this.value, {super.key});

  TextStyle textStyle = TextStyle(
    fontFamily: "Outfit",
    fontSize: 16,
    fontWeight: FontWeight.w400,
    color: AppColors.secondary.withOpacity(0.5)
  );

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Row(
      children: [
        Expanded(child: Text(Label,style: textStyle,)),
        const SizedBox(width: 10,),
        Expanded(child: Text(value,style: textStyle.copyWith(color: AppColors.secondary),textAlign: TextAlign.end,))
      ],
    );
  }

}