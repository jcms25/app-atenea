// Modelo de la respuesta del endpoint chat-detail
// (todos los mensajes de una conversación, modelo chat unificado)

class ChatDetailModel {
  final bool? status;
  final String? message;
  final ChatDetailData? data;

  ChatDetailModel({this.status, this.message, this.data});

  factory ChatDetailModel.fromJson(Map<String, dynamic> json) {
    return ChatDetailModel(
      status: json['status'],
      message: json['Message'] ?? json['message'],
      data: json['data'] != null
          ? ChatDetailData.fromJson(json['data'])
          : null,
    );
  }
}

class ChatDetailData {
  final ChatHeader? header;
  final List<ChatMessage> messages;

  ChatDetailData({this.header, this.messages = const []});

  factory ChatDetailData.fromJson(Map<String, dynamic> json) {
    return ChatDetailData(
      header: json['header'] != null
          ? ChatHeader.fromJson(json['header'])
          : null,
      messages: json['messages'] != null
          ? List<ChatMessage>.from(
              (json['messages'] as List).map((e) => ChatMessage.fromJson(e)))
          : [],
    );
  }
}

class ChatHeader {
  final String? chatType;
  final String? chatId;
  final String? name;
  final String? image;

  ChatHeader({this.chatType, this.chatId, this.name, this.image});

  factory ChatHeader.fromJson(Map<String, dynamic> json) {
    return ChatHeader(
      chatType: json['chat_type']?.toString(),
      chatId: json['chat_id']?.toString(),
      name: json['name']?.toString(),
      image: json['image']?.toString(),
    );
  }
}

class ChatMessage {
  final int mid;
  final int sId;
  final int rId;
  final String? senderName;
  final String? senderImage;
  final String? subject;
  final String? msg;
  final String? attachments; // url del adjunto, o '' si no hay
  final String? link;
  final String? mDate;
  final int rRead;
  final bool mine;
  final bool isBroadcast;
  final String? groupName;

  ChatMessage({
    this.mid = 0,
    this.sId = 0,
    this.rId = 0,
    this.senderName,
    this.senderImage,
    this.subject,
    this.msg,
    this.attachments,
    this.link,
    this.mDate,
    this.rRead = 0,
    this.mine = false,
    this.isBroadcast = false,
    this.groupName,
  });

  factory ChatMessage.fromJson(Map<String, dynamic> json) {
    // attachments puede llegar como string (url), como lista, o como ''
    String? parsedAttachment;
    final dynamic att = json['attachments'];
    if (att is String && att.isNotEmpty) {
      parsedAttachment = att;
    } else if (att is List && att.isNotEmpty) {
      parsedAttachment = att.first?.toString();
    } else {
      parsedAttachment = '';
    }

    int toInt(dynamic v) =>
        v is int ? v : int.tryParse(v?.toString() ?? '0') ?? 0;

    return ChatMessage(
      mid: toInt(json['mid']),
      sId: toInt(json['s_id']),
      rId: toInt(json['r_id']),
      senderName: json['sender_name']?.toString(),
      senderImage: json['sender_image']?.toString(),
      subject: json['subject']?.toString(),
      msg: json['msg']?.toString(),
      attachments: parsedAttachment,
      link: json['link']?.toString(),
      mDate: json['m_date']?.toString(),
      rRead: toInt(json['r_read']),
      mine: json['mine'] == true,
      isBroadcast: json['is_broadcast'] == true,
      groupName: json['group_name']?.toString(),
    );
  }
}