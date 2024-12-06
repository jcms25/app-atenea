class Transport {
  final bool status;
  final String message;
  final List<TransportItem> data;

  Transport({
    required this.status,
    required this.message,
    required this.data,
  });


  factory Transport.fromJson(Map<String, dynamic> json) => Transport(
    status: json["status"],
    message: json["Message"],
    data: List<TransportItem>.from(json["data"].map((x) => TransportItem.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "Message": message,
    "data": List<dynamic>.from(data.map((x) => x.toJson())),
  };

}

class TransportItem {
  final String id;
  final String routeName;
  final String busNo;
  final String busName;
  final String driverName;
  final String busRoute;
  final String routeFees;
  final String phoneNo;
  final List<String> students;

  TransportItem({
    required this.id,
    required this.routeName,
    required this.busNo,
    required this.busName,
    required this.driverName,
    required this.busRoute,
    required this.routeFees,
    required this.phoneNo,
    required this.students,
  });


  factory TransportItem.fromJson(Map<String, dynamic> json) => TransportItem(
    id: json["id"],
    busNo: json["bus_no"],
    busName: json["bus_name"],
    driverName: json["driver_name"],
    busRoute: json["bus_route"],
    routeFees: json["route_fees"],
    phoneNo: json["phone_no"],
    students: List<String>.from(json["students"].map((x) => x)), routeName: json["route_name"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "bus_no": busNo,
    "bus_name": busName,
    "driver_name": driverName,
    "bus_route": busRoute,
    "route_fees": routeFees,
    "phone_no": phoneNo,
    "students": List<dynamic>.from(students.map((x) => x)),
    "route_name" : routeName
  };

}
