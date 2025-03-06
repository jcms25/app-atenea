import 'dart:convert';
import 'dart:io';

import 'package:colegia_atenea/controllers/student_parent_teacher_controller.dart';
import 'package:colegia_atenea/models/login_model.dart';
import 'package:colegia_atenea/services/app_shared_preferences.dart';
import 'package:colegia_atenea/utils/app_constants.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';

import '../services/api.dart';

class EditProfileController extends ChangeNotifier {
  bool isLoading = false;

  void setIsLoading({required bool isLoading}) {
    this.isLoading = isLoading;
    notifyListeners();
  }

  File? pickImageFromFile;

  void setPickedImageFromFile({required File? pickImageFromFile}) {
    this.pickImageFromFile = pickImageFromFile;
    notifyListeners();
  }

  //pick image
  Future<void> pickProfilePicture() async {
    try {
      FilePickerResult? result = await FilePicker.platform
          .pickFiles(allowMultiple: false, type: FileType.image);

      if (result != null) {
        File file = File(result.files.single.path!);
        setPickedImageFromFile(pickImageFromFile: file);
      } else {
        // User canceled the picker
        AppConstants.showCustomToast(
            status: false, message: "Image is not picked.");
      }
    } catch (exception) {
      AppConstants.showCustomToast(status: false, message: "$exception");
    }
  }

  //edit profile
  Future<void> updateProfile({
    required RoleType? role,
    required String cookies,
    required String wpUserId,
    required StudentParentTeacherController studentParentTeacherController,
    String? email,
    String? mobileNumber,
    String? actualAddress,
    String? city,
    String? postalCode,
    String? profileImage,
    String? nif
  }) async {
    try {
      setIsLoading(isLoading: true);

      String token = AppSharedPreferences.getBasicAthToken() ?? "";
      Map<String, String> header = {
        'Content-Type': 'application/x-www-form-urlencoded; charset=UTF-8',
        'Authorization': "Basic $token",
        'Cookie': cookies
      };

      if (role == RoleType.parent &&
          profileImage != null &&
          profileImage.isNotEmpty) {
        MultipartRequest request = MultipartRequest(
            'POST',
            Uri.parse(
                "${Api.localBaseURL}/${Api.updateParentProfile}/$wpUserId"));

        request.headers.addAll(header);
        request.fields["fname"] = "";
        request.fields["mname"] = "";
        request.fields["lname"] = "";
        request.fields["gender"] = "";
        request.fields["dob"] = "";
        request.fields["address"] = actualAddress ?? "";
        request.fields["city"] = city ?? "";
        request.fields["pincode"] = postalCode ?? "";
        request.fields["country"] = "";
        request.fields["phone_number"] = mobileNumber ?? "";
        request.fields["bloodgroup"] = "";
        request.fields["qualification"] = "";
        request.fields["email"] = email ?? "";
        request.fields["nif"] = nif ?? "";
        request.files
            .add(await MultipartFile.fromPath('file_upload', profileImage));
        await request.send().then((res) async {
          var response = await Response.fromStream(res);

          if (response.statusCode == 200) {
            var data = jsonDecode(response.body);
            if (data['status']) {
              Userdata userdata = Userdata.fromJson(data['userdata']);
              AppSharedPreferences.saveUserData(userdata: userdata);
              studentParentTeacherController.setLoginModel(userdata: userdata);
            }
            setPickedImageFromFile(pickImageFromFile: null);
            AppConstants.showCustomToast(
                status: data['status'],
                message: data['Message'] ?? data['message'] ?? "");
          }
        });
      } else {
        await Api.httpRequest(
            requestType: RequestType.post,
            endPoint: role == RoleType.teacher
                ? "${Api.updateTeacherProfile}/$wpUserId"
                : role == RoleType.parent
                ? "${Api.updateParentProfile}/$wpUserId"
                : "${Api.updateStudentProfile}/$wpUserId",
            header: header,
            body: {
              "fname": "",
              "mname": "",
              "lname": "",
              "gender": "",
              "dob": "",
              "address": actualAddress ?? "",
              "city": city ?? "",
              "country": "",
              "pincode": postalCode ?? "",
              "phone_number": mobileNumber ?? "",
              "bloodgroup": "",
              "qualification": "",
              "email": email ?? "",
              "nif" : nif ?? "",
            }).then((res) {
          if (res['status']) {
            Userdata userdata = Userdata.fromJson(res['userdata']);
            AppSharedPreferences.saveUserData(userdata: userdata);
            studentParentTeacherController.setLoginModel(userdata: userdata);
          }
          AppConstants.showCustomToast(
              status: res['status'],
              message: res['Message'] ?? res['message'] ?? "");
        });
      }

      setIsLoading(isLoading: false);
    } catch (exception) {
      setIsLoading(isLoading: false);
      AppConstants.showCustomToast(status: false, message: "$exception");
    }



  }
}
