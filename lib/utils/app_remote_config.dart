// import 'package:firebase_remote_config/firebase_remote_config.dart';
//
// class AppRemoteConfig{
//
//
//    static FirebaseRemoteConfig? _firebaseRemoteConfig;
//
//    static Future<void> initializeRemoteConfig() async{
//      _firebaseRemoteConfig = FirebaseRemoteConfig.instance;
//
//      await _firebaseRemoteConfig!.setConfigSettings(RemoteConfigSettings(
//        fetchTimeout: const Duration(seconds: 20),
//        minimumFetchInterval: const Duration(hours: 0), // use Duration.zero in dev
//      ));
//    }
//    static FirebaseRemoteConfig? get  firebaseRemoteConfig => _firebaseRemoteConfig;
//
// }