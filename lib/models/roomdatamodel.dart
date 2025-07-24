class StudentModel {
  final String id;
  final String name;
  final String phone;
  final String email;
  final String roomId;

  StudentModel({
    required this.id,
    required this.name,
    required this.phone,
    required this.email,
    required this.roomId,
  });

  factory StudentModel.fromMap(Map<String, dynamic> map) {
    return StudentModel(
      id: map['id'],
      name: map['name'],
      phone: map['phone'],
      email: map['email'],
      roomId: map['room_id'],
    );
  }
}
