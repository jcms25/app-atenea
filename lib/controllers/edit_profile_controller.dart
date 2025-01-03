import 'dart:io';

import 'package:colegia_atenea/utils/app_constants.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';


class EditProfileController extends ChangeNotifier{

   File? pickImageFromFile;
   void setPickedImageFromFile({required File? pickImageFromFile}){
     this.pickImageFromFile = pickImageFromFile;
    notifyListeners();
   }

  //pick image
   void pickProfilePicture() async{
     try{

       FilePickerResult? result = await FilePicker.platform.pickFiles();

       if (result != null) {
         File file = File(result.files.single.path!);
         setPickedImageFromFile(pickImageFromFile: file);
       } else {
         // User canceled the picker
         AppConstants.showCustomToast(status: false, message: "Image is not picked.");
       }

     }catch(exception){
       AppConstants.showCustomToast(status: false, message: "$exception");
     }
   }


}