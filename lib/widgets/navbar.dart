import 'package:flutter/material.dart';

class NavBar extends StatelessWidget {
  final int selectedIndex;
  final Function(int) onTabTapped;
  final List<IconData> items;

  const NavBar({
    super.key,
    required this.selectedIndex,
    required this.onTabTapped,
    required this.items,
  });

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Container(
        // Atur jarak navbar dari tepi layar
        margin: const EdgeInsets.only(bottom: 24, left: 24, right: 24),
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        decoration: BoxDecoration(
          color: const Color(0xFF4361EE), // Warna biru primary
          borderRadius: BorderRadius.circular(30), // Membuat bentuk pil
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.15),
              blurRadius: 10,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: List.generate(items.length, (index) {
            return _buildNavItem(
              icon: items[index],
              isSelected: selectedIndex == index,
              onTap: () => onTabTapped(index),
            );
          }),
        ),
      ),
    );
  }

  // Widget helper untuk satu item navigasi
  Widget _buildNavItem({
    required IconData icon,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: Colors.white, size: 28),
          const SizedBox(height: 4),
          // Indikator titik yang hanya muncul jika item dipilih
          if (isSelected)
            Container(
              height: 5,
              width: 5,
              decoration: const BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
              ),
            ),
        ],
      ),
    );
  }
}
