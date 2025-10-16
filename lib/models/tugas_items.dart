// lib/models/tugas_item.dart

class TugasItem {
  final int id;
  final String matkul;
  final String title;
  final DateTime deadline;
  bool isDone;

  TugasItem({
    required this.id,
    required this.matkul,
    required this.title,
    required this.deadline,
    this.isDone = false,
  });

  // Factory constructor untuk mengubah data JSON dari Supabase menjadi objek TugasItem
  factory TugasItem.fromJson(Map<String, dynamic> json) {
    return TugasItem(
      id: json['id'],
      matkul: json['matkul'] ?? 'N/A',
      title: json['title'] ?? 'No Title',
      deadline: DateTime.parse(json['deadline']),
    );
  }
}
