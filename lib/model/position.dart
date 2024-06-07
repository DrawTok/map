class Position {
  double lat;
  double lng;

  Position({required this.lat, required this.lng});

  factory Position.fromJson(Map<String, dynamic> json) {
    return Position(
      lat: json['lat'],
      lng: json['lng'],
    );
  }
}
