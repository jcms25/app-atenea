import 'package:colegia_atenea/utils/app_colors.dart';

import 'package:colegia_atenea/views/custom_widgets/custom_loader.dart';
import 'package:colegia_atenea/views/screens/send_message_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../controllers/student_parent_teacher_controller.dart';
import '../../models/chat_list_model.dart';
import '../../utils/app_textstyle.dart';
import 'class_menu_screens/class_menu_details_screen/chat_detail_screen.dart';
import 'dart:async';
import 'package:firebase_messaging/firebase_messaging.dart';

class MessageScreen extends StatefulWidget {
  final String studentOrParent;

  const MessageScreen({super.key, required this.studentOrParent});

  @override
  State<MessageScreen> createState() => MessageListScreen();
}

class MessageListScreen extends State<MessageScreen>
    with WidgetsBindingObserver {
  StudentParentTeacherController? studentParentTeacherController;

  // Suscripción a los push recibidos con la app en primer plano.
  StreamSubscription<RemoteMessage>? _fcmSubscription;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      studentParentTeacherController =
          Provider.of<StudentParentTeacherController>(context, listen: false);
      studentParentTeacherController?.getChatList(
          showLoader:
              (studentParentTeacherController?.chatList.isEmpty ?? true));
    });

    // Fase 3: si llega un push de mensaje con la pantalla abierta,
    // refresca la lista de chats en tiempo real.
    _fcmSubscription =
        FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      final String type = message.data["type"] ?? "";
      if (type == "Message" || type == "New Sub Message") {
        _refreshChatList();
      }
    });
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _fcmSubscription?.cancel();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    // La app vuelve a primer plano -> refrescar la lista de chats
    if (state == AppLifecycleState.resumed) {
      _refreshChatList();
    }
  }

  // Recarga la lista de chats sin mostrar el loader (refresco silencioso)
  void _refreshChatList() {
    studentParentTeacherController ??=
        Provider.of<StudentParentTeacherController>(context, listen: false);
    studentParentTeacherController?.getChatList(showLoader: false);
  }

  // Formatea la fecha del último mensaje al estilo de un chat:
  // hoy -> hora; este año -> dd/MM; otro año -> dd/MM/yy
  String _formatChatDate(String? rawDate) {
    if (rawDate == null || rawDate.isEmpty) return "";
    final DateTime? date = DateTime.tryParse(rawDate);
    if (date == null) return "";
    final DateTime now = DateTime.now();
    if (date.year == now.year &&
        date.month == now.month &&
        date.day == now.day) {
      return DateFormat("HH:mm").format(date);
    } else if (date.year == now.year) {
      return DateFormat("dd/MM").format(date);
    } else {
      return DateFormat("dd/MM/yy").format(date);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Stack(
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Cabecera con buscador
              Container(
                  height: 90,
                  width: MediaQuery.of(context).size.width,
                  decoration: const BoxDecoration(
                      borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(20),
                          bottomRight: Radius.circular(20)),
                      color: AppColors.primary),
                  child: Padding(
                    padding: const EdgeInsets.only(left: 15, right: 15),
                    child: Row(
                      children: [
                        Expanded(
                          child: Container(
                            height: 50,
                            decoration: BoxDecoration(
                              color: AppColors.white,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Consumer<StudentParentTeacherController>(
                              builder: (context, appController, child) {
                                return TextField(
                                  autofocus: false,
                                  decoration: InputDecoration(
                                      prefixIcon: IconButton(
                                        icon: const Icon(
                                          Icons.search,
                                          color: AppColors.searchIcon,
                                        ),
                                        onPressed: () {},
                                      ),
                                      hintText: 'searchInList'.tr,
                                      hintStyle: AppTextStyle.getOutfit400(
                                          textSize: 16,
                                          textColor: AppColors.secondary
                                              .withValues(alpha: 0.5)),
                                      contentPadding: const EdgeInsets.all(10),
                                      border: InputBorder.none),
                                  style: AppTextStyle.getOutfit400(
                                      textSize: 18,
                                      textColor: AppColors.secondary),
                                  keyboardType: TextInputType.text,
                                  textInputAction: TextInputAction.done,
                                  cursorColor: AppColors.primary,
                                  onChanged: appController.searchInChatList,
                                );
                              },
                            ),
                          ),
                        ),
                      ],
                    ),
                  )),
              const SizedBox(height: 20),
              // Lista de chats
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: ScrollConfiguration(
                    behavior:
                        const ScrollBehavior().copyWith(overscroll: false),
                    child: Consumer<StudentParentTeacherController>(
                      builder: (context, appController, child) {
                        return appController.tempChatList.isEmpty
                            ? Center(
                                child: Text(
                                  "No hay conversaciones",
                                  style: AppTextStyle.getOutfit400(
                                      textSize: 16,
                                      textColor: AppColors.secondary),
                                ),
                              )
                            : ListView.separated(
                                itemBuilder: (context, index) {
                                  final ChatItem chat =
                                      appController.tempChatList[index];
                                  return ChatListTile(
                                    chat: chat,
                                    formattedDate:
                                        _formatChatDate(chat.lastDate),
                                    onPressed: () async {
                                      await Get.to(() => ChatDetailScreen(
                                            chatType: chat.chatType ?? "1to1",
                                            chatId: chat.chatId ?? "",
                                            chatName: chat.name ?? "",
                                            chatImage: chat.image ?? "",
                                          ));
                                      _refreshChatList();
                                    },
                                  );
                                },
                                separatorBuilder: (context, index) {
                                  return const Divider(
                                      height: 1,
                                      color: AppColors.searchIcon);
                                },
                                itemCount:
                                    appController.tempChatList.length);
                      },
                    ),
                  ),
                ),
              ),
            ],
          ),
          Consumer<StudentParentTeacherController>(
            builder: (context, studentParentTeacherController, child) {
              return Visibility(
                  visible: studentParentTeacherController.isLoading,
                  child: const LoadingLayout());
            },
          ),
        ],
      ),
      floatingActionButton: Consumer<StudentParentTeacherController>(
        builder: (context, studentParentTeacherController, child) {
          return FloatingActionButton(
            onPressed: () {
              Get.to(() => MessageSendScreen(
                  roleType:
                      studentParentTeacherController.currentLoggedInUserRole ??
                          RoleType.teacher));
            },
            backgroundColor: AppColors.primary,
            elevation: 0,
            child: const Icon(
              Icons.add,
              color: AppColors.white,
            ),
          );
        },
      ),
    );
  }
}

