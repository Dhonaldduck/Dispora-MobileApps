import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

import 'features/auth/providers/auth_provider.dart';
import 'ui/screens/auth/login_screen.dart';
import 'ui/screens/home_screen.dart';

void main() {
  runApp(
    const ProviderScope(
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Dispora Mobile',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF1D4ED8), // Primary Blue
          primary: const Color(0xFF1D4ED8),
          secondary: const Color(0xFFDC2626), // Secondary Red
          tertiary: const Color(0xFF10B981), // Tertiary Green
          background: const Color(0xFFF3F4F6),
          surface: Colors.white,
        ),
        textTheme: GoogleFonts.poppinsTextTheme(
          Theme.of(context).textTheme,
        ).apply(
          bodyColor: const Color(0xFF1F2937),
          displayColor: const Color(0xFF1F2937),
        ),
        useMaterial3: true,
      ),
      home: const AuthWrapper(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class AuthWrapper extends ConsumerWidget {
  const AuthWrapper({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authProvider);

    // Menunggu pengecekan auto-login selesai
    if (authState.status == AuthStatus.initial) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    // Jika user sudah terautentikasi atau masuk sebagai guest, tampilkan HomeScreen
    if (authState.status == AuthStatus.authenticated ||
        authState.status == AuthStatus.guest) {
      return const HomeScreen();
    }

    // Jika belum login, tampilkan layar login
    return const LoginScreen();
  }
}
