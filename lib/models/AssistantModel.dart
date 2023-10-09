


import 'package:colegia_atenea/utils/app_images.dart';

String  imagepath=AppImages.dashboard;
String imagepath1=AppImages.people;
String imagepath2=AppImages.calender;
String imagepath3=AppImages.edit;
String imagepath4=AppImages.message;
String imagepath6= AppImages.circular;


List Assistantlist = [

  {
    "id":1,
    "name": "Desk",
    "icon": imagepath,
    "submenu":[]
  },
  {
    "id":2,
    "name": "Clases",
    "icon":imagepath6,
    "submenu":[]
  },
  {
    "id":3,
    "name":"Assistance",
    "icon":imagepath4,
    "submenu":[]
  },
  {
    "id":4,
    "name": "Jornada",
    "icon": imagepath1,
    "submenu":[]
  },
  {
    "id":5,
    "name": "Personalizada",
    "icon": imagepath2,
    "submenu":[]
  },
  {
    "id":5,
    "name": "Petites",
    "icon": imagepath1,
    "submenu":[]
  },
  {
    "id":5,
    "name": "Communicaciones",
    "icon": imagepath4,
    "submenu":[]
  },


];



class MenuAssistant {
  var  id;
  int? position=0;
  var Name;
  var name;
  var icon;
  List<MenuAssistant> subMenuassi = [];
  var ischild;
  MenuAssistant(this.name,this.icon,this.ischild);
  MenuAssistant.fromJson(Map<String, dynamic> json) {
    id=json['id'];
    name = json['name'];
    icon = json['icon'];
    if (json['subMenu'] != null) {

      subMenuassi.clear();
      json['subMenu'].forEach((v) {
        subMenuassi.add(MenuAssistant.fromJson(v));
      });
    }
  }
}
