import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hostelmate/models/expenditure_model.dart';
import 'package:hostelmate/services/expenditureservices.dart';

// Provider for ExpenditureService
final expenditureServiceProvider = Provider<ExpenditureService>((ref) {
  return ExpenditureService();
});

// Add fallback provider
final expenditureDataProvider = FutureProvider.family<List<Expenditure>, String>((ref, hostelId) async {
  final service = ref.watch(expenditureServiceProvider);
  try {
    return await service.getExpenditures(hostelId);
  } catch (e) {
    print('Error in expenditureDataProvider: $e');
    return <Expenditure>[];
  }
});

// Stream provider for expenditures with real-time updates
final expenditureProvider = StreamProvider.family<List<Expenditure>, String>((ref, hostelId) {
  final service = ref.read(expenditureServiceProvider);
  return service.getExpendituresStream(hostelId).handleError((error) {
    print('Expenditure provider stream error: $error');
    // Fallback to the future provider data
    ref.read(expenditureDataProvider(hostelId));
  });
});

// Provider for expenditure actions
final expenditureActionsProvider = Provider((ref) {
  final service = ref.read(expenditureServiceProvider);
  return ExpenditureActions(ref, service);
});

// Provider for total expenditure
final totalExpenditureProvider = FutureProvider.family<double, String>((ref, hostelId) {
  final service = ref.read(expenditureServiceProvider);
  return service.getTotalExpenditure(hostelId);
});

class ExpenditureActions {
  final Ref ref;
  final ExpenditureService service;
  
  ExpenditureActions(this.ref, this.service);

  Future<void> addExpenditure(String hostelId, String item, double cost) async {
    try {
      await service.addExpenditure(hostelId, item, cost);
      // Refresh both providers
      ref.invalidate(expenditureProvider(hostelId));
      ref.invalidate(expenditureDataProvider(hostelId));
    } catch (e) {
      print('Error in addExpenditure action: $e');
      rethrow;
    }
  }

  Future<void> deleteExpenditure(String expenditureId, String hostelId) async {
    try {
      await service.deleteExpenditure(expenditureId);
      // Refresh both providers
      ref.invalidate(expenditureProvider(hostelId));
      ref.invalidate(expenditureDataProvider(hostelId));
    } catch (e) {
      print('Error in deleteExpenditure action: $e');
      rethrow;
    }
  }
}
