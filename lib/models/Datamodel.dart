//
//
//
// import 'package:colegia_atenea/utils/app_images.dart';
//
// String  imagepath=AppImages.dashboard;
// String imagepath1=AppImages.people;
// String imagepath2=AppImages.calender;
// String imagepath3=AppImages.edit;
// String imagepath4=AppImages.message;
// String imagepath6= AppImages.circular;
//
//
// List ParentList = [
//
//   {
//     "id":1,
//     "name": "Desk",
//     "icon": imagepath,
//     "submenu":[]
//   },
//   {
//     "id":2,
//     "name": "Circular",
//     "icon":imagepath6,
//     "submenu":[]
//   },
//   {
//     "id":3,
//     "name":"Message",
//     "icon":imagepath4,
//     "submenu":[]
//   },
//   {
//     "id":4,
//     "name": "Students",
//     "icon": imagepath1,
//     "submenu":[]
//   },
//   {
//     "id":5,
//     "name": "Events",
//     "icon": imagepath2,
//     "submenu":[]
//   },
//
//
// ];
// List StudentsList=[
//   {
//     "id":7,
//     "name": "Desk",
//     "icon": imagepath,
//     "submenu":[]
//   },
//   {
//     "id":8,
//     "name": "Parents",
//     "icon":imagepath1,
//     "submenu":[]
//   },
//   {
//     "id":9,
//     "name": "Enrolled Classes",
//     "icon": imagepath1,
//     "submenu":[
//       // {"id":"A","name": "Time Table","icon":"","submenu":[]},
//       // {"id":"B","name": "Teacher","icon":"","submenu":[]},
//       // {"id":"C","name": "Students","icon":"","submenu":[]},
//       // {"id":"D","name": "Subject","icon":"","submenu":[]},
//       // {"id":"E","name": "Exam","icon":"","submenu":[]},
//       // {"id":"F","name": "Marks","icon":"","submenu":[]},
//       // {"id":"G","name": "Attendance","icon":"","submenu":[]},
//       // {"id":"H","name": "Leave Calender","icon":"","submenu":[]},
//     ]
//   },
//   {
//     "id":10,
//     "name": "Events",
//     "icon": imagepath2,
//     "submenu":[]
//   },
//   // {
//   //   "id":11,
//   //   "name": "Setting",
//   //   "icon": imagepath5,
//   //   "submenu":[]
//   // },
//   // {
//   //   "id":10,
//   //   "name": "Transportation",
//   //   "icon": imagepath3,
//   //   "submenu":[]
//   // },
// ];
//
//
// class Menu {
//   var  id;
//   int? position;
//   var Name;
//   var name;
//   var icon;
//   List<Menu> subMenu = [];
//   var ischild;
//   Menu(this.name,this.subMenu,this.icon,this.ischild);
//   Menu.fromJson(Map<String, dynamic> json) {
//     id=json['id'];
//     name = json['name'];
//     icon = json['icon'];
//     if (json['subMenu'] != null) {
//
//       subMenu.clear();
//       json['subMenu'].forEach((v) {
//         subMenu.add(Menu.fromJson(v));
//       });
//     }
//   }
// }
