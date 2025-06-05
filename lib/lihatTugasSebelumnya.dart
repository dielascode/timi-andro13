import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'ambil_tugasSebelumnya.dart';

class LihatTugasSebelumnyaPage extends StatelessWidget {
  final TugasSebelumnyaController _tugasSebelumnyaController =
      Get.put(TugasSebelumnyaController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Tugas Sebelumnya'),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage("../assets/FrBg2.png"),
            fit: BoxFit.cover,
          ),
        ),
        child: Obx(() {
          return ListView.builder(
            itemCount: _tugasSebelumnyaController.dataList.length,
            itemBuilder: (context, index) {
              var tugas = _tugasSebelumnyaController.dataList[index];
              return Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                child: _buildTugasContainer(context, tugas),
              );
            },
          );
        }),
      ),
    );
  }

  Widget _buildTugasContainer(
      BuildContext context, Map<String, dynamic> tugas) {
    TextEditingController jawabanController =
        TextEditingController(text: tugas['jawaban']);
    var isEditing = false.obs;

    return Obx(() {
      return Container(
        height: 150, // Sesuaikan tinggi widget sesuai kebutuhan
        decoration: BoxDecoration(
          color: Color(0xFF06C798), // Gunakan warna yang diinginkan
          borderRadius: BorderRadius.circular(12.0),
        ),
        child: Stack(
          children: [
            Padding(
              padding: EdgeInsets.all(10.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Guru: ${tugas['guru']['nama']}",
                    style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  Text(
                    "Mapel: ${tugas['mapel']['nama_mapel']}",
                    style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  Text(
                    "Tugas: ${tugas['tugas']['tugas']}",
                    style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                  ),
                  Row(
                    children: [
                      Text(
                        "Tanggal Diberikan: ${tugas['tugas']['tanggal']}",
                        style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                        ),
                      ),
                      SizedBox(width: 10),
                      Text(
                        "Tanggal Dikumpulkan: ${tugas['tgl']}",
                        style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                  Text(
                    "Jawaban: ${tugas['jawaban']}",
                    style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
            Positioned(
              top: 10,
              right: 10,
              child: Text(
                "Nilai: ${tugas['nilai']}",
                style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
              ),
            ),
            Positioned(
              bottom: 10,
              right: 10,
              child: Row(
                children: [
                  if (isEditing.value)
                    ElevatedButton(
                      onPressed: () {
                        _tugasSebelumnyaController.editJawaban(
                            id: tugas['id'],
                            jawabanBaru: jawabanController.text);
                        isEditing.value = false;
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                              content: Text('Jawaban berhasil diperbarui!')),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        foregroundColor: Colors.black,
                        padding:
                            EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        backgroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12.0),
                        ),
                      ),
                      child: Text(
                        'Simpan',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 14),
                      ),
                    ),
                  if (!isEditing.value)
                    ElevatedButton(
                      onPressed: () {
                        isEditing.value = true;
                      },
                      style: ElevatedButton.styleFrom(
                        foregroundColor: Colors.black,
                        padding:
                            EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        backgroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12.0),
                        ),
                      ),
                      child: Text(
                        'Edit Jawaban',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 14),
                      ),
                    ),
                ],
              ),
            ),
          ],
        ),
      );
    });
  }
}
