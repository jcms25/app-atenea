
import 'package:colegia_atenea/utils/app_images.dart';


String  imagepath=AppImages.dashboard;
String imagepath1=AppImages.people;
String imagepath2=AppImages.calender;
String imagepath3=AppImages.edit;
String imagepath4=AppImages.message;
String imagepath6= AppImages.circular;
bool isswitch=false;


List ParentListspan= [

  {
    "id":1,
    "name": "Escritorio",
    "icon": AppImages.dashboard,
    "submenu":[]
  },
  {
    "id":2,
    "name": "Circulares",
    "icon": AppImages.circular,
    "submenu":[]
  },
  {
    "id":3,
    "name":"Comunicaciones",
    "icon":AppImages.message,
    "submenu":[]
  },
  {
    "id":4,
    "name": "Alumnos",
    "icon": AppImages.people,
    "submenu":[]
  },
  {
    "id":5,
    "name": "Eventos",
    "icon": AppImages.event,
    "submenu":[]
  },


];
List StudentsListspan=[
  {
    "id":7,
    "name": "Escritorio",
    "icon": AppImages.dashboard,
    "submenu":[]
  },
  {
    "id":8,
    "name": "Padres",
    "icon": AppImages.people,
    "submenu":[]
  },
  {
    "id":9,
    "name": "Clases inscritas",
    "icon": AppImages.people,
    "submenu":[]
  },
  {
    "id":10,
    "name": "Eventos",
    "icon": AppImages.calender,
    "submenu":[]
  },

];


class Menuspan {
  var  id;
  int? position=0;
  var Name;
  var name;
  var icon;
  List<Menuspan> subMenuspan = [];
  var ischild;
  Menuspan(this.name,this.subMenuspan,this.icon,this.ischild);
  Menuspan.fromJson(Map<String, dynamic> json) {
    id=json['id'];
    name = json['name'];
    icon = json['icon'];
    if (json['subMenu'] != null) {

      subMenuspan.clear();
      json['subMenu'].forEach((v) {
        subMenuspan.add(Menuspan.fromJson(v));
      });
    }
  }
}
