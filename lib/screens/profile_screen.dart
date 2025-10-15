import 'package:flutter/material.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Ukuran tinggi header
    const double headerHeight = 250.0;
    // Ukuran avatar
    const double avatarRadius = 60.0;

    return Scaffold(
      backgroundColor: const Color(0xFFFAF9F9),
      body: Stack(
        children: [
          // --- LAPISAN 1: KONTEN UTAMA (YANG BISA DI-SCROLL) ---
          SingleChildScrollView(
            child: Column(
              children: [
                // Spacer seukuran header untuk mendorong konten ke bawah
                const SizedBox(height: headerHeight),

                // Konten putih di bawah header
                Container(
                  decoration: const BoxDecoration(
                    color: Color(0xFFFAF9F9),
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(30.0),
                      topRight: Radius.circular(30.0),
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(24.0),
                    child: Column(
                      children: [
                        // Spacer untuk memberi ruang bagi avatar DAN jarak ke menu
                        const SizedBox(
                          height: avatarRadius + 8 + 24,
                        ), // <-- PERUBAHAN DI SINI
                        // --- Menu List ---
                        _buildMenuItem(
                          icon: Icons.edit_outlined,
                          text: 'Edit Profil',
                        ),
                        const SizedBox(height: 12),
                        // Kamu bisa tambahkan menu lain di sini dengan memanggil _buildMenuItem lagi
                        // _buildMenuItem(icon: Icons.settings_outlined, text: 'Pengaturan'),
                        // const SizedBox(height: 12),
                        // _buildMenuItem(icon: Icons.logout, text: 'Keluar'),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),

          // --- LAPISAN 2: HEADER BIRU MELENGKUNG ---
          _buildHeader(headerHeight),

          // --- LAPISAN 3: AVATAR & INFO PROFIL (MENGAMBANG) ---
          _buildProfileInfo(headerHeight, avatarRadius),
        ],
      ),
    );
  }

  // --- WIDGET UNTUK HEADER BIRU ---
  Widget _buildHeader(double height) {
    return ClipPath(
      clipper: CustomHeaderClipper(),
      child: Container(
        height: height,
        color: const Color(0xFF4361EE),
        child: Stack(
          children: [
            Positioned.fill(
              child: Image.asset(
                'assets/line_9.png', // Ganti dengan path gambar pattern-mu
                fit: BoxFit.cover,
                color: Colors.white.withOpacity(0.1),
                colorBlendMode: BlendMode.modulate,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // --- WIDGET UNTUK AVATAR, NAMA, & EMAIL ---
  Widget _buildProfileInfo(double headerHeight, double avatarRadius) {
    return Positioned(
      // Atur posisi agar avatar berada di tengah-tengah lengkungan
      top: headerHeight - avatarRadius - 30,
      left: 0,
      right: 0,
      child: Column(
        children: [
          // Stack untuk avatar dan ikon kamera
          Stack(
            children: [
              CircleAvatar(
                radius: avatarRadius,
                backgroundImage: const NetworkImage(
                  'https://i.pravatar.cc/150?img=3',
                ), // Ganti dengan gambar profil
              ),
              Positioned(
                bottom: 0,
                right: 0,
                child: Container(
                  padding: const EdgeInsets.all(4),
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.camera_alt,
                    color: Color(0xFF4361EE),
                    size: 20,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          const Text(
            'Hanestyan',
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 4),
          const Text(
            'Hanestyan@gmail.com',
            style: TextStyle(fontSize: 14, color: Colors.grey),
          ),
        ],
      ),
    );
  }

  // --- WIDGET HELPER UNTUK SATU ITEM MENU ---
  Widget _buildMenuItem({required IconData icon, required String text}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.grey.shade200,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Icon(icon, color: Colors.black54),
          const SizedBox(width: 16),
          Text(
            text,
            style: const TextStyle(
              fontWeight: FontWeight.w600,
              color: Colors.black87,
            ),
          ),
        ],
      ),
    );
  }
}

// --- CLASS CLIPPER UNTUK BENTUK MELENGKUNG (SAMA SEPERTI DI HOMESCREEN) ---
class CustomHeaderClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();
    path.lineTo(0, size.height - 80); // Atur kedalaman lengkungan di sini
    path.quadraticBezierTo(
      size.width / 2,
      size.height,
      size.width,
      size.height - 80,
    );
    path.lineTo(size.width, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}
