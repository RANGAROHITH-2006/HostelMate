import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hostelmate/models/expenditure_model.dart' as ExpenseModel;
import 'package:hostelmate/popupdialogs/floordialog.dart';
import 'package:hostelmate/providers/expenditure_provider.dart';
import 'package:hostelmate/providers/hostel_provider.dart';
import 'package:intl/intl.dart';

class Expenditure extends ConsumerWidget {
  const Expenditure({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final hostelIdAsync = ref.watch(hostelIdProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Expenditures'),
        backgroundColor: const Color(0xFF0B1E38),
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: hostelIdAsync.when(
        data: (hostelId) {
          if (hostelId == null) {
            return const Center(child: Text('No hostel data found'));
          }
          return ExpenditureContent(hostelId: hostelId);
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) => Center(child: Text('Error: $error')),
      ),
    );
  }
}

class ExpenditureContent extends ConsumerWidget {
  final String hostelId;

  const ExpenditureContent({required this.hostelId, super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final expendituresAsync = ref.watch(expenditureProvider(hostelId));
    final totalExpenditureAsync = ref.watch(totalExpenditureProvider(hostelId));

    return Column(
      children: [
        // Header with total expenditure
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(20),
          margin: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [Color(0xFF0B1E38), Color(0xFF1A3A5C)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 8,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            children: [
              const Text(
                'Total Expenditure',
                style: TextStyle(
                  color: Colors.white70,
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 8),
              totalExpenditureAsync.when(
                data: (total) => Text(
                  '₹ ${NumberFormat('#,##0.00').format(total)}',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                loading: () => const Text(
                  '₹ 0.00',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                error: (_, __) => const Text(
                  '₹ 0.00',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ),

        // Add Expense Button
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: () => _showAddExpenditureDialog(context, ref),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                elevation: 2,
              ),
              icon: const Icon(Icons.add, size: 24),
              label: const Text(
                'Add Expense',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
              ),
            ),
          ),
        ),

        const SizedBox(height: 16),

        // Expenditures List
        Expanded(
          child: expendituresAsync.when(
            data: (expenditures) {
              if (expenditures.isEmpty) {
                return const Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.receipt_long,
                        size: 64,
                        color: Colors.grey,
                      ),
                      SizedBox(height: 16),
                      Text(
                        'No expenses yet',
                        style: TextStyle(
                          fontSize: 18,
                          color: Colors.grey,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      SizedBox(height: 8),
                      Text(
                        'Add your first expense by tapping the button above',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                );
              }
              return ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemCount: expenditures.length,
                itemBuilder: (context, index) {
                  final expenditure = expenditures[index];
                  return ExpenditureCard(
                    expenditure: expenditure,
                    onDelete: () => _deleteExpenditure(context, ref, expenditure),
                  );
                },
              );
            },
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (error, _) => Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.error, size: 64, color: Colors.red),
                  const SizedBox(height: 16),
                  Text('Error: $error'),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  void _showAddExpenditureDialog(BuildContext context, WidgetRef ref) {
    showAddExpenditureDialog(
      context: context,
      onSave: (item, cost) async {
        try {
          await ref
              .read(expenditureActionsProvider)
              .addExpenditure(hostelId, item, cost);
          // Refresh both expenditure list and total expenditure
          ref.invalidate(expenditureProvider(hostelId));
          ref.invalidate(totalExpenditureProvider(hostelId));
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Expense added successfully'),
              backgroundColor: Colors.green,
            ),
          );
        } catch (e) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Error adding expense: $e'),
              backgroundColor: Colors.red,
            ),
          );
        }
      },
    );
  }

  void _deleteExpenditure(
      BuildContext context, WidgetRef ref, ExpenseModel.Expenditure expenditure) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Expense'),
        content: Text('Are you sure you want to delete "${expenditure.item}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () async {
              Navigator.pop(context);
              try {
                await ref
                    .read(expenditureActionsProvider)
                    .deleteExpenditure(expenditure.id, hostelId);
                // Refresh both expenditure list and total expenditure
                ref.invalidate(expenditureProvider(hostelId));
                ref.invalidate(totalExpenditureProvider(hostelId));
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Expense deleted successfully'),
                    backgroundColor: Colors.green,
                  ),
                );
              } catch (e) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Error deleting expense: $e'),
                    backgroundColor: Colors.red,
                  ),
                );
              }
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.orange),
            child: const Text('Delete', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }
}

class ExpenditureCard extends StatelessWidget {
  final ExpenseModel.Expenditure expenditure;
  final VoidCallback onDelete;

  const ExpenditureCard({
    required this.expenditure,
    required this.onDelete,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            // Item icon
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.blue.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(
                Icons.receipt,
                color: Colors.blue,
                size: 24,
              ),
            ),
            const SizedBox(width: 16),

            // Item details
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    expenditure.item,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    DateFormat('MMM dd, yyyy • hh:mm a').format(expenditure.createdAt),
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
            ),

            // Cost and delete button
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  '₹ ${NumberFormat('#,##0.00').format(expenditure.cost)}',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.green,
                  ),
                ),
                const SizedBox(height: 8),
                GestureDetector(
                  onTap: onDelete,
                  child: Container(
                    padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      color: Colors.orange.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: const Icon(
                      Icons.delete,
                      color: Colors.orange,
                      size: 20,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}