import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class HostelService {
  final _client = Supabase.instance.client;

  // Get hostel ID from SharedPreferences
  Future<String?> getHostelId() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('hostel_id');
  }

  // Get hostel name from SharedPreferences
  Future<String?> getHostelName() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('hostel_name');
  }

  // Get complete hostel data from Supabase using stored hostel ID
  Future<Map<String, dynamic>?> getHostelData() async {
    final hostelId = await getHostelId();
    if (hostelId == null) return null;

    final hostel = await _client
        .from('hostels')
        .select()
        .eq('id', hostelId)
        .maybeSingle();

    return hostel;
  }

  // Get hostel data stream for real-time updates
  Stream<Map<String, dynamic>?> getHostelDataStream() async* {
    final hostelId = await getHostelId();
    if (hostelId == null) {
      yield null;
      return;
    }

    yield* _client
        .from('hostels')
        .stream(primaryKey: ['id'])
        .eq('id', hostelId)
        .map((data) => data.isNotEmpty ? data.first : null);
  }
}
