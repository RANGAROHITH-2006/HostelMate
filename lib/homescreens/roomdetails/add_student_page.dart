import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hostelmate/providers/student_provider.dart';
import 'package:hostelmate/providers/roomdataprovider.dart';
import 'package:hostelmate/models/roomdatamodel.dart';

class AddStudentPage extends ConsumerStatefulWidget {
  final String hostelId;
  final String roomId;
  final bool isEditing;
  final StudentModel? student;

  const AddStudentPage({
    super.key,
    required this.hostelId,
    required this.roomId,
    this.isEditing = false,
    this.student,
  });

  @override
  ConsumerState<AddStudentPage> createState() => _AddStudentPageState();
}

class _AddStudentPageState extends ConsumerState<AddStudentPage> {
  final _formKey = GlobalKey<FormState>();
  final _fullNameController = TextEditingController();
  final _phoneNumberController = TextEditingController();
  final _emailController = TextEditingController();
  final _checkInDateController = TextEditingController();
  final _roomRentController = TextEditingController();
  final _aadharNumberController = TextEditingController();
  final _parentPhoneNumberController = TextEditingController();

  @override
  void initState() {
    super.initState();
    if (widget.isEditing && widget.student != null) {
      // Pre-fill the form with existing student data
      _fullNameController.text = widget.student!.name;
      _phoneNumberController.text = widget.student!.phone;
      _emailController.text = widget.student!.email;
      _checkInDateController.text = widget.student!.checkInDate;
      _roomRentController.text = widget.student!.roomRent.toString();
      _aadharNumberController.text = widget.student!.aadharNumber;
      _parentPhoneNumberController.text = widget.student!.parentPhoneNumber;
    }
  }

  @override
  Widget build(BuildContext context) {
    // Debug print to check room ID
    print('Room ID being used: ${widget.roomId}');
    print('Hostel ID being used: ${widget.hostelId}');
    
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: Text(
          widget.isEditing ? "Edit Student" : "Add Student",
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        backgroundColor: const Color(0xFF0B1E38),
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header section
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
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
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Icon(
                        Icons.person_add,
                        color: Colors.white,
                        size: 24,
                      ),
                    ),
                    const SizedBox(width: 16),
                    const Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Student Information',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          'Fill in the details below',
                          style: TextStyle(
                            color: Colors.white70,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              
              const SizedBox(height: 24),

              // Form fields
              _buildFormField(
                controller: _fullNameController,
                label: "Full Name",
                icon: Icons.person,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Please enter the full name";
                  }
                  return null;
                },
              ),
              
              const SizedBox(height: 16),
              
