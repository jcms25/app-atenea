class ListOfMessagesModel {
  bool? status;
  String? message;
  Data? data;

  ListOfMessagesModel({this.status, this.message, this.data});

  ListOfMessagesModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    data = json['data'] != null ? Data.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = status;
    data['message'] = message;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    return data;
  }
}

class Data {
  List<MessageItem>? allMessages;
  List<MessageItem>? receivedMessages;
  List<MessageItem>? sendMessages;
  List<MessageItem>? deleteMessageList;
  List<GroupList>? groupList;
  List<GroupList>? teacherList;

  Data(
      {this.allMessages,
        this.receivedMessages,
        this.sendMessages,
        this.deleteMessageList,
        this.groupList,
        this.teacherList});

  Data.fromJson(Map<String, dynamic> json) {
    if (json['alllist'] != null) {
      allMessages = <MessageItem>[];
      json['alllist'].forEach((v) {
        allMessages!.add(MessageItem.fromJson(v));
      });
    }
    if (json['inboxlist'] != null) {
      receivedMessages = <MessageItem>[];
      json['inboxlist'].forEach((v) {
        receivedMessages!.add(MessageItem.fromJson(v));
      });
    }
    if (json['sendlist'] != null) {
      sendMessages = <MessageItem>[];
      json['sendlist'].forEach((v) {
        sendMessages!.add(MessageItem.fromJson(v));
      });
    }
    if (json['deletelist'] != null) {
      deleteMessageList = <MessageItem>[];
      json['deletelist'].forEach((v) {
        deleteMessageList!.add(MessageItem.fromJson(v));
      });
    }
    if (json['groupList'] != null) {
      groupList = <GroupList>[];
      json['groupList'].forEach((v) {
        groupList!.add(GroupList.fromJson(v));
      });
    }
    if (json['teacherList'] != null) {
      teacherList = <GroupList>[];
      json['teacherList'].forEach((v) {
        teacherList!.add(GroupList.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (allMessages != null) {
      data['alllist'] = allMessages!.map((v) => v.toJson()).toList();
    }
    if (receivedMessages != null) {
      data['inboxlist'] = receivedMessages!.map((v) => v.toJson()).toList();
    }
    if (sendMessages != null) {
      data['sendlist'] = sendMessages!.map((v) => v.toJson()).toList();
    }
    if (deleteMessageList != null) {
      data['deletelist'] = deleteMessageList!.map((v) => v.toJson()).toList();
    }
    if (groupList != null) {
      data['groupList'] = groupList!.map((v) => v.toJson()).toList();
    }
    if (teacherList != null) {
      data['teacherList'] = teacherList!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class MessageItem {
  String? id;
  String? mid;
  String? sId;
  String? rId;
  String? subject;
  String? msg;
  String? replayId;
  String? mainMId;
  String? delStat;
  String? sRead;
  String? rRead;
  String? mDate;
  String? attachments;
  String? senderName;
  String? receiverName;
  String? direction;

  MessageItem(
      {
        this.id,
        this.mid,
        this.sId,
        this.rId,
        this.subject,
        this.msg,
        this.replayId,
        this.mainMId,
        this.delStat,
        this.sRead,
        this.rRead,
        this.mDate,
        this.attachments,
        this.senderName,
        this.receiverName
      });

MessageItem.fromJson(Map<String, dynamic> json) {
    id = json['id']?.toString();
    mid = json['mid']?.toString();
    sId = json['s_id']?.toString();
    rId = json['r_id']?.toString();
    subject = json['subject'];
    msg = json['msg'];
    replayId = json['replay_id']?.toString();
    mainMId = json['main_m_id']?.toString();
    delStat = json['del_stat']?.toString();
    sRead = json['s_read']?.toString();
    rRead = json['r_read']?.toString();
    mDate = json['m_date'];
    attachments = json['attachments']?.toString();
    senderName = json['sender_name'];
    receiverName = json['receiver_name'];
    direction = json['direction'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['mid'] = mid;
    data['s_id'] = sId;
    data['r_id'] = rId;
    data['subject'] = subject;
    data['msg'] = msg;
    data['replay_id'] = replayId;
    data['main_m_id'] = mainMId;
    data['del_stat'] = delStat;
    data['s_read'] = sRead;
    data['r_read'] = rRead;
    data['m_date'] = mDate;
    data['attachments'] = attachments;
    data['sender_name'] = senderName;
    data['receiver_name'] = receiverName;
    data['direction'] = direction;
    return data;
  }
}

class GroupList {
  String? wpUsrId;
  String? fullName;

  GroupList({this.wpUsrId, this.fullName});

  GroupList.fromJson(Map<String, dynamic> json) {
    wpUsrId = json['wp_usr_id'];
    fullName = json['full_name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['wp_usr_id'] = wpUsrId;
    data['full_name'] = fullName;
    return data;
  }
}
