import 'package:flutter/material.dart';

class DetailJawabanGuru extends StatelessWidget {
  final String siswa;
  final int idJawaban;

  DetailJawabanGuru({
    required this.siswa,
    required this.idJawaban,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Detail Jawaban $siswa'),
      ),
      body: Center(
        child: Text('Menampilkan detail jawaban untuk $siswa dengan ID jawaban $idJawaban'),
      ),
    );
  }
}


// orisinal

// import 'package:flutter/material.dart';

// class DetailJawabanGuru extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Tugas 1'),
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Container(
//           padding: EdgeInsets.all(16.0),
//           decoration: BoxDecoration(
//             color: Colors.grey[200],
//             borderRadius: BorderRadius.circular(12.0),
//           ),
//           child: Text(
//             'Dengan menggunakan kode di atas, badge pada setiap siswa akan diperbarui sesuai dengan nilai yang dimasukkan saat memberi nilai. Saat tombol "Beri Nilai" ditekan, dialog akan muncul dan memungkinkan untuk memasukkan nilai. Setelah nilai dimasukkan, badge akan diperbarui secara otomatis.',
//             style: TextStyle(fontSize: 18),
//           ),
//         ),
//       ),
//     );
//   }
// }
