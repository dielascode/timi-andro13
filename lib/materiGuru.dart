import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'detailMateriGuru.dart';
import 'package:get/get.dart';
import 'ambil_materiguruController.dart';

class MateriGuru extends StatelessWidget {
  final MateriGuruController _materiGuruController =
      Get.put(MateriGuruController());
  final int idKelas;

  MateriGuru({required this.idKelas});

  @override
  Widget build(BuildContext context) {
    _materiGuruController.setKelasId(idKelas);
    return Scaffold(
      appBar: AppBar(
        title: Text('Materi Anda'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Obx(() {
          return ListView.builder(
            itemCount: _materiGuruController.dataList.length,
            itemBuilder: (context, index) {
              var materi = _materiGuruController.dataList[index];
              return GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => DetailMateriGuru(),
                    ),
                  );
                },
                child: Card(
                  elevation: 4,
                  margin: EdgeInsets.only(bottom: 16.0),
                  color: Color.fromARGB(255, 255, 244, 179),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                  child: Padding(
                    padding: EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Row(
                          children: [
                            Icon(Icons.person, color: Colors.black),
                            SizedBox(width: 8.0),
                            Text(
                              'Guru: ${materi['guru']['nama']}',
                              style: TextStyle(
                                fontSize: 16.0,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 8.0),
                        Row(
                          children: [
                            Icon(Icons.book, color: Colors.black),
                            SizedBox(width: 8.0),
                            Text(
                              'Mata Pelajaran: ${materi['mapel']['nama_mapel']}',
                              style: TextStyle(
                                fontSize: 14.0,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 8.0),
                        GestureDetector(
                          onTap: () async {
                            final url = materi['materi'];
                            final Uri uri = Uri.parse(url);
                            if (await canLaunchUrl(uri)) {
                              await launchUrl(uri);
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text('Could not launch $url')),
                              );
                            }
                          },
                          child: Row(
                            children: [
                              Icon(Icons.link, color: Colors.black),
                              SizedBox(width: 8.0),
                              Expanded(
                                child: Text(
                                  '${materi['materi']}',
                                  style: TextStyle(
                                    color: Colors.black,
                                    decoration: TextDecoration.underline,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 1,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          );
        }),
      ),
    );
  }
}