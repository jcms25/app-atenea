import 'package:colegia_atenea/controllers/student_parent_teacher_controller.dart';
import 'package:colegia_atenea/models/chat_detail_model.dart';
import 'package:colegia_atenea/utils/app_textstyle.dart';
import 'package:colegia_atenea/views/custom_widgets/custom_app_bar_widget.dart';
import 'package:colegia_atenea/views/custom_widgets/custom_loader.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:file_picker/file_picker.dart';
import '../../../../utils/app_colors.dart';
import '../../../../utils/app_constants.dart';
import 'dart:async';
import 'package:firebase_messaging/firebase_messaging.dart';

class ChatDetailScreen extends StatefulWidget {
  final String chatType; // '1to1' | 'group'
  final String chatId;
  final String chatName;
  final String chatImage;

  const ChatDetailScreen({
    super.key,
    required this.chatType,
    required this.chatId,
    required this.chatName,
    required this.chatImage,
  });

  @override
  State<StatefulWidget> createState() => ChatDetailScreenChild();
}

class ChatDetailScreenChild extends State<ChatDetailScreen> {
  StudentParentTeacherController? studentParentTeacherController;
  final TextEditingController _replyController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  // Suscripción a los push recibidos con el chat abierto.
  StreamSubscription<RemoteMessage>? _fcmSubscription;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      studentParentTeacherController =
          Provider.of<StudentParentTeacherController>(context, listen: false);
      studentParentTeacherController?.getChatDetail(
        chatType: widget.chatType,
        chatId: widget.chatId,
      );
      // Fase 2: marcar como leídos los mensajes al abrir el chat
      studentParentTeacherController?.markChatRead(
        chatType: widget.chatType,
        chatId: widget.chatId,
      );
    });

    // Fase 3 (objetivo B): si llega un push de mensaje con el
    // chat abierto, recarga la conversación para mostrar la
    // burbuja nueva. Solo en chats 1-a-1: el chat de grupo es
    // difusión y no recibe mensajes entrantes.
    if (widget.chatType != 'group') {
      _fcmSubscription =
          FirebaseMessaging.onMessage.listen((RemoteMessage message) {
        final String type = message.data["type"] ?? "";
        if (type == "Message" || type == "New Sub Message") {
          studentParentTeacherController?.getChatDetail(
            chatType: widget.chatType,
            chatId: widget.chatId,
            showLoader: false,
          );
          _scrollToBottom();
        }
      });
    }
  }

  @override
  void dispose() {
    _replyController.dispose();
    _scrollController.dispose();
    _fcmSubscription?.cancel();
    super.dispose();
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  bool get _isGroup => widget.chatType == 'group';

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: true,
      onPopInvokedWithResult: (res, ctx) {
        studentParentTeacherController?.setIsLoading(isLoading: false);
        studentParentTeacherController?.setChatDetailData(
            chatDetailData: null);
      },
      child: Scaffold(
        appBar: CustomAppBarWidget(
          onLeadingIconClicked: () {
            studentParentTeacherController?.setIsLoading(isLoading: false);
            studentParentTeacherController?.setChatDetailData(
                chatDetailData: null);
            Get.back();
          },
          title: Text(
            widget.chatName,
            style: AppTextStyle.getOutfit500(
                textSize: 18, textColor: AppColors.white),
            overflow: TextOverflow.ellipsis,
          ),
        ),
        body: Stack(
          children: [
            Column(
              children: [
                Expanded(
                  child: Consumer<StudentParentTeacherController>(
                    builder: (context, ctrl, child) {
                      final data = ctrl.chatDetailData;
                      if (data == null) {
                        return const SizedBox.shrink();
                      }
                      if (data.messages.isEmpty) {
                        return Center(
                          child: Text(
                            "No hay mensajes en esta conversación",
                            style: AppTextStyle.getOutfit400(
                                textSize: 14,
                                textColor: AppColors.secondary),
                          ),
                        );
                      }
                      _scrollToBottom();
                      return ListView.builder(
                        controller: _scrollController,
                        padding: const EdgeInsets.all(12),
                        itemCount: data.messages.length,
                        itemBuilder: (context, index) {
                          final ChatMessage msg = data.messages[index];
                          return _ChatBubble(
                            message: msg,
                            isGroupChat: _isGroup,
                          );
                        },
                      );
                    },
                  ),
                ),
                // En chats de grupo (difusión) no se responde desde aquí
                if (!_isGroup)
                  _ReplyBar(
                    controller: _replyController,
                    onSend: (String? filePath) async {
                      final text = _replyController.text.trim();
                      if (text.isEmpty && filePath == null) return;
                      final ctrl = studentParentTeacherController;
                      if (ctrl == null) return;

                      if (filePath != null) {
                        ctrl.setSelectedFilePath(selectedFilePath: filePath);
                      }
                      _replyController.clear();

                      final res = await ctrl.sendMessage(
                        messageSubject: widget.chatName,
                        description: text,
                        receiverId: widget.chatId,
                      );
                      ctrl.setSelectedFilePath(selectedFilePath: null);

                      if (res['status'] == true) {
                        ctrl.getChatDetail(
                          chatType: widget.chatType,
                          chatId: widget.chatId,
                          showLoader: false,
                        );
                        _scrollToBottom();
                      } else {
                        AppConstants.showCustomToast(
                            status: false,
                            message: res['message'] ?? "Error al enviar");
                      }
                    },
                  ),
              ],
            ),
            Consumer<StudentParentTeacherController>(
              builder: (context, ctrl, child) {
                return Visibility(
                  visible: ctrl.isLoading,
                  child: const Center(child: LoadingLayout()),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

class _ChatBubble extends StatelessWidget {
  final ChatMessage message;
  final bool isGroupChat;

  const _ChatBubble({required this.message, required this.isGroupChat});

  @override
  Widget build(BuildContext context) {
    final bool isMe = message.mine;
    final bubbleColor =
        isMe ? const Color(0xFFEAF3DE) : const Color(0xFFE6F1FB);
    final nameColor =
        isMe ? const Color(0xFF3B6D11) : const Color(0xFF185FA5);

    String timeStr = "";
    if (message.mDate != null && message.mDate!.isNotEmpty) {
      try {
        timeStr = DateFormat("dd/MM/yyyy HH:mm")
            .format(DateTime.parse(message.mDate!));
      } catch (_) {}
    }

    final String displayName = message.senderName ?? "";
    // Etiqueta de difusión: solo en chats 1-a-1 (no en el chat de
    // grupo del profesor, donde sería redundante), y solo si el
    // mensaje es un broadcast con nombre de grupo.
    final bool showBroadcastTag = !isGroupChat &&
        message.isBroadcast &&
        (message.groupName != null && message.groupName!.trim().isNotEmpty);
    final String? avatarUrl = message.senderImage;
    final bool hasAttachment =
        message.attachments != null && message.attachments!.isNotEmpty;

    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        mainAxisAlignment:
            isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (!isMe) ...[
            CircleAvatar(
              radius: 16,
              backgroundColor: const Color(0xFFB5D4F4),
              backgroundImage: (avatarUrl != null && avatarUrl.isNotEmpty)
                  ? NetworkImage(avatarUrl)
                  : null,
              child: (avatarUrl == null || avatarUrl.isEmpty)
                  ? Text(
                      displayName.isNotEmpty
                          ? displayName[0].toUpperCase()
                          : "?",
                      style: const TextStyle(
                          fontSize: 12, color: Color(0xFF0C447C)),
                    )
                  : null,
            ),
            const SizedBox(width: 8),
          ],
          Flexible(
            child: Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: bubbleColor,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(isMe ? 12 : 4),
                  topRight: Radius.circular(isMe ? 4 : 12),
                  bottomLeft: const Radius.circular(12),
                  bottomRight: const Radius.circular(12),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (showBroadcastTag) ...[
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.campaign_outlined,
                            size: 13, color: Colors.grey[600]),
                        const SizedBox(width: 3),
                        Flexible(
                          child: Text(
                            "Enviado a ${message.groupName}",
                            style: TextStyle(
                              fontSize: 10,
                              fontStyle: FontStyle.italic,
                              color: Colors.grey[600],
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 3),
                  ],
                  Text(
                    displayName,
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      color: nameColor,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    message.msg ?? "",
                    style: const TextStyle(
                        fontSize: 14, color: Color(0xFF333333)),
                  ),
                  const SizedBox(height: 4),
                  if (hasAttachment)
                    GestureDetector(
                      onTap: () {
                        Provider.of<StudentParentTeacherController>(context,
                                listen: false)
                            .openUrl(url: message.attachments ?? "");
                      },
                      child: Padding(
                        padding: const EdgeInsets.only(top: 6),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(Icons.attach_file,
                                size: 14, color: Colors.blueGrey),
                            const SizedBox(width: 4),
                            Flexible(
                              child: Text(
                                message.attachments!.split("/").last,
                                style: const TextStyle(
                                  fontSize: 12,
                                  color: Colors.blueGrey,
                                  decoration: TextDecoration.underline,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  Text(
                    timeStr,
                    style: TextStyle(
                      fontSize: 10,
                      color: Colors.grey[500],
                    ),
                    textAlign: TextAlign.right,
                  ),
                ],
              ),
            ),
          ),
          if (isMe) ...[
            const SizedBox(width: 8),
            CircleAvatar(
              radius: 16,
              backgroundColor: const Color(0xFFC0DD97),
              backgroundImage: (avatarUrl != null && avatarUrl.isNotEmpty)
                  ? NetworkImage(avatarUrl)
                  : null,
              child: (avatarUrl == null || avatarUrl.isEmpty)
                  ? Text(
                      displayName.isNotEmpty
                          ? displayName[0].toUpperCase()
                          : "?",
                      style: const TextStyle(
                          fontSize: 12, color: Color(0xFF3B6D11)),
                    )
                  : null,
            ),
          ],
        ],
      ),
    );
  }
}

class _ReplyBar extends StatefulWidget {
  final TextEditingController controller;
  final Future<void> Function(String? filePath) onSend;

  const _ReplyBar({required this.controller, required this.onSend});

  @override
  State<_ReplyBar> createState() => _ReplyBarState();
}

class _ReplyBarState extends State<_ReplyBar> {
  String? _selectedFilePath;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      decoration: BoxDecoration(
        color: AppColors.white,
        border: Border(
          top: BorderSide(color: AppColors.secondary.withValues(alpha: 0.15)),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (_selectedFilePath != null)
            Padding(
              padding: const EdgeInsets.only(bottom: 6),
              child: Row(
                children: [
                  const Icon(Icons.attach_file,
                      size: 14, color: Colors.blueGrey),
                  const SizedBox(width: 4),
                  Expanded(
                    child: Text(
                      _selectedFilePath!.split("/").last,
                      style: const TextStyle(
                          fontSize: 12, color: Colors.blueGrey),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  GestureDetector(
                    onTap: () => setState(() => _selectedFilePath = null),
                    child: const Icon(Icons.close,
                        size: 16, color: Colors.grey),
                  ),
                ],
              ),
            ),
          Row(
            children: [
              GestureDetector(
                onTap: () async {
                  final result = await FilePicker.platform.pickFiles();
                  if (result != null &&
                      result.files.single.path != null) {
                    setState(() =>
                        _selectedFilePath = result.files.single.path);
                  }
                },
                child: Container(
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                    color: AppColors.secondary.withValues(alpha: 0.08),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.attach_file,
                      size: 18, color: Colors.blueGrey),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: TextField(
                  controller: widget.controller,
                  maxLines: null,
                  decoration: InputDecoration(
                    hintText: "Escribe un mensaje...",
                    hintStyle: TextStyle(
                      fontSize: 14,
                      color: AppColors.secondary.withValues(alpha: 0.5),
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                      borderSide: BorderSide(
                          color:
                              AppColors.secondary.withValues(alpha: 0.2)),
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                        horizontal: 14, vertical: 8),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              GestureDetector(
                onTap: () async {
                  await widget.onSend(_selectedFilePath);
                  setState(() => _selectedFilePath = null);
                },
                child: Container(
                  width: 40,
                  height: 40,
                  decoration: const BoxDecoration(
                    color: AppColors.primary,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.send,
                      color: Colors.white, size: 18),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}