import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class RestaurantMapScreen extends StatefulWidget {
  @override
  _RestaurantMapScreenState createState() => _RestaurantMapScreenState();
}

class _RestaurantMapScreenState extends State<RestaurantMapScreen> {
  LatLng _currentLocation = LatLng(3.857251, 11.502263); // Coordonnées par défaut
  final List<Marker> _markers = [];

  final List<Map<String, dynamic>> _restaurants = [
    {'name': 'Dr Shawarma', 'lat': 3.857951, 'lng': 11.502563},
    {'name': 'Chez Fouta', 'lat': 3.858451, 'lng': 11.503063},
    {'name': 'Glacier Italien', 'lat': 3.856951, 'lng': 11.501563},
  ];

  Future<List<Map<String, dynamic>>> fetchNearbyRestaurants(LatLng location) async {
    final url =
        'https://nominatim.openstreetmap.org/search?format=json&q=restaurant&lat=${location.latitude}&lon=${location.longitude}&radius=1000';
    print('Nominatim URL: $url'); // Vérifiez l'URL

    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      print('Restaurants from API: ${data.length}'); // Vérifiez les données récupérées
      return data.map((item) {
        return {
          'name': item['display_name'],
          'lat': double.parse(item['lat']),
          'lng': double.parse(item['lon']),
        };
      }).toList();
    } else {
      throw Exception('Failed to fetch restaurants');
    }
  }

  @override
  void initState() {
    super.initState();
    _getUserLocation();
    _addNearbyRestaurants(); // Ajout explicite des restaurants fictifs
  }

  Future<void> _getUserLocation() async {
    try {
      Position position = await Geolocator.getCurrentPosition(
        locationSettings: LocationSettings(accuracy: LocationAccuracy.high),
      );

      setState(() {
        _currentLocation = LatLng(position.latitude, position.longitude);
      });

      // Charger les restaurants réels
      List<Map<String, dynamic>> nearbyRestaurants = await fetchNearbyRestaurants(_currentLocation);

      // Ajouter les marqueurs pour les restaurants réels
      setState(() {
        for (var restaurant in nearbyRestaurants) {
          _markers.add(
            Marker(
              point: LatLng(restaurant['lat'], restaurant['lng']),
              child: GestureDetector(
                onTap: () {
                  _showReservationDialog(restaurant['name']);
                },
                child: const Icon(
                  Icons.location_pin,
                  size: 40,
                  color: Colors.green,
                ),
              ),
            ),
          );
        }
      });
      print('Markers added (real): ${_markers.length}');
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error getting location or restaurants: $e')),
      );
    }
  }


  void _addNearbyRestaurants() {
    setState(() {
      for (var restaurant in _restaurants) {
        _markers.add(
          Marker(
            point: LatLng(restaurant['lat'], restaurant['lng']),
            child: GestureDetector(
              onTap: () {
                _showReservationDialog(restaurant['name']);
              },
              child: const Icon(Icons.location_pin, size: 40, color: Colors.red),
            ),
          ),
        );
      }
      print('Markers added (fictitious): ${_markers.length}');
    });
  }

  void _showReservationDialog(String restaurantName) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('Reserve a Table at $restaurantName'),
        content: const Text('Do you want to reserve a table?'),
        actions: [
          TextButton(onPressed: () => Navigator.of(ctx).pop(), child: const Text('Cancel')),
          TextButton(onPressed: () => Navigator.of(ctx).pop(), child: const Text('Reserve')),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Nearest Restaurants')),
      body: FlutterMap(
        options: MapOptions(
          initialCenter: _currentLocation,
          initialZoom: 14.0,
        ),
        children: [
          TileLayer(
            urlTemplate: 'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png',
            subdomains: ['a', 'b', 'c'],
          ),
          MarkerLayer(markers: _markers),
        ],
      ),
    );
  }
}
