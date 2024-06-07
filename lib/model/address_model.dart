import 'package:map/model/position.dart';

class Address {
  String title;
  String id;
  Position position;

  Address({required this.title, required this.id, required this.position});

  factory Address.fromJson(Map<String, dynamic> json) {
    return Address(
        title: json['title'],
        id: json['id'],
        position: Position.fromJson(json['position']));
  }
}



