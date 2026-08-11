import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:google_fonts/google_fonts.dart';
import 'ui/screens/home_screen.dart';
import 'ui/screens/auth/user_login_screen.dart';
import 'features/auth/providers/auth_provider.dart';

void main() {
  runApp(
    const ProviderScope(
      child: MyApp(),
    ),
  );
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authProvider);
    return MaterialApp(
      title: 'Dispora Mobile',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF1D4ED8), // Primary Blue
          primary: const Color(0xFF1D4ED8),
          secondary: const Color(0xFFDC2626), // Secondary Red
          tertiary: const Color(0xFF10B981), // Tertiary Green
          surface: const Color(0xFFF3F4F6),
        ),
        textTheme: GoogleFonts.poppinsTextTheme(
          Theme.of(context).textTheme,
        ).apply(
          bodyColor: const Color(0xFF1F2937),
          displayColor: const Color(0xFF1F2937),
        ),
        useMaterial3: true,
      ),
      home: authState.isAuthenticated ? const HomeScreen() : const UserLoginScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}
