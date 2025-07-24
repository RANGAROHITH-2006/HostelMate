import 'package:go_router/go_router.dart';
import 'package:hostelmate/Authentication/login_session.dart';
import 'package:hostelmate/Authentication/loginpage.dart';
import 'package:hostelmate/Authentication/signuppage.dart';
import 'package:hostelmate/screens/mainscreen.dart';

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
  ]
);