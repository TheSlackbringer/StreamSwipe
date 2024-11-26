import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'presentation/dependency_injection.dart';
import 'presentation/widgets/bottom_navigation_bar.dart';
import 'presentation/widgets/pages/auth_guard.dart';
import 'presentation/widgets/pages/signin_page.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Supabase.initialize(
    url: 'https://fxxerkigscucidhukisd.supabase.co',
    anonKey: 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImZ4eGVya2lnc2N1Y2lkaHVraXNkIiwicm9sZSI6ImFub24iLCJpYXQiOjE3MzE3MTg4OTYsImV4cCI6MjA0NzI5NDg5Nn0.66U0A7R7CBtX0jfi-Ub1rQq96Z5lpcam-swZqYeBa4U',
  );
  setupDI();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    final supabase = Supabase.instance.client;
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // TRY THIS: Try running your application with "flutter run". You'll see
        // the application has a purple toolbar. Then, without quitting the app,
        // try changing the seedColor in the colorScheme below to Colors.green
        // and then invoke "hot reload" (save your changes or press the "hot
        // reload" button in a Flutter-supported IDE, or press "r" if you used
        // the command line to start the app).
        //
        // Notice that the counter didn't reset back to zero; the application
        // state is not lost during the reload. To reset the state, use hot
        // restart instead.
        //
        // This works for code too, not just values: Most code changes can be
        // tested with just a hot reload.
        colorScheme: ColorScheme.fromSwatch( primarySwatch: Colors.grey,
            brightness: Brightness.dark),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.orange, // Set default color to orange
            foregroundColor: Colors.white, // Set text color
          ),
        ),
        useMaterial3: true,
      ),
      initialRoute: supabase.auth.currentSession != null
          ? '/home'
          : '/signin',
      routes: {
        '/signin': (context) => const SignInScreen(),
      //  '/signup': (context) => const SignInScreen(),
        '/home': (context) => const AuthGuard(child: BottomNavBar()),
      },
    );
  }
}
