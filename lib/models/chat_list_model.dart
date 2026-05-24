// Modelo de la respuesta del endpoint chat-list
// (modelo conversación = pareja de usuarios / grupo difusor)

class ChatListModel {
  final bool? status;
  final String? message;
  final ChatListData? data;

  ChatListModel({this.status, this.message, this.data});

  factory ChatListModel.fromJson(Map<String, dynamic> json) {
    return ChatListModel(
      status: json['status'],
      message: json['Message'] ?? json['message'],
      data: json['data'] != null
          ? ChatListData.fromJson(json['data'])
          : null,
    );
  }
}

class ChatListData {
  final List<ChatItem> chatList;

  ChatListData({this.chatList = const []});

  factory ChatListData.fromJson(Map<String, dynamic> json) {
    return ChatListData(
      chatList: json['chatlist'] != null
          ? List<ChatItem>.from(
              (json['chatlist'] as List).map((e) => ChatItem.fromJson(e)))
          : [],
    );
  }
}

class ChatItem {
  final String? chatType; // '1to1' | 'group'
  final String? chatId; // wp_user_id del otro usuario | group_name
  final String? name;
  final String? image;
  final String? lastMsg;
  final String? lastSubject;
  final String? lastDate;
  final int unread;

  ChatItem({
    this.chatType,
    this.chatId,
    this.name,
    this.image,
    this.lastMsg,
    this.lastSubject,
    this.lastDate,
    this.unread = 0,
  });

  factory ChatItem.fromJson(Map<String, dynamic> json) {
    return ChatItem(
      chatType: json['chat_type']?.toString(),
      chatId: json['chat_id']?.toString(),
      name: json['name']?.toString(),
      image: json['image']?.toString(),
      lastMsg: json['last_msg']?.toString(),
      lastSubject: json['last_subject']?.toString(),
      lastDate: json['last_date']?.toString(),
      unread: json['unread'] is int
          ? json['unread']
          : int.tryParse(json['unread']?.toString() ?? '0') ?? 0,
    );
  }

  bool get isGroup => chatType == 'group';
}