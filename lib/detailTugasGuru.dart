import 'package:flutter/material.dart';
import 'progresTugasGuru.dart';
import 'ambil_tugasguruController.dart';
import 'package:get/get.dart';

class DetailTugasGuru extends StatelessWidget {
  final TugasGuru _tugasGuruController = Get.put(TugasGuru());
  final int idKelas;

  DetailTugasGuru({required this.idKelas});

  @override
  Widget build(BuildContext context) {
    _tugasGuruController.setKelasId(idKelas);

    return Scaffold(
      appBar: AppBar(
        title: Text('Tugas'),
        backgroundColor: Colors.white, // Ubah warna app bar menjadi putih
        elevation: 0, // Hilangkan shadow app bar
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return NewTaskDialog();
                },
              );
            },
          ),
        ],
      ),
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage("../assets/FrBg2.png"),
            fit: BoxFit.cover,
          ),
        ),
        child: Obx(() {
          if (_tugasGuruController.dataList.isEmpty) {
            return Center(child: Text('Anda belum memberi tugas'));
          } else {
            return ListView.builder(
              itemCount: _tugasGuruController.dataList.length,
              itemBuilder: (context, index) {
                var tugas = _tugasGuruController.dataList[index];
                return Card(
                  color: Color(0xFF06C798), // Gunakan warna yang diinginkan
                  margin: EdgeInsets.all(8.0),
                  child: Padding(
                    padding: const EdgeInsets.all(0.0),
                    child: TugasItemWithButton(
                      tugasName: tugas['id_tugas'].toString(),
                      teacherName: tugas['guru']['nama'].toString(),
                      subject: tugas['tugas'].toString(),
                      dateGiven: tugas['tanggal'].toString(),
                      dueDate: tugas['tenggat'].toString(),
                      onViewProgres: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ProgresTugasGuru(
                              tugasName: tugas['tugas'].toString(),
                              idKelas: idKelas,
                              idTugas: tugas['id'],
                              idGuru: tugas['id_guru'],
                            ),
                          ),
                        );
                      },
                      onEdit: () {
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return EditTaskDialog(
                              taskId: tugas['id'],
                              initialMapelId: tugas['id_mapel'],
                              initialTugas: tugas['tugas'],
                              initialTanggal: tugas['tanggal'],
                            );
                          },
                        );
                      },
                      onDelete: () async {
                        try {
                          await _tugasGuruController.deleteTask(tugas['id']);
                          Get.snackbar('Success', 'Task deleted successfully');
                        } catch (e) {
                          Get.snackbar('Error', 'Failed to delete task');
                        }
                      },
                    ),
                  ),
                );
              },
            );
          }
        }),
      ),
    );
  }
}

class TugasItemWithButton extends StatelessWidget {
  final String tugasName;
  final String teacherName;
  final String subject;
  final String dateGiven;
  final String dueDate;
  final VoidCallback onViewProgres;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  TugasItemWithButton({
    required this.tugasName,
    required this.teacherName,
    required this.subject,
    required this.dateGiven,
    required this.dueDate,
    required this.onViewProgres,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Color(0xFF06C798), // Gunakan warna yang diinginkan
      margin: EdgeInsets.all(8.0),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              teacherName,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            SizedBox(height: 8),
            Text(
              subject,
              style: TextStyle(
                fontSize: 14,
                color: Colors.black,
              ),
            ),
            SizedBox(height: 8),
            Row(
              children: [
                Text(
                  'Tanggal Diberikan: $dateGiven',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.black,
                  ),
                ),
                SizedBox(width: 10),
                Text(
                  'Tenggat Waktu: $dueDate',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.black,
                  ),
                ),
              ],
            ),
            SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                IconButton(
                  icon: Icon(Icons.edit),
                  onPressed: onEdit,
                ),
                IconButton(
                  icon: Icon(Icons.delete),
                  onPressed: onDelete,
                ),
                ElevatedButton(
                  onPressed: onViewProgres,
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    foregroundColor: Colors.black,
                    backgroundColor: Colors.white,
                  ),
                  child: Text('Lihat Data Pengumpulan'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class NewTaskDialog extends StatefulWidget {
  @override
  _NewTaskDialogState createState() => _NewTaskDialogState();
}

class _NewTaskDialogState extends State<NewTaskDialog> {
  String? selectedMapel;
  DateTime? selectedDate;
  TextEditingController tugasController = TextEditingController();
  final TugasGuru _tugasGuruController = Get.find<TugasGuru>();

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Tugas Baru'),
      content: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Divider(),
            Text('Mapel'),
            SizedBox(height: 8.0),
            Obx(() {
              if (_tugasGuruController.dataMapel.isEmpty) {
                return CircularProgressIndicator();
              } else {
                return DropdownButtonFormField<String>(
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: 'Pilih mapel',
                  ),
                  value: selectedMapel,
                  items: _tugasGuruController.dataMapel
                      .map((mapel) => DropdownMenuItem<String>(
                            value: mapel['id'].toString(),
                            child: Text(mapel['nama_mapel'] as String),
                          ))
                      .toList(),
                  onChanged: (value) {
                    setState(() {
                      selectedMapel = value;
                    });
                  },
                );
              }
            }),
            SizedBox(height: 16.0),
            Text('Tugas'),
            SizedBox(height: 8.0),
            TextField(
              controller: tugasController,
              maxLines: 4,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 16.0),
            Text('Tanggal'),
            SizedBox(height: 8.0),
            InkWell(
              onTap: () async {
                DateTime? pickedDate = await showDatePicker(
                  context: context,
                  initialDate: DateTime.now(),
                  firstDate: DateTime(2000),
                  lastDate: DateTime(2101),
                );
                if (pickedDate != null) {
                  setState(() {
                    selectedDate = pickedDate;
                  });
                }
              },
              child: InputDecorator(
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: 'Pilih tanggal',
                ),
                child: Text(
                  selectedDate == null
                      ? 'Pilih tanggal'
                      : '${selectedDate!.day}/${selectedDate!.month}/${selectedDate!.year}',
                ),
              ),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: Text('Batal'),
        ),
        TextButton(
          onPressed: () async {
            if (selectedMapel != null &&
                tugasController.text.isNotEmpty &&
                selectedDate != null) {
              int mapelId =
                  int.parse(selectedMapel!); // Konversi ID mapel ke int
              await _tugasGuruController.addTask(
                mapelId, // Kirim sebagai int
                tugasController.text,
                '${selectedDate!.year}-${selectedDate!.month}-${selectedDate!.day}',
              );
              Navigator.of(context).pop();
            } else {
              // Tampilkan pesan kesalahan atau lakukan tindakan lain jika input tidak valid
              print('Input tidak valid');
            }
          },
          child: Text('Tambahkan'),
        ),
      ],
    );
  }
}

