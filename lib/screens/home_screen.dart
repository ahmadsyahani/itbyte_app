import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

// --- Halaman Utama Aplikasi ---
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Mengatur warna status bar menjadi transparan
    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle.light.copyWith(statusBarColor: Colors.transparent),
    );

    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F8), // Warna background utama
      body: Stack(
        children: [
          // --- Lapisan Konten Utama (Bisa di-scroll) ---
          SingleChildScrollView(
            child: Column(
              children: [
                // Spacer diperbesar agar konten di bawah tidak tertutup oleh menu icon yang fixed
                const SizedBox(height: 430),

                // --- Jadwal Hari Ini ---
                _buildJadwalSection(),
                const SizedBox(height: 24),

                // --- Tugas Mendekati Deadline ---
                _buildTugasSection(),
                const SizedBox(height: 24),
              ],
            ),
          ),

          // --- Lapisan Header Biru Melengkung ---
          _buildHeader(),

          // --- Lapisan Kartu ByteCash (Menumpuk di atas) ---
          _buildByteCashCard(context),

          // --- Lapisan Menu Icon (Fixed Position) ---
          Positioned(
            top: 320, // Atur posisi vertikal menu icon
            left: 0,
            right: 0,
            child: _buildMenuIcons(context),
          ),
        ],
      ),
    );
  }

  // --- WIDGET UNTUK HEADER BIRU ---
  Widget _buildHeader() {
    return ClipPath(
      clipper: CustomHeaderClipper(),
      child: Container(
        height: 300,
        color: const Color(0xFF4361EE),
        // Child dari Container sekarang adalah Stack
        child: Stack(
          children: [
            Positioned(
              top: 40,
              child: Image.asset(
                width: 500,
                height: 200,
                'assets/line_9.png',
                fit: BoxFit.cover,
                color: Colors.white.withOpacity(0.2),
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
                    const Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          'Selamat Pagi, Ahmad',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 4),
                        Text(
                          '3125600058',
                          style: TextStyle(color: Colors.white70, fontSize: 14),
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

  // --- WIDGET UNTUK KARTU BYTECASH ---
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
                    onTap: () {
                      Navigator.pushNamed(context, '/bayarkas');
                    },
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

  // --- WIDGET UNTUK 4 ICON MENU (SUDAH DIPERBAIKI) ---
  Widget _buildMenuIcons(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildMenuItem(
            Icons.receipt,
            'Cek Kas',
            onTap: () {
              Navigator.pushNamed(
                context,
                '/cekkas',
              ); // <-- Diperbaiki dari '/cek_kas'
            },
          ),
          _buildMenuItem(
            Icons.assignment,
            'Tugas',
            onTap: () {
              Navigator.pushNamed(context, '/tugas');
            },
          ),
          _buildMenuItem(
            Icons.calendar_today,
            'Jadwal Kuliah',
            onTap: () {
              Navigator.pushNamed(context, '/jadwalkuliah');
            },
          ),
          _buildMenuItem(Icons.folder_open, 'Materi'),
        ],
      ),
    );
  }

  // --- WIDGET HELPER UNTUK SATU ITEM MENU ---
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
            child: Icon(icon, color: const Color(0xFFFFFFFF), size: 30),
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

  // --- WIDGET UNTUK BAGIAN JADWAL ---
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

  // --- WIDGET HELPER UNTUK DETAIL JADWAL ---
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

  // --- WIDGET UNTUK BAGIAN TUGAS ---
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
          _buildTugasCard(
            subject: 'Logika dan Algoritma',
            title: 'Membuat Flowchart tentang Project Pribadi',
            date1: 'Senin, 13 Oktober 2025',
            date2: 'Selasa, 21 Oktober 2025 (23:59)',
            isDone: false,
          ),
          const SizedBox(height: 16),
          _buildTugasCard(
            subject: 'Logika dan Algoritma',
            title: 'Membuat Flowchart tentang Project Pribadi',
            date1: 'Senin, 13 Oktober 2025',
            date2: 'Selasa, 21 Oktober 2025 (23:59)',
            isDone: true,
          ),
        ],
      ),
    );
  }

  // --- WIDGET UNTUK SATU KARTU TUGAS ---
  Widget _buildTugasCard({
    required String subject,
    required String title,
    required String date1,
    required String date2,
    required bool isDone,
  }) {
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
                subject,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: isDone ? Colors.green.shade100 : Colors.red.shade100,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    Icon(
                      isDone ? Icons.check_circle : Icons.pending_actions,
                      size: 16,
                      color: isDone ? Colors.green : Colors.red,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      isDone ? 'Done' : 'Kerjakan',
                      style: TextStyle(
                        color: isDone ? Colors.green : Colors.red,
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(title, style: const TextStyle(color: Colors.black54)),
          const Divider(color: Colors.grey, height: 24),
          _buildTugasDetailRow(Icons.calendar_today_outlined, date1),
          const SizedBox(height: 8),
          _buildTugasDetailRow(Icons.calendar_today, date2),
        ],
      ),
    );
  }

  // --- FUNGSI HILANG YANG SUDAH DITAMBAHKAN KEMBALI ---
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

// --- CLASS UNTUK MEMBUAT BENTUK MELENGKUNG PADA HEADER ---
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
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    return false;
  }
}
