import 'dart:async';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class JadwalItem {
  final String startTime;
  final String endTime;
  final String subject;
  final String topic;
  final String lecturer;
  final String room;

  JadwalItem({
    required this.startTime,
    required this.endTime,
    required this.subject,
    required this.topic,
    required this.lecturer,
    required this.room,
  });
}

class JadwalKuliahScreen extends StatefulWidget {
  const JadwalKuliahScreen({super.key});

  @override
  State<JadwalKuliahScreen> createState() => _JadwalKuliahScreenState();
}

class _JadwalKuliahScreenState extends State<JadwalKuliahScreen> {
  int _selectedDayIndex = 0;
  Timer? _timer;
  DateTime _currentTime = DateTime.now();

  final List<String> _days = ['Sen', 'Sel', 'Rab', 'Kam', 'Jum', 'Sab', 'Min'];

  // --- LANGKAH 2: MENYIAPKAN DATA JADWAL UNTUK SETIAP HARI ---
  final Map<int, List<JadwalItem>> _allSchedules = {
    // Data untuk hari Senin (index 0)
    0: [
      JadwalItem(
        startTime: '11:20',
        endTime: '13:50',
        subject: 'Agama',
        topic: 'Keutamaan Sholat',
        lecturer: 'Dr. Si Imoet',
        room: 'B.203',
      ),
      JadwalItem(
        startTime: '14:40',
        endTime: '16:20',
        subject: 'Dasar Sistem Komputer',
        topic: 'Aljabar Boolean',
        lecturer: 'Ir. Rusdi',
        room: 'SAW 6.7',
      ),
    ],
    // Data untuk hari Selasa (index 1)
    1: [
      JadwalItem(
        startTime: '08:00',
        endTime: '10:30',
        subject: 'Matematika 1',
        topic: 'Kalkulus Dasar',
        lecturer: 'Prof. Yanto',
        room: 'C.101',
      ),
    ],
    // Hari Rabu (index 2) tidak ada jadwal
    2: [],
    // Data untuk hari Kamis (index 3)
    3: [
      JadwalItem(
        startTime: '09:00',
        endTime: '11:00',
        subject: 'Konsep Pemrograman',
        topic: 'Tipe Data & Variabel',
        lecturer: 'Dr. Budi',
        room: 'D.305',
      ),
    ],
  };

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (mounted) {
        setState(() {
          _currentTime = DateTime.now();
        });
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Ambil jadwal untuk hari yang dipilih
    final todaySchedule = _allSchedules[_selectedDayIndex] ?? [];

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
          'Jadwal Kuliah',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: Column(
        children: [
          _buildDaySelector(),
          const SizedBox(height: 32),

          // --- LANGKAH 3: MENAMPILKAN JADWAL SECARA DINAMIS ---
          Expanded(
            child: todaySchedule.isEmpty
                // Jika tidak ada jadwal, tampilkan pesan
                ? const Center(
                    child: Text(
                      'Tidak ada jadwal hari ini.',
                      style: TextStyle(color: Colors.grey, fontSize: 16),
                    ),
                  )
                // Jika ada jadwal, tampilkan list-nya
                : ListView.separated(
                    padding: const EdgeInsets.symmetric(horizontal: 24.0),
                    itemCount: todaySchedule.length,
                    itemBuilder: (context, index) {
                      final jadwal = todaySchedule[index];
                      return _buildScheduleItem(jadwal);
                    },
                    separatorBuilder: (context, index) =>
                        const SizedBox(height: 24),
                  ),
          ),
        ],
      ),
    );
  }

  // --- WIDGET UNTUK SATU ITEM JADWAL (DIEDIT AGAR MENERIMA OBJEK) ---
  Widget _buildScheduleItem(JadwalItem jadwal) {
    final now = _currentTime;
    final start = DateFormat('HH:mm').parse(jadwal.startTime);
    final end = DateFormat('HH:mm').parse(jadwal.endTime);
    final startTimeToday = DateTime(
      now.year,
      now.month,
      now.day,
      start.hour,
      start.minute,
    );
    final endTimeToday = DateTime(
      now.year,
      now.month,
      now.day,
      end.hour,
      end.minute,
    );

    final isOngoing = now.isAfter(startTimeToday) && now.isBefore(endTimeToday);

    final cardColor = isOngoing
        ? const [Color(0xFF8A98FD), Color(0xFF4361EE)]
        : [const Color(0xFFC8C8C8), const Color(0xFFC8C8C8)];

    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                jadwal.startTime,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              Text(
                jadwal.endTime,
                style: const TextStyle(color: Colors.grey, fontSize: 12),
              ),
            ],
          ),
          const SizedBox(width: 16),
          _buildTimelineConnector(isOngoing),
          const SizedBox(width: 16),
          Expanded(child: _buildScheduleCard(jadwal, cardColor)),
        ],
      ),
    );
  }

  // --- KODE LAINNYA TIDAK BERUBAH ---
  Widget _buildTimelineConnector(bool isOngoing) {
    return SizedBox(
      width: 20,
      child: Column(
        children: [
          Expanded(child: Container(width: 2, color: Colors.grey.shade300)),
          Container(
            padding: const EdgeInsets.all(4),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                width: 2,
                color: isOngoing
                    ? const Color(0xFFFFD700)
                    : Colors.grey.shade300,
              ),
            ),
            child: CircleAvatar(
              radius: 5,
              backgroundColor: isOngoing
                  ? const Color(0xFFFFD700)
                  : Colors.transparent,
            ),
          ),
          Expanded(child: Container(width: 2, color: Colors.grey.shade300)),
        ],
      ),
    );
  }

  Widget _buildDaySelector() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: List.generate(_days.length, (index) {
          final isSelected = _selectedDayIndex == index;
          return GestureDetector(
            onTap: () {
              setState(() {
                _selectedDayIndex = index;
              });
            },
            child: Column(
              children: [
                Text(
                  _days[index],
                  style: TextStyle(
                    color: isSelected ? const Color(0xFF4361EE) : Colors.grey,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  (index + 1).toString(),
                  style: const TextStyle(
                    color: Colors.black,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                if (isSelected)
                  Container(
                    height: 2,
                    width: 20,
                    color: const Color(0xFF4361EE),
                  ),
              ],
            ),
          );
        }),
      ),
    );
  }

  Widget _buildScheduleCard(JadwalItem jadwal, List<Color> cardColor) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: cardColor,
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            jadwal.subject,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 18,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            jadwal.topic,
            style: TextStyle(
              color: Colors.white.withOpacity(0.8),
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 24),
          _buildDetailRow(Icons.person_outline, jadwal.lecturer),
          const SizedBox(height: 8),
          _buildDetailRow(Icons.location_on_outlined, jadwal.room),
        ],
      ),
    );
  }

  Widget _buildDetailRow(IconData icon, String text) {
    return Row(
      children: [
        Icon(icon, color: Colors.white.withOpacity(0.8), size: 16),
        const SizedBox(width: 8),
        Text(text, style: TextStyle(color: Colors.white.withOpacity(0.8))),
      ],
    );
  }
}
