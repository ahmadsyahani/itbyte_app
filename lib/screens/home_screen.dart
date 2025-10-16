import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:itbyte_app/models/tugas_items.dart'; // Pastikan path ini benar

// Definisikan client Supabase agar mudah diakses
final supabase = Supabase.instance.client;

// ----------------------------------------------------

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // State untuk menyimpan data profil dan status loading
  bool _isLoading = true;
  String? _fullName;
  String? _nrp;
  List<TugasItem> _deadlineTugas = [];

  @override
  void initState() {
    super.initState();
    _fetchInitialData();
  }

  Future<void> _fetchInitialData() async {
    await Future.wait([_fetchUserProfile(), _fetchDeadlineTugas()]);

    if (mounted) {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _fetchUserProfile() async {
    try {
      final userId = supabase.auth.currentUser!.id;
      final data = await supabase
          .from('profiles')
          .select('full_name, nrp')
          .eq('id', userId)
          .single();

      if (mounted) {
        setState(() {
          _fullName = data['full_name'];
          _nrp = data['nrp']?.toString();
        });
      }
    } catch (error) {
      if (mounted) {
        setState(() {
          _fullName = 'Pengguna';
          _nrp = 'N/A';
        });
      }
    }
  }

  Future<void> _fetchDeadlineTugas() async {
    try {
      final now = DateTime.now();
      final response = await supabase
          .from('tugas')
          .select()
          .gte('deadline', now.toIso8601String())
          .order('deadline', ascending: true)
          .limit(2);

      if (mounted) {
        setState(() {
          _deadlineTugas = response
              .map((item) => TugasItem.fromJson(item))
              .toList();
        });
      }
    } catch (e) {
      print('Gagal memuat tugas deadline: $e');
    }
  }

  String _getGreeting() {
    final hour = DateTime.now().hour;
    if (hour < 11) {
      return 'Selamat Pagi';
    } else if (hour < 15) {
      return 'Selamat Siang';
    } else if (hour < 19) {
      return 'Selamat Sore';
    } else {
      return 'Selamat Malam';
    }
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle.light.copyWith(statusBarColor: Colors.transparent),
    );

    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F8),
      body: Stack(
        children: [
          if (_isLoading)
            const Center(child: CircularProgressIndicator())
          else
            RefreshIndicator(
              onRefresh: _fetchInitialData,
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                child: Column(
                  children: [
                    const SizedBox(height: 430),
                    _buildJadwalSection(),
                    const SizedBox(height: 24),
                    _buildTugasSection(),
                    const SizedBox(height: 24),
                  ],
                ),
              ),
            ),
          _buildHeader(),
          _buildByteCashCard(context),
          _buildMenuContainer(context),
        ],
      ),
    );
  }

  Widget _buildMenuContainer(BuildContext context) {
    return Positioned(
      top: 300,
      left: 0,
      right: 0,
      child: Container(
        padding: const EdgeInsets.only(top: 20.0, bottom: 16.0),
        decoration: BoxDecoration(
          color: const Color(0xFFF5F5F8),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.15),
              spreadRadius: 1,
              blurRadius: 10,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: _buildMenuIcons(context),
      ),
    );
  }

  Widget _buildHeader() {
    final greeting = _getGreeting();
    final firstName = _fullName?.split(' ').first ?? 'Pengguna';

    return ClipPath(
      clipper: CustomHeaderClipper(),
      child: Container(
        height: 300,
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
            SafeArea(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 50,
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const CircleAvatar(
                      radius: 24,
                      backgroundImage: NetworkImage(
                        'https://picsum.photos/200',
                      ),
                    ),
                    const SizedBox(width: 16),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          '$greeting, $firstName',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          _nrp ?? 'Memuat NRP...',
                          style: const TextStyle(
                            color: Colors.white70,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                    const Spacer(),
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.notifications_none,
                        color: Color(0xFF4361EE),
                        size: 26,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildByteCashCard(BuildContext context) {
    return Positioned(
      top: 170,
      left: 24,
      right: 24,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.2),
              spreadRadius: 2,
              blurRadius: 10,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.asset('assets/byte_cash.png', height: 20),
            const SizedBox(height: 16),
            IntrinsicHeight(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Uang dibayar',
                        style: TextStyle(color: Colors.grey, fontSize: 14),
                      ),
                      SizedBox(height: 4),
                      Text(
                        'Rp 30.000',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                        ),
                      ),
                    ],
                  ),
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 8.0),
                    child: VerticalDivider(color: Colors.grey, thickness: 1),
                  ),
                  const Expanded(
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Tunggakan',
                            style: TextStyle(color: Colors.grey, fontSize: 14),
                          ),
                          SizedBox(height: 4),
                          Text(
                            'Rp 120.000',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 20,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () => Navigator.pushNamed(context, '/bayarkas'),
                    child: Padding(
                      padding: const EdgeInsets.only(right: 8.0),
                      child: Column(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: const Color(0xFFE8F0FE),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: const Icon(
                              Icons.receipt_long,
                              color: Color(0xFF4361EE),
                            ),
                          ),
                          const SizedBox(height: 4),
                          const Text(
                            'Bayar Kas',
                            style: TextStyle(fontSize: 12, color: Colors.black),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMenuIcons(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildMenuItem(
            Icons.receipt,
            'Cek Kas',
            onTap: () => Navigator.pushNamed(context, '/cekkas'),
          ),
          _buildMenuItem(
            Icons.assignment,
            'Tugas',
            onTap: () => Navigator.pushNamed(context, '/tugas'),
          ),
          _buildMenuItem(
            Icons.calendar_today,
            'Jadwal Kuliah',
            onTap: () => Navigator.pushNamed(context, '/jadwalkuliah'),
          ),
          _buildMenuItem(Icons.folder_open, 'Materi'),
        ],
      ),
    );
  }

  Widget _buildMenuItem(IconData icon, String label, {VoidCallback? onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: const BoxDecoration(
              color: Color(0xFF4361EE),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: Colors.white, size: 30),
          ),
          const SizedBox(height: 8),
          Text(
            label,
            style: const TextStyle(
              color: Colors.black,
              fontSize: 14,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildJadwalSection() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Jadwal Hari ini',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
              ),
              Row(
                children: [
                  Icon(Icons.arrow_back_ios, size: 16, color: Colors.grey),
                  const SizedBox(width: 8),
                  Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
                ],
              ),
            ],
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: const Color(0xFF4361EE),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Row(
                  children: [
                    Icon(Icons.access_time, color: Colors.white70, size: 16),
                    SizedBox(width: 8),
                    Text(
                      '11:30 - 12:30',
                      style: TextStyle(color: Colors.white),
                    ),
                    Spacer(),
                    Icon(Icons.info_outline, color: Colors.white),
                  ],
                ),
                const Divider(color: Colors.white30, height: 24),
                const Text(
                  'Logika dan Algoritma',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 22,
                  ),
                ),
                const SizedBox(height: 16),
                _buildJadwalDetailRow(
                  Icons.book_outlined,
                  'Basic Algorithm',
                  color: Colors.white,
                ),
                const SizedBox(height: 8),
                _buildJadwalDetailRow(
                  Icons.location_on_outlined,
                  'B.203',
                  color: Colors.white,
                ),
                const SizedBox(height: 8),
                _buildJadwalDetailRow(
                  Icons.person_outline,
                  'Prof. Ambasani',
                  color: Colors.white,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildJadwalDetailRow(
    IconData icon,
    String text, {
    required Color color,
  }) {
    return Row(
      children: [
        Icon(icon, color: color, size: 20),
        const SizedBox(width: 12),
        Text(text, style: TextStyle(color: color)),
      ],
    );
  }

  Widget _buildTugasSection() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Tugas Mendekati Deadline',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
          const SizedBox(height: 16),
          if (_deadlineTugas.isEmpty)
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFFE8F0FE),
                borderRadius: BorderRadius.circular(16),
              ),
              child: const Center(
                child: Text(
                  'Tidak ada tugas mendekati deadline.',
                  style: TextStyle(color: Colors.grey),
                ),
              ),
            )
          else
            ..._deadlineTugas
                .map(
                  (tugas) => Padding(
                    padding: const EdgeInsets.only(bottom: 16.0),
                    child: _buildTugasCard(tugas),
                  ),
                )
                .toList(),
        ],
      ),
    );
  }

  Widget _buildTugasCard(TugasItem tugas) {
    final deadlineFormatted = DateFormat(
      'EEEE, d MMMM yyyy',
      'id_ID',
    ).format(tugas.deadline);
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFE8F0FE),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                tugas.matkul,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(tugas.title, style: const TextStyle(color: Colors.black54)),
          const Divider(color: Colors.grey, height: 24),
          _buildTugasDetailRow(
            Icons.calendar_today_outlined,
            deadlineFormatted,
          ),
        ],
      ),
    );
  }

  Widget _buildTugasDetailRow(IconData icon, String text) {
    return Row(
      children: [
        Icon(icon, color: Colors.grey, size: 20),
        const SizedBox(width: 12),
        Text(text, style: const TextStyle(color: Colors.grey)),
      ],
    );
  }
}

class CustomHeaderClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();
    path.lineTo(0, size.height - 50);
    path.quadraticBezierTo(
      size.width / 2,
      size.height,
      size.width,
      size.height - 50,
    );
    path.lineTo(size.width, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}
