import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:homestay2u_malaysia/models/homestay.dart';
class ApiPath {

  static String get baseUrl {

    if(kIsWeb){
      return "https://corsproxy.io/?http://slum78.myddns.me/homestay2u/api";

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

  static Future<List<Homestay>> getHomestays () async{
    final response = await http.get(Uri.parse(homestays));
    print('Status: ${response.statusCode}');
    print('Body: ${response.body}');
    if (response.statusCode == 200) {

      final Map<String, dynamic> jsonBody = jsonDecode(response.body);
      final List<dynamic> data = jsonBody['data'];
      return data.map((item) => Homestay.fromJson(item)).toList();
      } else {
      throw Exception('Failed to load homestays');
        }
    }

  static Future<List<Homestay>> fetchSearchHomestays(String keyword) async {
    final response =
        await http.get(Uri.parse(searchHomestays(keyword)));

    if (response.statusCode == 200) {
      final Map<String, dynamic> jsonBody = jsonDecode(response.body);
      final List<dynamic> data = jsonBody['data'];
      return data.map((item) => Homestay.fromJson(item)).toList();
    } else {
      throw Exception('Failed to search homestays');

      }

  }

}