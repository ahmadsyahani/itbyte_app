import 'package:flutter/material.dart';
import 'package:itbyte_app/screens/home_screen.dart';
import 'package:itbyte_app/screens/profile_screen.dart';
import 'package:itbyte_app/widgets/navbar.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;

  // --- PERUBAHAN DI SINI ---
  final List<Widget> _pages = [
    const HomeScreen(),
    const Center(child: Text('Halaman Favorit')),
    const Center(child: Text('Halaman Jelajah')),
    const ProfileScreen(), // <-- 2. GANTI PLACEHOLDER DENGAN HALAMAN PROFIL
  ];
  // -------------------------

  void _onTabTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          _pages[_selectedIndex],
          NavBar(
            selectedIndex: _selectedIndex,
            onTabTapped: _onTabTapped,
            items: const [
              Icons.home_filled,
              Icons.favorite_border,
              Icons.explore_outlined,
              Icons.person_outline,
            ],
          ),
        ],
      ),
    );
  }
}
