class Room {
  final String id;
  final String floorId;
  final String hostelId;
  final String roomNumber;
  final int capacity;

  Room({
    required this.id,
    required this.floorId,
    required this.hostelId,
    required this.roomNumber,
    required this.capacity,
  });

  factory Room.fromMap(Map<String, dynamic> map) {
    return Room(
      id: map['id'] as String,
      floorId: map['floor_id'] as String,
      hostelId: map['hostel_id'] as String,
      roomNumber: map['room_number'] ?? '',
      capacity: map['capacity'] != null ? map['capacity'] as int : 0,
    );
  }
}
