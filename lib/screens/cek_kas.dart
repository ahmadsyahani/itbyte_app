import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class CekKasScreen extends StatefulWidget {
  const CekKasScreen({super.key});

  @override
  State<CekKasScreen> createState() => _CekKasScreenState();
}

class _CekKasScreenState extends State<CekKasScreen> {
  // Variabel untuk melacak tab history yang aktif
  int _selectedHistoryTab = 0; // 0: Harian, 1: Bulanan, 2: Tahunan

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
          'Cek Kas',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        children: [
          const Text(
            'Total keseluruhan\nKas yang terkumpul.',
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              height: 1.3,
            ),
          ),
          const SizedBox(height: 24),

          // --- Kartu Total Kas & Grafik ---
          _buildTotalKasCard(),
          const SizedBox(height: 16),

          // --- Kartu Pemasukan & Pengeluaran ---
          _buildSummaryCards(),
          const SizedBox(height: 32),

          // --- Section History ---
          _buildHistorySection(),
        ],
      ),
    );
  }

  // --- WIDGET UNTUK KARTU TOTAL KAS & GRAFIK ---
  Widget _buildTotalKasCard() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Total Kas', style: TextStyle(color: Colors.grey)),
          const SizedBox(height: 8),
          const Text(
            'Rp 2.500.000.000',
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: Color(0xFF4361EE),
            ),
          ),
          const SizedBox(height: 24),
          SizedBox(height: 120, child: BarChart(_buildBarChartData())),
        ],
      ),
    );
  }

  // --- DATA & KONFIGURASI UNTUK BAR CHART ---
  BarChartData _buildBarChartData() {
    return BarChartData(
      alignment: BarChartAlignment.spaceAround,
      maxY: 10, // Nilai maksimal untuk sumbu Y
      barTouchData: BarTouchData(enabled: false),
      titlesData: FlTitlesData(
        show: true,
        bottomTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            reservedSize: 30, // Beri ruang untuk teks di bawah
            getTitlesWidget: (double value, TitleMeta meta) {
              const style = TextStyle(color: Colors.grey, fontSize: 10);
              String text;
              switch (value.toInt()) {
                case 0:
                  text = 'Jan';
                  break;
                case 1:
                  text = 'Feb';
                  break;
                case 2:
                  text = 'Mar';
                  break;
                case 3:
                  text = 'Apr';
                  break;
                case 4:
                  text = 'Mei';
                  break;
                case 5:
                  text = 'Jun';
                  break;
                case 6:
                  text = 'Jul';
                  break;
                default:
                  text = '';
                  break;
              }
              // Cukup return Text saja
              return Text(text, style: style);
            },
          ),
        ),
        leftTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
        topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
        rightTitles: const AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
      ),
      gridData: const FlGridData(show: false),
      borderData: FlBorderData(show: false),
      barGroups: [
        _makeBarGroupData(0, 5),
        _makeBarGroupData(1, 6),
        _makeBarGroupData(2, 4),
        _makeBarGroupData(3, 8),
        _makeBarGroupData(4, 7),
        _makeBarGroupData(5, 7.5),
        _makeBarGroupData(6, 4.5),
      ],
    );
  }

  // Helper untuk membuat satu bar
  BarChartGroupData _makeBarGroupData(int x, double y) {
    return BarChartGroupData(
      x: x,
      barRods: [
        BarChartRodData(
          toY: y,
          color: const Color(0xFF4361EE),
          width: 20,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(6),
            topRight: Radius.circular(6),
          ),
        ),
      ],
    );
  }

  // --- WIDGET UNTUK KARTU PEMASUKAN & PENGELUARAN ---
  Widget _buildSummaryCards() {
    return Row(
      children: [
        Expanded(
          child: _buildSummaryCard(
            'Pemasukan',
            'Rp. 125.000',
            Icons.arrow_upward,
            Colors.green,
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: _buildSummaryCard(
            'Pengeluaran',
            'Rp. 50.000',
            Icons.arrow_downward,
            Colors.red,
          ),
        ),
      ],
    );
  }

  // Helper untuk satu kartu summary
  Widget _buildSummaryCard(
    String title,
    String amount,
    IconData icon,
    Color iconColor,
  ) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(color: Colors.grey, fontSize: 12),
              ),
              const SizedBox(height: 4),
              Text(
                amount,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ],
          ),
          Icon(icon, color: iconColor, size: 20),
        ],
      ),
    );
  }

  // --- WIDGET UNTUK SECTION HISTORY ---
  Widget _buildHistorySection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'History Penggunaan',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
        ),
        const SizedBox(height: 16),
        _buildHistoryTabs(),
        const SizedBox(height: 16),
        _buildHistoryItem(
          icon: Icons.restaurant,
          title: 'Bukber Sekelas',
          date: '12 Juni 2025',
          amount: '-Rp 150.000',
        ),
        const SizedBox(height: 12),
        _buildHistoryItem(
          icon: Icons.shield_outlined,
          title: 'Dana Darurat',
          date: '14 Juni 2025',
          amount: '-Rp 70.000',
        ),
        const SizedBox(height: 12),
        _buildHistoryItem(
          icon: Icons.card_travel,
          title: 'Liburan ke Malang',
          date: '20 Juni 2025',
          amount: '-Rp 500.000',
        ),
      ],
    );
  }

  // Widget untuk tab Harian, Bulanan, Tahunan
  Widget _buildHistoryTabs() {
    final tabs = ['Harian', 'Bulanan', 'Tahunan'];
    return Row(
      children: List.generate(tabs.length, (index) {
        final isSelected = _selectedHistoryTab == index;
        return GestureDetector(
          onTap: () {
            setState(() {
              _selectedHistoryTab = index;
            });
          },
          child: Container(
            margin: const EdgeInsets.only(right: 8),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: isSelected ? const Color(0xFFE8F0FE) : Colors.transparent,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: isSelected
                    ? const Color(0xFF4361EE)
                    : Colors.grey.shade300,
              ),
            ),
            child: Text(
              tabs[index],
              style: TextStyle(
                color: isSelected ? const Color(0xFF4361EE) : Colors.grey,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        );
      }),
    );
  }

  // Widget untuk satu item di history list
  Widget _buildHistoryItem({
    required IconData icon,
    required String title,
    required String date,
    required String amount,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: const Color(0xFFE8F0FE),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: const Color(0xFF4361EE)),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 4),
                Text(
                  date,
                  style: const TextStyle(color: Colors.grey, fontSize: 12),
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                amount,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.red,
                ),
              ),
              const SizedBox(height: 4),
              const Text(
                'Uang Kas',
                style: TextStyle(color: Colors.grey, fontSize: 12),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
