import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hostelmate/services/hostelservices.dart';

// Provider for HostelService
final hostelServiceProvider = Provider<HostelService>((ref) {
  return HostelService();
});

// Provider for hostel ID
final hostelIdProvider = FutureProvider<String?>((ref) async {
  final hostelService = ref.read(hostelServiceProvider);
  return await hostelService.getHostelId();
});

// Provider for hostel name
final hostelNameProvider = FutureProvider<String?>((ref) async {
  final hostelService = ref.read(hostelServiceProvider);
  return await hostelService.getHostelName();
});

// Provider for complete hostel data
final hostelDataProvider = FutureProvider<Map<String, dynamic>?>((ref) async {
  final hostelService = ref.read(hostelServiceProvider);
  return await hostelService.getHostelData();
});

// Add fallback provider
final hostelDataFallbackProvider = FutureProvider<Map<String, dynamic>?>((ref) async {
  final hostelService = ref.read(hostelServiceProvider);
  try {
    return await hostelService.getHostelDataFallback();
  } catch (e) {
    print('Error in hostelDataFallbackProvider: $e');
    return null;
  }
});

// Stream provider for real-time hostel data
final hostelDataStreamProvider = StreamProvider<Map<String, dynamic>?>((ref) {
  final hostelService = ref.read(hostelServiceProvider);
  return hostelService.getHostelDataStream().handleError((error) {
    print('Hostel stream provider error: $error');
    // Fallback to the future provider data
    ref.read(hostelDataFallbackProvider);
  });
});
