import 'package:colegia_atenea/views/screens/store_screens/order_history_screen.dart';
import 'package:flutter/foundation.dart';

class StoreController extends ChangeNotifier{

    //check box on billing address screen regarding subscribe to email
     bool isOptional = false;
     void setIsOptional({required bool isOptional}){
       this.isOptional = isOptional;
       notifyListeners();
     }


     List<OrderHistory> listOfOrders = [
       OrderHistory(
           orderNumber: "#312709",
           orderDate: "12/02/2024",
           orderStatus: "Completed",
           orderTotal: "€ 7 for all items"),
     ];


    List<OrderHistory> listOfOrders1 = [];

}