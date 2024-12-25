import 'package:cloud_firestore/cloud_firestore.dart';

Future<void> testFirestore() async {
  await FirebaseFirestore.instance.collection('test').add({'name': 'Flutter Setup', 'success': true});
}
