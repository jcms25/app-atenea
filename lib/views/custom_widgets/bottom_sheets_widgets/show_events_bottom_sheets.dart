import 'package:colegia_atenea/controllers/student_parent_teacher_controller.dart';
import 'package:colegia_atenea/models/dashboard_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../utils/app_colors.dart';


class ShowEventsBottomSheets extends StatelessWidget {
  final List<EventItemDetail> eventList;
  const ShowEventsBottomSheets({super.key, required this.eventList});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.sizeOf(context).width,
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(10),
          topRight: Radius.circular(10)
        )
      ),
      child: ScrollConfiguration(
          behavior: ScrollBehavior().copyWith(overscroll: false),
          child: SingleChildScrollView(
        child: Consumer<StudentParentTeacherController>(
            builder : (context,studentParentTeacherController,child){
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                    ...eventList.map((e){
                      return Container(child: Text(e.title),);
                    }).toList()
                ],
              );
            }
        ),
      )),
    );
  }
}