// Fila de un chat en la lista
class ChatListTile extends StatelessWidget {
  final ChatItem chat;
  final String formattedDate;
  final VoidCallback onPressed;

  const ChatListTile({
    super.key,
    required this.chat,
    required this.formattedDate,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPressed,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 5),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Avatar
            CircleAvatar(
              radius: 26,
              backgroundColor: AppColors.primary.withValues(alpha: 0.1),
              backgroundImage: (chat.image != null && chat.image!.isNotEmpty)
                  ? NetworkImage(chat.image!)
                  : null,
              child: (chat.image == null || chat.image!.isEmpty)
                  ? Icon(
                      chat.isGroup ? Icons.groups : Icons.person,
                      color: AppColors.primary)
                  : null,
            ),
            const SizedBox(width: 12),
            // Nombre + último mensaje
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    chat.name ?? "",
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: AppTextStyle.getOutfit400(
                        textSize: 16, textColor: AppColors.secondary),
                  ),
                  const SizedBox(height: 3),
                  Text(
                    chat.lastMsg ?? "",
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: AppTextStyle.getOutfit400(
                        textSize: 14,
                        textColor:
                            AppColors.secondary.withValues(alpha: 0.6)),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            // Fecha + badge de no leídos
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  formattedDate,
                  style: AppTextStyle.getOutfit400(
                      textSize: 12,
                      textColor:
                          AppColors.secondary.withValues(alpha: 0.6)),
                ),
                const SizedBox(height: 5),
                if (chat.unread > 0)
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 7, vertical: 2),
                    decoration: BoxDecoration(
                      color: AppColors.primary,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    constraints: const BoxConstraints(minWidth: 22),
                    child: Text(
                      chat.unread > 99 ? "99+" : "${chat.unread}",
                      textAlign: TextAlign.center,
                      style: AppTextStyle.getOutfit400(
                          textSize: 12, textColor: AppColors.white),
                    ),
                  )
                else
                  const SizedBox(height: 19),
              ],
            ),
          ],
        ),
      ),
    );
  }
}