              _buildFormField(
                controller: _phoneNumberController,
                label: "Phone Number",
                icon: Icons.phone,
                keyboardType: TextInputType.phone,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Please enter the phone number";
                  }
                  return null;
                },
              ),
              
              const SizedBox(height: 16),
              
              _buildFormField(
                controller: _emailController,
                label: "Email Address (Optional)",
                icon: Icons.email,
                keyboardType: TextInputType.emailAddress,
              ),
              
              const SizedBox(height: 16),
              
              _buildDateField(
                controller: _checkInDateController,
                label: "Check-in Date",
                icon: Icons.calendar_today,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Please select a check-in date";
                  }
                  return null;
                },
              ),
              
              const SizedBox(height: 16),
              
              _buildFormField(
                controller: _roomRentController,
                label: "Room Rent (₹)",
                icon: Icons.currency_rupee,
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Please enter the room rent";
                  }
                  return null;
                },
              ),
              
              const SizedBox(height: 16),
              
              _buildFormField(
                controller: _aadharNumberController,
                label: "Aadhar Number",
                icon: Icons.credit_card,
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Please enter the Aadhar number";
                  }
                  return null;
                },
              ),
              
              const SizedBox(height: 16),
              
              _buildFormField(
                controller: _parentPhoneNumberController,
                label: "Parent Phone Number",
                icon: Icons.contact_phone,
                keyboardType: TextInputType.phone,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Please enter the parent's phone number";
                  }
                  return null;
                },
              ),
              
              const SizedBox(height: 32),
              
              // Action buttons
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () async {
                        if (_formKey.currentState!.validate()) {
                          try {
                            if (widget.isEditing && widget.student != null) {
                              // Update existing student
                              await ref.read(studentProvider.notifier).updateStudent(
                                studentId: widget.student!.id,
                                fullName: _fullNameController.text,
                                phoneNumber: _phoneNumberController.text,
                                email: _emailController.text,
                                checkInDate: _checkInDateController.text,
                                roomRent: double.parse(_roomRentController.text),
                                aadharNumber: _aadharNumberController.text,
                                parentPhoneNumber: _parentPhoneNumberController.text,
                              );
                              
                              // Show success message
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('Student updated successfully!'),
                                  backgroundColor: Colors.green,
                                ),
                              );
                            } else {
                              // Add new student
                              await ref.read(studentProvider.notifier).addStudent(
                                hostelId: widget.hostelId,
                                roomId: widget.roomId,
                                fullName: _fullNameController.text,
                                phoneNumber: _phoneNumberController.text,
                                email: _emailController.text,
                                checkInDate: _checkInDateController.text,
                                roomRent: double.parse(_roomRentController.text),
                                aadharNumber: _aadharNumberController.text,
                                parentPhoneNumber: _parentPhoneNumberController.text,
                              );
                              
                              // Show success message
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('Student added successfully!'),
                                  backgroundColor: Colors.green,
                                ),
                              );
                            }
                            
                            // Refresh the students data
                            ref.invalidate(allStudentsProvider);
                            
                            Navigator.pop(context);
                          } catch (e) {
                            // Show error message
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text('Error ${widget.isEditing ? "updating" : "adding"} student: $e'),
                                backgroundColor: Colors.red,
                              ),
                            );
                          }
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        elevation: 2,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(widget.isEditing ? Icons.update : Icons.save, size: 20),
                          const SizedBox(width: 8),
                          Text(
                            widget.isEditing ? "Update Student" : "Save Student",
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.grey[300],
                        foregroundColor: Colors.grey[800],
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        elevation: 2,
                      ),
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.cancel, size: 20),
                          SizedBox(width: 8),
                          Text(
                            "Cancel",
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFormField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    TextInputType? keyboardType,
    String? Function(String?)? validator,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: TextFormField(
        controller: controller,
        keyboardType: keyboardType,
        validator: validator,
        decoration: InputDecoration(
          labelText: label,
          prefixIcon: Icon(
            icon,
            color: const Color(0xFF0B1E38),
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: Colors.grey[300]!),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: Colors.grey[300]!),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Color(0xFF0B1E38), width: 2),
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Colors.red),
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Colors.red, width: 2),
          ),
          filled: true,
          fillColor: Colors.white,
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          labelStyle: TextStyle(color: Colors.grey[600]),
        ),
      ),
    );
  }

  Widget _buildDateField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    String? Function(String?)? validator,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: TextFormField(
        controller: controller,
        readOnly: true,
        validator: validator,
        onTap: () async {
          FocusScope.of(context).requestFocus(FocusNode());
          final date = await showDatePicker(
            context: context,
            initialDate: DateTime.now(),
            firstDate: DateTime(2000),
            lastDate: DateTime(2100),
          );
          if (date != null) {
            controller.text = "${date.day}/${date.month}/${date.year}";
          }
        },
        decoration: InputDecoration(
          labelText: label,
          prefixIcon: Icon(
            icon,
            color: const Color(0xFF0B1E38),
          ),
          suffixIcon: const Icon(
            Icons.arrow_drop_down,
            color: Color(0xFF0B1E38),
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: Colors.grey[300]!),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: Colors.grey[300]!),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Color(0xFF0B1E38), width: 2),
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Colors.red),
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Colors.red, width: 2),
          ),
          filled: true,
          fillColor: Colors.white,
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          labelStyle: TextStyle(color: Colors.grey[600]),
        ),
      ),
    );
  }
}
