import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hostelmate/Authentication/login_session.dart';
import 'package:hostelmate/router.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Supabase.initialize(
    url: 'https://agvnblcwttnsvrgieqsq.supabase.co',
    anonKey: 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImFndm5ibGN3dHRuc3ZyZ2llcXNxIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NTA2MDk5MDUsImV4cCI6MjA2NjE4NTkwNX0.43oiCmyKjj9wWWVsDdLrYC-pQlaBul-umhB21M-0HhI',
  );
  await LoginSession().checkLogin();
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      title: 'Movies',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.black),
      ),
      routerConfig: route,
    );
  }
}
