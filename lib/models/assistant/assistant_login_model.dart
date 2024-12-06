// To parse this JSON data, do
//
//     final assistant = assistantFromJson(jsonString);

import 'dart:convert';

Assistant assistantFromJson(String str) => Assistant.fromJson(json.decode(str));

String assistantToJson(Assistant data) => json.encode(data.toJson());

class Assistant {
  bool status;
  String message;
  String basicAuthToken;
  AssistantUserdata userdata;

  Assistant({
    required this.status,
    required this.message,
    required this.basicAuthToken,
    required this.userdata,
  });

  factory Assistant.fromJson(Map<String, dynamic> json) => Assistant(
    status: json["status"],
    message: json["Message"],
    basicAuthToken: json["basicAuthToken"],
    userdata: AssistantUserdata.fromJson(json["userdata"]),
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "Message": message,
    "basicAuthToken": basicAuthToken,
    "userdata": userdata.toJson(),
  };
}

class AssistantUserdata {
  Data data;
  int id;
  Caps caps;
  String capKey;
  String roles;
  AllCaps allCaps;
  dynamic filter;

  AssistantUserdata({
    required this.data,
    required this.id,
    required this.caps,
    required this.capKey,
    required this.roles,
    required this.allCaps,
    this.filter,
  });

  factory AssistantUserdata.fromJson(Map<String, dynamic> json) => AssistantUserdata(
    data: Data.fromJson(json["data"]),
    id: json["ID"],
    caps: Caps.fromJson(json["caps"]),
    capKey: json["cap_key"],
    roles: json["roles"],
    allCaps: AllCaps.fromJson(json["allcaps"]),
    filter: json["filter"],
  );

  Map<String, dynamic> toJson() => {
    "data": data.toJson(),
    "ID": id,
    "caps": caps.toJson(),
    "cap_key": capKey,
    "roles": roles,
    "allcaps": allCaps.toJson(),
    "filter": filter,
  };
}

class AllCaps {
  bool? editPosts;
  bool? editPrivatePosts;
  bool? editPublishedPosts;
  bool? read;
  bool? readPrivatePages;
  bool? readPrivatePosts;
  bool? assistant;

  AllCaps({
    required this.editPosts,
    required this.editPrivatePosts,
    required this.editPublishedPosts,
    required this.read,
    required this.readPrivatePages,
    required this.readPrivatePosts,
    required this.assistant,
  });

  factory AllCaps.fromJson(Map<String, dynamic> json) => AllCaps(
    editPosts: json["edit_posts"],
    editPrivatePosts: json["edit_private_posts"],
    editPublishedPosts: json["edit_published_posts"],
    read: json["read"],
    readPrivatePages: json["read_private_pages"],
    readPrivatePosts: json["read_private_posts"],
    assistant: json["assistant"],
  );

  Map<String, dynamic> toJson() => {
    "edit_posts": editPosts,
    "edit_private_posts": editPrivatePosts,
    "edit_published_posts": editPublishedPosts,
    "read": read,
    "read_private_pages": readPrivatePages,
    "read_private_posts": readPrivatePosts,
    "assistant": assistant,
  };
}

class Caps {
  bool? assistant;

  Caps({
    required this.assistant,
  });

  factory Caps.fromJson(Map<String, dynamic> json) => Caps(
    assistant: json["assistant"],
  );

  Map<String, dynamic> toJson() => {
    "assistant": assistant,
  };
}

class Data {
  String id;
  String userLogin;
  String userPass;
  String userNicename;
  String userEmail;
  String userUrl;
  DateTime userRegistered;
  String userActivationKey;
  String userStatus;
  String displayName;
  String userRole;
  String className;
  String classId;
  String? cookie;

  Data({
    required this.id,
    required this.userLogin,
    required this.userPass,
    required this.userNicename,
    required this.userEmail,
    required this.userUrl,
    required this.userRegistered,
    required this.userActivationKey,
    required this.userStatus,
    required this.displayName,
    required this.userRole,
    required this.className,
    required this.classId,
    required this.cookie
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    id: json["ID"],
    userLogin: json["user_login"],
    userPass: json["user_pass"],
    userNicename: json["user_nicename"],
    userEmail: json["user_email"],
    userUrl: json["user_url"],
    userRegistered: DateTime.parse(json["user_registered"]),
    userActivationKey: json["user_activation_key"],
    userStatus: json["user_status"],
    displayName: json["display_name"],
    userRole: json["user_role"],
    className: json["class_name"],
    classId: json["class_id"],
    cookie: json["cookies"]
  );

  Map<String, dynamic> toJson() => {
    "ID": id,
    "user_login": userLogin,
    "user_pass": userPass,
    "user_nicename": userNicename,
    "user_email": userEmail,
    "user_url": userUrl,
    "user_registered": userRegistered.toIso8601String(),
    "user_activation_key": userActivationKey,
    "user_status": userStatus,
    "display_name": displayName,
    "user_role": userRole,
    "class_name": className,
    "class_id": classId,
    "cookies" : cookie
  };
}
