import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';
import '../utils/reservation_database.dart';

class DietitianMapScreen extends StatefulWidget {
  @override
  _DietitianMapScreenState createState() => _DietitianMapScreenState();
}

class _DietitianMapScreenState extends State<DietitianMapScreen> {
  LatLng _currentLocation = LatLng(3.857251, 11.502263); // Coordonnées par défaut
  final List<Marker> _markers = [];
  final List<Map<String, dynamic>> _dietitians = [
    {'name': 'Dr. Nutrition Yaoundé', 'lat': 3.857851, 'lng': 11.503163},
    {'name': 'Healthy Life Clinic', 'lat': 3.858451, 'lng': 11.502963},
    {'name': 'Dietitian Expert Center', 'lat': 3.856951, 'lng': 11.504263},
  ];

  @override
  void initState() {
    super.initState();
    _getUserLocation();
    _addNearbyDietitians();
  }

  Future<void> _getUserLocation() async {
    try {
      Position position = await Geolocator.getCurrentPosition(
        locationSettings: LocationSettings(accuracy: LocationAccuracy.high),
      );

      setState(() {
        _currentLocation = LatLng(position.latitude, position.longitude);
      });

      _markers.add(
        Marker(
          point: _currentLocation,
          child: const Icon(
            Icons.my_location,
            size: 40,
            color: Colors.blue,
          ),
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error getting location: $e')),
      );
    }
  }

  void _addNearbyDietitians() {
    setState(() {
      for (var dietitian in _dietitians) {
        _markers.add(
          Marker(
            point: LatLng(dietitian['lat'], dietitian['lng']),
            child: GestureDetector(
              onTap: () {
                _showReservationDialog(dietitian['name']);
              },
              child: const Icon(
                Icons.person_pin_circle,
                size: 40,
                color: Colors.blue,
              ),
            ),
          ),
        );
      }
    });
  }

  void _showReservationDialog(String dietitianName) {
    DateTime selectedDate = DateTime.now();
    TimeOfDay selectedTime = TimeOfDay.now();

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('Reserve an Appointment with $dietitianName'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Select Date: ${selectedDate.toLocal()}'),
            Text('Select Time: ${selectedTime.format(context)}'),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.of(ctx).pop(), child: const Text('Cancel')),
          TextButton(onPressed: () {
            _reserveAppointment(dietitianName, selectedDate, selectedTime);
            Navigator.of(ctx).pop();
          }, child: const Text('Reserve')),
        ],
      ),
    );
  }

  void _reserveAppointment(String dietitianName, DateTime date, TimeOfDay time) async {
    final String formattedDate =
        '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
    final String formattedTime =
        '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}';

    await ReservationDatabase.addReservation(
      dietitianName,
      '$formattedDate $formattedTime',
    );

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Appointment reserved with $dietitianName on $formattedDate at $formattedTime')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Nearest Dietitians')),
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
