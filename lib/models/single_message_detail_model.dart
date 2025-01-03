class MessageDetails {
  bool? status;
  String? message;
  MessageDetailItem? data;

  MessageDetails({this.status, this.message, this.data});

  MessageDetails.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['Message'];
    data = json['data'] != null ? MessageDetailItem.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = status;
    data['Message'] = message;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    return data;
  }
}

class MessageDetailItem {
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
  String? name;
  String? image;
  String? recevierName;
  String? recevierImage;
  List<String>? subMessage;

  MessageDetailItem(
      {this.mid,
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
        this.name,
        this.image,
        this.recevierName,
        this.recevierImage,
        this.subMessage});

  MessageDetailItem.fromJson(Map<String, dynamic> json) {
    mid = json['mid'];
    sId = json['s_id'];
    rId = json['r_id'];
    subject = json['subject'];
    msg = json['msg'];
    replayId = json['replay_id'];
    mainMId = json['main_m_id'];
    delStat = json['del_stat'];
    sRead = json['s_read'];
    rRead = json['r_read'];
    mDate = json['m_date'];
    attachments = json['attachments'];
    name = json['name'];
    image = json['image'];
    recevierName = json['recevier_name'];
    recevierImage = json['recevier_image'];
    if (json['sub_message'] != null) {
      subMessage = <String>[];
      json['sub_message'].forEach((v) {
        if(v.runtimeType != String){
          subMessage!.add("");
        }
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
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
    data['name'] = name;
    data['image'] = image;
    data['recevier_name'] = recevierName;
    data['recevier_image'] = recevierImage;
    if (subMessage != null) {
      data['sub_message'] = subMessage!.map((v) => v).toList();
    }
    return data;
  }
}
