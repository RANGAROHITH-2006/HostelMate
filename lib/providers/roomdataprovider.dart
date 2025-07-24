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