class EditTaskDialog extends StatefulWidget {
  final int taskId;
  final int initialMapelId;
  final String initialTugas;
  final String initialTanggal;

  EditTaskDialog({
    required this.taskId,
    required this.initialMapelId,
    required this.initialTugas,
    required this.initialTanggal,
  });

  @override
  _EditTaskDialogState createState() => _EditTaskDialogState();
}

class _EditTaskDialogState extends State<EditTaskDialog> {
  String? selectedMapel;
  DateTime? selectedDate;
  TextEditingController tugasController = TextEditingController();
  final TugasGuru _tugasGuruController = Get.find<TugasGuru>();

  @override
  void initState() {
    super.initState();
    selectedMapel = widget.initialMapelId.toString();
    tugasController.text = widget.initialTugas;
    selectedDate = DateTime.parse(widget.initialTanggal);
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Edit Tugas'),
      content: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Divider(),
            Text('Mapel'),
            SizedBox(height: 8.0),
            Obx(() {
              if (_tugasGuruController.dataMapel.isEmpty) {
                return CircularProgressIndicator();
              } else {
                return DropdownButtonFormField<String>(
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: 'Pilih mapel',
                  ),
                  value: selectedMapel,
                  items: _tugasGuruController.dataMapel
                      .map((mapel) => DropdownMenuItem<String>(
                            value: mapel['id'].toString(),
                            child: Text(mapel['nama_mapel'] as String),
                          ))
                      .toList(),
                  onChanged: (value) {
                    setState(() {
                      selectedMapel = value;
                    });
                  },
                );
              }
            }),
            SizedBox(height: 16.0),
            Text('Tugas'),
            SizedBox(height: 8.0),
            TextField(
              controller: tugasController,
              maxLines: 4,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 16.0),
            Text('Tanggal'),
            SizedBox(height: 8.0),
            InkWell(
              onTap: () async {
                DateTime? pickedDate = await showDatePicker(
                  context: context,
                  initialDate: selectedDate ?? DateTime.now(),
                  firstDate: DateTime(2000),
                  lastDate: DateTime(2101),
                );
                if (pickedDate != null) {
                  setState(() {
                    selectedDate = pickedDate;
                  });
                }
              },
              child: InputDecorator(
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: 'Pilih tanggal',
                ),
                child: Text(
                  selectedDate == null
                      ? 'Pilih tanggal'
                      : '${selectedDate!.day}/${selectedDate!.month}/${selectedDate!.year}',
                ),
              ),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: Text('Batal'),
        ),
        TextButton(
          onPressed: () async {
            if (selectedMapel != null &&
                tugasController.text.isNotEmpty &&
                selectedDate != null) {
              int mapelId =
                  int.parse(selectedMapel!); // Konversi ID mapel ke int
              await _tugasGuruController.updateTask(
                widget.taskId,
                mapelId, // Kirim sebagai int
                tugasController.text,
                '${selectedDate!.year}-${selectedDate!.month}-${selectedDate!.day}',
              );
              Navigator.of(context).pop();
            } else {
              // Tampilkan pesan kesalahan atau lakukan tindakan lain jika input tidak valid
              print('Input tidak valid');
            }
          },
          child: Text('Simpan'),
        ),
      ],
    );
  }
}
