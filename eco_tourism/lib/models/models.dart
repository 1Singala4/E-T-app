class Hotel {
  String name;
  String location;
  double price;
  String description;
  List<String> gallery;

  Hotel({
    required this.name,
    required this.location,
    required this.price,
    required this.description,
    required this.gallery,
  });

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'location': location,
      'price': price,
      'description': description,
      'gallery': gallery,
    };
  }

  factory Hotel.fromJson(Map<String, dynamic> json) {
    return Hotel(
      name: json['name'],
      location: json['location'],
      price: json['price'].toDouble(),
      description: json['description'],
      gallery: List<String>.from(json['gallery']),
    );
  }
}

class Transport {
  String name;
  String destination;
  double price;
  String description;
  List<String> gallery;

  Transport({
    required this.name,
    required this.destination,
    required this.price,
    required this.description,
    required this.gallery,
  });

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'destination': destination,
      'price': price,
      'description': description,
      'gallery': gallery,
    };
  }

  factory Transport.fromJson(Map<String, dynamic> json) {
    return Transport(
      name: json['name'],
      destination: json['destination'],
      price: json['price'].toDouble(),
      description: json['description'],
      gallery: List<String>.from(json['gallery']),
    );
  }
}

class CulturalCentre {
  String name;
  String location;
  double price;
  String description;
  List<String> gallery;

  CulturalCentre({
    required this.name,
    required this.location,
    required this.price,
    required this.description,
    required this.gallery,
  });

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'location': location,
      'price': price,
      'description': description,
      'gallery': gallery,
    };
  }

  factory CulturalCentre.fromJson(Map<String, dynamic> json) {
    return CulturalCentre(
      name: json['name'],
      location: json['location'],
      price: json['price'].toDouble(),
      description: json['description'],
      gallery: List<String>.from(json['gallery']),
    );
  }
}

class TouristPlace {
  String name;
  String location;
  double price;
  String description;
  List<String> gallery;

  TouristPlace({
    required this.name,
    required this.location,
    required this.price,
    required this.description,
    required this.gallery,
  });

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'location': location,
      'price': price,
      'description': description,
      'gallery': gallery,
    };
  }

  factory TouristPlace.fromJson(Map<String, dynamic> json) {
    return TouristPlace(
      name: json['name'],
      location: json['location'],
      price: json['price'].toDouble(),
      description: json['description'],
      gallery: List<String>.from(json['gallery']),
    );
  }
}
