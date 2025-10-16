import 'dart:async';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:supabase_flutter/supabase_flutter.dart'; // Jangan lupa import Supabase

// Buat variabel global agar mudah diakses
final supabase = Supabase.instance.client;

// Model Data (Sudah Benar)
class JadwalItem {
  final String startTime;
  final String endTime;
  final String matkul; // Menggunakan matkul
  final String topic;
  final String lecturer;
  final String room;

  JadwalItem({
    required this.startTime,
    required this.endTime,
    required this.matkul,
    required this.topic,
    required this.lecturer,
    required this.room,
  });

  // Factory constructor (Sudah Benar)
  factory JadwalItem.fromJson(Map<String, dynamic> json) {
    return JadwalItem(
      startTime: json['start_time'] ?? '00:00',
      endTime: json['end_time'] ?? '00:00',
      matkul: json['matkul'] ?? 'No Subject', // Mencari 'matkul'
      topic: json['topic'] ?? 'No Topic',
      lecturer: json['lecturer'] ?? 'No Lecturer',
      room: json['room'] ?? 'No Room',
    );
  }
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
  bool _isLoading = true;

  final List<String> _days = ['Sen', 'Sel', 'Rab', 'Kam', 'Jum', 'Sab', 'Min'];

  Map<int, List<JadwalItem>> _allSchedules = {};

  @override
  void initState() {
    super.initState();
    _ambilDataJadwal();

    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (mounted) {
        setState(() {
          _currentTime = DateTime.now();
        });
      }
    });
  }

  Future<void> _ambilDataJadwal() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final response = await supabase.from('jadwal').select();
      final Map<int, List<JadwalItem>> groupedSchedules = {
        0: [],
        1: [],
        2: [],
        3: [],
        4: [],
        5: [],
        6: [],
      };

      for (var item in response) {
        final dayIndex = item['day_of_week'] as int;
        if (groupedSchedules.containsKey(dayIndex)) {
          groupedSchedules[dayIndex]!.add(JadwalItem.fromJson(item));
        }
      }

      setState(() {
        _allSchedules = groupedSchedules;
      });
    } catch (error) {
      print('Error mengambil data: $error');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Gagal memuat data: $error'),
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

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
          Expanded(
            child: _isLoading
                ? const Center(child: CircularProgressIndicator())
                : todaySchedule.isEmpty
                ? const Center(
                    child: Text(
                      'Tidak ada jadwal hari ini.',
                      style: TextStyle(color: Colors.grey, fontSize: 16),
                    ),
                  )
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

    final isOngoing =
        !now.isBefore(startTimeToday) && now.isBefore(endTimeToday);

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

  // --- FUNGSI DUPLIKAT SUDAH DIHAPUS, HANYA MENYISAKAN YANG INI ---
  Widget _buildDaySelector() {
    return SizedBox(
      height: 80, // Beri tinggi tetap untuk area scroll
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        itemCount: _days.length,
        itemBuilder: (context, index) {
          final isSelected = _selectedDayIndex == index;
          return GestureDetector(
            onTap: () {
              setState(() {
                _selectedDayIndex = index;
              });
            },
            child: Container(
              width: 50, // Beri lebar tetap untuk setiap chip
              padding: const EdgeInsets.symmetric(vertical: 8),
              decoration: BoxDecoration(
                color: isSelected ? const Color(0xFF4361EE) : Colors.white,
                borderRadius: BorderRadius.circular(25), // Membuat bentuk pil
                border: Border.all(
                  color: isSelected
                      ? const Color(0xFF4361EE)
                      : Colors.grey.shade300,
                ),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    _days[index],
                    style: TextStyle(
                      color: isSelected ? Colors.white : Colors.grey,
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    (index + 1).toString(),
                    style: TextStyle(
                      color: isSelected ? Colors.white : Colors.black,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
        separatorBuilder: (context, index) =>
            const SizedBox(width: 12), // Jarak antar chip
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
            jadwal.matkul,
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
