import 'package:flutter/material.dart';
import 'package:hotel_search_app/screens/hotel_search_screen.dart';
import 'package:hotel_search_app/theme/app_theme.dart';

void main() {
  runApp(const HotelSearchApp());
}

class HotelSearchApp extends StatefulWidget {
  const HotelSearchApp({Key? key}) : super(key: key);

  @override
  State<HotelSearchApp> createState() => _HotelSearchAppState();
}

class _HotelSearchAppState extends State<HotelSearchApp> {
  ThemeMode _themeMode = ThemeMode.system;

  void _toggleTheme(bool isDark) {
    setState(() {
      _themeMode = isDark ? ThemeMode.dark : ThemeMode.light;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Hotel Search',
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: _themeMode,
      debugShowCheckedModeBanner: false,
      home: HotelSearchScreen(
        onThemeChanged: _toggleTheme,
        isDarkMode: _themeMode == ThemeMode.dark,
      ),
    );
  }
}
