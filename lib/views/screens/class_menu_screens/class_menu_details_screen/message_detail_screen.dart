import 'package:colegia_atenea/controllers/student_parent_teacher_controller.dart';
import 'package:colegia_atenea/models/single_message_detail_model.dart';
import 'package:colegia_atenea/utils/app_textstyle.dart';
import 'package:colegia_atenea/views/custom_widgets/custom_app_bar_widget.dart';
import 'package:colegia_atenea/views/custom_widgets/custom_loader.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../../../../utils/app_colors.dart';
import '../../../../utils/app_constants.dart';
import 'package:file_picker/file_picker.dart';

class MessageDetailScreen extends StatefulWidget {
  final String messageId;
  final String messageType;

  const MessageDetailScreen(
      {super.key, required this.messageId, required this.messageType});

  @override
  State<StatefulWidget> createState() {
    return MessageDetailScreenChild();
  }
}

class MessageDetailScreenChild extends State<MessageDetailScreen> {
  StudentParentTeacherController? studentParentTeacherController;
  final TextEditingController _replyController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      studentParentTeacherController =
          Provider.of<StudentParentTeacherController>(context, listen: false);
      studentParentTeacherController?.getMessageDetails(
          messageId: widget.messageId);
    });
  }

  @override
  void dispose() {
    _replyController.dispose();
    _scrollController.dispose();
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

  List<MessageDetailItem> _buildMessageList(MessageDetailItem root) {
    List<MessageDetailItem> list = [root];
    if (root.subMessage != null) {
      for (var sub in root.subMessage!) {
        list.addAll(_buildMessageList(sub));
      }
    }
    return list;
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
        canPop: true,
        onPopInvokedWithResult: (res, ctx) {
          studentParentTeacherController?.setIsLoading(isLoading: false);
          studentParentTeacherController?.setMessageDetailItem(
              messageDetailItem: null);
        },
        child: Scaffold(
          appBar: CustomAppBarWidget(
            onLeadingIconClicked: () {
              studentParentTeacherController?.setIsLoading(isLoading: false);
              studentParentTeacherController?.setMessageDetailItem(
                  messageDetailItem: null);
              Get.back();
            },
            title: Consumer<StudentParentTeacherController>(
              builder: (context, ctrl, child) {
                return Text(
                  ctrl.messageDetailItem?.subject ?? "mTitle".tr,
                  style: AppTextStyle.getOutfit500(
                      textSize: 18, textColor: AppColors.white),
                  overflow: TextOverflow.ellipsis,
                );
              },
            ),
          ),
          body: Stack(
            children: [
              Column(
                children: [
                  Expanded(
                    child: Consumer<StudentParentTeacherController>(
                      builder: (context, ctrl, child) {
                        if (ctrl.messageDetailItem == null) {
                          return const SizedBox.shrink();
                        }
                        final currentUserId = ctrl.currentLoggedInUserRole == RoleType.parent
                            ? ctrl.userdata?.parentWpUsrId ?? ""
                            : ctrl.userdata?.wpUsrId ?? "";
                        final messages = _buildMessageList(ctrl.messageDetailItem!);
                        _scrollToBottom();
                        return ListView.builder(
                          controller: _scrollController,
                          padding: const EdgeInsets.all(12),
                          itemCount: messages.length,
                          itemBuilder: (context, index) {
                            final msg = messages[index];
                            final isMe = msg.sId == currentUserId;
                            return _ChatBubble(
                              message: msg,
                              isMe: isMe,
                            );
                          },
                        );
                      },
                    ),
                  ),
                  _ReplyBar(
                    controller: _replyController,
                    onSend: (String? filePath) async {
                      final text = _replyController.text.trim();
                      if (text.isEmpty && filePath == null) return;
                      final ctrl = studentParentTeacherController;
                      if (ctrl == null) return;
                      final mainMId = ctrl.messageDetailItem?.mainMId ?? ctrl.messageDetailItem?.mid ?? "";
                      final receiverId = widget.messageType == "Recibidas"
                          ? ctrl.messageDetailItem?.sId
                          : ctrl.messageDetailItem?.rId;
                      if (filePath != null) {
                        ctrl.setSelectedFilePath(selectedFilePath: filePath);
                      }
                      _replyController.clear();
                      final res = await ctrl.sendMessage(
                        messageSubject: ctrl.messageDetailItem?.subject ?? "",
                        description: text,
                        receiverId: receiverId,
                        replyId: mainMId,
                      );
                      ctrl.setSelectedFilePath(selectedFilePath: null);
                      if (res['status'] == true) {
                        ctrl.getMessageDetails(messageId: widget.messageId);
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
              })
            ],
          ),
        ));
  }
}

class _ChatBubble extends StatelessWidget {
  final MessageDetailItem message;
  final bool isMe;

  const _ChatBubble({required this.message, required this.isMe});

  @override
  Widget build(BuildContext context) {
    final bubbleColor = isMe
        ? const Color(0xFFEAF3DE)
        : const Color(0xFFE6F1FB);
    final nameColor = isMe
        ? const Color(0xFF3B6D11)
        : const Color(0xFF185FA5);
    final name = isMe
        ? (message.name ?? "")
        : (message.name ?? "");

    String timeStr = "";
    if (message.mDate != null && message.mDate!.isNotEmpty) {
      try {
        timeStr = DateFormat("dd/MM/yyyy HH:mm").format(DateTime.parse(message.mDate!));
      } catch (_) {}
    }

    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        mainAxisAlignment: isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (!isMe) ...[
            CircleAvatar(
              radius: 16,
              backgroundColor: const Color(0xFFB5D4F4),
              backgroundImage: message.image != null && message.image!.isNotEmpty
                  ? NetworkImage(message.image!)
                  : null,
              child: message.image == null || message.image!.isEmpty
                  ? Text(
                      (message.name ?? "?").isNotEmpty ? message.name![0].toUpperCase() : "?",
                      style: const TextStyle(fontSize: 12, color: Color(0xFF0C447C)),
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
                  Text(
                    name,
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      color: nameColor,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    message.msg ?? "",
                    style: const TextStyle(fontSize: 14, color: Color(0xFF333333)),
                  ),
                  const SizedBox(height: 4),
                  if (message.attachments != null && message.attachments!.isNotEmpty)
                    GestureDetector(
                      onTap: () {
                        Provider.of<StudentParentTeacherController>(context, listen: false)
                            .openUrl(url: message.attachments ?? "");
                      },
                      child: Padding(
                        padding: const EdgeInsets.only(top: 6),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(Icons.attach_file, size: 14, color: Colors.blueGrey),
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
              backgroundImage: message.image != null && message.image!.isNotEmpty
                  ? NetworkImage(message.image!)
                  : null,
              child: message.image == null || message.image!.isEmpty
                  ? Text(
                      (message.name ?? "?").isNotEmpty ? message.name![0].toUpperCase() : "?",
                      style: const TextStyle(fontSize: 12, color: Color(0xFF3B6D11)),
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
                  const Icon(Icons.attach_file, size: 14, color: Colors.blueGrey),
                  const SizedBox(width: 4),
                  Expanded(
                    child: Text(
                      _selectedFilePath!.split("/").last,
                      style: const TextStyle(fontSize: 12, color: Colors.blueGrey),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  GestureDetector(
                    onTap: () => setState(() => _selectedFilePath = null),
                    child: const Icon(Icons.close, size: 16, color: Colors.grey),
                  ),
                ],
              ),
            ),
          Row(
            children: [
              GestureDetector(
                onTap: () async {
                  final result = await FilePicker.platform.pickFiles();
                  if (result != null && result.files.single.path != null) {
                    setState(() => _selectedFilePath = result.files.single.path);
                  }
                },
                child: Container(
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                    color: AppColors.secondary.withValues(alpha: 0.08),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.attach_file, size: 18, color: Colors.blueGrey),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: TextField(
                  controller: widget.controller,
                  maxLines: null,
                  decoration: InputDecoration(
                    hintText: "Escribe una respuesta...",
                    hintStyle: TextStyle(
                      fontSize: 14,
                      color: AppColors.secondary.withValues(alpha: 0.5),
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                      borderSide: BorderSide(color: AppColors.secondary.withValues(alpha: 0.2)),
                    ),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
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
                  child: const Icon(Icons.send, color: Colors.white, size: 18),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
