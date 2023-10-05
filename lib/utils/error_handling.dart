import 'dart:io';

Map<String,dynamic> errorHandle(Exception exception){
    if(exception is SocketException){
        return {'status': false, "Message": "please check your internet connection."};
    }
    return {'status': false, "Message": "something went wrong"};
}