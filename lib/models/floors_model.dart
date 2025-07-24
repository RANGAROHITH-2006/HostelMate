class Floor {
  final String id;
  final String hostelId;
  final int floorNumber;

  Floor({
    required this.id,
    required this.hostelId,
    required this.floorNumber,
  });

  factory Floor.fromMap(Map<String, dynamic> map) {
    return Floor(
      id: map['id'],
      hostelId: map['hostel_id'],
      floorNumber: map['floor_number'],
    );
  }
}
