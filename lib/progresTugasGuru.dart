import 'package:flutter/material.dart';
import 'progresTugasGuruController.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';

class ProgresTugasGuru extends StatelessWidget {
  final String tugasName;
  final int idKelas;
  final int idTugas;
  final int idGuru;

  ProgresTugasGuru({
    required this.tugasName,
    required this.idKelas,
    required this.idTugas,
    required this.idGuru,
  });

  final ProgresTugasGuruController _controller = Get.put(ProgresTugasGuruController());

  @override
  Widget build(BuildContext context) {
    _controller.fetchPengumpulan(idKelas, idTugas, idGuru);

    return Scaffold(
      backgroundColor: Color.fromARGB(255, 255, 241, 176),
      appBar: AppBar(
        title: Text('Progres Tugas: $tugasName'),
      ),
      body: Obx(() {
        if (_controller.isLoading.value) {
          return Center(child: CircularProgressIndicator());
        } else if (_controller.dataList.isEmpty) {
          return Center(child: Text('Tidak ada data'));
        } else {
          return ListView.builder(
            padding: EdgeInsets.all(10.0),
            itemCount: _controller.dataList.length,
            itemBuilder: (context, index) {
              var pengumpulan = _controller.dataList[index];
              return Card(
                color: Colors.white,
                margin: EdgeInsets.symmetric(vertical: 8.0, horizontal: 8.0),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15.0),
                ),
                elevation: 4,
                child: ListTile(
                  contentPadding: EdgeInsets.all(10.0),
                  leading: CircleAvatar(
                    child: Text(
                      pengumpulan['id_siswa'].toString()[0],
                      style: TextStyle(color: Colors.white),
                    ),
                    backgroundColor: Colors.blue,
                  ),
                  title: Text(
                    'Siswa: ${pengumpulan['siswa']['nama']}',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 4.0),
                      GestureDetector(
                        onTap: () async {
                          final url = pengumpulan['jawaban'];
                          final Uri uri = Uri.parse(url);
                          if (await canLaunchUrl(uri)) {
                            await launchUrl(uri);
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text('Could not launch $url')),
                            );
                          }
                        },
                        child: Text(
                          'Jawaban: ${pengumpulan['jawaban']}',
                          style: TextStyle(
                            color: Colors.blue,
                            decoration: TextDecoration.underline,
                          ),
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                        ),
                      ),
                      SizedBox(height: 4.0),
                      Text('Nilai: ${pengumpulan['nilai']}'),
                      Text('Tanggal dikumpulkan: ${pengumpulan['tgl']}'),
                    ],
                  ),
                  trailing: IconButton(
                    icon: Icon(Icons.edit, color: Colors.grey),
                    onPressed: () {
                      _showBeriNilaiDialog(context, pengumpulan);
                    },
                  ),
                ),
              );
            },
          );
        }
      }),
    );
  }

  void _showBeriNilaiDialog(BuildContext context, Map<String, dynamic> pengumpulan) {
    final TextEditingController nilaiController = TextEditingController(text: pengumpulan['nilai'].toString());

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.0),
          ),
          title: Text('Beri Nilai'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Jawaban: ${pengumpulan['jawaban']}'),
              TextField(
                controller: nilaiController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  hintText: 'Beri Nilai',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Batal'),
            ),
            ElevatedButton(
              onPressed: () {
                _controller.updateNilai(pengumpulan['id'], idKelas, idTugas, idGuru, nilaiController.text);
                Navigator.of(context).pop();
                _showSuccessDialog(context);
              },
              child: Text('Selesai'),
            ),
          ],
        );
      },
    );
  }

  void _showSuccessDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.0),
          ),
          title: Row(
            children: [
              Icon(Icons.check_circle, color: Colors.green),
              SizedBox(width: 8),
              Text('Berhasil Diberi Nilai'),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('OK'),
            ),
          ],
        );
      },
    );
  }
}