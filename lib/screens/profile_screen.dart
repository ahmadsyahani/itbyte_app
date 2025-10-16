import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:itbyte_app/screens/edit_profile.dart'; // Import halaman edit profil

// Definisikan client Supabase agar mudah diakses
final supabase = Supabase.instance.client;

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  // State untuk menyimpan data profil
  bool _isLoading = true;
  String? _fullName;
  String? _email;

  @override
  void initState() {
    super.initState();
    _fetchProfile();
  }

  /// Mengambil data profil dari tabel 'profiles' di Supabase
  Future<void> _fetchProfile() async {
    if (!mounted) return;
    setState(() {
      _isLoading = true;
    });

    try {
      final userId = supabase.auth.currentUser!.id;
      // Ambil data dari tabel 'profiles' di mana 'id' cocok dengan user yang login
      final data = await supabase
          .from('profiles')
          .select()
          .eq('id', userId)
          .single();

      if (mounted) {
        setState(() {
          _fullName = data['full_name'];
          _email = supabase.auth.currentUser!.email;
        });
      }
    } catch (error) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Gagal memuat profil: ${error.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  /// Fungsi untuk logout
  Future<void> _signOut() async {
    try {
      await supabase.auth.signOut();
    } catch (error) {
      // Handle error jika perlu
    } finally {
      if (mounted) {
        // Arahkan kembali ke halaman login setelah logout
        Navigator.of(context).pushReplacementNamed('/login');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    const double headerHeight = 250.0;
    const double avatarRadius = 60.0;

    // Tampilkan loading indicator saat data sedang diambil
    if (_isLoading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return Scaffold(
      backgroundColor: const Color(0xFFFAF9F9),
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Column(
              children: [
                const SizedBox(height: headerHeight),
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
                        const SizedBox(height: avatarRadius + 8 + 24),
                        _buildMenuItem(
                          icon: Icons.edit_outlined,
                          text: 'Edit Profil',
                          onTap: () {
                            // Navigasi ke halaman edit profil
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => EditProfileScreen(
                                  currentName: _fullName ?? '',
                                ),
                              ),
                            ).then((_) {
                              // Refresh data setelah kembali dari halaman edit
                              _fetchProfile();
                            });
                          },
                        ),
                        const SizedBox(height: 12),
                        // Tombol logout sekarang berfungsi
                        _buildMenuItem(
                          icon: Icons.logout,
                          text: 'Keluar',
                          onTap: _signOut,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          _buildHeader(headerHeight),
          // Kirim data yang sudah di-fetch ke widget info profil
          _buildProfileInfo(headerHeight, avatarRadius, _fullName, _email),
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
                'assets/line_9.png',
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

  // --- WIDGET UNTUK AVATAR, NAMA, & EMAIL (MENERIMA DATA DINAMIS) ---
  Widget _buildProfileInfo(
    double headerHeight,
    double avatarRadius,
    String? fullName,
    String? email,
  ) {
    return Positioned(
      top: headerHeight - avatarRadius - 30,
      left: 0,
      right: 0,
      child: Column(
        children: [
          Stack(
            children: [
              CircleAvatar(
                radius: avatarRadius,
                backgroundImage: const NetworkImage(
                  'https://i.pravatar.cc/150?img=3',
                ),
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
          // Gunakan data dari state
          Text(
            fullName ?? 'Nama Pengguna',
            style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 4),
          Text(
            email ?? 'email@pengguna.com',
            style: const TextStyle(fontSize: 14, color: Colors.grey),
          ),
        ],
      ),
    );
  }

  // --- WIDGET HELPER UNTUK SATU ITEM MENU (DIBUAT BISA DIKLIK) ---
  Widget _buildMenuItem({
    required IconData icon,
    required String text,
    VoidCallback? onTap,
  }) {
    return GestureDetector(
      // Dibungkus GestureDetector agar bisa diklik
      onTap: onTap,
      child: Container(
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
      ),
    );
  }
}

// --- CLASS CLIPPER UNTUK BENTUK MELENGKUNG ---
class CustomHeaderClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();
    path.lineTo(0, size.height - 80);
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
