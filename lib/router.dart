import 'package:go_router/go_router.dart';
import 'package:hostelmate/Authentication/login_session.dart';
import 'package:hostelmate/Authentication/loginpage.dart';
import 'package:hostelmate/Authentication/signuppage.dart';
import 'package:hostelmate/screens/mainscreen.dart';
import 'package:hostelmate/screens/screenpages/all_students_page.dart';
import 'package:hostelmate/homescreens/roomdetails/add_student_page.dart';
import 'package:hostelmate/models/roomdatamodel.dart';

final route = GoRouter(
  initialLocation: '/loginpage',
    redirect: (context, state) {
      final isLoggedIn = LoginSession.loggedIn;
      final loggingIn = state.matchedLocation == '/loginpage' || state.matchedLocation == '/signuppage';

      if (!isLoggedIn && !loggingIn) return '/loginpage';
      if (isLoggedIn && loggingIn) return '/homepage';

      return null;
    },
    refreshListenable: LoginSession(),
  routes: [
    GoRoute(path: '/signuppage',builder: (context,state)=>SignUpPage()),
    GoRoute(path: '/loginpage',builder: (context,state)=>Loginpage()),
    GoRoute(path: '/homepage',builder: (context,state)=>MainScreen()),
    GoRoute(path: '/all_students',builder: (context,state)=>AllStudentsPage()),
    GoRoute(
      path: '/add_student',
      builder: (context, state) {
        final hostelId = state.uri.queryParameters['hostelId'] ?? '';
        final roomId = state.uri.queryParameters['roomId'] ?? '';
        final isEditing = state.uri.queryParameters['isEditing'] == 'true';
        final studentData = state.extra as StudentModel?;
        
        return AddStudentPage(
          hostelId: hostelId,
          roomId: roomId,
          isEditing: isEditing,
          student: studentData,
        );
      },
    ),
  ]
);