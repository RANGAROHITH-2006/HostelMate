class StudentModel {
  final String id;
  final String name;
  final String phone;
  final String email;
  final String roomId;
  final String hostelId;
  final String checkInDate;
  final double roomRent;
  final String aadharNumber;
  final String parentPhoneNumber;

  StudentModel({
    required this.id,
    required this.name,
    required this.phone,
    required this.email,
    required this.roomId,
    required this.hostelId,
    required this.checkInDate,
    required this.roomRent,
    required this.aadharNumber,
    required this.parentPhoneNumber,
  });

  factory StudentModel.fromMap(Map<String, dynamic> map) {
    return StudentModel(
      id: map['id']?.toString() ?? '',
      name: map['full_name']?.toString() ?? '',
      phone: map['phone_number']?.toString() ?? '',
      email: map['email']?.toString() ?? '',
      roomId: map['room_id']?.toString() ?? '',
      hostelId: map['hostel_id']?.toString() ?? '',
      checkInDate: map['check_in_date']?.toString() ?? '',
      roomRent: (map['room_rent'] as num?)?.toDouble() ?? 0.0,
      aadharNumber: map['aadhar_number']?.toString() ?? '',
      parentPhoneNumber: map['parent_phone_number']?.toString() ?? '',
    );
  }
}
