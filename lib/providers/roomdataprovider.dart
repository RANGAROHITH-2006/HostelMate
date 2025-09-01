import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hostelmate/models/roomdatamodel.dart';
import 'package:supabase_flutter/supabase_flutter.dart';


final allStudentsProvider = FutureProvider<List<StudentModel>>((ref) async {
  final response = await Supabase.instance.client
      .from('students')
      .select();

  return (response as List)
      .map((data) => StudentModel.fromMap(data))
      .toList();
});

// Provider to get room information by room ID
final allRoomsProvider = FutureProvider<Map<String, Map<String, dynamic>>>((ref) async {
  final response = await Supabase.instance.client
      .from('rooms')
      .select();

  final Map<String, Map<String, dynamic>> roomsMap = {};
  for (final room in response) {
    roomsMap[room['id']] = room;
  }
  return roomsMap;
});
