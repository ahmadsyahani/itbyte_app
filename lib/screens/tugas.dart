import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:itbyte_app/models/tugas_items.dart';

// Definisikan client Supabase agar mudah diakses
final supabase = Supabase.instance.client;

class TugasScreen extends StatefulWidget {
  const TugasScreen({super.key});
  @override
  State<TugasScreen> createState() => _TugasScreenState();
}

class _TugasScreenState extends State<TugasScreen> {
  // State untuk data dan UI
  bool _isLoading = true;
  List<TugasItem> _tugasList = [];

  // --- DIUBAH KEMBALI MENJADI STATIS ---
  // State untuk dropdown sekarang menggunakan daftar yang tetap
  final List<String> _mataKuliahOptions = [
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
  String? _selectedMataKuliah;
  bool _isDropdownOpen = false;

  @override
  void initState() {
    super.initState();
    _fetchTugas();
  }

  /// Mengambil data tugas dan statusnya dari Supabase
  Future<void> _fetchTugas() async {
    setState(() {
      _isLoading = true;
    });
    try {
      final tugasResponse = await supabase
          .from('tugas')
          .select()
          .order('deadline', ascending: true);
      final userId = supabase.auth.currentUser!.id;
      final statusResponse = await supabase
          .from('user_tugas_status')
          .select('tugas_id, is_done')
          .eq('user_id', userId);
      final statusMap = {
        for (var item in statusResponse) item['tugas_id']: item['is_done'],
      };

      if (mounted) {
        setState(() {
          _tugasList = tugasResponse.map((item) {
            final tugas = TugasItem.fromJson(item);
            tugas.isDone = statusMap[tugas.id] ?? false;
            return tugas;
          }).toList();

          // --- BARIS INI DIHAPUS ---
          // Kita tidak lagi membuat daftar matkul dari data tugas
          // _mataKuliahOptions = _tugasList.map((tugas) => tugas.matkul).toSet().toList();
        });
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Gagal memuat tugas: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted)
        setState(() {
          _isLoading = false;
        });
    }
  }

  /// Fungsi untuk mengubah status 'is_done' di database
  Future<void> _toggleDoneStatus(TugasItem tugas) async {
    final userId = supabase.auth.currentUser!.id;
    final newStatus = !tugas.isDone;

    try {
      await supabase.from('user_tugas_status').upsert({
        'user_id': userId,
        'tugas_id': tugas.id,
        'is_done': newStatus,
      });

      if (mounted) {
        setState(() {
          tugas.isDone = newStatus;
        });
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Gagal mengubah status tugas.'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    // Logika filtering (tidak berubah dan akan berfungsi dengan benar)
    final filteredList = _selectedMataKuliah == null
        ? _tugasList
        : _tugasList
              .where((tugas) => tugas.matkul == _selectedMataKuliah)
              .toList();

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
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : RefreshIndicator(
              onRefresh: _fetchTugas,
              child: ListView(
                physics: const AlwaysScrollableScrollPhysics(),
                padding: const EdgeInsets.all(24.0),
                children: [
                  const Text(
                    'Cek dan Kerjakan\nsemua Tugasmu.',
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      height: 1.3,
                    ),
                  ),
                  const SizedBox(height: 24),
                  _buildCustomDropdown(),
                  const SizedBox(height: 32),

                  // UI akan menampilkan pesan ini jika filteredList kosong, sesuai permintaanmu
                  if (filteredList.isEmpty && !_isLoading)
                    const Center(
                      child: Padding(
                        padding: EdgeInsets.all(32.0),
                        child: Text(
                          'Tidak ada tugas untuk mata kuliah ini.',
                          style: TextStyle(color: Colors.grey),
                        ),
                      ),
                    )
                  else
                    ...filteredList
                        .map(
                          (tugas) => Padding(
                            padding: const EdgeInsets.only(bottom: 16.0),
                            child: _buildTugasCard(tugas),
                          ),
                        )
                        .toList(),
                ],
              ),
            ),
    );
  }

  Widget _buildCustomDropdown() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
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
              border: Border.all(
                color: _selectedMataKuliah != null
                    ? const Color(0xFF4361EE)
                    : Colors.grey.shade400,
                width: 1.5,
              ),
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
        Visibility(
          visible: _isDropdownOpen,
          child: Container(
            margin: const EdgeInsets.only(top: 4),
            height: 250,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: const Color(0xFFE0E0E0), width: 1.5),
            ),
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(vertical: 8),
              itemCount: _mataKuliahOptions.length, // Menggunakan list statis
              itemBuilder: (context, index) {
                final item = _mataKuliahOptions[index];
                final isSelected = _selectedMataKuliah == item;
                return GestureDetector(
                  onTap: () {
                    setState(() {
                      if (_selectedMataKuliah == item) {
                        _selectedMataKuliah = null;
                      } else {
                        _selectedMataKuliah = item;
                      }
                      _isDropdownOpen = false;
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

  Widget _buildTugasCard(TugasItem tugas) {
    final deadlineFormatted = DateFormat(
      'd MMMM yyyy',
      'id_ID',
    ).format(tugas.deadline);
    final bool isDone = tugas.isDone;

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
              Expanded(
                child: Text(
                  tugas.title,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
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
                child: Text(
                  tugas.matkul.length > 3
                      ? tugas.matkul.substring(0, 3).toUpperCase()
                      : tugas.matkul.toUpperCase(),
                  style: const TextStyle(
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
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Deadline : $deadlineFormatted',
                    style: const TextStyle(color: Colors.red, fontSize: 12),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    isDone ? 'Selesai' : 'Belum Selesai',
                    style: TextStyle(
                      color: isDone ? Colors.green : Colors.grey,
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
              GestureDetector(
                onTap: () => _toggleDoneStatus(tugas),
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: isDone ? Colors.green : Colors.transparent,
                    borderRadius: BorderRadius.circular(8),
                    border: isDone ? null : Border.all(color: Colors.green),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        isDone
                            ? Icons.check_circle
                            : Icons.check_circle_outline,
                        color: isDone ? Colors.white : Colors.green,
                        size: 16,
                      ),
                      const SizedBox(width: 6),
                      Text(
                        isDone ? 'Selesai' : 'Tandai Selesai',
                        style: TextStyle(
                          color: isDone ? Colors.white : Colors.green,
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
