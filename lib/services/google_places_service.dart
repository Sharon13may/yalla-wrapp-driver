import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:google_maps_flutter/google_maps_flutter.dart';

class PlaceSuggestion {
  final String description;
  final String placeId;

  PlaceSuggestion({
    required this.description,
    required this.placeId,
  });
}

class GooglePlacesService {
  final String apiKey;

  GooglePlacesService({required this.apiKey});

  Future<List<PlaceSuggestion>> getSuggestions(String input) async {
    if (input.isEmpty) return [];

    final url = Uri.parse(
      "https://maps.googleapis.com/maps/api/place/autocomplete/json"
      "?input=$input&key=$apiKey&language=en",
    );

    final response = await http.get(url);
    final data = json.decode(response.body);

    final predictions = data["predictions"] as List;

    return predictions
        .map((e) => PlaceSuggestion(
              description: e["description"],
              placeId: e["place_id"],
            ))
        .toList();
  }

  Future<LatLng> getLatLng(String placeId) async {
    final url = Uri.parse(
      "https://maps.googleapis.com/maps/api/place/details/json"
      "?place_id=$placeId&key=$apiKey",
    );

    final response = await http.get(url);
    final data = json.decode(response.body);

    final location = data["result"]["geometry"]["location"];
    return LatLng(location["lat"], location["lng"]);
  }
}
