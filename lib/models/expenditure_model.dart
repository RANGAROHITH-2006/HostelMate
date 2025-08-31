class Expenditure {
  final String id;
  final String hostelId;
  final String item;
  final double cost;
  final DateTime createdAt;

  Expenditure({
    required this.id,
    required this.hostelId,
    required this.item,
    required this.cost,
    required this.createdAt,
  });

  factory Expenditure.fromMap(Map<String, dynamic> map) {
    return Expenditure(
      id: map['id'] as String,
      hostelId: map['hostel_id'] as String,
      item: map['item'] as String,
      cost: (map['cost'] as num).toDouble(),
      createdAt: DateTime.parse(map['created_at'] as String),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'hostel_id': hostelId,
      'item': item,
      'cost': cost,
      'created_at': createdAt.toIso8601String(),
    };
  }
}
