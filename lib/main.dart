import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';

import 'screens/home_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializeDateFormatting('bn');
  runApp(const MyReportApp());
}

const seedColor = Color(0xFF1B6B4A);

class MyReportApp extends StatelessWidget {
  const MyReportApp({super.key});

  @override
  Widget build(BuildContext context) {
    final base = ThemeData(
      useMaterial3: true,
      colorSchemeSeed: seedColor,
      brightness: Brightness.light,
      fontFamily: 'SolaimanLipi',
    );
    return MaterialApp(
      title: 'MyReportBD',
      theme: base.copyWith(
        scaffoldBackgroundColor: const Color(0xFFF4F6F5),
        appBarTheme: AppBarTheme(
          backgroundColor: base.colorScheme.surface,
          foregroundColor: base.colorScheme.onSurface,
          elevation: 0,
          scrolledUnderElevation: 1,
          centerTitle: false,
        ),
        cardTheme: CardThemeData(
          elevation: 0,
          color: Colors.white,
          surfaceTintColor: Colors.transparent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
            side: BorderSide(color: base.colorScheme.outlineVariant.withValues(alpha: 0.6)),
          ),
          margin: EdgeInsets.zero,
        ),
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: const Color(0xFFF7F8F8),
          isDense: true,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide.none),
          contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        ),
        chipTheme: base.chipTheme.copyWith(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        ),
        tabBarTheme: TabBarThemeData(
          labelColor: base.colorScheme.primary,
          unselectedLabelColor: base.colorScheme.onSurfaceVariant,
          indicatorColor: base.colorScheme.primary,
          dividerColor: base.colorScheme.outlineVariant.withValues(alpha: 0.5),
        ),
      ),
      home: const HomeScreen(),
    );
  }
}
