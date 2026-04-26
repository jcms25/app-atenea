import 'package:colegia_atenea/models/list_of_messages_model.dart';
import 'package:colegia_atenea/utils/app_textstyle.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../utils/app_colors.dart';

class MessageListWidget extends StatelessWidget {
  final VoidCallback onPressed;
  final MessageItem messageItem;
  final bool showDirection;

  const MessageListWidget(
      {super.key, required this.messageItem, required this.onPressed, this.showDirection = false});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          children: [
            Row(
              children: [
                if (showDirection)
                  Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: Icon(
                      messageItem.direction == 'sent'
                          ? Icons.arrow_outward
                          : Icons.arrow_downward,
                      size: 18,
                      color: messageItem.direction == 'sent'
                          ? Colors.red
                          : Colors.green,
                    ),
                  ),
                Expanded(
                  child: Text(messageItem.subject ?? "",
                      style: AppTextStyle.getOutfit500(
                          textSize: 18, textColor: AppColors.secondary)),
                ),
                const SizedBox(width: 10),
                Text(
                    DateFormat("dd/MM/yy")
                        .format(DateTime.parse(messageItem.mDate ?? "")),
                    style: AppTextStyle.getOutfit400(
                        textSize: 14, textColor: AppColors.secondary))
              ],
            ),
            const SizedBox(height: 10),
            Align(
              alignment: AlignmentDirectional.bottomStart,
              child: Text(
                messageItem.direction == 'sent'
                    ? messageItem.receiverName ?? messageItem.senderName ?? ""
                    : messageItem.senderName ?? messageItem.receiverName ?? "",
                style: AppTextStyle.getOutfit400(
                    textSize: 16, textColor: AppColors.secondary),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
