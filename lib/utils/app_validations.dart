class AppValidations{


  static String? valueEmptyOrNot(String? value){
    if(value == null || value.isEmpty || value.trim().isEmpty){
      return "Por favor ingrese datos";
    }
    return null;
  }


}