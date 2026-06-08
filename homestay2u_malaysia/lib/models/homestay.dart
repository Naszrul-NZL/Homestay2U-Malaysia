import 'dart:convert';

class Homestay {

  final int id;
  final String name;
  final String state;
  final String district;
  final String description;
  final int priceMin;
  final String imageUrl;

  Homestay ({

    required this.id,
    required this.name,
    required this.state,
    required this.district,
    required this.description,
    required this.priceMin,
    required this.imageUrl

  });

  factory Homestay.fromJson(Map<String, dynamic>json){
    return Homestay(id: json['id'], 
    name: json['name'], 
    state: json['state'], 
    district: json['district'], 
    description: json['description'], 
    priceMin: json['priceMin'], 
    imageUrl:json['imageUrl']
    );

  }

}