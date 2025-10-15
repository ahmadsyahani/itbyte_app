import 'package:flutter/material.dart';

class TugasScreen extends StatefulWidget {
  const TugasScreen({super.key});

  @override
  State<TugasScreen> createState() => _TugasScreenState();
}

class _TugasScreenState extends State<TugasScreen> {
  // Daftar mata kuliah untuk dropdown
  final List<String> _mataKuliah = [
    'Agama',
    'Dasar Sistem Komputer',
    'Keterampilan Non Teknis',
    'Praktikum Konsep Pemrograman',
    'Workshop Desain Web',
    'Konsep Teknologi Informasi',
    'Konsep Pemrograman',
    'Logika dan Algoritma',
    'Pancasila',
    'Matematika 1',
  ];

  // Variabel untuk menyimpan mata kuliah yang dipilih
  String? _selectedMataKuliah;
  // Variabel untuk state dropdown (terbuka/tertutup)
  bool _isDropdownOpen = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFAF9F9),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        foregroundColor: Colors.black,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text(
          'Tugas',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 26),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(24.0),
        children: [
          // --- Header Teks ---
          const Text(
            'Cek dan Kerjakan\nsemua Tugasmu.',
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              height: 1.3,
            ),
          ),
          const SizedBox(height: 24),

          // --- Dropdown Kustom ---
          _buildCustomDropdown(),
          const SizedBox(height: 32),

          // --- Kartu Tugas ---
          _buildTugasCard(),
          // Kamu bisa tambahkan kartu tugas lainnya di sini
        ],
      ),
    );
  }

  // --- WIDGET DROPDOWN KUSTOM YANG BARU ---
  Widget _buildCustomDropdown() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Tombol untuk membuka/menutup dropdown
        GestureDetector(
          onTap: () {
            setState(() {
              _isDropdownOpen = !_isDropdownOpen;
            });
          },
          child: Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 16.0,
              vertical: 16.0,
            ),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: const Color(0xFF4361EE), width: 1.5),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  _selectedMataKuliah ?? 'Pilih Matkul',
                  style: TextStyle(
                    color: _selectedMataKuliah != null
                        ? const Color(0xFF4361EE)
                        : Colors.black54,
                    fontWeight: FontWeight.w600,
                    fontSize: 16,
                  ),
                ),
                Icon(
                  _isDropdownOpen
                      ? Icons.keyboard_arrow_up
                      : Icons.keyboard_arrow_down,
                  color: Colors.black54,
                ),
              ],
            ),
          ),
        ),

        // Daftar item dropdown yang bisa muncul/hilang
        Visibility(
          visible: _isDropdownOpen,
          child: Container(
            margin: const EdgeInsets.only(top: 4),
            height: 250, // Atur tinggi maksimal daftar
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: const Color(0xFFE0E0E0), width: 1.5),
            ),
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(vertical: 8),
              itemCount: _mataKuliah.length,
              itemBuilder: (context, index) {
                final item = _mataKuliah[index];
                final isSelected = _selectedMataKuliah == item;
                return GestureDetector(
                  onTap: () {
                    setState(() {
                      _selectedMataKuliah = item;
                      _isDropdownOpen = false; // Tutup dropdown setelah memilih
                    });
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 12,
                    ),
                    color: isSelected
                        ? const Color(0xFFE8F0FE)
                        : Colors.transparent,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          item,
                          style: TextStyle(
                            fontWeight: isSelected
                                ? FontWeight.bold
                                : FontWeight.normal,
                            color: isSelected
                                ? const Color(0xFF4361EE)
                                : Colors.black87,
                          ),
                        ),
                        if (isSelected)
                          const Icon(Icons.check, color: Color(0xFF4361EE)),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ),
      ],
    );
  }

  // --- WIDGET UNTUK KARTU TUGAS ---
  Widget _buildTugasCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Expanded(
                child: Text(
                  'Membuat Laporan Praktikum Modul Looping',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
              ),
              const SizedBox(width: 12),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: const Color(0xFF4361EE),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: const Text(
                  'PKP',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Deadline : 10 November 2025',
                    style: TextStyle(color: Colors.red, fontSize: 12),
                  ),
                  SizedBox(height: 4),
                  Text(
                    'Selesai : 5 November 2025',
                    style: TextStyle(color: Colors.grey, fontSize: 12),
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: Colors.green,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Row(
                  children: [
                    Icon(
                      Icons.check_circle_outline,
                      color: Colors.white,
                      size: 16,
                    ),
                    SizedBox(width: 6),
                    Text(
                      'Done',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
