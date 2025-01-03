import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import '../utils/reservation_database.dart';

class RestaurantMapScreen extends StatefulWidget {
  const RestaurantMapScreen({super.key});

  @override
  _RestaurantMapScreenState createState() => _RestaurantMapScreenState();
}

class _RestaurantMapScreenState extends State<RestaurantMapScreen> {
  LatLng _currentLocation = LatLng(3.857251, 11.502263); // Coordonnées par défaut (Yaoundé)
  final List<Marker> _markers = []; // Liste des marqueurs
  bool _isLoading = false; // Indicateur de chargement

  // Liste des restaurants fictifs (exemples)
  final List<Map<String, dynamic>> _restaurants = [
    {'name': 'Dr Shawarma', 'lat': 3.857951, 'lng': 11.502563},
    {'name': 'Chez Fouta', 'lat': 3.858451, 'lng': 11.503063},
    {'name': 'Glacier Italien', 'lat': 3.856951, 'lng': 11.501563},
  ];

  @override
  void initState() {
    super.initState();
    _getUserLocation(); // Récupérer la localisation de l'utilisateur
    _addNearbyRestaurants(); // Ajouter les restaurants fictifs
  }

  // Récupérer les restaurants réels à proximité
  Future<List<Map<String, dynamic>>> fetchNearbyRestaurants(LatLng location) async {
    final url =
        'https://nominatim.openstreetmap.org/search?format=json&q=restaurant&lat=${location.latitude}&lon=${location.longitude}&radius=1000';

    try {
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
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
    } catch (e) {
      throw Exception('Error fetching data: $e');
    }
  }

  // Obtenir la position actuelle de l'utilisateur
  Future<void> _getUserLocation() async {
    setState(() {
      _isLoading = true; // Activer l'indicateur de chargement
    });

    try {
      // Vérifier et demander les permissions de localisation
      final permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied || permission == LocationPermission.deniedForever) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Location permissions are denied.')),
        );
        return;
      }

      // Obtenir la position actuelle
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
                  color: Colors.green, // Marqueurs verts pour les restaurants réels
                ),
              ),
            ),
          );
        }
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error getting location or restaurants: $e')),
      );
    } finally {
      setState(() {
        _isLoading = false; // Désactiver l'indicateur de chargement
      });
    }
  }

  // Ajouter les restaurants fictifs à la carte
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
              child: const Icon(
                Icons.location_pin,
                size: 40,
                color: Colors.red, // Marqueurs rouges pour les restaurants fictifs
              ),
            ),
          ),
        );
      }
    });
  }

  // Afficher une boîte de dialogue pour la réservation
  void _showReservationDialog(String restaurantName) {
    DateTime selectedDate = DateTime.now();
    TimeOfDay selectedTime = TimeOfDay.now();

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('Reserve an Appointment with $restaurantName'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Sélecteur de date
            TextButton(
              onPressed: () async {
                final pickedDate = await showDatePicker(
                  context: ctx,
                  initialDate: selectedDate,
                  firstDate: DateTime.now(),
                  lastDate: DateTime.now().add(const Duration(days: 30)),
                );
                if (pickedDate != null) {
                  setState(() {
                    selectedDate = pickedDate;
                  });
                }
              },
              child: Text('Select Date: ${selectedDate.toLocal()}'.split(' ')[0]),
            ),
            // Sélecteur d'heure
            TextButton(
              onPressed: () async {
                final pickedTime = await showTimePicker(
                  context: ctx,
                  initialTime: selectedTime,
                );
                if (pickedTime != null) {
                  setState(() {
                    selectedTime = pickedTime;
                  });
                }
              },
              child: Text('Select Time: ${selectedTime.format(context)}'),
            ),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.of(ctx).pop(), child: const Text('Cancel')),
          TextButton(
            onPressed: () {
              _reserveAppointment(restaurantName, selectedDate, selectedTime);
              Navigator.of(ctx).pop();
            },
            child: const Text('Reserve'),
          ),
        ],
      ),
    );
  }

  // Enregistrer un rendez-vous dans la base de données
  void _reserveAppointment(String restaurantName, DateTime date, TimeOfDay time) async {
    final String formattedDate =
        '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
    final String formattedTime =
        '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}';

    await ReservationDatabase.addReservation(
      restaurantName,
      '$formattedDate $formattedTime',
      'restaurant', // Spécifier que le type est "restaurant"
    );

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Table reserved at $restaurantName on $formattedDate at $formattedTime'),
      ),
    );
  }




  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Nearest Restaurants')),
      body: Stack(
        children: [
          // Carte avec marqueurs
          FlutterMap(
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
          // Afficher un indicateur de chargement pendant la récupération des données
          if (_isLoading)
            const Center(
              child: CircularProgressIndicator(),
            ),
        ],
      ),
    );
  }
}
