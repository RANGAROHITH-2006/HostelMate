import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hostelmate/services/payment_service.dart';

final paymentServiceProvider = Provider<PaymentService>((ref) {
  return PaymentService();
});

final paymentActionProvider = Provider<PaymentAction>((ref) {
  final paymentService = ref.read(paymentServiceProvider);
  return PaymentAction(paymentService);
});

class PaymentAction {
  final PaymentService _paymentService;

  PaymentAction(this._paymentService);

  Future<bool> markStudentPaid(String studentId) async {
    return await _paymentService.updatePaymentStatus(studentId, true);
  }

  Future<bool> markStudentUnpaid(String studentId) async {
    return await _paymentService.updatePaymentStatus(studentId, false);
  }

  Future<bool> markMultipleStudentsPaid(List<String> studentIds) async {
    return await _paymentService.markMultipleStudentsPaid(studentIds);
  }

  Future<bool?> getPaymentStatus(String studentId) async {
    return await _paymentService.getPaymentStatus(studentId);
  }
}
