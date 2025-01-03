import 'package:flutter/material.dart';

import '../utils/reservation_database.dart';

class ReservationHistoryScreen extends StatelessWidget {
  const ReservationHistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2, // Deux onglets : restaurants et diététiciens
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Reservation History'),
          bottom: const TabBar(
            tabs: [
              Tab(text: 'Restaurants'),
              Tab(text: 'Dietitians'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            _buildReservationList('restaurant'), // Liste des restaurants
            _buildReservationList('dietitian'), // Liste des diététiciens
          ],
        ),
      ),
    );
  }

  Widget _buildReservationList(String type) {
    return FutureBuilder(
      future: ReservationDatabase.getReservationsByType(type),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasError) {
          return Center(
            child: Text(
              'Error fetching reservations: ${snapshot.error}',
              style: const TextStyle(color: Colors.red),
            ),
          );
        }

        final reservations = snapshot.data as List<Map<String, dynamic>>;

        if (reservations.isEmpty) {
          return const Center(
            child: Text(
              'No reservations yet.',
              style: TextStyle(fontSize: 16, fontStyle: FontStyle.italic),
            ),
          );
        }

        return ListView.builder(
          itemCount: reservations.length,
          itemBuilder: (ctx, index) {
            final reservation = reservations[index];
            return Card(
              margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
              child: ListTile(
                leading: CircleAvatar(
                  backgroundColor: Colors.blue.shade100,
                  child: Icon(
                    type == 'restaurant' ? Icons.restaurant : Icons.person,
                  ),
                ),
                title: Text(
                  reservation['name'],
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                subtitle: Text(
                  reservation['datetime'],
                  style: const TextStyle(color: Colors.grey),
                ),
                trailing: IconButton(
                  icon: const Icon(Icons.delete, color: Colors.red),
                  onPressed: () {
                    _deleteReservation(context, reservation['id']);
                  },
                ),
              ),
            );
          },
        );
      },
    );
  }

  // Suppression d'une réservation
  void _deleteReservation(BuildContext context, int id) async {
    await ReservationDatabase.deleteReservation(id);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Reservation deleted.')),
    );
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (context) => const ReservationHistoryScreen()),
    );
  }
}
