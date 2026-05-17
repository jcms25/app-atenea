import 'package:colegia_atenea/controllers/student_parent_teacher_controller.dart';
import 'package:colegia_atenea/models/dashboard_model.dart';
import 'package:colegia_atenea/utils/app_textstyle.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../../utils/app_colors.dart';


class ShowEventsBottomSheets extends StatelessWidget {
  final List<EventItemDetail> eventList;
  final Color color;
  const ShowEventsBottomSheets({super.key, required this.eventList, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.sizeOf(context).width,
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(30),
          topRight: Radius.circular(30)
        )
      ),
      padding: const EdgeInsets.all(10),
      child: ScrollConfiguration(
          behavior: ScrollBehavior().copyWith(overscroll: false),
          child: SingleChildScrollView(
        child: Consumer<StudentParentTeacherController>(
            builder : (context,studentParentTeacherController,child){
              return eventList.isEmpty ? Center(
                child: Text(
                  "Sin exámenes",
                  style: AppTextStyle.getOutfit500(textSize: 18, textColor: AppColors.secondary),
                ),
              ) : Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ...eventList.map((e){
                    final itemColor = (e.isOwn == null || e.isOwn == true) ? AppColors.red : AppColors.darkPurple;
                    return Container(
                      width: MediaQuery.of(context).size.width,
                      decoration: BoxDecoration(
                        color: itemColor.withValues(alpha: 0.05),
                        borderRadius: BorderRadius.circular(10)),
                      padding: const EdgeInsets.all(10),
                      margin: const EdgeInsets.only(bottom: 10),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if ((e.className != null && e.className!.isNotEmpty) || (e.subject != null && e.subject!.isNotEmpty))
                            Text(
                            [e.className, e.subject].where((s) => s != null && s!.isNotEmpty).join(' - '),
                            style: AppTextStyle.getOutfit600(textSize: 16, textColor: itemColor),
                            ),
                          if ((e.className != null && e.className!.isNotEmpty) || (e.subject != null && e.subject!.isNotEmpty))
                            const SizedBox(height: 4),
                          Text(e.title,
                              style: AppTextStyle.getOutfit700(
                                  textSize: 20, textColor: itemColor)),
                          const SizedBox(height: 10),
                          Text(
                            e.startDate != null && e.startDate!.isNotEmpty
                                ? DateFormat("dd-MM-yyyy HH:mm").format(DateTime.parse(e.startDate!))
                                : '',
                            style: AppTextStyle.getOutfit600(textSize: 16, textColor: itemColor),
                          ),
                        ],
                      ),
                    );
                  })
                ],
              );
            }
        ),
      )),
    );
  }
}
