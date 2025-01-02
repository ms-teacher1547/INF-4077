import 'package:flutter/material.dart';
import '../utils/reservation_database.dart';

class ReservationHistoryScreen extends StatelessWidget {
  const ReservationHistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Reservation History')),
      body: FutureBuilder(
        future: ReservationDatabase.getReservations(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          final reservations = snapshot.data as List<Map<String, dynamic>>;

          if (reservations.isEmpty) {
            return const Center(child: Text('No reservations yet.'));
          }

          return ListView.builder(
            itemCount: reservations.length,
            itemBuilder: (ctx, index) {
              final reservation = reservations[index];
              return ListTile(
                title: Text(reservation['name']),
                subtitle: Text(reservation['datetime']),
              );
            },
          );
        },
      ),
    );
  }
}
