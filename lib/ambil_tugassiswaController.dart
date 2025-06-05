import 'dart:convert';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

class TugasSiswa extends GetxController {
var idKelas = 0.obs;
  var idSiswa = 0.obs;
  var tugasList = [].obs;

  void setIdKelas(int idKelasValue) {
    idKelas.value = idKelasValue;
    fetchTugas();
  }

  void setIdSiswa(int idsiswa) {
    idSiswa.value = idsiswa;
    fetchTugas();
  }

  Future<void> fetchTugas() async {
    try {
      final tugasResponse = await http.get(
        Uri.parse('http://127.0.0.1:8000/api/tugas?id_kelas=${idKelas.value}'),
        headers: {'Content-Type': 'application/json; charset=UTF-8'},
      );

      if (tugasResponse.statusCode == 200) {
        var tugasData = json.decode(tugasResponse.body) as List;

        final pengumpulanResponse = await http.get(
          Uri.parse('http://127.0.0.1:8000/api/pengumpulan?id_siswa=${idSiswa.value}'),
          headers: {'Content-Type': 'application/json; charset=UTF-8'},
        );

        if (pengumpulanResponse.statusCode == 200) {
          var pengumpulanData = json.decode(pengumpulanResponse.body) as List;

          // Get a list of submitted task IDs
          var submittedTaskIds = pengumpulanData.map((submission) => submission['id_tugas']).toList();

          // Filter out the tasks that have been submitted
          var filteredTugasData = tugasData.where((task) => !submittedTaskIds.contains(task['id'])).toList();

          tugasList.value = filteredTugasData;
          print('Tugas fetched and filtered successfully');
        } else {
          throw Exception('Failed to load submissions');
        }
      } else {
        throw Exception('Failed to load tasks');
      }
    } catch (e) {
      print('Error fetching tasks: $e');
    }
  }

Future<bool> submitTugas(int id, int idKelas, int idSiswa, int idMapel, int idGuru, String link) async {
  try {
    final String currentDate = DateFormat('yyyy-MM-dd').format(DateTime.now());
    final double nilai = 0.0;
    final String status = 'selesai';

    final response = await http.post(
      Uri.parse('http://127.0.0.1:8000/api/pengumpulan'),
      headers: {'Content-Type': 'application/json; charset=UTF-8'},
      body: jsonEncode(<String, dynamic>{
        'id_tugas': id,
        'id_kelas': idKelas,
        'id_siswa': idSiswa,
        'id_mapel': idMapel,
        'id_guru': idGuru,
        'tgl': currentDate,
        'jawaban': link,
        'nilai': nilai,
        'status': status,
      }),
    );

    if (response.statusCode == 200) {
      print('Tugas submitted successfully');
      return true;
    } else {
      print('Failed to submit task: ${response.statusCode}');
      return false;
    }
  } catch (e) {
    print('Error submitting task: $e');
    return false;
  }
}}
