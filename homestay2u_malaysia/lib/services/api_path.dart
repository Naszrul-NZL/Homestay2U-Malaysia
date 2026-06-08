import 'package:flutter/foundation.dart';
import 'package:homestay2u_malaysia/models/homestay.dart';
class ApiPath {

  static String get baseUrl {

    if(kIsWeb){
      return "http://slum78.myddns.me/homestay2u/api";

    }
    switch (defaultTargetPlatform){
      case TargetPlatform.android:
        return "http://slum78.myddns.me/homestay2u/api";
      default:
        return "http://slum78.myddns.me/homestay2u/api";

    }

  } 

  static String endpoint (String path) {
    return "$baseUrl/$path";

  }

  static String get homestays => endpoint("homestays");
  static String get states => endpoint("states");
  static String searchHomestays (String keyword) => endpoint ("homestays?search=$keyword");
  static String filterByState (String state) => endpoint("homestays?state=$state"); 
  static String filterByStateAndDistrict (String state, String district) => endpoint ("homestays?state=$state&district=$district");

}